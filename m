Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAEBC3A5A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:14:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B3E32074F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 19:14:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FLdm4rq8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgDTTOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 15:14:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29146 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726234AbgDTTOu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 15:14:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587410089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Wo3K2g1EGY49vzgXNrPKj+5JeYyYSOBuG//unFhQsE=;
        b=FLdm4rq8aaNmbLErchYHb14HGm5yGu3b/lwTn9U+tFOnTRH+vMwAqAUv5Pnr09Oh95E2a/
        tfY05M/k9It+eWl+/YNmG3DGge9o/mD76QNv2l2HuwscHnqgPqGRBC5MT7j0ukthdj+bc6
        brnIDqMlg7KOqzi9ps5aMB/JrFDfldo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-HdMXHMHJP36xB6TVifuT5A-1; Mon, 20 Apr 2020 15:14:46 -0400
X-MC-Unique: HdMXHMHJP36xB6TVifuT5A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F4D61853887;
        Mon, 20 Apr 2020 19:14:45 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-118-198.rdu2.redhat.com [10.10.118.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D6C2A18BF;
        Mon, 20 Apr 2020 19:14:30 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     jsmart2021@gmail.com, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [RFC PATCH 01/12] target: check enforce_pr_isids during registration
Date:   Mon, 20 Apr 2020 14:14:15 -0500
Message-Id: <20200420191426.17055-2-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
References: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the check for enforce_pr_isids to the registration code where we
can fail at the time an initiator tries to register a path without an
isid. In its current place in __core_scsi3_locate_pr_reg, it is too
late because it can be registered and be reported in PR in commands and
it is stuck in this state because we cannot unregister it.

I am sending this bug fix patch with the RFC ones, because the bug
intersects with patch 5 "target: drop sess_get_initiator_sid from PR code=
".
I will break this out and send as a proper bug fix later.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_pr.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
index 5e93169..cd2d32f 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1176,15 +1176,6 @@ static struct t10_pr_registration *__core_scsi3_lo=
cate_pr_reg(
 		 * ISID, then we have found a match.
 		 */
 		if (!pr_reg->isid_present_at_reg) {
-			/*
-			 * Determine if this SCSI device server requires that
-			 * SCSI Intiatior TransportID w/ ISIDs is enforced
-			 * for fabric modules (iSCSI) requiring them.
-			 */
-			if (tpg->se_tpg_tfo->sess_get_initiator_sid !=3D NULL) {
-				if (dev->dev_attrib.enforce_pr_isids)
-					continue;
-			}
 			atomic_inc_mb(&pr_reg->pr_res_holders);
 			spin_unlock(&pr_tmpl->registration_lock);
 			return pr_reg;
@@ -1591,10 +1582,25 @@ static void core_scsi3_lunacl_undepend_item(struc=
t se_dev_entry *se_deve)
 				continue;
 			dest_rtpi =3D tmp_lun->lun_rtpi;
=20
+			iport_ptr =3D NULL;
 			i_str =3D target_parse_pr_out_transport_id(tmp_tpg,
 					ptr, &tid_len, &iport_ptr);
 			if (!i_str)
 				continue;
+			/*
+			 * Determine if this SCSI device server requires that
+			 * SCSI Intiatior TransportID w/ ISIDs is enforced
+			 * for fabric modules (iSCSI) requiring them.
+			 */
+			if (tpg->se_tpg_tfo->sess_get_initiator_sid &&
+                            dev->dev_attrib.enforce_pr_isids &&
+			    !iport_ptr) {
+				pr_warn("SPC-PR: enforce_pr_isids is set but a isid has not been sen=
t in the SPEC_I_PT data for %s.",
+					i_str);
+				ret =3D TCM_INVALID_PARAMETER_LIST;
+				spin_unlock(&dev->se_port_lock);
+				goto out_unmap;
+			}
=20
 			atomic_inc_mb(&tmp_tpg->tpg_pr_ref_count);
 			spin_unlock(&dev->se_port_lock);
--=20
1.8.3.1

