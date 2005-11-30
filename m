From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 5/5] aacraid: Check scsi_bios_ptabe return code
	(Updated)
Date: Wed, 30 Nov 2005 12:01:39 -0800
Message-ID: <1133380899.2288.37.camel@markh1.pdx.osdl.net>
References: <1133375802.2288.25.camel@markh1.pdx.osdl.net>
	 <20051130191400.GD19001@infradead.org>
	 <1133379795.2288.32.camel@markh1.pdx.osdl.net>
	 <1133380042.2825.62.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:50862 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750703AbVK3UBo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 15:01:44 -0500
In-Reply-To: <1133380042.2825.62.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>

On Wed, 2005-11-30 at 20:47 +0100, Arjan van de Ven wrote:
> On Wed, 2005-11-30 at 11:43 -0800, Mark Haverkamp wrote:
> > On Wed, 2005-11-30 at 19:14 +0000, Christoph Hellwig wrote:
> > > On Wed, Nov 30, 2005 at 10:36:42AM -0800, Mark Haverkamp wrote:
> > > > Received from Mark Salyzyn.
> > > > 
> > > > scsi_bios_ptable return value is not being checked in aac_biosparm.
> > > 
> > > should probably go into 2.6.15 after the usual trivial codingstyle fix..
> > > 
> > > >  	buf = scsi_bios_ptable(bdev);
> > > > +	if(buf == NULL)
> > > > +		return 0;
> > > 
> > > 	if (!buf)
> > > 		return 0;
> > OK, here is the updated patch:
> 
> I think your space bar is defective on your keyboard

I guess I need to get that fixed.

> 
> >  	buf = scsi_bios_ptable(bdev);
> > +	if(!buf)
> > +		return 0;
> 
> in linux we put a space between the if and the ()'s
> 
> 

This time for sure?

Received from Mark Salyzyn.

scsi_bios_ptable return value is not being checked in aac_biosparm.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.


Index: scsi-misc-aac/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2005-11-30 10:54:42.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2005-11-30 11:57:29.000000000 -0800
@@ -325,6 +325,8 @@
 	 *	translations ( 64/32, 128/32, 255/63 ).
 	 */
 	buf = scsi_bios_ptable(bdev);
+	if (!buf)
+		return 0;
 	if(*(__le16 *)(buf + 0x40) == cpu_to_le16(0xaa55)) {
 		struct partition *first = (struct partition * )buf;
 		struct partition *entry = first;

-- 
Mark Haverkamp <markh@osdl.org>

