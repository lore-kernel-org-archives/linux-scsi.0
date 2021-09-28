Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1698DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0C0C61262
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242217AbhI1SrG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:47:06 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35722 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242214AbhI1SrD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:47:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854724; x=1664390724;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=dJRtymwxoEy9U9w8j/xyCbuR/yJm3lXBla3vb+05SNUfBFfv2tE3o/Za
   t9s6v4gSe3TwxcXdk/OMjxIU190JsGEYxwkAm+p7jm5fdnxLcM47z16Ge
   N3kj7bzN1/PyXwbwFrPALErfpDOezJLKW4tQAKRKWTco90a4jSfYHRgtX
   jqNi39/quN5DaqQI66voy38oZ73nKYcprnlMidDtHqxRF36xpTGQYvCny
   JpcRS2Ce0yWxk4loO3DcbzLHiFYZuz7QUApYVwGd4N/1uzdjqq5gCi40Q
   lHYA1+mfRh8dGXPwDfbXejKQcOHpUXE+abfI4kDIsShgTyjzxHsDfwBIc
   A==;
IronPort-SDR: yGPy/7o9H2dr0gPyAN6ellg2CCTVbvWCv80GNW+F80Ywv74YvhCMmtsTkq7dHDXB6bgxqjlHbM
 hw1kUtvVKwteBJOASZwog0Racr9JN4E24L4z2jlhBZEJ9vw+htWyKBmdfiQVGxhcnjBTbD2DDN
 nPnMCReDBDpRegXh6o8btFL3ur7BcVOWY0ziNvwgCkHeGI9ca70S2S7TAutehEg2O0ys35O606
 Yf1mJ7saxRpJjasxvK2dB0HRzxN+SoBaGw3uVrE73ffY0jeAdKlsPXwWN7QCq/iA8utpgPj4+M
 Ov+4+2bxUS1FnzhmrKonmbjY
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="137712575"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:45:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:45:10 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:45:09 -0700
Subject: [PATCH 06/11] smartpqi: avoid failing ios for offline devices
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 28 Sep 2021 13:45:09 -0500
Message-ID: <163285470952.194893.8100949573334943444.stgit@brunhilda.pdev.net>
In-Reply-To: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
References: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.1+40.g1b20.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


