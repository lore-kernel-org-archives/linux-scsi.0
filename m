From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: dmesg spam
Date: Mon, 04 Feb 2008 14:20:42 -0600
Message-ID: <1202156442.3096.107.camel@localhost.localdomain>
References: <20080203143033.cfea0501.akpm@linux-foundation.org>
	 <200802041524.55700.bzolnier@gmail.com>
	 <20080204120548.79f3fe57.akpm@linux-foundation.org>
	 <47A7721C.5020505@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44685 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565AbYBDUUq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 15:20:46 -0500
In-Reply-To: <47A7721C.5020505@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>


On Mon, 2008-02-04 at 15:14 -0500, Jeff Garzik wrote:
> Andrew Morton wrote:
> > On Mon, 4 Feb 2008 15:24:55 +0100 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > 
> >> On Sunday 03 February 2008, Andrew Morton wrote:
> >>> With latest -mm, running fc8 I am getting this in the logs,
> >>                            ^^^
> >> => SCSI/libata
> >>
> >> cc:ing Jeff
> >>
> >>> once per second.
> >>>
> >>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> >>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> >>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> >>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> >>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> >>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> >>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> >>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> >>> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> > 
> > Well..  it's coming out of the kernel.  Presumably it's that cdrom polling
> > thing in KDE.  James recently made changes to sr_ioctl.c but I've been
> > buried in more terminal regressions than this one.
> 
> I don't see this in upstream...  can you isolate it to a particular git 
> tree?

It's here in sr_ioctl.c:

int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
{
[...]
                case NOT_READY: /* This happens if there is no disc in
drive */
[...]
                        if (!cgc->quiet)
                                printk(KERN_INFO "%s: CDROM not ready.
Make sure there is a disc in the drive.\n", cd->cdi.name);
#ifdef DEBUG
                        scsi_print_sense_hdr("sr", &sshdr);
#endif


> Clearly userland is initiating a once-per-second poll.  That is quite 
> normal for 99% of CDROMs, which do not support async notification.
> 
> But also clearly that message is printk'd way too much in your case.

I'm not averse to simply nuking the printk ... it's probably valueless
in a modern kernel, since something dbussy is supposed to tell you to
put a CD in the drive, not something in the kernel.

I am however interested to see if it's a symptom of something else that
might be a bigger problem.

James


