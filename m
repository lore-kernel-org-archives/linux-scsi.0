From: Douglas Gilbert <dougg@torque.net>
Subject: Re: "do ata" scsi command?
Date: Sat, 17 May 2003 14:17:34 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC5B7DE.4060402@torque.net>
References: <20030515230223.GA516@gtf.org> <20030516060324.GT812@suse.de> <3EC509A1.10503@pobox.com> <20030516160502.GE812@suse.de> <3EC51235.8090701@pobox.com> <20030516163558.GH812@suse.de> <3EC514AD.4000504@pobox.com> <20030516164320.GK812@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:60943 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261203AbTEQEEJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 00:04:09 -0400
In-Reply-To: <20030516164320.GK812@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Fri, May 16 2003, Jeff Garzik wrote:
> 
>>Jens Axboe wrote:
>>
>>>How would you shoehorn any given ata command into a scsi
>>>command?
>>
>>
>>Make up a vendor-specific scsi opcode, say 0x70.  Define this opcode 
>>such that it carries the ATA taskfile registers as cdb parameters.  Look 
>>at the taskfile as passed in the cdb to classify it (a la 
>>req_file->data_phase in drivers/ide).  Then execute it.
> 
> 
> As I wrote in the last email, I think this is about the ugliest idea (or
> close to) I've ever heard. You can't just go around making up opcodes.

Jens,
This subject is going to come up in the future. I'm
thinking about Serial Attached SCSI (SAS) which was
demo-ed at CeBit and various alliances are trying to
get to market by the end of this year.

In SAS we have a pure SCSI command set protocol (SSP),
a management protocol (SMP) and a protocol for tunnelling
the ATA/PI command set/task file over an SAS link (STP)**.
The idea is that users will be able to plug either SAS
or SATA disks into their RAID backplanes.

So we are likely to get a SAS HBA in the SCSI subsystem
(from Justin??) that is an initiator for those three
protocols. How do we handle STP??


** devices called expanders placed between the SAS HBA
and the SATA devices will provide fanout and the
SATA to STP physical/link mapping.

Doug Gilbert


