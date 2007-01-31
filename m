From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] - export scsilun_to_int
Date: Wed, 31 Jan 2007 14:48:59 -0600
Message-ID: <1170276539.3402.68.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D7055F3DB@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49615 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030568AbXAaUtG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2007 15:49:06 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7055F3DB@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2007-01-31 at 12:44 -0700, Moore, Eric wrote:
> On Wednesday, January 31, 2007 10:02 AM,  James Bottomley wrote:
> > This is wrong.  the "int" represents our internal coding of the 8 byte
> > extended LUN (currently it's a lossy transform that only allows up to
> > two level LUNs, so one day this will definitely change).  No driver
> > should be using this internally.  From the patches it merely 
> > looks like
> > you want to print out the value of a struct scsilun in debugging code,
> > so perhaps a simple print_scsilun or something would be better?
> > 
> > James
> 
> 
> No, this section of code is needed for more than printing the lun value.
> Here is a snip from that patch you may of missed:
> 
> - if ((mf->TargetID != ((u8)vdevice->vtarget->target_id)) || (mf->LUN[1]
> != ((u8) vdevice->lun)))
> +if ((mf->Bus != vdevice->vtarget->channel) ||
> +    (mf->TargetID != vdevice->vtarget->id) ||
> +    (lun != vdevice->lun))

Yes, I missed that.  However, the mf (SCSIIORequest_t) comes back with
the 8 byte luns, couldn't you just run vdevice->lun through
int_to_scsilun and compare on that?

I'm really reluctant to export the lun to int lossy transform because it
will encourage bad uses.

James


