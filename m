From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: CONFIG_SCSI_MQ_DEFAULT cause slow direct write speed to usb stick
Date: Tue, 10 Feb 2015 17:10:18 -0500
Message-ID: <54DA81CA.2030303@interlog.com>
References: <20150210195036.3dce0e9e@bigpc>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150210195036.3dce0e9e@bigpc>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrej Gelenberg <andrej.gelenberg@udo.edu>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de, martin.petersen@oracle.com, elliott@hp.com
List-Id: linux-scsi@vger.kernel.org

On 15-02-10 01:50 PM, Andrej Gelenberg wrote:
> Hi,
>
> i had found a problem with CONFIG_SCSI_MQ_DEFAULT config option. If it
> activated, then the write speeds to the /dev/sd* of an usb stick drops
> dramatically: it's only about 250 kb/CONFIG_SCSI_MQ_DEFAULTs, but
> should be about 7 Mb/s. Git bisect also points to commit
> 24c20f10583647e30afe87b6f6d5e14bc7b1cbc6 'scsi: add a
> CONFIG_SCSI_MQ_DEFAULT option' (i always set CONFIG_SCSI_MQ_DEFAULT to
> y, because it sounded interesting). Same problem is also in 3.19
> present. Write speeds to a filesystem on that USB-Stick were not so
> bad, but as i tried to dd in Live-DVD Ubuntu image it was painfully
> slow. After i disabled CONFIG_SCSI_MQ_DEFAULT write speeds are back to
> normal.
>
> I created bug report in bugzilla:
> https://bugzilla.kernel.org/show_bug.cgi?id=92571

Perhaps a related datapoint: when reading from a uSD card via
a USB dongle in lk 3.19 (SCSI_MQ set), blk_get_request()
sometimes returns EAGAIN to the sg driver. I'm not sure that
I have seen the SG_IO ioctl return EAGAIN via this route before
(i.e. before it can even set up the SCSI command). Arguably doing
that breaks the long standing interface of ioctl(sg, SG_IO).

Faster storage devices do not seem to have this problem. The
laptop involved has plenty of ram and was lightly loaded. This
was a synchronous copy of a slow device onto local storage
(a SSD) so it is hard to see why there might be a resource
problem. By adjusting my user space code (ddpt and sg_dd) to
repeat the ioctl, the copy continues normally.

Here is an example:

# ddpt if=/dev/sg1 bs=512 of=x.bin
1953792+0 records in
1953792+0 records out
1281 retries after EAGAIN error(s) during IO
time to transfer data: 59.678788 secs at 16.76 MB/sec

That is not a bad transfer time but other utilities
or drivers might dwell longer on those (nuisance) EAGAINs.

Doug Gilbert
