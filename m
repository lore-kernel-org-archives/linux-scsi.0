Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4FCC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 10:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiBXKMI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 05:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbiBXKMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 05:12:06 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5DD193DE
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645697496; x=1677233496;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=S4zEpoMx77CN+B2oXbx0vq9Ww9LaJo0Ni4rWb11orHw=;
  b=C97suqyQmCWAx7MiTlor1ZO69xlmIlU7wxYGD+y76/xcYfFM8QWpnzZf
   1hISizY1rNCLxeLDsxgpmLLwLQWR+v49RQszNBZzUXb5XyFCgMQwstX+z
   bhvCmvM2dM4ZRaGJduIqrXeDXubpo4xlNFRLGovDEjTfVfjy894BsGx5X
   hxDBL6b4PcnSQOEjr2MDCxG5N/rPTGXHG3yhbij19ioCbhCGelCWMxwdz
   3s0rS2whrqU+ZUSw0CKPGhl5Aj+2l/G8lcgiuvoWXoORjtLszLp3fI3Gq
   cso0ezN+CEaIsUQV6dkroBiqHlFt+4bv3Owbh1f3iSGg7nVst7npxgMVN
   w==;
X-IronPort-AV: E=Sophos;i="5.88,393,1635177600"; 
   d="scan'208";a="297965112"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2022 18:11:35 +0800
IronPort-SDR: X1a5OKG4LbTSd1gK5RfNm2GpXHC5zgTMiK1bbWeqMkpIcomAUBxNYJ8pFpKt25XYbB7Aj2x5Pa
 t1q7Z4Kf7CHXzXXd7aO3YTA+eHfjMmqLXj0spDAZE/nbAxhRRp47zA9TqfN+kn2yhEkZznk/v8
 CjIQqIs93gJMHj99wBR2qh6TVfWQSHkIdN5nvi3zTvPQXpy5TodXgnq6aKJn0Z5+Qxxrxw05Kv
 TS4ATcbheEb60Teqj28IONe321cEkqpsMvxAhVbsmPc+PSJ+ViYT8mYinFf6zPd1g2YpoEnB90
 fXBa86Nv0Xi1TkZpdC1nq7so
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 01:43:06 -0800
IronPort-SDR: qFHVTfG46k9qbR9qGMc7q/MHqkwpR//odlx/rDl+D5qefnD8q1wZlEymrboOT/3Rd2KKBTqrKM
 sw9NIKCAP9FpDtEAnilir37TGOmUcdZgogLVmhAKTDGJfLXxGE/JQsXzu1HkKRUlWn86ghBnss
 Qf03sbdlRtaUnf6CWZvxBniJWtOmj/E6/6wSA1ZJ+p0Inz+63xWOG7M3TbWN/GfFCFHjl5yOm7
 INmu7uAuvAaclQpdG7CFegwBz9SrwsGqTLi2/4oEvVfB+Kzyor0UgIR1PwDfYtVGdWowPCSsS3
 32g=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 02:11:35 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K47wl3skKz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 02:11:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645697495; x=1648289496; bh=S4zEpoMx77CN+B2oXb
        x0vq9Ww9LaJo0Ni4rWb11orHw=; b=SjDrj/4+adhqk/ly002+uElAeEETjsmD4W
        ByrJ9vOh5eqmv2LTa+Tdi6/hn1vNXFKZ9zeKLwEtgO7zJDiPTrE8FvMv7eRUPPdA
        6SA48dtI7a9wvkkgkHs1b6C1KA5pYRCYMd1UqQ5X3dARbuBjm7/0KbHwrKu9j+Ri
        2dnd4cOqJo2fuMBdN96i/8KRifVwT105UCfXgu+upBN4sY63HgbwcgkWJ+Cd4Vv1
        7h/7MvbVH7Ibt8PzJnXmgW7fIYjtDrxdHOVL1ncwWOv3A6lbuPcl+36wFQa5htb4
        rHYYbqEfFRVDnwrSurwBJ7b6H3Fpim2cufdrCLEXgLu7u8yKEqIg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KcUTO3r6coOW for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 02:11:35 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K47wk0BWqz1Rwrw;
        Thu, 24 Feb 2022 02:11:33 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 1/5] scsi: mpt3sas: fix Mpi2SCSITaskManagementRequest_t TaskMID handling
Date:   Thu, 24 Feb 2022 19:11:25 +0900
Message-Id: <20220224101129.371905-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
References: <20220224101129.371905-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The TaskMID field of sturtc Mpi2SCSITaskManagementRequest_t seems to be
a 16-bits little endian value but is not declared as such, causing
sparse to generate warnings. Change this field declaration to __le16 and
fix a test in _ctl_set_task_mid() to avoid sparse warnings.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpi/mpi2_init.h | 2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_init.h b/drivers/scsi/mpt3sas/=
mpi/mpi2_init.h
index 8f1b903fe0a9..80bcf7d83184 100644
--- a/drivers/scsi/mpt3sas/mpi/mpi2_init.h
+++ b/drivers/scsi/mpt3sas/mpi/mpi2_init.h
@@ -428,7 +428,7 @@ typedef struct _MPI2_SCSI_TASK_MANAGE_REQUEST {
 	U16 Reserved3;		/*0x0A */
 	U8 LUN[8];		/*0x0C */
 	U32 Reserved4[7];	/*0x14 */
-	U16 TaskMID;		/*0x30 */
+	__le16 TaskMID;		/*0x30 */
 	U16 Reserved5;		/*0x32 */
 } MPI2_SCSI_TASK_MANAGE_REQUEST,
 	*PTR_MPI2_SCSI_TASK_MANAGE_REQUEST,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
index d92ca140d298..eac253fce2da 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -618,7 +618,8 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct=
 mpt3_ioctl_command *karg,
 		 * first outstanding smid will be picked up.  Otherwise,
 		 * targeted smid will be the one.
 		 */
-		if (!tm_request->TaskMID || tm_request->TaskMID =3D=3D st->smid) {
+		if (!tm_request->TaskMID ||
+		    tm_request->TaskMID =3D=3D cpu_to_le16(st->smid)) {
 			tm_request->TaskMID =3D cpu_to_le16(st->smid);
 			found =3D 1;
 		}
--=20
2.35.1

