From: James Smart <james.smart@emulex.com>
Subject: Re: [SCSI] lpfc 8.3.28: Add support for ABTS failure handling
Date: Wed, 21 Dec 2011 10:01:35 -0500
Message-ID: <4EF1F4CF.3070704@emulex.com>
References: <20111216202745.GE18570@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:41541 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750733Ab1LUPB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2011 10:01:56 -0500
In-Reply-To: <20111216202745.GE18570@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Dan,

We should have another patch set coming shortly - will address it in that patch.

-- james s


On 12/16/2011 3:27 PM, Dan Carpenter wrote:
> Hello James Smart,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch cb69f7decc37: "[SCSI] lpfc 8.3.28: Add support for ABTS
> failure handling" from Dec 13, 2011, leads to the following Smatch
> complaint:
>
> drivers/scsi/lpfc/lpfc_sli.c +8391 lpfc_sli4_abts_err_handler()
> 	 error: we previously assumed 'ndlp' could be null (see line 8387)
>
> drivers/scsi/lpfc/lpfc_sli.c
>    8386	
>    8387		if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
>                      ^^^^^
> New check.
>
>    8388			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
>    8389					"3115 Node Context not found, driver "
>    8390					"ignoring abts err event\n");
>    8391		vport = ndlp->vport;
>                          ^^^^^^^^^^^
> New dereference.  Maybe the intent was to return after the print
> statement?
>
>    8392		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
>    8393				"3116 Port generated FCP XRI ABORT event on "
>
> regards,
> dan carpenter
>
>
