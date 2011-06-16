From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Thu, 16 Jun 2011 10:18:44 +0800
Message-ID: <51A55E816E3847EF97FE4E849A572717@usish.com.cn>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com> <1308065367.2401.24.camel@mulgrave> <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com> <1308117450.2329.31.camel@mulgrave> <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com> <637AF86F1A314F15B816411A580575F0@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66CAE@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAE66CAE@SC-VEXCH4.marvell.com>
Sender: linux-kernel-owner@vger.kernel.org
To: 'Xiangliang Yu' <yuxiangl@marvell.com>, 'James Bottomley' <James.Bottomley@HansenPartnership.com>
Cc: yxlraid@gmail.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 'Jacky Feng' <jfeng@marvell.com>
List-Id: linux-scsi@vger.kernel.org

> >> I get the issue like this:
> >> 1. HBA support 3Gbps, level 1 expander support 6Gbps, and level 2
expander
> >> support 6Gbps;
> >> 2. level 1 is fine, and find that level 2 link rate is 6Gbps in
DISCOVER
> command
> >> response.
> >> 3. LIBSAS think level 2 is 6Gbps by sas_ex_get_linkrate function, and
send
> >> command to level 2 expander
> >> 4. LIBSAS link error.
> >>
> >[Jack Wang]
> >What do you mean by "LIBSAS link error", OPEN_REJECT(CONNECTION RATE NOT
> >SUPPORTED)? LIBSAS only get the error event through LLDD.
> >According to SAS2r15 7.8.3
> I mean that HBA get link error. Sorry.
> 
> >A SAS initiator port shall set the initial CONNECTION RATE field to:
> >a) the highest supported connection rate supported by a potential pathway
as
> determined during the
> >discover process (e.g., based on the logical link rates of each logical
link
> reported in the SMP
> >DISCOVER responses); or
> Sas_ex_get_linkrate function
> 
[Jack Wang] 
It's the same, sas_ex_get_linkrate use DISCOVER response as linkrate.

> >b) the logical link rate of the logical phy used to transmit the OPEN
> address frame.
> MVSAS get value of linkrate from sas_ex_get_linkrate
> function(child->linkrate)
> 
> >If a SAS initiator port selected a connection rate based on discover
process
> information but the connection
> >request results in OPEN_REJECT (CONNECTION RATE NOT SUPPORTED), then the
> discover process
> >information is no longer current and the discover process should be run
> again.
> 
> Fail again.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
