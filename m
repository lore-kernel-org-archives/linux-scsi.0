From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fix dma mapping leak in fusion
Date: Fri, 20 Aug 2004 11:01:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5704DE6A9E@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:37568 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S268207AbUHTPBo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 11:01:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Would it be possible for you to set up remote system 
to send kernel messages over serial cable?
Is so, pls recompile the driver with MPT_DEBUG_TM defined in
the mpt device driver Makefile; then send me log file.

Thanks,
Eric

On Thursday, August 19, 2004 9:05 PM, Masao Fukuchi wrote:
> 
> 
> Eric,
> 
> I applyed your patch and tested it, but the patch didn't work well.
> I didn't met Oops. 
> But after read command finishing with fail, keyboard and mouse click 
> didn't work.
> And also I couldn't login from other server.
> 
> The message was almost same as Fusion MPT driver 3.01.15.
> 
> Masao Fukuchi
> 
> Moore, Eric Dean wrote:
> >Here is a patch to apply against 3.01.15. It will have a small
> >fix in mptscsih_abort which should work with Christoph's suggestion
> >of removing the "is the device is offline" check in 
> >mptscsih_flush_running_cmds.  Pls test and let me know if you still 
> >hit the oops.
> >
> >Eric
> >
> >
> >On Thursday, August 19, 2004 7:15 AM, Masao Fukuchi wrote:
> >> 
> >> I tried fusion MPT driver 3.01.15 and I didn't met Oops.
> >> (Eric fixed Oops problem by Fusion MPT driver 3.01.04)
> >> 
> >> Masao Fukuchi
> >> 
> >> Message:
> >>  18:19:01 kernel: mptscsih: ioc3: >> Attempting task abort! 
> >> (sc=e00000007c205080)
> >>  18:19:01 kernel: mptscsih: ioc3: >> Attempting target reset! 
> >> (sc=e00000007c205080)
> >>  18:19:01 kernel: mptscsih: ioc3: >> Attempting bus reset! 
> >> (sc=e00000007c205080)
> >>  18:19:03 kernel: mptbase: Initiating ioc3 recovery
> >>  18:19:28 kernel: mptscsih: ioc3: >> Attempting task abort! 
> >> (sc=e00000007c205080)
> >>  18:19:28 kernel: mptscsih: ioc3: >> Attempting host reset! 
> >> (sc=e00000007c205080)
> >>  18:19:28 kernel: mptbase: Initiating ioc3 recovery
> >>  18:19:52 kernel: mptscsih: ioc3: >> Attempting task abort! 
> >> (sc=e00000007c205080)
> >>  18:19:52 kernel: scsi: Device offlined - not ready after 
> >> error recovery: host 3 channel 0 id 1 lun 0
> >>  18:19:52 kernel: scsi3 (1:0): rejecting I/O to offline device
> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 0
> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 1
> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 2
> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 3
> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 4
> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 5
> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 6
> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 7
> >>  18:19:52 kernel: scsi3 (1:0): rejecting I/O to offline device
> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 0
> >>  18:19:52 kernel: Buffer I/O error on device sdb, logical block 1
> >>  18:19:54 kernel: mptbase: Initiating ioc3 recovery
> >> 
> >> 
> >> Christoph Hellwig wrote:
> >> >On Thu, Aug 19, 2004 at 12:01:11PM +0900, Masao Fukuchi wrote:
> >> >> Hi Christoph,
> >> >> 
> >> >> I applyed attached patch into latest fusion MPT 
> driver(3.01.15) and
> >> >> tested it, but I still met Oops.
> >> >> Then I also applyed your latest patch(it gets rid of the 
> >> fusion pendingQ
> >> >> in favour of using the scsi midlayer queuing), but I met 
> >> Oops again.
> >> >
> >> >Can you try the patch Eric posted instead?
> >> >
> >> >-
> >> >To unsubscribe from this list: send the line "unsubscribe 
> >> linux-scsi" in
> >> >the body of a message to majordomo@vger.kernel.org
> >> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> 
> >
> 
