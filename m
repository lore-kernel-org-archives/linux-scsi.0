From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH][SCSI] cxgb3i: Fix error path for module init
Date: Wed, 28 Apr 2010 01:21:39 -0500
Message-ID: <4BD7D3F3.2070002@cs.wisc.edu>
References: <adazl0ojfud.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36181 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab0D1GVP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2010 02:21:15 -0400
In-Reply-To: <adazl0ojfud.fsf@roland-alpha.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-scsi@vger.kernel.org, Karen Xie <kxie@chelsio.com>, Rakesh Ranjan <rakesh@chelsio.com>, James Bottomley <James.Bottomley@suse.de>

On 04/28/2010 12:39 AM, Roland Dreier wrote:
> If cxgb3i_pdu_init() fails, then it appears that cxgb3i_iscsi_init()
> will not be cleaned up, leading to the iscsi transport being left
> registered.  Fix this by adding a call to cxgb3i_iscsi_cleanup() on the
> error path.
>
> Signed-off-by: Roland Dreier<rolandd@cisco.com>
> ---
>   drivers/scsi/cxgb3i/cxgb3i_init.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
> index d0ab23a..685af36 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_init.c
> +++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
> @@ -104,8 +104,10 @@ static int __init cxgb3i_init_module(void)
>   		return err;
>
>   	err = cxgb3i_pdu_init();
> -	if (err<  0)
> +	if (err<  0) {
> +		cxgb3i_iscsi_cleanup();
>   		return err;
> +	}
>
>   	cxgb3_register_client(&t3c_client);
>
>

Looks good to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
