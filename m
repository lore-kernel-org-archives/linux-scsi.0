From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] hpsa: correct compiler warnings introduced by
 hpsa-add-local-workqueue patch
Date: Tue, 10 Feb 2015 08:56:30 -0800
Message-ID: <1423587390.2167.21.camel@HansenPartnership.com>
References: <20150206234415.23960.78547.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52733 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762AbbBJQ4c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2015 11:56:32 -0500
In-Reply-To: <20150206234415.23960.78547.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, keescook@chromium.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>

On Fri, 2015-02-06 at 17:44 -0600, Don Brace wrote:
> Correct compiler warning introduced by hpsa-add-local-workqueue patch
> 6636e7f455b33b957c5ee016daa6de46148026ab hpsa: Use local workqueues
> instead of system workqueues
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Webb Scales <webbnh@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 95d581c..a1cfbd3 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6831,10 +6831,8 @@ static struct workqueue_struct *hpsa_create_controller_wq(struct ctlr_info *h,
>  						char *name)
>  {
>  	struct workqueue_struct *wq = NULL;
> -	char wq_name[20];
>  
> -	snprintf(wq_name, sizeof(wq_name), "%s_%d_hpsa", name, h->ctlr);
> -	wq = alloc_ordered_workqueue(wq_name, 0);
> +	wq = alloc_ordered_workqueue("%s_%d_hpsa", 0, name, h->ctlr);

It's not an objection to your patch, but what idiot did this?  There's
an extra variable there between the format and the arguments.  That
makes the pattern counterintuitive (i.e. an interface easy to get wrong)
because everywhere else, the arguments immediately follow the format
argument.  Please never, ever do this again.

By the way, the above is rhetorical ... the culprit is in the cc.

James

