From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Wed, 15 Jun 2011 19:29:18 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAE66CCA@SC-VEXCH4.marvell.com>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
 <1308065367.2401.24.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
 <1308117450.2329.31.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com>
 <637AF86F1A314F15B816411A580575F0@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66CAE@SC-VEXCH4.marvell.com>
 <51A55E816E3847EF97FE4E849A572717@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:52846 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab1FPCa4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2011 22:30:56 -0400
In-Reply-To: <51A55E816E3847EF97FE4E849A572717@usish.com.cn>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: "yxlraid@gmail.com" <yxlraid@gmail.com>, "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>, "maciej.trela@intel.com" <maciej.trela@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>

> [Jack Wang] 
>It's the same, sas_ex_get_linkrate use DISCOVER response as linkrate.
But the function have problem, actually, the error statement is:
child->linkrate = min(parent_phy->linkrate, child->max_linkrate); 
its mean like this:
child->linkrate = min(child_phy->linkrate, max(parent->max_linkrate,child_phy->linkrate));
and if parent->max_linkrate(3Gbps) is less than child_phy->linkrate(6Gbps),
the statement will be change this:
child->linkrate = child_phy->linkrate, forget the parent linkrate.

