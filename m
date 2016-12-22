From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Testing latest linux-next 4.9 ib_srp and ib_srpt sees I/O
 capped at 1MB and no merging
Date: Thu, 22 Dec 2016 08:17:58 -0500 (EST)
Message-ID: <1661819060.8462293.1482412678092.JavaMail.zimbra@redhat.com>
References: <07c07529-4636-fafb-2598-7358d8a1460d@sandisk.com> <1918919536.8196250.1482262406057.JavaMail.zimbra@redhat.com> <2052479881.8196880.1482263028727.JavaMail.zimbra@redhat.com> <1668746735.8200653.1482266682585.JavaMail.zimbra@redhat.com> <120559766.8215321.1482291094018.JavaMail.zimbra@redhat.com> <1928955380.8220327.1482302041315.JavaMail.zimbra@redhat.com> <1337539588.8422488.1482372617094.JavaMail.zimbra@redhat.com> <20161222062321.GA30326@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222062321.GA30326-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Hello Christoph, apologies, here is a clear summary of the issue.

During testing of the latest linux-next with rc-10 block layer changes I noticed that I/O was being capped at 1MB size and no merging was seen.

The issue was not apparent on 4.8.0-rc8 or earlier.

dd if=/dev/sdw bs=4096k of=/dev/null iflag=direct

### RECORD    6 >>> ibclient <<< (1482266543.001) (Tue Dec 20 15:42:23 2016) ###
# DISK STATISTICS (/sec)
#                   <---------reads---------------><---------writes--------------><--------averages--------> Pct
#Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size  Wait  RWSize  QLen  Wait SvcTim Util
15:42:23 sdw         278528    201   68 4096     2       0      0    0    0     0    4096     1     2      2   206

Then git checkout master and build final test kernel
4.9.0+

This one clearly shows the I.O at 1MB and no merging.

# DISK STATISTICS (/sec)
#                   <---------reads---------------><---------writes--------------><--------averages--------> Pct
#Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size  Wait  RWSize  QLen  Wait SvcTim Util
22:12:48 sdw         1413120      0 1380 1024     2       0      0    0    0     0    1024     3     2      0   99
22:12:49 sdw         1409024      0 1376 1024     2       0      0    0    0     0    1024     3     2      0   98
22:12:50 sdw         1445888      0 1412 1024     2       0      0    0    0     0    1024     3     2      0   98
22:12:51 sdw         1429504      0 1396 1024     2       0      0    0    0     0    1024     3     2      0   98
22:12:52 sdw         1426432      0 1393 1024     2       0      0    0    0     0    1024     3     2      0   98
22:12:53 sdw         1408000      0 1375 1024     2       0      0    0    0     0    1024     3     2      0   98
                                ***      ****                                         ****

After multiple bisects (6000 revisions, 13 cycles), I got to this one.
Of course there are a huge amount of block layer changes as we know in rc10.

[loberman@ibclient linux-next.orig]$ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[542ff7bf18c63cf403e36a4a1c71d86dc120d924] block: new direct I/O implementation

This commit is the one that seems to have changed the behavior.
Max I/O size restricted 1MB, even when 4MB I/O is requested, no merging seen.

This is not going to only affect SRP targets.

I will be happy to test any patches and the test bed is always in place.


commit 542ff7bf18c63cf403e36a4a1c71d86dc120d924
Author: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Date:   Wed Nov 16 23:14:22 2016 -0700

    block: new direct I/O implementation
    
    Similar to the simple fast path, but we now need a dio structure to
    track multiple-bio completions.  It's basically a cut-down version
    of the new iomap-based direct I/O code for filesystems, but without
    all the logic to call into the filesystem for extent lookup or
    allocation, and without the complex I/O completion workqueue handler
    for AIO - instead we just use the FUA bit on the bios to ensure
    data is flushed to stable storage.
    
    Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
    Signed-off-by: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>

Many Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
