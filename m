From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: READ CAPACITY (16) failing
Date: Fri, 10 Apr 2009 17:04:07 -0400
Message-ID: <49DFB447.5040009@interlog.com>
References: <20090408194357.GA15043@beardog.cca.cpqcorp.net> <20090408195447.GP20983@parisc-linux.org> <20090410193134.GA2615@beardog.cca.cpqcorp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51554 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZDJVEQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2009 17:04:16 -0400
In-Reply-To: <20090410193134.GA2615@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML-SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, mike.miller@hp.com, James Bottomley <james.bottomley@hansenpartnership.com>

Mike Miller (OS Dev) wrote:
> On Wed, Apr 08, 2009 at 01:54:48PM -0600, Matthew Wilcox wrote:
>> On Wed, Apr 08, 2009 at 02:43:57PM -0500, Mike Miller (OS Dev) wrote:
>>> I'm working on the HP Smart Array SCSI driver (hpsa) and I'm seeing the
>>> following failures:
>>>
>>> hpsa1: <0x3230> at PCI 0000:02:00.0 IRQ 76 using DAC
>>> scsi4 : hpsa
>>> scsi 4:0:0:0: Direct-Access     HP       LOGICAL VOLUME   5.20 PQ: 0 ANSI: 5
>>> sd 4:0:0:0: Attached scsi generic sg4 type 0
>>> sd 4:0:0:0: [sdd] READ CAPACITY(16) failed
>>> sd 4:0:0:0: [sdd] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
>>> sd 4:0:0:0: [sdd] Sense not available.
>>> hpsa: cp ffff8800cf400000 has check condition: unknown type: Sense: 0x5,
>>> ASC: 0x20, ASCQ: 0x0, Returning result: 0x2, cmd=[a0 00 00 00 00 00 00 00 10
>>> 00]
>>> The READ CAPACITY failures are what I'm concerned about. I can't seem to track
>>> down why that's failing.
>>> I've tried printing out the_result from sd but it's not printing out. I'm
>>> assuming that anytime I load the driver it goes thru sd.
>>>
>>> 	if (the_result) {
>>> 		sense_valid = scsi_sense_valid(&sshdr);
>>> 		if (sense_valid &&
>>> 			sshdr.sense_key == ILLEGAL_REQUEST &&
>>> 			(sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
>>> 			sshdr.ascq == 0x00)
>>> 			/* Invalid Command Operation Code or
>>> 			 * Invalid Field in CDB, just retry
>>> 			 * silently with RC10 */
>>> 			return -EINVAL;
>>> 		}
>>> 	retries--;
>>> 	} while (the_result && retries);
>>> 	printk(KERN_WARNING "sd-mfm: the_result = %d\n", the_result);
>> Probably the device you're testing against doesn't support RC16, which
>> is fine.  But for some reason, we're not getting valid sense data back
>> from the device.  Now, there's two responses to this that seem rational
>> to me:
>>
>>  - In sd.c, if the drive has returned no/invalid sense data, try RC10
>>    silently, just like the 0x20 / 0x24 ASC case.
>>  - Find out why this drive doesn't report valid sense data when attached
>>    to hpsa.  I assume it does report valid sense data when attached to
>>    some other scsi card?
> 
> Me again,
> The controllers do support RC16. After some more work it looks like RC16 is
> never getting to the driver. I'm snooping the CDB's of all requests as well
> as the completions from the driver and I never see a 0x9e. I do see the
> RC10 (0x25) though, so I think my debug is right.
> 
> Why would I never the see the command in the driver?

struct Scsi_host::max_cmd_len < 16 would be one reason but
one would expect an indicative message in the log.

Does a 'sg_readcap --long -vvv <device>' give you any further
information?

Doug Gilbert
