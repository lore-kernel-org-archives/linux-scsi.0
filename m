From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: scsi-rc-fixes tree build failure
Date: Thu, 30 Jul 2009 09:53:23 -0500
Message-ID: <1248965603.3880.64.camel@mulgrave.site>
References: <20090730181345.cec774b2.sfr@canb.auug.org.au>
	 <1248961882.3880.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751372AbZG3Ox3@vger.kernel.org>
In-Reply-To: <1248961882.3880.4.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Tom Peng <tom_peng@usish.com>, Jack Wang <jack_wang@usish.com>, Lindar Liu <lindar_liu@usish.com>, Kevin Ao <aoqingyun@usish.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-07-30 at 08:51 -0500, James Bottomley wrote:
> On Thu, 2009-07-30 at 18:13 +1000, Stephen Rothwell wrote:
> > Hi James,
> > 
> > Today's linux-next build (powerpc allyesconfig) failed like this:
> > 
> > drivers/scsi/libsas/sas_expander.c: In function 'sas_find_bcast_dev':
> > drivers/scsi/libsas/sas_expander.c:1701: error: 'FALSE' undeclared (first use in this function)
> > drivers/scsi/libsas/sas_expander.c: In function 'sas_discover_new':
> > drivers/scsi/libsas/sas_expander.c:1809: error: 'FALSE' undeclared (first use in this function)
> > drivers/scsi/libsas/sas_expander.c:1824: error: 'TRUE' undeclared (first use in this function)
> > drivers/scsi/libsas/sas_expander.c: In function 'sas_rediscover':
> > drivers/scsi/libsas/sas_expander.c:1903: error: 'TRUE' undeclared (first use in this function)
> > drivers/scsi/libsas/sas_expander.c:1918: error: 'FALSE' undeclared (first use in this function)
> > drivers/scsi/libsas/sas_expander.c: In function 'sas_ex_revalidate_domain':
> > drivers/scsi/libsas/sas_expander.c:1951: error: 'TRUE' undeclared (first use in this function)
> > 
> > Caused by commit 4c70d933a41e1d712f3db90d2a41141730383d5a ("[SCSI]
> > libsas: fix wide port hotplug issues").  Presumably a missing include
> > file.
> 
> Actually, I don't think so.  It's confusion over the use of boolean
> variables.  I think they have to be set to lower case true, false, not
> upper case.  There's obviously some accidental definition of TRUE and
> FALSE in x86.
> 
> > I have reverted that commit for today.
> 
> Thanks, I've dropped it from my tree ... I'll put it back when this is
> sorted out.

This fixes it on my ppc64 box, so I'll fold it into the original patch
and put it back into the tree.

James

---

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 296d008..b338195 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1698,7 +1698,7 @@ static int sas_find_bcast_dev(struct domain_device *dev,
 		* in order to determine if this expander originate BROADCAST,
 		* and do not update phy change count field in our structure.
 		*/
-		res = sas_find_bcast_phy(dev, &phy_id, 0, FALSE);
+		res = sas_find_bcast_phy(dev, &phy_id, 0, false);
 		if (phy_id != -1) {
 			*src_dev = dev;
 			ex->ex_change_count = ex_change_count;
@@ -1806,7 +1806,7 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
 {
 	struct ex_phy *ex_phy = &dev->ex_dev.ex_phy[phy_id];
 	struct domain_device *child;
-	bool found = FALSE;
+	bool found = false;
 	int res, i;
 
 	SAS_DPRINTK("ex %016llx phy%d new device attached\n",
@@ -1821,7 +1821,7 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
 			continue;
 		if (SAS_ADDR(ex_phy_temp->attached_sas_addr) ==
 		    SAS_ADDR(ex_phy->attached_sas_addr)) {
-			found = TRUE;
+			found = true;
 			break;
 		}
 	}
@@ -1900,7 +1900,7 @@ static int sas_rediscover(struct domain_device *dev, const int phy_id)
 	struct ex_phy *changed_phy = &ex->ex_phy[phy_id];
 	int res = 0;
 	int i;
-	bool last = TRUE;	/* is this the last phy of the port */
+	bool last = true;	/* is this the last phy of the port */
 
 	SAS_DPRINTK("ex %016llx phy%d originated BROADCAST(CHANGE)\n",
 		    SAS_ADDR(dev->sas_addr), phy_id);
@@ -1915,7 +1915,7 @@ static int sas_rediscover(struct domain_device *dev, const int phy_id)
 			    SAS_ADDR(changed_phy->attached_sas_addr)) {
 				SAS_DPRINTK("phy%d part of wide port with "
 					    "phy%d\n", phy_id, i);
-				last = FALSE;
+				last = false;
 				break;
 			}
 		}
@@ -1948,7 +1948,7 @@ int sas_ex_revalidate_domain(struct domain_device *port_dev)
 
 		do {
 			phy_id = -1;
-			res = sas_find_bcast_phy(dev, &phy_id, i, TRUE);
+			res = sas_find_bcast_phy(dev, &phy_id, i, true);
 			if (phy_id == -1)
 				break;
 			res = sas_rediscover(dev, phy_id);
