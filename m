From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: READ CAPACITY (16) failing
Date: Thu, 9 Apr 2009 10:22:35 -0500
Message-ID: <20090409152235.GB15043@beardog.cca.cpqcorp.net>
References: <20090408194357.GA15043@beardog.cca.cpqcorp.net> <20090408195447.GP20983@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:7662 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222AbZDIPWe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2009 11:22:34 -0400
Content-Disposition: inline
In-Reply-To: <20090408195447.GP20983@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: LKML-SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, mike.miller@hp.com

On Wed, Apr 08, 2009 at 01:54:48PM -0600, Matthew Wilcox wrote:
> On Wed, Apr 08, 2009 at 02:43:57PM -0500, Mike Miller (OS Dev) wrote:
> > I'm working on the HP Smart Array SCSI driver (hpsa) and I'm seeing the
> > following failures:
> > 
> > hpsa1: <0x3230> at PCI 0000:02:00.0 IRQ 76 using DAC
> > scsi4 : hpsa
> > scsi 4:0:0:0: Direct-Access     HP       LOGICAL VOLUME   5.20 PQ: 0 ANSI: 5
> > sd 4:0:0:0: Attached scsi generic sg4 type 0
> > sd 4:0:0:0: [sdd] READ CAPACITY(16) failed
> > sd 4:0:0:0: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
> > sd 4:0:0:0: [sdd] Sense not available.
> > hpsa: cp ffff8800cf400000 has check condition: unknown type: Sense: 0x5,
> > ASC: 0x20, ASCQ: 0x0, Returning result: 0x2, cmd=[a0 00 00 00 00 00 00 00 10
> > 00]
> 
> > The READ CAPACITY failures are what I'm concerned about. I can't seem to track
> > down why that's failing.
> > I've tried printing out the_result from sd but it's not printing out. I'm
> > assuming that anytime I load the driver it goes thru sd.
> > 
> > 	if (the_result) {
> > 		sense_valid = scsi_sense_valid(&sshdr);
> > 		if (sense_valid &&
> > 			sshdr.sense_key == ILLEGAL_REQUEST &&
> > 			(sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
> > 			sshdr.ascq == 0x00)
> > 			/* Invalid Command Operation Code or
> > 			 * Invalid Field in CDB, just retry
> > 			 * silently with RC10 */
> > 			return -EINVAL;
> > 		}
> > 	retries--;
> > 	} while (the_result && retries);
> > 	printk(KERN_WARNING "sd-mfm: the_result = %d\n", the_result);
> 
> Probably the device you're testing against doesn't support RC16, which
> is fine.  But for some reason, we're not getting valid sense data back
> from the device.  Now, there's two responses to this that seem rational
> to me:
> 
>  - In sd.c, if the drive has returned no/invalid sense data, try RC10
>    silently, just like the 0x20 / 0x24 ASC case.
>  - Find out why this drive doesn't report valid sense data when attached
>    to hpsa.  I assume it does report valid sense data when attached to
>    some other scsi card?

If I connect to another card everything seems to work OK. But, the
controllers I'm testing with DO support RC16. If I load the cciss driver I
can see my large volumes with no problems. I've also bugged the firmware
folks and according to them RC16 is supported.

WRT the TUR failing, if this controller message is accurate it looks like
the TUR is being sent to the controller and not the logical volumes.

[04/08 14:31:09]Ctlr SCSI Request, Illegal CDB Opcode=0x0

Wonder why that would be the case.

-- mikem
