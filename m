Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17EAC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 17:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88C6F20828
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 17:04:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="LpECj5s0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfLJREp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 12:04:45 -0500
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:39689 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbfLJREp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 12:04:45 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2019 12:04:43 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1575997484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=LmLcwm7ETBP99P7FEc+YIc1hsYwuyPtB6gvyIrxiSLc=;
  b=LpECj5s0QAYKGP/jzogs02EIo3M0fH7PNroqEuc+UCjHtB/jbmDMMfqg
   ya6XbARHZcSevtYhxXWZu99WrVwcbVxM4pPWkdxCFflzrOCaZQXsE3mxI
   923pV31mFHtRZW8kt9DXyWE11qEXl0moxwcpxDnK0dtS6C4c9ACkRZJVd
   w=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=igor.druzhinin@citrix.com; spf=Pass smtp.mailfrom=igor.druzhinin@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa2.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  igor.druzhinin@citrix.com) identity=pra;
  client-ip=162.221.158.21; receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="igor.druzhinin@citrix.com";
  x-sender="igor.druzhinin@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa2.hc3370-68.iphmx.com: domain of
  igor.druzhinin@citrix.com designates 162.221.158.21 as
  permitted sender) identity=mailfrom;
  client-ip=162.221.158.21; receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="igor.druzhinin@citrix.com";
  x-sender="igor.druzhinin@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83
  ip4:168.245.78.127 ~all"
Received-SPF: None (esa2.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="igor.druzhinin@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: ZuoikandVuC0rBPfb3zNS375Kcj9GDcFEeiQFxx5UQc5+J0/obTYt2MgjF7gEDlbI3T3wjD0lR
 AJaiVjUkFEOJu5TMMrLkDBHckXgVClu/V5Fr8aI34YCih3IT1BZs6ytA92D2bJwuLOZTVSJwyI
 loi4Accyn7VV45hgHe94j7SgTsK91DNdzuwNWZ4mqBloq5uj5Z/QBpuFxr/tJGxccNK+fSluIs
 b7QaTDxsv8acjnEY7OMRafK7Yyic4Rz3q5ogelaewrUEOERHIbx/zok9p9XlnhcQJewAPy7dLf
 ffg=
X-SBRS: 2.7
X-MesageID: 9479234
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.69,300,1571716800"; 
   d="scan'208";a="9479234"
From:   Igor Druzhinin <igor.druzhinin@citrix.com>
To:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        "Igor Druzhinin" <igor.druzhinin@citrix.com>
Subject: [PATCH 2/2] scsi: libfc: drop extra rport reference in fc_rport_create()
Date:   Tue, 10 Dec 2019 16:57:30 +0000
Message-ID: <1575997050-12959-3-git-send-email-igor.druzhinin@citrix.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575997050-12959-1-git-send-email-igor.druzhinin@citrix.com>
References: <1575997050-12959-1-git-send-email-igor.druzhinin@citrix.com>
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

