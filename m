From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 27/27] scsi: ratelimit I/O error messages
Date: Tue, 21 Oct 2014 17:53:13 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295931CF6D@G4W3296.americas.hpqcorp.net>
References: <1413787950-14659-1-git-send-email-hare@suse.de>
 <1413787950-14659-28-git-send-email-hare@suse.de>
 <94D0CD8314A33A4D9D801C0FE68B40295931CCBB@G4W3296.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:58458 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312AbaJURyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 13:54:11 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295931CCBB@G4W3296.americas.hpqcorp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Elliott, Robert (Server Storage)
...
> With scsi_logging_level --set --error=5, there are:
> * 10 "FAILED Result" prints
>   * the first has no CDB
>   * at the end, there is a much later CDB print not preceded by a
> FAILED print
> * 10 "blk_update_request: critical target error" prints
>   * their sector number matches the preceding CDB print
> * 1 "blk_update_request: 539 callbacks suppressed" print
> * fio printed 33 io_u errors
>   * the first at offset 27118616, matching the first print
>   * one of the later ones is at offset 28297168, matching the last
> print
> * no "callbacks suppressed" messages from scsi_io_completion
...
> [49190.337402] sd 2:0:0:1: [sds] FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [49190.337404] sd 2:0:0:1: [sds] Sense Key : Hardware Error [current]
> [49190.337406] sd 2:0:0:1: [sds] Add. Sense: Logical unit failure
> [49190.337408] sd 2:0:0:1: [sds] CDB:
> [49190.337412] Read(10): 28 00 01 9d cc 58 00 00 08 00
> [49190.337413] blk_update_request: critical target error, dev sds,
> sector 27118680 <0x19dcc58>
> [49190.337417] blk_update_request: critical target error, dev sds,
> sector 27118688 <0x19dcc60>
> [49190.554043] sd 2:0:0:1: [sds] CDB:
> [49190.555178] Read(10): 28 00 01 af c7 d0 00 00 08 00 <28297168>
...

After triggering another error after lunch, a ratelimit message
for scsi_io_completion did finally appear:
[57601.577000] scsi_io_completion: 536 callbacks suppressed
[57601.578865] sd 2:0:0:0: [sdr] FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[57601.581535] sd 2:0:0:0: [sdr] Sense Key : Hardware Error [current]
[57601.584406] sd 2:0:0:0: [sdr] Add. Sense: Logical unit failure
[57601.586419] sd 2:0:0:0: [sdr] CDB:
[57601.587662] Read(10): 28 00 2e 92 90 00 00 00 08 00

---
Rob Elliott    HP Server Storage





