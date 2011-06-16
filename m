From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Wed, 15 Jun 2011 18:57:05 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAE66CAE@SC-VEXCH4.marvell.com>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
 <1308065367.2401.24.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
 <1308117450.2329.31.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com>
 <637AF86F1A314F15B816411A580575F0@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:36259 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209Ab1FPB6f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2011 21:58:35 -0400
In-Reply-To: <637AF86F1A314F15B816411A580575F0@usish.com.cn>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: "yxlraid@gmail.com" <yxlraid@gmail.com>, "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>, "maciej.trela@intel.com" <maciej.trela@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jacky Feng <jfeng@marvell.com>


>> I get the issue like this:
>> 1. HBA support 3Gbps, level 1 expander support 6Gbps, and level 2 expander
>> support 6Gbps;
>> 2. level 1 is fine, and find that level 2 link rate is 6Gbps in DISCOVER
command
>> response.
>> 3. LIBSAS think level 2 is 6Gbps by sas_ex_get_linkrate function, and send
>> command to level 2 expander
>> 4. LIBSAS link error.
>> 
>[Jack Wang] 
>What do you mean by "LIBSAS link error", OPEN_REJECT(CONNECTION RATE NOT
>SUPPORTED)? LIBSAS only get the error event through LLDD. 
>According to SAS2r15 7.8.3
I mean that HBA get link error. Sorry.

>A SAS initiator port shall set the initial CONNECTION RATE field to:
>a) the highest supported connection rate supported by a potential pathway as
determined during the 
>discover process (e.g., based on the logical link rates of each logical link
reported in the SMP 
>DISCOVER responses); or
Sas_ex_get_linkrate function

>b) the logical link rate of the logical phy used to transmit the OPEN
address frame.
MVSAS get value of linkrate from sas_ex_get_linkrate function(child->linkrate)

>If a SAS initiator port selected a connection rate based on discover process
information but the connection 
>request results in OPEN_REJECT (CONNECTION RATE NOT SUPPORTED), then the
discover process 
>information is no longer current and the discover process should be run
again.

Fail again.

