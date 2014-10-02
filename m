From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCHv5 00/24] scsi logging update (the boring part)
Date: Thu, 2 Oct 2014 18:53:54 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCABD2@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:32780 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaJBSyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 14:54:55 -0400
In-Reply-To: <1412144580-72880-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, 01 October, 2014 1:23 AM
> To: James Bottomley
> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Elliott, Robert (Server
> Storage); Hannes Reinecke
> Subject: [PATCHv5 00/24] scsi logging update (the boring part)
> 
> This is the next iteration of my scsi logging patchset.
> The patchset just contains some logging updates, code
> reshuffling and sanity fixes. Nothing major.
> 
> The second part of this patchset (the printk bit)
> has been vetoed for the moment, so I'll have to
> work on that. But in any case this patchset is
> pretty much independent.
> 
> Difference to v4:
> - Add 'Reviewed-by' tags from hch where applicable
> - Split off the fas216 patch into two different patches
> - Added a patch to document scsi_try_to_abort_cmd
> 
> Hannes Reinecke (24):
>   Remove scsi_cmd_print_sense_hdr()
>   sd: Remove scsi_print_sense() in sd_done()
>   aha152x: Debug output update and whitespace cleanup
>   scsi: introduce sdev_prefix_printk()
>   scsi: Use sdev as argument for sense code printing
>   acornscsi: use scsi_print_command()
>   fas216: Return DID_ERROR for incomplete data transfer
>   fas216: Update logging messages
>   53c700: remove scsi_print_sense() usage
>   scsi: stop decoding if scsi_normalize_sense() fails
>   scsi: do not decode sense extras
>   scsi: use 'bool' as return value for scsi_normalize_sense()
>   scsi: remove scsi_print_status()
>   Implement scsi_opcode_sa_name
>   scsi: merge print_opcode_name()
>   scsi: consolidate opcode lookup in scsi_opcode_sa_name()
>   scsi: remove last argument from print_opcode_name()
>   scsi: Remove scsi_print_command when calling abort
>   scsi: separate out scsi_(host|driver)byte_string()
>   sd: Cleanup logging
>   scsi: simplify scsi_log_(send|completion)
>   scsi: fixup logging messages in scsi_error.c
>   scsi: use shost argument in scsi_eh_prt_fail_stats
>   scsi_error: document scsi_try_to_abort_cmd

With this 24-part series applied to 3.17rc7, with the 
kernel set to print timestamps (e.g., printk.time=y on the kernel
command line), the prints still end up trickling out a byte
at a time, interleaved from different threads, when the system 
is overloaded.

Maybe that's addressed by the part that is deferred?

Example serial log excerpt:

[74465.705193] sd 2:0:0:0: [sdr] CDB:
[74465.705194] :
[74465.705196]  0
                 [74465.705196] sd 2:0:0:0: [sdr] (null)FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[74465.705197]  00
[74465.705198] :
[74465.705198] :
[74465.705199]  00
[74465.705200] Read(10)
[74465.705201]  28
[74465.705202]  f4
[74465.705202] sd 2:0:0:0: [sdr] Sense Key : Hardware Error [current]
[74465.705204]  b2
[74465.705204]  28
[74465.705205]  28
[74465.705206]  01
[74465.705207] :
[74465.705207]  00
[74465.705208]  70
[74465.705209]  f8
[74465.705210] sd 2:0:0:0: [sdr] Add. Sense: Logical unit failure
[74465.705211]  00
[74465.705211]  00
[74465.705212]  2f
[74465.705213]  28
[74465.705214]  00
[74465.705215]  00
[74465.705215]  00
[74465.705217]  00
[74465.705217] sd 2:0:0:0: [sdr] CDB:
[74465.705218]  00
[74465.705219]  70
[74465.705219]  00
[74465.705220]  00
[74465.705221]  00
[74465.705221]  00
[74465.705222]  01
[74465.705223] Read(10)
[74465.705223]  01
[74465.705224]  00
[74465.705225]  00
[74465.705226]  9c
[74465.705227]  08
[74465.705227]  08
[74465.705228]  81
[74465.705229] :
[74465.705229]  9d
[74465.705230]  00
[74465.705231]  01
[74465.705232]  70
[74465.705232]  00
[74465.705233]  00
[74465.705234]  50
[74465.705234]  28
[74465.705235]  e8
[74465.705236]  08
[74465.705237]  9f
[74465.705237]  00
[74465.705238]
[74465.705238]
[74465.705239]  00
[74465.705240]  00
[74465.705240]  00
[74465.705241]  00
[74465.705242]  68
[74465.705243]  00
[74465.705243]  00
[74465.705244]  00
[74465.705245]  00
[74465.705245]
[74465.705246]  00
[74465.705247]  08
[74465.705247]  08
[74465.705248]  01
[74465.705249]  08
[74465.705250]  00
[74465.705250]  00
[74465.705251]  00
[74465.705253]  33
[74465.705253] sd 2:0:0:0: [sdr] Done: SUCCESS Result: hostbyte=DID_TARGET_FAILURE driverbyte=DRIVER_OK


