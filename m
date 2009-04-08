From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: READ CAPACITY (16) failing
Date: Wed, 8 Apr 2009 13:54:48 -0600
Message-ID: <20090408195447.GP20983@parisc-linux.org>
References: <20090408194357.GA15043@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34792 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759352AbZDHTzF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 15:55:05 -0400
Content-Disposition: inline
In-Reply-To: <20090408194357.GA15043@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: LKML-SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, mike.miller@hp.com

On Wed, Apr 08, 2009 at 02:43:57PM -0500, Mike Miller (OS Dev) wrote:
> I'm working on the HP Smart Array SCSI driver (hpsa) and I'm seeing the
> following failures:
> 
> hpsa1: <0x3230> at PCI 0000:02:00.0 IRQ 76 using DAC
> scsi4 : hpsa
> scsi 4:0:0:0: Direct-Access     HP       LOGICAL VOLUME   5.20 PQ: 0 ANSI: 5
> sd 4:0:0:0: Attached scsi generic sg4 type 0
> sd 4:0:0:0: [sdd] READ CAPACITY(16) failed
> sd 4:0:0:0: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
> sd 4:0:0:0: [sdd] Sense not available.
> hpsa: cp ffff8800cf400000 has check condition: unknown type: Sense: 0x5,
> ASC: 0x20, ASCQ: 0x0, Returning result: 0x2, cmd=[a0 00 00 00 00 00 00 00 10
> 00]

> The READ CAPACITY failures are what I'm concerned about. I can't seem to track
> down why that's failing.
> I've tried printing out the_result from sd but it's not printing out. I'm
> assuming that anytime I load the driver it goes thru sd.
> 
> 	if (the_result) {
> 		sense_valid = scsi_sense_valid(&sshdr);
> 		if (sense_valid &&
> 			sshdr.sense_key == ILLEGAL_REQUEST &&
> 			(sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
> 			sshdr.ascq == 0x00)
> 			/* Invalid Command Operation Code or
> 			 * Invalid Field in CDB, just retry
> 			 * silently with RC10 */
> 			return -EINVAL;
> 		}
> 	retries--;
> 	} while (the_result && retries);
> 	printk(KERN_WARNING "sd-mfm: the_result = %d\n", the_result);

Probably the device you're testing against doesn't support RC16, which
is fine.  But for some reason, we're not getting valid sense data back
from the device.  Now, there's two responses to this that seem rational
to me:

 - In sd.c, if the drive has returned no/invalid sense data, try RC10
   silently, just like the 0x20 / 0x24 ASC case.
 - Find out why this drive doesn't report valid sense data when attached
   to hpsa.  I assume it does report valid sense data when attached to
   some other scsi card?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
