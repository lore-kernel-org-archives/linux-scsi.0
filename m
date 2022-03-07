Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3FDC4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 23:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344008AbiCGXuJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344068AbiCGXuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 18:50:02 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BB422522
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646696942; x=1678232942;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=zdVLbzhYla2YZaTACujeWEbgVYGpiiXXLA0O0Pmn0YY=;
  b=dpdpvpzqYqqpFZvBp3Co6Mk+jycw6btaphDcsf0B7xGM8XX/Tj2eb3TI
   7OHX967p66fQ2+gpkrvxzaqvJhAu5xj0esfISJK2QTqGp5p5Vq2JzXr5X
   yNDpgF4kiFHm3xhmj/F0ySbvXr/cRA3r8/XOWSF688WDqCUCye5QW7Z1A
   6HXYenXVbc4l8JBH9KFY7prvHfDTSyoX3lYEA/WP1tGTe80kJjro1LSq5
   Tj9CGKt+M7eF1cbpAMs5Ulp6tPWzw9hUKwpVqA3m2JOWIhM4pBx4CSZJp
   7NIO87mjBlyYzy4r1CyyoAApSBfxXG8f5FS+pJCibHt+gDenOxfZaZyBq
   w==;
X-IronPort-AV: E=Sophos;i="5.90,163,1643644800"; 
   d="scan'208";a="195659150"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2022 07:49:00 +0800
IronPort-SDR: sdUHPychTizfxD3jeRQxPrg1dJz3QyX9q1+U1BjrRQTbNjgEpWNyuPQxunv5O9axBq+S8akPLY
 QmGFD6BSfNw14PPS9bCIqQg0I5U2qjf4c8nc1YF5e8+Q0AUW4uSAG3n64P/gU0EXWObiAVWJRT
 iSGEyUtpViJ2zD+8FCDlB9NKt/M3sftyVrrv0PWE2RRoune4C6B4PtFrbBqWsnuD/sLP2ogybB
 6BHQP4YYMIj6cxgfvWrMYMPIJWLMcHmIRVXfR8BvuCM3mhnOgpt5bLrrWL0ybnrCSIxO5N/sce
 5tQg1Oz6ZacV39edIY/+ayeN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:21:17 -0800
IronPort-SDR: p6k42R+p6joipXLupwB+aifq8VO8rSIXw9ju9HVGZsZFtxMMDt15dY482l+xrBYt2rCP84tp+U
 ohIlsUfxNKS4KYjVwwbiZqHTBKzFkQfRl4aLrN7QU2/58fh3y4HZq3cxPp7g0/calzQw8rQA/J
 6npUtfyLzvpcGJmxFXPQBjiNt287wlxG9idAK1RK9PJi2YHUmV8Chil7oax1X8Q1AYW9ufsSXZ
 Om8Ey7K5rUPKkemiU9YBFzYBFMfFLWIu1GDDT7wd4JRlImccsA1ag5NF1heiVTB0OK4X+ELoIH
 Hyk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:49:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KCFXq4tWDz1SVnx
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 15:48:59 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1646696939; x=1649288940; bh=zdVLbzhYla2YZaTACu
        jeWEbgVYGpiiXXLA0O0Pmn0YY=; b=ay1rr9m9QskWAWNDTbOb8jxgjLd8CJNufU
        yRZGo/NqLq+2whiPbfvwIEvjgqyuXhRhS3rwndK3qlWHSal9IKXFLi3DRzWGdmWT
        uzSmsRtYtyt3PgNf7+WcO700CWmyn1+dEU752nuXZLIndknTqgjRAh4LyHyU3u4f
        fCkaiITOgbx+uywpRyO7LKRL7lAqHufiWHKEsCYi/WPk+5sinAz4wvjbDAD2iNLo
        YrvDNboM9huCRFhrNbeN0ywYTA4HMjr7EzXMjbo1our6qu/Q3nG78QgZfgUDnAQO
        hSFHVyJVxvIHKLfbUR43mmB8eBjnsp0grE1xdbV1u1KEunzsssLw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bQTOcm5WTAQ9 for <linux-scsi@vger.kernel.org>;
        Mon,  7 Mar 2022 15:48:59 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KCFXp25SXz1Rwrw;
        Mon,  7 Mar 2022 15:48:58 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 1/5] scsi: mpt3sas: fix _ctl_set_task_mid() TaskMID check
Date:   Tue,  8 Mar 2022 08:48:50 +0900
Message-Id: <20220307234854.148145-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The TaskMID field of struct Mpi2SCSITaskManagementRequest_t is a 16-bits
little endian value. Fix the search loop in _ctl_set_task_mid() to add
a cpu_to_le16() conversion before checking the value of TaskMID to avoid
sparse warnings. While at it, simplify the search loop code to remove an
unnecessarily complicated if condition.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
index d92ca140d298..84c87c2c3e7e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -578,7 +578,7 @@ static int
 _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command=
 *karg,
 	Mpi2SCSITaskManagementRequest_t *tm_request)
 {
-	u8 found =3D 0;
+	bool found =3D false;
 	u16 smid;
 	u16 handle;
 	struct scsi_cmnd *scmd;
@@ -600,6 +600,7 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct=
 mpt3_ioctl_command *karg,
 	handle =3D le16_to_cpu(tm_request->DevHandle);
 	for (smid =3D ioc->scsiio_depth; smid && !found; smid--) {
 		struct scsiio_tracker *st;
+		__le16 task_mid;
=20
 		scmd =3D mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
@@ -618,10 +619,10 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, stru=
ct mpt3_ioctl_command *karg,
 		 * first outstanding smid will be picked up.  Otherwise,
 		 * targeted smid will be the one.
 		 */
-		if (!tm_request->TaskMID || tm_request->TaskMID =3D=3D st->smid) {
-			tm_request->TaskMID =3D cpu_to_le16(st->smid);
-			found =3D 1;
-		}
+		task_mid =3D cpu_to_le16(st->smid);
+		if (!tm_request->TaskMID)
+			tm_request->TaskMID =3D task_mid;
+		found =3D tm_request->TaskMID =3D=3D task_mid;
 	}
=20
 	if (!found) {
--=20
2.35.1

