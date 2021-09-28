Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422EBC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DF2860F9D
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237753AbhI1SrJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:47:09 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18654 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242214AbhI1SrI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:47:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854728; x=1664390728;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=0kkvET6HOG6ZvcfwAyZar78nBitA0+402HGaSs2Vu7U6uUfDq2khusC9
   Izsj9Q99G4JNSaBN8CFulrkZ2hhHk2qfC9FakT8RL5zlDSVDC7NGUDb3z
   VjzjBVBFv/b69HV6kV/74RhEYdiHIAHqVzqxoJBlaUOidB0EvMpiMCQ+3
   okRtIS8Zv0ye+UT6sC2OCx+daQVxQZzGFTNmmspyPWFz5uFxnd5lIeIjf
   ADPHaTiCo0j2yQRPV5SLcdQSLN0iOXpp4vDDLtA+1JRCT0NR43sXOPE5I
   vuAbq6v/8u/deEZegskm/k4l3KupL3+LX481OnnKQykxww933FM6Mtibt
   w==;
IronPort-SDR: cP8sNeTEooUtlueoBsX/G7AtQeCFNkUAeCIHKrN8mJ9WK1AiGVYUKZkafdeV6nNfvmG3NAft1+
 enSOQVgA3uJmUA3ooFQpneZU8rHqa0/rl0Ua5+rucWzpOPvGWONPCxtSQ+sh2Wq6I4scDvb+uy
 J24zGhkmRSQr3b3bWOACBNvT7UlePSBaw4ZFKGYtXUwcJKc/LI0Ii41i/OMq7h39R8wQFlMoYw
 7WM4dI/7aUoWJ3m4f7TMyzywcHFfctNqcupEnnMm6tR8eUmC22jKE9FRZriFsuHg5PgsNXs+S7
 Q2uJ3FsvCuoxhmqB1tNs1FtF
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="130992482"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:45:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:45:27 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:45:27 -0700
Subject: [PATCH 09/11] smartpqi: fix duplicate device nodes for tape changers
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 28 Sep 2021 13:45:27 -0500
Message-ID: <163285472713.194893.6797736399721227028.stgit@brunhilda.pdev.net>
In-Reply-To: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
References: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.1+40.g1b20.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


