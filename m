From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Return -EINVAL when "id == max_id" in scsi_scan_host_selected()
Date: Tue, 23 May 2006 09:47:53 +0200
Message-ID: <4472BE29.4020106@suse.de>
References: <1148080489.23417.18.camel@amitarora.in.ibm.com> <20060520042132.GC2826@parisc-linux.org> <1148108792.13190.36.camel@amitarora.in.ibm.com> <1148345675.3320.77.camel@mulgrave.il.steeleye.com> <20060523011619.GG4093@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:42400 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1750892AbWEWHsR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 May 2006 03:48:17 -0400
In-Reply-To: <20060523011619.GG4093@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Amit Arora <aarora@in.ibm.com>, linux-scsi@vger.kernel.org, patmans@us.ibm.com

Matthew Wilcox wrote:
> On Mon, May 22, 2006 at 07:54:35PM -0500, James Bottomley wrote:
>> Actually, we've got another cockup here with drivers: some have set =
this
>> to 8 or 16 and others to 7 or 15.  If we apply this without auditing
>> them, for those who set it to 7 or 15, the last target will end up
>> inaccessible.
>=20
> So as scsi maintainer, what's your preference for the 'right way' to =
fix
> this?  Clearly a whole-scale driver audit is needed, so my preference=
 is
> to rename the variable (how about id_limit?) and then do a sweep
> checking that everybody's using it correctly.
>=20
Ah. I see a pattern emerging.

ncr53c7xx.c has this:

#ifdef LINUX_1_2
	|| cmd->device->id > 7
#else
	|| cmd->device->id > host->max_id
#endif

So appearently in the good old days max_id was indeed defined as the
highest available target number. Whereas most 'modern' drivers define
this c-style-wise as the first non-available number.

So I would go for the latter approach and audit the drivers.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
