From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [Patch]Status_byte() in drivers/scsi/scsi.h
Date: 20 Jun 2003 07:37:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056112633.1804.5.camel@mulgrave>
References: <3EF178AC.CEC2C720@in.ibm.com> <3EF17DFC.8030700@torque.net>
	<3EF2C869.F794F1A6@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:29447 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263062AbTFTMXS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 08:23:18 -0400
In-Reply-To: <3EF2C869.F794F1A6@in.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Sachin Sant <sachinp@in.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-06-20 at 03:40, Sachin Sant wrote:
> 
> According to Dougs comments , here is the patch to include new macros
> for SAM status codes . Patch is in drivers/scsi/scsi.h
> 
> +#define sam_status_value(scmd_result) ((scmd_result) & 0x7e)

This is not the correct thing to do.  Our problems with the status byte
stem from its evolving meaning.  In SCSI-1, it was a bitmap, in SCSI-2 a
value in a bitrange of reserved bits and in SCSI-3 it covers an entire
byte.  In SAM-3 all the defined codes have bit zero set to zero, so your
current patch would do no harm for now, but bit zero is no-longer a
reserved bit.

James






