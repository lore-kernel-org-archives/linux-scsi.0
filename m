From: Sergey Meirovich <rathamahata@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Wed, 8 Jan 2014 19:30:38 +0200
Message-ID: <CA+QCeVRXAXAk2Zv2gtdvT+c80hbpcvezz_dvk9aUjwPbVp7pnQ@mail.gmail.com>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz> <20140107155830.GA28395@infradead.org>
 <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
 <20140108140307.GA588@infradead.org> <CA+QCeVQy08m9oBM1ULE_KAjd-36ao35p7-BCWErJewyr3m6NGg@mail.gmail.com>
 <20140108152610.GA5863@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140108152610.GA5863@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 8 January 2014 17:26, Christoph Hellwig <hch@infradead.org> wrote:
>
> On my laptop SSD I get the following results (sometimes up to 200MB/s,
> sometimes down to 100MB/s, always in the 40k to 50k IOps range):
>
> time elapsed (sec.):    5
> bandwidth (MiB/s):      160.00
> IOps:                   40960.00

Any direct attached storage I've tried was faster for me as well,
indeed. I have already posted IIRC
"06:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS
2208 [Thunderbolt] (rev 05)"   - 1Gb BBU RAM
sysbench seqwr aio 4k:                     326.24Mb/sec 20879.56 Requests/sec

That is good that you mentioned SSD. I've tried fnic HBA zoned to EMC
XtremIO (SSD only based storage)
     14.43Mb/sec 3693.65 Requests/sec for sequential 4k.

So far I've seen so massive degradation only in SAN environment. I
started my investigation with RHEL6.5 kernel so below table is from it
but the trend is the same as for mainline it seems.

Chunk size Bandwidth MiB/s
================================
64M                512
32M                510
16M                492
8M                  451
4M                  436
2M                  350
1M                  256
512K               191
256K               165
128K               142
64K                 101
32K                 65
16K                 39
8K                   20
4K                   11


>
> The IOps are more than the hardware is physically capable of, but given
> that you didn't specify O_SYNC this seems sensible given that we never
> have to flush the disk cache.
>
> Could it be that your array has WCE=0?  In Linux we'll never enable the
> cache automatically, but Solaris does at least when using ZFS.  Try
> running:
>
>    sdparm --set=WCE /dev/sdX
>
> and try again.

ZFS is not supporting direct IO so that was UFS. I tried to do sdparm
--set=WCE /dev/sdX on the same fnic/XtremIO however this is multipath
and for second half of 4 LUNs that failed (probably this is normal)
Results have not changed much: 13.317Mb/sec 3409.26 Requests/sec


[root@dca-poc-gtsxdb3 mnt]# multipath -ll
mpathb (3514f0c5c11a0002d) dm-0 XtremIO,XtremApp
size=50G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 0:0:4:1 sdg 8:96  active ready running
  |- 0:0:5:1 sdh 8:112 active ready running
  |- 1:0:4:1 sdo 8:224 active ready running
  `- 1:0:5:1 sdp 8:240 active ready running

[root@dca-poc-gtsxdb3 mnt]# sdparm --set=WCE /dev/sdg
    /dev/sdg: XtremIO   XtremApp          1.05
[root@dca-poc-gtsxdb3 mnt]# sdparm --set=WCE /dev/sdh
    /dev/sdh: XtremIO   XtremApp          1.05
[root@dca-poc-gtsxdb3 mnt]# sdparm --set=WCE /dev/sdo
    /dev/sdo: XtremIO   XtremApp          1.05
mode sense command failed, unit attention
change_mode_page: failed fetching page: Caching (SBC)
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[root@dca-poc-gtsxdb3 mnt]# sdparm --set=WCE /dev/sdp
    /dev/sdp: XtremIO   XtremApp          1.05
mode sense command failed, unit attention
change_mode_page: failed fetching page: Caching (SBC)
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[root@dca-poc-gtsxdb3 mnt]#
