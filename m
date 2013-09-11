From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/9] fnic: host reset returns nonzero value(errno) on
 success
Date: Wed, 11 Sep 2013 13:04:29 -0700
Message-ID: <1378929869.4061.38.camel@dabdike.int.hansenpartnership.com>
References: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
	 <1378758713-22443-2-git-send-email-hiralpat@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50902 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757205Ab3IKUEb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Sep 2013 16:04:31 -0400
In-Reply-To: <1378758713-22443-2-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>
Cc: linux-scsi@vger.kernel.org, Narsimhulu Musini <nmusini@cisco.com>

On Mon, 2013-09-09 at 13:31 -0700, Hiral Patel wrote:
> From: Narsimhulu Musini <nmusini@cisco.com>
> 
> Fixed appropriate error codes that returns -1 on failure, and 0 on success

This is about as undescriptive as they come.  What you mean is that
fnic_reset() is used directly by the fc transport callback
issue_fc_host_lip which requires a negative error number on failure.

I really don't think you want to be returning -1, though; that's -EPERM.

> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Hiral Patel <hiralpat@cisco.com>
> ---
>  drivers/scsi/fnic/fnic_scsi.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index a97e6e5..ef3c463 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -2208,7 +2208,7 @@ int fnic_reset(struct Scsi_Host *shost)
>  {
>  	struct fc_lport *lp;
>  	struct fnic *fnic;
> -	int ret = SUCCESS;
> +	int ret = 0;
>  
>  	lp = shost_priv(shost);
>  	fnic = lport_priv(lp);
> @@ -2221,11 +2221,11 @@ int fnic_reset(struct Scsi_Host *shost)
>  	 * reset remote port sessions, and if link is up, begin flogi
>  	 */
>  	if (lp->tt.lport_reset(lp))
> -		ret = FAILED;
> +		ret = -1;

tt.lport_reset can't actually fail anyway, but if it did, it would
return a negative error no, so why not just do

ret = lp->tt.lport_reset()

instead of the if?

James


