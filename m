From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Patch]Status_byte() in drivers/scsi/scsi.h
Date: Fri, 20 Jun 2003 23:52:39 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EF311A7.8030102@torque.net>
References: <3EF178AC.CEC2C720@in.ibm.com> <3EF17DFC.8030700@torque.net> 	<3EF2C869.F794F1A6@in.ibm.com> <1056112633.1804.5.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:17161 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S261773AbTFTNjE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 09:39:04 -0400
In-Reply-To: <1056112633.1804.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Sachin Sant <sachinp@in.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Fri, 2003-06-20 at 03:40, Sachin Sant wrote:
> 
>>According to Dougs comments , here is the patch to include new macros
>>for SAM status codes . Patch is in drivers/scsi/scsi.h
>>
>>+#define sam_status_value(scmd_result) ((scmd_result) & 0x7e)
> 
> 
> This is not the correct thing to do.  Our problems with the status byte
> stem from its evolving meaning.  In SCSI-1, it was a bitmap, in SCSI-2 a
> value in a bitrange of reserved bits and in SCSI-3 it covers an entire
> byte.  In SAM-3 all the defined codes have bit zero set to zero, so your
> current patch would do no harm for now, but bit zero is no-longer a
> reserved bit.

SAM-3 (rev 7) doesn't say status is a byte either.
However since it doesn't define the endianess of
status then it is probably safe to assume it is.
If we choose a mask of 0xff we could only upset
SCSI-1 (and perhaps CCS) devices. Many of those
around?


On a related subject, SPC-3 defines a new "descriptor" sense
data format (see section 4.5). It is a lot cleaner and more
compact than the original one and is controlled by the D_SENSE
bit in the control mode page. Has anybody seen a target
that supports these?

Doug Gilbert


