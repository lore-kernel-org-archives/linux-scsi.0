From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi_debug: support scsi-mq, queues and locks
Date: Thu, 31 Jul 2014 14:52:38 +0400
Message-ID: <1406803958.6957.2.camel@jarvis>
References: <20140731091028.GA29976@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50960 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbaGaKwo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2014 06:52:44 -0400
In-Reply-To: <20140731091028.GA29976@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, 2014-07-31 at 12:10 +0300, Dan Carpenter wrote:
> [ This is not really a new bug, it's just that renaming the function
>   made it show up as a new bug and I figured maybe you know what's going
>   on since you are working with related code.  -dan ]
> 
> Hello Douglas Gilbert,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch cbf67842c3d9: "scsi_debug: support scsi-mq, queues and 
> locks" from Jul 26, 2014, leads to the following Smatch complaint:
> 
> drivers/scsi/scsi_debug.c:4153 scsi_debug_queuecommand()
> 	 error: we previously assumed 'cmd' could be null (see line 4106)
> 
> drivers/scsi/scsi_debug.c
>   4105		if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) &&
>   4106		    !(SCSI_DEBUG_OPT_NO_CDB_NOISE & scsi_debug_opts) && cmd) {
>                                                                         ^^^
> Check.

This check is bogus.  cmd comes from

int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t
done)
{
	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;

which can never be NULL (cast is pointless as well, it's already an
unsigned char *).

James


