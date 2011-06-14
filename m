From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Tue, 14 Jun 2011 10:29:27 -0500
Message-ID: <1308065367.2401.24.camel@mulgrave>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yxlraid@gmail.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, yuxiangl@marvell.com, jfeng@marvell.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-06-14 at 23:17 +0800, yxlraid@gmail.com wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
> 
> -- The value of child link rate should is minimum of link rate, or
>    command will fail if child link rate is bigger than parent link rate.
> 
> Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
> ---
>  drivers/scsi/libsas/sas_expander.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 874e29d..6ccca09 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -638,7 +638,7 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
>  			sas_port_add_phy(port, phy->phy);
>  		}
>  	}
> -	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
> +	child->linkrate = min(parent_phy->linkrate, child->min_linkrate);

This patch doesn't look right.  It will clamp the phy to the minimum
possible link rate.  The child is supposed to support everywhere between
child->min_linkrate and child->max_linkrate.  The reason why we pick the
max is because we should use that if the parent supports it, and fall
back only if the parent isn't capable.

James
