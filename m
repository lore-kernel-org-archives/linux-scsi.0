From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: questions on scsi_level & Read command?
Date: Fri, 27 Jul 2007 10:17:39 -0400
Message-ID: <yq1d4yend6k.fsf@sermon.lab.mkp.net>
References: <87a7e2a0707262116q24f0f0edoefeddbff71df4605@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:38145 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760896AbXG0OSV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 10:18:21 -0400
In-Reply-To: <87a7e2a0707262116q24f0f0edoefeddbff71df4605@mail.gmail.com> (Ashish Sood's message of "Fri, 27 Jul 2007 09:46:09 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ashish Sood <ashishsood@gmail.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Ashish" == Ashish Sood <ashishsood@gmail.com> writes:

Ashish> Seems like scsi_level comes in response to the inquiry
Ashish> command.

Ashish> I am curious to know as to how this information will be used
Ashish> by scsi initiator?

Most things that depend on the SCSI level aren't used directly by the
initiator.  They're used by the SCSI layer when preparing commands to
send to the target.  Take a look at scsi_add_lun() in scsi_scan.c.

There are a couple of knobs that initiator drivers tend to access.
Whether a device supports wide and synchronous transfers, for
instance, is parallel SCSI specific and sits there for legacy reasons.
HBA drivers also want to know if a target supports tagged command
queuing.


Ashish> Also, looks there are six different read commands

Ashish> How does scsi initiator know which command to use? Is it based
Ashish> on some field which comes in response to the INQUIRY command.

There is a limit to how big a logical block address you can reach with
each of the READ/WRITE commands.  Over the years disks have grown
bigger and as a result new commands have been introduced to be able to
address the data them.

If you look in sd.c (the SCSI disk driver) you'll see that we'll use
READ(10) for LBAs below 2TB and READ(16) for LBAs above (assuming 512
byte sectors).

READ(32) / WRITE(32) are slightly different and are there to support
devices formatted with DIF Type 2 protection.

-- 
Martin K. Petersen	Oracle Linux Engineering

