Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7AAC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 02:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236692AbiFICZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 22:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiFICZD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 22:25:03 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1701F132748
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 19:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654741502; x=1686277502;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=B6RxOZNJHpIgyDZa6jg9+HlCsfHX6UqUtcLq+JIMyT0=;
  b=eipuxLi/kK5pCqHjqK2we6cCnOrNSQBcLAGaarjB+hbAcz+nBpK5czJ+
   Yn+Xqlln/wHJvmrerRRgAMv51ygNz1Yp/z7NUKfEEbx16j79ylgmnIvZk
   7BfxZYWdaEQBrbSoobIQHU68vlBHcmfpgul/kZBsROGWLMWMupB49fU6H
   fiW/P35/gMYwdVl2Vl6/Jxe8FXaApOqwAb9DXtw5rg9OSmfns2eIIKxUD
   dVUMLTBIPbd2Kl8uv4L73mEB5qYlA4PUv87Wze7A32/C2l8A+AWlQwiRz
   /ZSHig0SOZ4zXszAhZoZ0w3xhKukNRQepm8ynnNZCOC/3h+eKvQObP/yb
   g==;
X-IronPort-AV: E=Sophos;i="5.91,287,1647273600"; 
   d="scan'208";a="314703266"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2022 10:25:00 +0800
IronPort-SDR: 5Q4Aiy6kaqr/uJ87BBW8T0Breh6qKxJn4+DKyJ9glySX9NGDbBAwC+8i2KHrwNg1mbaw5t7woM
 NLBjv18BKJCof1Kcx++msaKgAsIQbohoGe0AWczUYJqqG12tZD3db+lHUuX5GPH+cmXZc49yWY
 /ptONrUGpCoX47eO73uxYOHvX0BIoIt6tjxNn2R6WX/QRPKX85Ekzj5fj24paWRP98hCAf9P7j
 3FrSMGoVDcctz++6clWBjr3fprRGZ3NnmuFRIJAMtTtC2uvhIQIYu1SAHbFlU+iYx7VZWoxdhs
 433rcebnwg1K4QZWzfd+9rGu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jun 2022 18:43:48 -0700
IronPort-SDR: Jyz48sjwwZp7asMfi2oUUc9JtSI4na3eo1Twj/+OO/J6Qata2G5pPDzc7kcdkIrZo3k1nXH6wA
 tQXEoEtbMrfATLBYeA1rLkJlf78FcVG/NxygKTCVp1qSoJP8IcGUVT0bRt8+jk9x91offWgVky
 GdIIonGiFcPmzI3VPCL9IalhLiY3T0OldK3ngigjZa7XJutMl2xCXqrBw7B6O2RqLX6HtnfYXV
 eQ6vxfNV73u20SCNXUq0UhGYYklN5Wbz9zYRvrZzGfLA9MDn3CbBlec5i40wtATC7ZXaUElwXg
 +T4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jun 2022 19:25:00 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LJSbw1CBCz1Rwrw
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 19:25:00 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :mime-version:references:in-reply-to:x-mailer:message-id:date
        :subject:to:from; s=dkim; t=1654741499; x=1657333500; bh=B6RxOZN
        JHpIgyDZa6jg9+HlCsfHX6UqUtcLq+JIMyT0=; b=JkEOeytooNO/ieMlQOxW0Ab
        BOg15X3Sz0kLPW68ZZJPMuPUCvoQWZsziRdbRIAplhYt+0gFTzSEg2VrHxJzLUHO
        kJUrGl3NgDIZQLrBRRKcvlfiWzRI9IzKCDCAHBkRgKPKPb7+SvVfOV3PKCQm32sN
        2ozTRq+EqdhI9WzeTOX8Q40/KXY5AGZGLS4IswwfT5YOHEE2aS9l8fgbTKT3nOcO
        KeXfQAFNj2w7ka2rG6gs4gnr9et80xbGXfiN5etFPIYJViG1VlGeQLVaOtyPViK/
        dOv5L75eM/lj/4ewy0va+s9sB8pUOh5whaxjlTFerF8gbC33MQMhhZuXxR9+kCA=
        =
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UM0ezZJW7Yzb for <linux-scsi@vger.kernel.org>;
        Wed,  8 Jun 2022 19:24:59 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LJSbv0Tvcz1Rvlx;
        Wed,  8 Jun 2022 19:24:58 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 1/3] scsi: libsas: introduce struct smp_disc_resp
Date:   Thu,  9 Jun 2022 11:24:54 +0900
Message-Id: <20220609022456.409087-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
References: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When compiling with gcc 12, several warnings are thrown by gcc when
compiling drivers/scsi/libsas/sas_expander.c, e.g.:

In function =E2=80=98sas_get_phy_change_count=E2=80=99,
    inlined from =E2=80=98sas_find_bcast_phy.constprop=E2=80=99 at
drivers/scsi/libsas/sas_expander.c:1737:9:
drivers/scsi/libsas/sas_expander.c:1697:39: warning: array subscript
=E2=80=98struct smp_resp[0]=E2=80=99 is partly outside array bounds of =E2=
=80=98unsigned
char[56]=E2=80=99 [-Warray-bounds]
 1697 |                 *pcc =3D disc_resp->disc.change_count;
      |                        ~~~~~~~~~~~~~~~^~~~~~~~~~~~~

This is due to the use of the struct smp_resp to aggregate all possible
response types using a union but allocating a response buffer with a
size exactly equal to the size of the response type needed. This leads
to access to fields of struct smp_resp from an allocated memory area
that is smaller than the size of struct smp_resp.

Fix this by defining struct smp_disc_resp for sas discovery operations.
Since this structure and the generic struct smp_resp are identical for
the little endian and big endian archs, move the definition of these
structures at the end of include/scsi/sas.h to avoid repeating their
definition.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/libsas/sas_expander.c | 32 +++++++++++++-----------------
 include/scsi/sas.h                 | 28 +++++++++++---------------
 2 files changed, 26 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
index 260e735d06fa..fb998a8a7d3b 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -175,13 +175,13 @@ static enum sas_device_type to_dev_type(struct disc=
over_resp *dr)
 		return dr->attached_dev_type;
 }
=20
-static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *=
rsp)
+static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
+			   struct smp_disc_resp *disc_resp)
 {
 	enum sas_device_type dev_type;
 	enum sas_linkrate linkrate;
 	u8 sas_addr[SAS_ADDR_SIZE];
-	struct smp_resp *resp =3D rsp;
-	struct discover_resp *dr =3D &resp->disc;
+	struct discover_resp *dr =3D &disc_resp->disc;
 	struct sas_ha_struct *ha =3D dev->port->ha;
 	struct expander_device *ex =3D &dev->ex_dev;
 	struct ex_phy *phy =3D &ex->ex_phy[phy_id];
@@ -198,7 +198,7 @@ static void sas_set_ex_phy(struct domain_device *dev,=
 int phy_id, void *rsp)
 		BUG_ON(!phy->phy);
 	}
=20
-	switch (resp->result) {
+	switch (disc_resp->result) {
 	case SMP_RESP_PHY_VACANT:
 		phy->phy_state =3D PHY_VACANT;
 		break;
@@ -347,12 +347,13 @@ struct domain_device *sas_ex_to_ata(struct domain_d=
evice *ex_dev, int phy_id)
 }
=20
 #define DISCOVER_REQ_SIZE  16
-#define DISCOVER_RESP_SIZE 56
+#define DISCOVER_RESP_SIZE sizeof(struct smp_disc_resp)
=20
 static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 *dis=
c_req,
-				      u8 *disc_resp, int single)
+				      struct smp_disc_resp *disc_resp,
+				      int single)
 {
-	struct discover_resp *dr;
+	struct discover_resp *dr =3D &disc_resp->disc;
 	int res;
=20
 	disc_req[9] =3D single;
@@ -361,7 +362,6 @@ static int sas_ex_phy_discover_helper(struct domain_d=
evice *dev, u8 *disc_req,
 			       disc_resp, DISCOVER_RESP_SIZE);
 	if (res)
 		return res;
-	dr =3D &((struct smp_resp *)disc_resp)->disc;
 	if (memcmp(dev->sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE) =3D=3D =
0) {
 		pr_notice("Found loopback topology, just ignore it!\n");
 		return 0;
@@ -375,7 +375,7 @@ int sas_ex_phy_discover(struct domain_device *dev, in=
t single)
 	struct expander_device *ex =3D &dev->ex_dev;
 	int  res =3D 0;
 	u8   *disc_req;
-	u8   *disc_resp;
+	struct smp_disc_resp *disc_resp;
=20
 	disc_req =3D alloc_smp_req(DISCOVER_REQ_SIZE);
 	if (!disc_req)
@@ -1657,7 +1657,7 @@ int sas_discover_root_expander(struct domain_device=
 *dev)
 /* ---------- Domain revalidation ---------- */
=20
 static int sas_get_phy_discover(struct domain_device *dev,
-				int phy_id, struct smp_resp *disc_resp)
+				int phy_id, struct smp_disc_resp *disc_resp)
 {
 	int res;
 	u8 *disc_req;
@@ -1673,10 +1673,8 @@ static int sas_get_phy_discover(struct domain_devi=
ce *dev,
 			       disc_resp, DISCOVER_RESP_SIZE);
 	if (res)
 		goto out;
-	else if (disc_resp->result !=3D SMP_RESP_FUNC_ACC) {
+	if (disc_resp->result !=3D SMP_RESP_FUNC_ACC)
 		res =3D disc_resp->result;
-		goto out;
-	}
 out:
 	kfree(disc_req);
 	return res;
@@ -1686,7 +1684,7 @@ static int sas_get_phy_change_count(struct domain_d=
evice *dev,
 				    int phy_id, int *pcc)
 {
 	int res;
-	struct smp_resp *disc_resp;
+	struct smp_disc_resp *disc_resp;
=20
 	disc_resp =3D alloc_smp_resp(DISCOVER_RESP_SIZE);
 	if (!disc_resp)
@@ -1704,19 +1702,17 @@ static int sas_get_phy_attached_dev(struct domain=
_device *dev, int phy_id,
 				    u8 *sas_addr, enum sas_device_type *type)
 {
 	int res;
-	struct smp_resp *disc_resp;
-	struct discover_resp *dr;
+	struct smp_disc_resp *disc_resp;
=20
 	disc_resp =3D alloc_smp_resp(DISCOVER_RESP_SIZE);
 	if (!disc_resp)
 		return -ENOMEM;
-	dr =3D &disc_resp->disc;
=20
 	res =3D sas_get_phy_discover(dev, phy_id, disc_resp);
 	if (res =3D=3D 0) {
 		memcpy(sas_addr, disc_resp->disc.attached_sas_addr,
 		       SAS_ADDR_SIZE);
-		*type =3D to_dev_type(dr);
+		*type =3D to_dev_type(&disc_resp->disc);
 		if (*type =3D=3D 0)
 			memset(sas_addr, 0, SAS_ADDR_SIZE);
 	}
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index acfc69fd72d0..b3ee9bd63277 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -471,18 +471,6 @@ struct report_phy_sata_resp {
 	__be32 crc;
 } __attribute__ ((packed));
=20
-struct smp_resp {
-	u8    frame_type;
-	u8    function;
-	u8    result;
-	u8    reserved;
-	union {
-		struct report_general_resp  rg;
-		struct discover_resp        disc;
-		struct report_phy_sata_resp rps;
-	};
-} __attribute__ ((packed));
-
 #elif defined(__BIG_ENDIAN_BITFIELD)
 struct sas_identify_frame {
 	/* Byte 0 */
@@ -704,6 +692,18 @@ struct report_phy_sata_resp {
 	__be32 crc;
 } __attribute__ ((packed));
=20
+#else
+#error "Bitfield order not defined!"
+#endif
+
+struct smp_disc_resp {
+	u8    frame_type;
+	u8    function;
+	u8    result;
+	u8    reserved;
+	struct discover_resp disc;
+} __attribute__ ((packed));
+
 struct smp_resp {
 	u8    frame_type;
 	u8    function;
@@ -716,8 +716,4 @@ struct smp_resp {
 	};
 } __attribute__ ((packed));
=20
-#else
-#error "Bitfield order not defined!"
-#endif
-
 #endif /* _SAS_H_ */
--=20
2.36.1

