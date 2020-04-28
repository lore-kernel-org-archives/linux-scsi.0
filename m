Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CD1C8300A
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C81B220730
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:11:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KqHtrFk3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgD1GL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 02:11:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41616 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726357AbgD1GLX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 02:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588054281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rvL4TBUT8IqneXOcycrthcEmyku94zfv6Jd8TdQNkuo=;
        b=KqHtrFk3Ne5MKvqcsd5KVTtTp325HjaBpSK2h3T+5UdUPpg9ATJjxIJK6OugBfV9pboSHq
        gOz0gx3PaM9bYkm7H+ggiHQEsyZj0RHbnVxIL1MXhZqQ4rH/PpIgYS6Shlm6v2Y2JReiOz
        fw9a7+4aRMCKCqj2Ag54CNObmI+Hy1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-GhNGbo7XOF6WXmuxThoWTQ-1; Tue, 28 Apr 2020 02:11:15 -0400
X-MC-Unique: GhNGbo7XOF6WXmuxThoWTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83E9DA0BF2;
        Tue, 28 Apr 2020 06:11:14 +0000 (UTC)
Received: from rh2.redhat.com (ovpn-116-120.rdu2.redhat.com [10.10.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 832131001281;
        Tue, 28 Apr 2020 06:11:13 +0000 (UTC)
From:   Mike Christie <mchristi@redhat.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>
Subject: [PATCH 01/11] target: check enforce_pr_isids during registration
Date:   Tue, 28 Apr 2020 01:10:59 -0500
Message-Id: <20200428061109.3042-2-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-1-mchristi@redhat.com>
References: <20200428061109.3042-1-mchristi@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Note.
I am including in this patchset, because the 5th patch is built on top.

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

