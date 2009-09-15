From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/5] SCSI: Add support for 32-byte CDBs
Date: Tue, 15 Sep 2009 11:15:23 +0300
Message-ID: <4AAF4D1B.3060205@panasas.com>
References: <1252053394-24886-1-git-send-email-martin.petersen@oracle.com>	<1252053394-24886-2-git-send-email-martin.petersen@oracle.com>	<4AA395E8.8020300@panasas.com> <yq18wgo4u41.fsf@sermon.lab.mkp.net>	<4AA766F8.6050801@panasas.com> <yq1iqfq2doc.fsf@sermon.lab.mkp.net>	<4AACBC0C.9050703@panasas.com> <yq163bk8y35.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:55627 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755217AbZIOIQB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2009 04:16:01 -0400
In-Reply-To: <yq163bk8y35.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 09/15/2009 10:29 AM, Martin K. Petersen wrote:
>>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> 
> Boaz> This patch replaces both:
> Boaz> 	[PATCH 1/5] SCSI: Add support for 32-byte CDBs
> Boaz>   [PATCH 4/5] sd: Support disks formatted with DIF Type 2
> 
> Boaz> right?
> 
> Yep.
> 
> 
> Boaz> One question below
> 
>>> + SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
>>> +
> 
> Boaz> The cmd_len gets updated later on, in scsi_lib.c right?
> 
> Nope.  But you are right that I should set cmd_len correctly.  Otherwise
> LLDs won't transfer sufficient CDB data (that's obviously not a problem
> for scsi_debug which is what I've been using for testing).
> 

It does in scsi_init_cmd_errh() which is called from scsi_request_fn().
It does:
	if (cmd->cmd_len == 0)
		cmd->cmd_len = scsi_command_size(cmd->cmnd);

Now scsi_command_size() perfectly understand VARIABLE_LENGTH_CMD, but it might
be clearer to set it here next to the command setup, in sd.c.

Boaz
