From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFC] [PATCH 2.6.9-rc1] add blacklist attribute indicating no ULD attach
Date: Wed, 15 Sep 2004 00:37:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915073757.GA102330@sgi.com>
References: <20040914063237.GA97486@sgi.com> <20040914144023.GA9524@beaverton.ibm.com> <20040914182203.GA100433@sgi.com> <20040915031834.GA102988@sgi.com> <20040915074744.A17264@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:3766 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S262605AbUIOHio (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 03:38:44 -0400
Content-Disposition: inline
In-Reply-To: <20040915074744.A17264@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, patmans@us.ibm.com, axboe@suse.de, james.bottomley@steeleye.com

On Wed, Sep 15, 2004 at 07:47:44AM +0100, Christoph Hellwig wrote:
> On Tue, Sep 14, 2004 at 08:18:34PM -0700, Jeremy Higdon wrote:
> >  	}
> > +	else if (*bflags & BLIST_NO_ULD_ATTACH) {
> 
> Please put the else if on the same line as the closing brace

I don't like that style, but it does seem to be specified (I
hadn't noticed before) . . .

> > +		sdev->no_uld_attach = 1;
> > +	}
> 
> don't we already carry around the blacklist flags in the scsi dev so
> they could be checked laer?  If not maybe we should instead of adding
> more and more flags?

Outside of the scope of this patch, I think.  They are in the scsi
dev, but there is a little comment about them only being used "only
to pass settings from slave_alloc to scsi core."


Here is a patch to the previous patch.  If desired, once everyone
has commented, I can send the entire thing again.

Signed-off-by: Jeremy Higdon <jeremy@sgi.com>

===== drivers/scsi/scsi_scan.c 1.130 vs edited =====
--- 1.130/drivers/scsi/scsi_scan.c	2004-09-14 19:57:44 -07:00
+++ edited/drivers/scsi/scsi_scan.c	2004-09-15 00:31:52 -07:00
@@ -531,8 +531,7 @@
 		 */
 		inq_result[0] = TYPE_ROM;
 		inq_result[1] |= 0x80;	/* removable */
-	}
-	else if (*bflags & BLIST_NO_ULD_ATTACH) {
+	} else if (*bflags & BLIST_NO_ULD_ATTACH) {
 		sdev->no_uld_attach = 1;
 	}
 
