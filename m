From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/tcm_fc: Fix use-after-free of ft_tpg
Date: Sun, 06 Apr 2014 15:59:36 -0700
Message-ID: <1396825176.31010.5.camel@haakon3.risingtidesystems.com>
References: <1396655077-30912-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35410 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaDFW7f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Apr 2014 18:59:35 -0400
In-Reply-To: <1396655077-30912-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org

Hi Andy,

On Fri, 2014-04-04 at 16:44 -0700, Andy Grover wrote:
> ft_del_tpg checks tpg->tport is set before unlinking the tpg from the
> tport when the tpg is being removed. Set this pointer in ft_tport_create,
> or the unlinking won't happen in ft_del_tpg and tport->tpg will reference
> a deleted object.
> 
> see https://bugzilla.redhat.com/show_bug.cgi?id=1071340
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/tcm_fc/tfc_sess.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
> index 0475142..1329726 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c
> @@ -68,6 +68,7 @@ static struct ft_tport *ft_tport_create(struct fc_lport *lport)
>  
>  	if (tport) {
>  		tport->tpg = tpg;
> +		tpg->tport = tport;
>  		return tport;
>  	}
>  

I'm confused how this addresses the bug above..?

Does this mean the bug is only triggered when a previously
configured /sys/kernel/config/target/fc/$FCOE_WWPN/$TPGT has been
removed, and then a new PLOGI picks up a left-over pointer to an
endpoint that previously had been released..?

Care to add a more detailed commit explaining the exact details..?

--nab



