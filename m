From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: READ CAPACITY (16) failing
Date: Wed, 8 Apr 2009 14:43:57 -0500
Message-ID: <20090408194357.GA15043@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:32254 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbZDHTn4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 15:43:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML-SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: mike.miller@hp.com

Hello,
I'm working on the HP Smart Array SCSI driver (hpsa) and I'm seeing the
following failures:

hpsa1: <0x3230> at PCI 0000:02:00.0 IRQ 76 using DAC
scsi4 : hpsa
scsi 4:0:0:0: Direct-Access     HP       LOGICAL VOLUME   5.20 PQ: 0 ANSI: 5
sd 4:0:0:0: Attached scsi generic sg4 type 0
sd 4:0:0:0: [sdd] READ CAPACITY(16) failed
sd 4:0:0:0: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
sd 4:0:0:0: [sdd] Sense not available.
hpsa: cp ffff8800cf400000 has check condition: unknown type: Sense: 0x5,
ASC: 0x20, ASCQ: 0x0, Returning result: 0x2, cmd=[a0 00 00 00 00 00 00 00 10
00]
sd 4:0:0:0: [sdd] 213196320 512-byte hardware sectors: (109 GB/101 GiB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 6b 00 00 08
sd 4:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
sd 4:0:0:0: [sdd] READ CAPACITY(16) failed
sd 4:0:0:0: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
sd 4:0:0:0: [sdd] Sense not available.
 sdd: sdd1
sd 4:0:0:0: [sdd] Attached SCSI disk
scsi 4:1:0:0: RAID              HP       P400             5.20 PQ: 0 ANSI: 0
scsi 4:1:0:0: Attached scsi generic sg5 type 12

The illegal request is coming from smartd and probably doesn't mean anything
in this context since SA doesn't support the SCSI Report LUNs command. The
READ CAPACITY failures are what I'm concerned about. I can't seem to track
down why that's failing.
I've tried printing out the_result from sd but it's not printing out. I'm
assuming that anytime I load the driver it goes thru sd.

	if (the_result) {
		sense_valid = scsi_sense_valid(&sshdr);
		if (sense_valid &&
			sshdr.sense_key == ILLEGAL_REQUEST &&
			(sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
			sshdr.ascq == 0x00)
			/* Invalid Command Operation Code or
			 * Invalid Field in CDB, just retry
			 * silently with RC10 */
			return -EINVAL;
		}
	retries--;
	} while (the_result && retries);
	printk(KERN_WARNING "sd-mfm: the_result = %d\n", the_result);

sd reports:
sd 4:0:0:0: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK

>From the controllers serial port I see:

[04/08 14:31:09]Ctlr SCSI Request, Illegal CDB Opcode=0x0
[04/08 14:37:28]Volume SCSI Request, Illegal CDB Opcode=0xa0

when the driver loads. I guess the TUR is coming from sd. But neither of
these indicate why the READ CAPACITY (16) failed.

I've also tried printing out the command status from the driver but it only
shows a check condition with no sense.

Any ideas? Or is there not enough info here?

Thanks,
mikem
