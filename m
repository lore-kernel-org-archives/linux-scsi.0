From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sense buffer length for REQUEST SENSE?
Date: Sat, 27 Jul 2002 00:47:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D4225D5.9A8ED692@torque.net>
References: <3D420D77.A4633D9C@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> 
> The sense buffer size is 64 bytes.

I can plead guilty to that. A finger in the air trade off
between the standard ** and reality. It previously was 16
bytes (changed in lk 2.3 I think). At 64 bytes it matches 
the size of the Scsi_Cmnd::sense_buffer array 
(and Scsi_Request::sr_sense_buffer).
 
> According to SAM-3, to make sure that that an application

SAM-3 is new (it branched off recently from SAM-2) and adds
SAS to its protocol tables. SAS is SCSI over Serial ATA
type infrastructure ... SAS may displace Ultra 640.

> client has gotten all the sense data the sense buffer
> should be 252 bytes.

Yes I can see that number in SPC-3. Has anyone every seen
an actual REQUEST SENSE response (sense buffer) anywhere near 
that size? The new "descriptor" sense data format should
further reduce the size requirement.
 
> How safe am I to actually set the allocation length
> to 252 bytes? (in terms of borken hardware devices, etc.)

Following the lead from 36 byte INQUIRYs, what does Windows
do?

BTW I have not seen a report of the current 64 byte allocation
length causing a problem.

** SCSI-2 said 18 bytes or greater and now SPC-3 says at least
   252 bytes.

Doug Gilbert
