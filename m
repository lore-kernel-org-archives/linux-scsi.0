From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] libiscsi: fix iscsi pool leak
Date: Fri, 16 Jan 2009 12:38:26 -0600
Message-ID: <4970D422.4050706@cs.wisc.edu>
References: <12321310122973-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53496 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760795AbZAPSie (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 13:38:34 -0500
Received: from [20.15.0.9] (c-75-73-66-60.hsd1.mn.comcast.net [75.73.66.60])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id n0GIcWsf012564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2009 12:38:32 -0600
In-Reply-To: <12321310122973-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I forgot to send a 0/2 patch.

These two patches were made over scsi-rc-fixes.


michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> I am not sure what happened. It looks like we have always leaked
> the q->queue that is allocated from the kfifo_init call. nab finally
> noticed that we were leaking and this patch fixes it by adding a
> kfree call to iscsi_pool_free. kfifo_free is not used per kfifo_init's
> instructions to use kfree.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/libiscsi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 7225b6e..257c241 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1981,6 +1981,7 @@ void iscsi_pool_free(struct iscsi_pool *q)
>  		kfree(q->pool[i]);
>  	if (q->pool)
>  		kfree(q->pool);
> +	kfree(q->queue);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_pool_free);
>  

