From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] libsas: fix sense_buffer overrun
Date: Mon, 14 Jan 2008 11:29:25 -0800
Message-ID: <20080114192925.GB7118@tree.beaverton.ibm.com>
References: <20080113022015S.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:52141 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbYANT3e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 14:29:34 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0EJTS7S001837
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2008 14:29:28 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0EJTQxO072328
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2008 12:29:27 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0EJTQrd022540
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2008 12:29:26 -0700
Content-Disposition: inline
In-Reply-To: <20080113022015S.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Looks sane to me;
Acked-by: Darrick J. Wong <djwong@us.ibm.com>

--D

On Sun, Jan 13, 2008 at 02:20:18AM +0900, FUJITA Tomonori wrote:
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/libsas/sas_scsi_host.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index b784089..828fed1 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -108,7 +108,7 @@ static void sas_scsi_task_done(struct sas_task *task)
>  			break;
>  		case SAM_CHECK_COND:
>  			memcpy(sc->sense_buffer, ts->buf,
> -			       max(SCSI_SENSE_BUFFERSIZE, ts->buf_valid_size));
> +			       min(SCSI_SENSE_BUFFERSIZE, ts->buf_valid_size));
>  			stat = SAM_CHECK_COND;
>  			break;
>  		default:
> -- 
> 1.5.3.4
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
