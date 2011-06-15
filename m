From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Tue, 14 Jun 2011 23:31:25 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
	 <1308065367.2401.24.camel@mulgrave>
	 <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
 <1308117450.2329.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1308117450.2329.31.camel@mulgrave>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "yxlraid@gmail.com" <yxlraid@gmail.com>, "jack_wang@usish.com" <jack_wang@usish.com>, "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>, "maciej.trela@intel.com" <maciej.trela@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>
List-Id: linux-scsi@vger.kernel.org


On Tue, 2011-06-14 at 18:44 -0700, Xiangliang Yu wrote:
>> Subject: Re: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
>> 
>> On Tue, 2011-06-14 at 23:17 +0800, yxlraid@gmail.com wrote:
>> >> From: Xiangliang Yu <yuxiangl@marvell.com>
>> >> 
>> >> -- The value of child link rate should is minimum of link rate, or
>> >>    command will fail if child link rate is bigger than parent link rate.
>> >> 
>> >> Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
>> >> ---
>> >>  drivers/scsi/libsas/sas_expander.c |    2 +-
>> >>  1 files changed, 1 insertions(+), 1 deletions(-)
>> >> 
>> >> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> >> index 874e29d..6ccca09 100644
>> >> --- a/drivers/scsi/libsas/sas_expander.c
>> >> +++ b/drivers/scsi/libsas/sas_expander.c
>> >> @@ -638,7 +638,7 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
>> >>  			sas_port_add_phy(port, phy->phy);
>> >>  		}
>> >>  	}
>> >> -	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
>> >> +	child->linkrate = min(parent_phy->linkrate, child->min_linkrate);
>> 
>> >This patch doesn't look right.  It will clamp the phy to the minim
>> >possible link rate.  
>> Link negotiation should get the minimum.

>it's probably a negotiation problem.  If the
>child can't support the highest possible link rate because of problems
>like transmission errors, it should fall back.

I get the issue like this: 
1. HBA support 3Gbps, level 1 expander support 6Gbps, and level 2 expander support 6Gbps; 
2. level 1 is fine, and find that level 2 link rate is 6Gbps in DISCOVER command response.
3. LIBSAS think level 2 is 6Gbps by sas_ex_get_linkrate function, and send command to level 2 expander
4. LIBSAS link error.
