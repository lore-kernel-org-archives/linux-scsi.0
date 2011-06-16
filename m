From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Thu, 16 Jun 2011 16:11:57 +0800
Message-ID: <6E6072BD03F348168F749B19B2BA90D3@usish.com.cn>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com> <1308065367.2401.24.camel@mulgrave> <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com> <1308117450.2329.31.camel@mulgrave> <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com> <637AF86F1A314F15B816411A580575F0@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66CAE@SC-VEXCH4.marvell.com> <51A55E816E3847EF97FE4E849A572717@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66CCA@SC-VEXCH4.marvell.com> <C8FBA6A948D643679B01520A89FAC48A@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66D1E@SC-VEXCH4.marvell.com> <E3CF09ECAD244C00A4C096DB374E140E@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66D88@SC-VEXCH4.marvell.com> <4F7167A354D8476AB58FD36CA6321960@usish.com.cn> <F766E4F80769BD47805
 2FB6533FA745D19FAE66DB6@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:51321 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1FPIMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2011 04:12:20 -0400
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAE66DB6@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Xiangliang Yu' <yuxiangl@marvell.com>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: yxlraid@gmail.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 'Jacky Feng' <jfeng@marvell.com>

> >> > >[Jack Wang]
> >> > >I don't think the statement below is error:
> >> > >child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
> >>
> >> The parent_phy is same to child_phy, I don't think it's right.
> >>
> >[Jack Wang] The parent_phy->linkrate is report from DISCOVER response as
> >negotiated link rate(parent phy with child phy), so same is right.
> 
> Parent_phy = &parent->ex_dev.ex_phy[phy_id]; (sas_ex_discover_expander)
> struct expander_device *parent_ex = &parent->ex_dev;(sas_ex_get_linkrate)
> struct ex_phy *phy = &parent_ex->ex_phy[i];
> so, parent_phy and phy are same one variable.
> 
> >> >> Yes, you can test like this.
> >> >> >Then expander1's linkrate will set to 3G, and expander2's linkrate
> will
> >> set
> >> >> >to 6G, that is correct.
> >> >> yes
> >> >> > But the connection rate will be 3G from hba to
> >> >> >expander2.
> >> >> How to configure the connection rate?
> >> >> Now, MVSAS driver get 6G from sas_ex_get_linkrate function, and set
> >> linkrate
> >> >> of OPEN address frame to the value. right?
> >> >>
> >> >> --
> >> >[Jack Wang]
> >> >Connection rate is auto, link layer will insert deletable primitives
to
> do
> >> >rate matching (sas2r15 7.14).
> >>
> >> >Yes, you should set the linkrate to that value .
> >>
> >> OK.MVSAS driver seem right. But, the problem is command fail because of
> link
> >> error, that is why I commit this patch. And my patch work fine.
> >> You can reproduce the issue and fix it. Thanks!
> >[Jack Wang]  I re-consider it , you maybe should compare the HBA linkrate
> >with the child phy linkrate and chose a minor.
> 
> Yes, how about this:
> -	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
>  +	child->linkrate = min(parent->max_linkrate, child->max_linkrate);
> The max link rate of parent have HBA link rate info:
> dev->max_linkrate = port->linkrate; (in sas_get_port_device function).

[Jack Wang] 
No, I mean you when you set connection rate in OPEN Address frame, you
compare your HBA linkrate with the linkrate of the phy you want to open, and
chose the minor.

