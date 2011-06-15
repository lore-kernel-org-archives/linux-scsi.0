From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Wed, 15 Jun 2011 01:57:30 -0400
Message-ID: <1308117450.2329.31.camel@mulgrave>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
	 <1308065367.2401.24.camel@mulgrave>
	 <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55452 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922Ab1FOF5e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2011 01:57:34 -0400
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: "yxlraid@gmail.com" <yxlraid@gmail.com>, "jack_wang@usish.com" <jack_wang@usish.com>, "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>, "maciej.trela@intel.com" <maciej.trela@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>

On Tue, 2011-06-14 at 18:44 -0700, Xiangliang Yu wrote:
> Subject: Re: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
> 
> On Tue, 2011-06-14 at 23:17 +0800, yxlraid@gmail.com wrote:
> >> From: Xiangliang Yu <yuxiangl@marvell.com>
> >> 
> >> -- The value of child link rate should is minimum of link rate, or
> >>    command will fail if child link rate is bigger than parent link rate.
> >> 
> >> Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
> >> ---
> >>  drivers/scsi/libsas/sas_expander.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> >> index 874e29d..6ccca09 100644
> >> --- a/drivers/scsi/libsas/sas_expander.c
> >> +++ b/drivers/scsi/libsas/sas_expander.c
> >> @@ -638,7 +638,7 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
> >>  			sas_port_add_phy(port, phy->phy);
> >>  		}
> >>  	}
> >> -	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
> >> +	child->linkrate = min(parent_phy->linkrate, child->min_linkrate);
> 
> >This patch doesn't look right.  It will clamp the phy to the minim
> >possible link rate.  
> Link negotiation should get the minimum.

No ... according to the spec it should be the max of what the child
supports taking into account the max the expander phy supports.

> >The child is supposed to support everywhere between
> >child->min_linkrate and child->max_linkrate.  The reason why we pick the
> >max is because we should use that if the parent supports it, and fall
> >back only if the parent isn't capable.
> Now, the problem is command fail, and LIBSAS seem to do nothing.
> Do you mean drive need to fix the link error?
> Thanks!
> 
> PS: The Kernel will panic when link error happening.

Post the panic then ... it's probably a negotiation problem.  If the
child can't support the highest possible link rate because of problems
like transmission errors, it should fall back.

James


