From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Thu, 16 Jun 2011 12:31:34 +0800
Message-ID: <C8FBA6A948D643679B01520A89FAC48A@usish.com.cn>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com> <1308065367.2401.24.camel@mulgrave> <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com> <1308117450.2329.31.camel@mulgrave> <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com> <637AF86F1A314F15B816411A580575F0@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66CAE@SC-VEXCH4.marvell.com> <51A55E816E3847EF97FE4E849A572717@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66CCA@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:43830 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1FPEbw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2011 00:31:52 -0400
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAE66CCA@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Xiangliang Yu' <yuxiangl@marvell.com>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: yxlraid@gmail.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 'Jacky Feng' <jfeng@marvell.com>

> > [Jack Wang]
> >It's the same, sas_ex_get_linkrate use DISCOVER response as linkrate.
> But the function have problem, actually, the error statement is:
> child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
> its mean like this:
> child->linkrate = min(child_phy->linkrate,
> max(parent->max_linkrate,child_phy->linkrate));
> and if parent->max_linkrate(3Gbps) is less than
child_phy->linkrate(6Gbps),
> the statement will be change this:
> child->linkrate = child_phy->linkrate, forget the parent linkrate.
[Jack Wang] 
I don't think the statement below is error:
child->linkrate = min(parent_phy->linkrate, child->max_linkrate);

parent_phy->linkrate is came from sas_set_ex_phy which will set the linkrate
to negotiated logical linkrate. For your eg: you topo like this:
hba(3G)---expander1(6G)---expander2(6G):

Then expander1's linkrate will set to 3G, and expander2's linkrate will set
to 6G, that is correct. But the connection rate will be 3G from hba to
expander2.

