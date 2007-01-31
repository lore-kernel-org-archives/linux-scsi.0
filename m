From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] - export scsilun_to_int
Date: Wed, 31 Jan 2007 12:44:43 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D7055F3DB@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43021 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160998AbXAaTo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2007 14:44:57 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Wednesday, January 31, 2007 10:02 AM,  James Bottomley wrote:
> This is wrong.  the "int" represents our internal coding of the 8 byte
> extended LUN (currently it's a lossy transform that only allows up to
> two level LUNs, so one day this will definitely change).  No driver
> should be using this internally.  From the patches it merely 
> looks like
> you want to print out the value of a struct scsilun in debugging code,
> so perhaps a simple print_scsilun or something would be better?
> 
> James


No, this section of code is needed for more than printing the lun value.
Here is a snip from that patch you may of missed:

- if ((mf->TargetID != ((u8)vdevice->vtarget->target_id)) || (mf->LUN[1]
!= ((u8) vdevice->lun)))
+if ((mf->Bus != vdevice->vtarget->channel) ||
+    (mf->TargetID != vdevice->vtarget->id) ||
+    (lun != vdevice->lun))

We need to convert the SAM3 LUN format, back to the scsi-mid layer
version of the lun
value, which currently is defined as an integer in linux.    We save
that scsi midlayer verison
of lun, inside vdevice->lun at the start of day.  The mf->LUN  field
will be in SAM3 LUN format.
This sanity if/then check is required as we are trying to complete
outstanding request 
for a given scsi_device, eg. lun.

Do you want me to create my own function for converting the lun value,
or can I use
this one already defined in the linux kernel?

Eric
