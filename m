Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEB5C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 17:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F28E2073D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 17:04:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="MmLdcfeX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfLJREo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 12:04:44 -0500
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:39689 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfLJREo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 12:04:44 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2019 12:04:43 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1575997484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=PX5tKIG5LXYHZbMQPwsn5YEgEtw9pEZTLwOmysNDEoE=;
  b=MmLdcfeXqEq2zeQKcNcn1W1jVFZuSJ6Bc7HYNGeDOavMJi8Zug4Fv8YX
   gLj8/XW6+uHhbJe3HiXuZUgv6a0TLBNqG/7jUwrPxW85VJuwDNi9W8FEd
   QlgjtVMWoNqAal/VDIQ3NpsWx6rlQj2qgjfYciQbE86itA/62HA8h/ZXH
   8=;
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
IronPort-SDR: dEN1p4rXAEv/2vdzGaoR1Ds7OiI8GGfP97MHIwg+llWhb2GSsXhO3eDwRcld91X1oihBQxEAPm
 Yg2TfF/u/Jh3oQpawQ5WGBSL7kJeiFDH5/IVRYHeIq+q5iLmqd2LEHXNQm3QIHXXXOae90OQMO
 M/8mN/D89WICfoyU531aS0Y2EU1vJ8uDUwlnQ3LWEFrkIRyDSo5hx7VDk5bkwUdLWDhvg2Bhd5
 d7QR8DGu2PpBlRkXQ4HMTwRlTllxhiAW89usC7xvJoUKJYCkZznPRPF63HYMJl/z5K1Y2wpxc8
 wes=
X-SBRS: 2.7
X-MesageID: 9479233
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.69,300,1571716800"; 
   d="scan'208";a="9479233"
From:   Igor Druzhinin <igor.druzhinin@citrix.com>
To:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        "Igor Druzhinin" <igor.druzhinin@citrix.com>
Subject: [PATCH 1/2] scsi: libfc: free response frame from GPN_ID
Date:   Tue, 10 Dec 2019 16:57:29 +0000
Message-ID: <1575997050-12959-2-git-send-email-igor.druzhinin@citrix.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575997050-12959-1-git-send-email-igor.druzhinin@citrix.com>
References: <1575997050-12959-1-git-send-email-igor.druzhinin@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

fc_disc_gpn_id_resp() should be the last function using it so free it
here to avoid memory leak.

Signed-off-by: Igor Druzhinin <igor.druzhinin@citrix.com>
---
 drivers/scsi/libfc/fc_disc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 9c5f7c9..2b865c6 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -628,6 +628,8 @@ static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	}
 out:
 	kref_put(&rdata->kref, fc_rport_destroy);
+	if (!IS_ERR(fp))
+		fc_frame_free(fp);
 }
 
 /**
-- 
2.7.4

