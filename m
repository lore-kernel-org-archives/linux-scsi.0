From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH/RFT] libata "DMA timeout" fix
Date: Sat, 28 Feb 2004 16:23:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <404106D7.8050809@pobox.com>
References: <4040E7B5.4020709@pobox.com> <1078001357.2020.90.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:42664 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261920AbUB1VXv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2004 16:23:51 -0500
In-Reply-To: <1078001357.2020.90.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Sat, 2004-02-28 at 13:10, Jeff Garzik wrote:
> 
>>===== drivers/scsi/libata-core.c 1.19 vs edited =====
>>--- 1.19/drivers/scsi/libata-core.c	Wed Feb 25 22:41:13 2004
>>+++ edited/drivers/scsi/libata-core.c	Sat Feb 28 14:03:18 2004
>>@@ -2130,6 +2130,14 @@
>> 				cmd->result = SAM_STAT_CHECK_CONDITION;
>> 			else
>> 				ata_to_sense_error(qc);
>>+
>>+			/* hack alert! we need this to get past the
>>+			 * first check in scsi_done().  libata is the
>>+			 * -only- user of ->eh_strategy_handler() in
>>+			 * any kernel tree, which exposes some incorrect
>>+			 * assumptions in the SCSI layer.
>>+			 */
>>+			scsi_add_timer(cmd, 2000 * HZ, NULL);
>> 		} else {
>> 			cmd->result = SAM_STAT_GOOD;
>> 		}
> 
> 
> You can't do this.  Supposing there command's delayed, the timer fires
> and then the command returns with a sense error?  The done will go
> through automatically completing the command, but your strategy handler
> will still think it has a failed command to handle.

hmmm, yeah that will be a problem iff we are not already in the strategy 
handler.


> The correct fix is this, I think (uncompiled, but you get the idea):

Yeah, that's much better.  That function is not exported though ;-)

	Jeff



