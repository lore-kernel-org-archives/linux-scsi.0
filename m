Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF0D5C00454
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 17:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3A5E2073D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 17:04:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="dJ6qC0dz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfLJREs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 12:04:48 -0500
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:39689 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbfLJREq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 12:04:46 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Dec 2019 12:04:43 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1575997485;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=bh4wBGVIIt6FwYzD2A/GCbI85tJhoANufsWXt/nPgfs=;
  b=dJ6qC0dzd3sy7FgfUVdWgwu2PU2g/r5iYfDJitlG0KyQzkMqLwM2ZhIH
   dqza47hjisGWHvxkvntPmpt4h/QItNzNbD+arxUXABbmbrEppufmDNOzB
   CbxwnTGLlrHRjgweSVu0PBraKwMP3/tR8r/4z8yLwoF5aM3MfnktozeDB
   Q=;
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
IronPort-SDR: o+qsGJbNa3suDdEcZu3nxCsTb15rCj2BGw6qcWZoYcN6ZNwdvNzo9iPbYScjv/dWg3bTyQy/dW
 lL0Pgg9ICBe9RRalAw1H2Scp9tLgd9T2JfWJ1sQYaH0XJl9qF3y5fM1GSKWMJ0vjBhUJx4C0yV
 v+xzNE/uKuQmNRxZrOzGsDkBAiSub/ZMnJTgSOVxLnWnywbp25NOEuE8jw71mx7OiUwe2SrsqR
 QXbDUSexpKbuQOE+iC03alye8by3UapYVcHxnjhItCdHmp+Q0LTCK9491OjvbgpO1Gn929uAhy
 5wk=
X-SBRS: 2.7
X-MesageID: 9479236
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.69,300,1571716800"; 
   d="scan'208";a="9479236"
From:   Igor Druzhinin <igor.druzhinin@citrix.com>
To:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        "Igor Druzhinin" <igor.druzhinin@citrix.com>
Subject: [PATCH 0/2] Fixing libfc memory leaks
Date:   Tue, 10 Dec 2019 16:57:28 +0000
Message-ID: <1575997050-12959-1-git-send-email-igor.druzhinin@citrix.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Igor Druzhinin (2):
  scsi: libfc: free response frame from GPN_ID
  scsi: libfc: drop extra rport reference in fc_rport_create()

 drivers/scsi/libfc/fc_disc.c  | 2 ++
 drivers/scsi/libfc/fc_rport.c | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.7.4

