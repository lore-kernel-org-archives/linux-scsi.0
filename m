From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: fix uninitialized variable in iscsi
Date: Wed, 29 Oct 2008 10:44:12 -0500
Message-ID: <490884CC.9060106@cs.wisc.edu>
References: <20081029170359.70682e02.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46374 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbYJ2Po2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 11:44:28 -0400
In-Reply-To: <20081029170359.70682e02.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: open-iscsi@googlegroups.com, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Stephen Rothwell wrote:
> [Resend to get through vger's filters, sorry]
> 
> drivers/scsi/scsi_transport_iscsi.c: In function 'iscsi_add_session':
> drivers/scsi/scsi_transport_iscsi.c:704: warning: 'err' may be used uninitialized in this function
> 
> Indeed the error path can be taken without err being set.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/scsi/scsi_transport_iscsi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> I don't know if ENOMEM is the proper error code to return.
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 4a803eb..99855db 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -719,6 +719,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
>  						 "Too many iscsi targets. Max "
>  						 "number of targets is %d.\n",
>  						 ISCSI_MAX_TARGET - 1);
> +			err = -ENOMEM;
>  			goto release_host;
>  		}
>  	}

Thanks for the patch.

I have a patch for this from Benny Halevy already.
