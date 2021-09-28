Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1340C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C65D560F9D
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242222AbhI1SrH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:47:07 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35722 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242214AbhI1SrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:47:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854727; x=1664390727;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=bI4XDQCM+8SlYebrvcfJ1LHnVRXe6UrSMOfe1DERMEWzdJq45pkI/jF5
   AlMCN5EdxNSjOh0zmc6fxnIUC4jQF3kO/ds03wgSsluco3hFSRFEQHEGn
   cLc49RB5to4w2mmJacQM4/0r8HHyr7+ST4dgSBngg47UTzrvLCWLdXRiF
   3C/rinO2vW6Tyc4ND0Rkg0ukKtr6yq+qo/UQy462QnnPIEckdy6Od4g0b
   SJMwmVlF6XUNOiYRRcp1LUuGQ3NEVs9F2OkVFqMM21IKIJGFO93sbbaTG
   6qTnDYsiWzU3lja6SiSwSNb+SIQwaswFzG6rzGQ+WFyiOA1TMS9qoxeMS
   Q==;
IronPort-SDR: HoL15/MKbzjPwm2jzAp58DC75u30szpdBrKiG/JR7bk5kYnweaj9xjbCBW/lpqH433Mgfvx7WS
 0b2XHwTIE6zQd3wDLAuBhS6vHEcgEIMCp1RlYTtBvaodhnWfk7lRAXigLWeC+oskapObwYsA9W
 l/nstm7XSMObuQVIDj22L1snrfTsC/nkUu3waP6RSR6RYobcmtU6OZOKvYNL5Xhc55Uc/0+1KQ
 jKuB/h0VBlKYBxyWH4F0BlUqd0YJSxjbyG4EgJf78jRR0pEXwzIcZOD7Bvzuvi2jYdbkGix+kK
 Ye2i5qPziNijPUdOVaxnjehY
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="137712598"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:45:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:45:16 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:45:15 -0700
Subject: [PATCH 07/11] smartpqi: add extended report physical luns
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 28 Sep 2021 13:45:15 -0500
Message-ID: <163285471539.194893.12598492843845834729.stgit@brunhilda.pdev.net>
In-Reply-To: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
References: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.1+40.g1b20.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


