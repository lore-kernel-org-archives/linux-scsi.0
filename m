From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Thu, 16 Jun 2011 09:41:01 +0800
Message-ID: <637AF86F1A314F15B816411A580575F0@usish.com.cn>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com> <1308065367.2401.24.camel@mulgrave> <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com> <1308117450.2329.31.camel@mulgrave> <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:48670 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab1FPBlO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 21:41:14 -0400
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Xiangliang Yu' <yuxiangl@marvell.com>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: yxlraid@gmail.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 'Jacky Feng' <jfeng@marvell.com>

> 
> I get the issue like this:
> 1. HBA support 3Gbps, level 1 expander support 6Gbps, and level 2 expander
> support 6Gbps;
> 2. level 1 is fine, and find that level 2 link rate is 6Gbps in DISCOVER
command
> response.
> 3. LIBSAS think level 2 is 6Gbps by sas_ex_get_linkrate function, and send
> command to level 2 expander
> 4. LIBSAS link error.
> 
[Jack Wang] 
What do you mean by "LIBSAS link error", OPEN_REJECT(CONNECTION RATE NOT
SUPPORTED)? LIBSAS only get the error event through LLDD. 
According to SAS2r15 7.8.3

A SAS initiator port shall set the initial CONNECTION RATE field to:
a) the highest supported connection rate supported by a potential pathway as
determined during the 
discover process (e.g., based on the logical link rates of each logical link
reported in the SMP 
DISCOVER responses); or
b) the logical link rate of the logical phy used to transmit the OPEN
address frame.
If a SAS initiator port selected a connection rate based on discover process
information but the connection 
request results in OPEN_REJECT (CONNECTION RATE NOT SUPPORTED), then the
discover process 
information is no longer current and the discover process should be run
again.


