From: Andrew Schulman <andrex@alumni.utexas.net>
Subject: Re: dc395x: can't write to tape
Date: Tue, 11 Jan 2005 10:19:06 -0500
Message-ID: <200501111019.06281.andrex@alumni.utexas.net>
References: <200501060518.25782.andrex@alumni.utexas.net> <200501070552.57607.andrex@alumni.utexas.net> <Pine.LNX.4.60.0501072057500.6238@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc12.comcast.net ([216.148.227.85]:28900 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S262791AbVAKPTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 10:19:09 -0500
In-Reply-To: <Pine.LNX.4.60.0501072057500.6238@poirot.grange>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> > > > Jan  5 22:50:18 helium kernel: dc395x: sg_update_list: sg_to_virt
> > > > failed
> > >
> > > This doesn't look good. However, after a brief look at the code, I
> > > cannot say what exactly went wrong there. Jamie?
> >
> > I didn't mention it before, but I've gotten that particular message for a
> > long time, even when the tape drive used to work.
>
> Could you try disabling highmem either try a kernel without highmem
> support, or boot with mem=900M, or remove a part of your RAM (if you
> don't have to saw your RAMs for that:-)), maybe, booting with highmem=0,
> or with nohighio.

Okay, I finally got to this.  Rebooted with mem=900M.  Unfortunately tar fails 
as before:

tar: /dev/st0: Wrote only 0 of 10240 bytes
tar: Error is not recoverable: exiting now

I had rebuilt dc395x with 

#define DEBUG_MASK (DBG_0|DBG_1|DBG_SG|DBG_FIFO|DBG_PIO) 

uncommented in dc395x.c.  Here's what I got:

# tail -40 /var/log/kern.log
Jan 11 06:29:18 helium kernel: dc395x: srb_done: (pid#4596449) <02-0>
Jan 11 06:29:18 helium kernel: dc395x: srb_done: srb=f6aa2eec sg=0(0/1) 
buf=e7c64000 addr=e7c64000
Jan 11 06:29:18 helium kernel: dc395x: srb_done: AUTO_REQSENSE1
Jan 11 06:29:18 helium kernel: dc395x: pci_unmap_srb_sense: buffer=12a69452
Jan 11 06:29:18 helium kernel: dc395x: ReqSense: MEDIUM_ERROR cmnd=0x10 <02-0> 
stat=0 scan=1 sense=0x03 ASC=0x0c ASCQ=0x00 (0x00000000 0x00000000)
Jan 11 06:29:18 helium kernel: dc395x: srb_done: AUTO_REQSENSE2
Jan 11 06:29:18 helium kernel: dc395x: srb_going_remove: (pid#4596449) <02-0> 
srb=f6aa2eec
Jan 11 06:29:18 helium kernel: dc395x: srb_done: (pid#4596449) done 
result=0x08000002
Jan 11 06:29:18 helium kernel: dc395x: srb_free_insert: srb=f6aa2eec
Jan 11 06:29:18 helium kernel: st0: Error with sense data: Current st0: sense 
= 70  3
Jan 11 06:29:18 helium kernel: ASC= c ASCQ= 0
Jan 11 06:29:18 helium kernel: Raw sense data:0x70 0x00 0x03 0x00 0x00 0x00 
0x00 0x0a 0x00 0x00 0x00 0x00 0x0c 0x00 0x00 0x00 0x00 0x00
Jan 11 06:29:18 helium kernel: st0: Error on write filemark.
Jan 11 06:29:18 helium kernel: dc395x: queue_command: (pid#4596450) <02-0> 
cmnd=0x01
Jan 11 06:29:18 helium kernel: dc395x: srb_get_free: srb=f6aa2f2c
Jan 11 06:29:18 helium kernel: dc395x: build_srb: (pid#4596450) <02-0>
Jan 11 06:29:18 helium kernel: dc395x: build_srb: [0] len=0 buf=e7c64000 
use_sg=0 !MAP=277c0000
Jan 11 06:29:18 helium kernel: dc395x: start_scsi: (pid#4596450) <02-0> 
srb=f6aa2f2c
Jan 11 06:29:18 helium kernel: dc395x: srb_going_append: (pid#4596450) <02-0> 
srb=f6aa2f2c
Jan 11 06:29:18 helium kernel: dc395x: queue_command: (pid#4596450) done
Jan 11 06:29:18 helium kernel: dc395x: msgin_phase1: (pid#4596450)
Jan 11 06:29:18 helium kernel: dc395x: msgin_phase0: (pid#4596450)
Jan 11 06:29:18 helium kernel: dc395x: msgin_phase0: (pid#4596450) SAVE 
POINTER rem=0 Ignore
Jan 11 06:29:18 helium kernel: dc395x: msgin_phase1: (pid#4596450)
Jan 11 06:29:18 helium kernel: dc395x: msgin_phase0: (pid#4596450)
Jan 11 06:29:18 helium kernel: dc395x: disconnect: (pid#4596450)
Jan 11 06:30:41 helium kernel: dc395x: reselect: acb=f6aa21e4
Jan 11 06:30:41 helium kernel: dc395x: reselect: select <2>
Jan 11 06:30:41 helium kernel: dc395x: status_phase1: (pid#4596450) <02-0>
Jan 11 06:30:41 helium kernel: dc395x: status_phase0: (pid#4596450) <02-0>
Jan 11 06:30:41 helium kernel: dc395x: disconnect: (pid#4596450)
Jan 11 06:30:41 helium kernel: dc395x: srb_done: (pid#4596450) <02-0>
Jan 11 06:30:41 helium kernel: dc395x: srb_done: srb=f6aa2f2c sg=0(0/0) 
buf=e7c64000 addr=e7c64000
Jan 11 06:30:41 helium kernel: dc395x: srb_going_remove: (pid#4596450) <02-0> 
srb=f6aa2f2c
Jan 11 06:30:41 helium kernel: dc395x: srb_done: (pid#4596450) done 
result=0x00000000
Jan 11 06:30:41 helium kernel: dc395x: srb_free_insert: srb=f6aa2f2c

The log file is 2.8 GB uncompressed after this operation.  Let me know if it 
would be helpful to see more of it and I can post it (or part of it) on my 
web site for download.

> > > > Jan  5 22:50:18 helium kernel: st0: Error with sense data: Info
> > > > fld=0x67, Current st0: sense = f0  4
> > >
> > > Sense key 4 - hardware error.

I notice that the sense key is 3 this time.

> Still, your tape problem seems to be unrelated. Do you have a chance to
> test it in another system / with another controller?

Not now, although I may replace the controller just as something to try.  That 
would be much cheaper than a new tape drive.

I have your other suggestions and will get to them as soon as I have time.
A.
