From: <berthiaume_wayne@emc.com>
Subject: RE: [PATCH] Add BLIST_REPORTLUN2 to EMC SYMMETRIX
Date: Thu, 2 Jul 2009 10:38:38 -0400
Message-ID: <8F08A56613D77044BD153E2AC5DA0F84023B21A2@CORPUSMX40A.corp.emc.com>
References: <200907012018.13695.jdelvare@suse.de> <1246476812.3894.56.camel@mulgrave.site> <20090701194224.GC20681@tpkurt2.suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:52993 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZGBOis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2009 10:38:48 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20090701194224.GC20681@tpkurt2.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: garloff@suse.de, James.Bottomley@HansenPartnership.com
Cc: jdelvare@suse.de, linux-scsi@vger.kernel.org, hare@suse.de

There are still very old Symmetrix arrays out there that could be broken
if we drop BLIST_SPARSELUN or BLIST_LARGELUN because they don't support
REPORT_LUNS.

Regards,
Wayne.  

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Kurt Garloff
Sent: Wednesday, July 01, 2009 3:42 PM
To: James Bottomley
Cc: Jean Delvare; linux-scsi@vger.kernel.org; Hannes Reinecke
Subject: Re: [PATCH] Add BLIST_REPORTLUN2 to EMC SYMMETRIX

James,

On Wed, Jul 01, 2009 at 07:33:32PM +0000, James Bottomley wrote:
> > --- root.orig/drivers/scsi/scsi_devinfo.c
> > +++ root/drivers/scsi/scsi_devinfo.c
> > @@ -152,7 +152,7 @@ static struct {
> >  	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage
on LUN 0 */
> >  	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no
storage on LUN 0 */
> >  	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
> > -	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |
BLIST_FORCELUN},
> > +	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |
BLIST_REPORTLUN2},
> 
> You don't actually need SPARSE or LARGELUN ... that's implied by
> REPORTLUN2, so only REPORTLUN2 is needed here.

When I created the patch, all SYMMETRIXes that I had ever been exposed
to did support REPORT_LUNs, but I was not sure that every single 
SYMMETRIX out there would actually support it. So in case some old
SYMMETRIX would not and the kernel would fall back to sequential
scanning, we would still find all LUNs by not dropping SPARSELUN
and LARGELUN. (Dropping FORCELUN on the other hand was absolutely right;
the flag is broken by design anyway and should never be used.)

So leaving in SPARSELUN and LARGELUN was not an oversight, but really
trying to be conservative.

If you have additional insight (you positively know that every SYMMETRIX
does support REPORT_LUNS) or you want to force possible devices that
do not support it into the open by breaking them, then remove the two
flags.

> >  	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
> >  	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
> >  	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},

Best,
-- 
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.
