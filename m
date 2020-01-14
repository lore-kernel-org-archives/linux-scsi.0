Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E145FC33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 14:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B47B32072B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 14:50:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="LI9+Mkkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgANOub (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 09:50:31 -0500
Received: from esa6.hc3370-68.iphmx.com ([216.71.155.175]:51458 "EHLO
        esa6.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbgANOua (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 09:50:30 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jan 2020 09:50:30 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1579013430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=LmLcwm7ETBP99P7FEc+YIc1hsYwuyPtB6gvyIrxiSLc=;
  b=LI9+MkkflKGXk67N5BMaTrRoql2yA/7fhNxnRATaU4fGVmNEMKoywpQI
   7fIsgK8xi5dW6DT21zBtr9XgKoaSBFCWmhgCNHzlUdPckbKrM6AqwYd/J
   cKcPY1uRrDKt3mMHfmHYLZppYM7msJ4/u8J0RjCqn1nHEnQrFNearaRXs
   c=;
Authentication-Results: esa6.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=igor.druzhinin@citrix.com; spf=Pass smtp.mailfrom=igor.druzhinin@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa6.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  igor.druzhinin@citrix.com) identity=pra;
  client-ip=162.221.158.21; receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="igor.druzhinin@citrix.com";
  x-sender="igor.druzhinin@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa6.hc3370-68.iphmx.com: domain of
  igor.druzhinin@citrix.com designates 162.221.158.21 as
  permitted sender) identity=mailfrom;
  client-ip=162.221.158.21; receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="igor.druzhinin@citrix.com";
  x-sender="igor.druzhinin@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa6.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa6.hc3370-68.iphmx.com;
  envelope-from="igor.druzhinin@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: QuCOSjVj2SpJELBpaAxW3hiC/ycnXsWdWQPRo+lPtUKiHp3f9mNJoQ/vyizR7bumcB2UKxalrz
 WpBHkIfywCWTPDRNaSyBDE4pauf/sqZ+Ms8YrKvA8rl39vRO4xgUeswyxzVAJwa6gqEmNcxzwL
 1a4PY37RLBRZg6qkD19c8VhGl1dBoZMeZ6B1sAblxO3r2zitM2sCO5RauA2zs287NR6pjftpGI
 QkCVs68qqaZ0CxHiDirAHyHlgfIjXRajvKsdZsfF/pISHS+NRpdQhDGUCqesyAZlRgyjfzuIIH
 pSA=
X-SBRS: 2.7
X-MesageID: 11321047
X-Ironport-Server: esa6.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.69,433,1571716800"; 
   d="scan'208";a="11321047"
From:   Igor Druzhinin <igor.druzhinin@citrix.com>
To:     <fcoe-devel@open-fcoe.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hare@suse.de>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        Igor Druzhinin <igor.druzhinin@citrix.com>
Subject: [PATCH RESEND 2/2] scsi: libfc: drop extra rport reference in fc_rport_create()
Date:   Tue, 14 Jan 2020 14:43:20 +0000
Message-ID: <1579013000-14570-3-git-send-email-igor.druzhinin@citrix.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579013000-14570-1-git-send-email-igor.druzhinin@citrix.com>
References: <1579013000-14570-1-git-send-email-igor.druzhinin@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The callers of this function seem to assume the reference is not taken
in case rport already exists. This results in one extra reference taken
on each rport re-discovery that will eventually get to inability to
free rport structure on port removal.

Signed-off-by: Igor Druzhinin <igor.druzhinin@citrix.com>
---
 drivers/scsi/libfc/fc_rport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index da6e97d..a43f9dd 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -133,8 +133,10 @@ struct fc_rport_priv *fc_rport_create(struct fc_lport *lport, u32 port_id)
 	lockdep_assert_held(&lport->disc.disc_mutex);
 
 	rdata = fc_rport_lookup(lport, port_id);
-	if (rdata)
+	if (rdata) {
+		kref_put(&rdata->kref, fc_rport_destroy);
 		return rdata;
+	}
 
 	if (lport->rport_priv_size > 0)
 		rport_priv_size = lport->rport_priv_size;
-- 
2.7.4

