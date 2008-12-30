From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH -next v2] cxgb3i: use same dependencies & selects
	as	CHELSIO_T3
Date: Tue, 30 Dec 2008 10:20:24 -0600
Message-ID: <1230654024.3296.9.camel@localhost.localdomain>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
	 <20081229130110.67d5271a.randy.dunlap@oracle.com>
	 <20081229132312.10934479.randy.dunlap@oracle.com>
	 <1230587887.3302.70.camel@localhost.localdomain>
	 <49594A4D.6050303@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37463 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbYL3QU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2008 11:20:29 -0500
In-Reply-To: <49594A4D.6050303@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, kxie@chelsio.com, akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, samr <sam@ravnborg.org>

On Mon, 2008-12-29 at 14:08 -0800, Randy Dunlap wrote:
> James Bottomley wrote:
> > On Mon, 2008-12-29 at 13:23 -0800, Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> Make the CXGB iSCSI driver (that selects the CXGB net driver) have the same
> >> dependencies as the net driver, since kconfig doesn't do that automatically.
> >> Also make it select INET_LRO & FW_LOADER like the net driver does.
> > 
> > I thought select of a symbol that selected something else propagated
> > correctly (even if select of a symbol that depends on something else
> > doesn't).
> 
> I don't see that happening, at least in this case.
> Sam, can you clarify?

I've verified it works empirically ... and it's behaviour a lot more
than SCSI seems to be relying on.  However, confirming and documenting
this as expected behaviour would seem to be in order.

> > If this is untrue, we have several other Kconfig problems in
> > the kernel.
> 
> That would not be a surprise.

So, relying on the behaviour, I think this is the fix for the cxgb3i: it
splits the chelsio_t3 depends off so cxgbi3 can depend on them
separately and still select the option.

James

---

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 72a9212..9a18270 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2399,9 +2399,14 @@ config CHELSIO_T1_1G
           Enables support for Chelsio's gigabit Ethernet PCI cards.  If you
           are using only 10G cards say 'N' here.
 
+config CHELSIO_T3_DEPENDS
+	tristate
+	depends on PCI && INET
+	default y
+
 config CHELSIO_T3
 	tristate "Chelsio Communications T3 10Gb Ethernet support"
-	depends on PCI && INET
+	depends on CHELSIO_T3_DEPENDS
 	select FW_LOADER
 	select INET_LRO
 	help
diff --git a/drivers/scsi/cxgb3i/Kconfig b/drivers/scsi/cxgb3i/Kconfig
index 2762814..bfdcaf5 100644
--- a/drivers/scsi/cxgb3i/Kconfig
+++ b/drivers/scsi/cxgb3i/Kconfig
@@ -1,5 +1,6 @@
 config SCSI_CXGB3_ISCSI
 	tristate "Chelsio S3xx iSCSI support"
+	depends on CHELSIO_T3_DEPENDS
 	select CHELSIO_T3
 	select SCSI_ISCSI_ATTRS
 	---help---




