Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93619C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F8356124A
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242212AbhI1Sqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:46:42 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:31197 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242153AbhI1Sql (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854702; x=1664390702;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=2Vd5s5na0d/p5nMiVWfuoz8qF0NwHMPANueP4N6QDCA6fYJX6erNxlp3
   tsHmgHT6h36t9e6a7cNrs+zipGkKvbGciY1RB6KzePK1PLSLHRiSO/Z2C
   QY1pHtwczuTrrVRxQxBvZXus/tbvlcVapirD9Ue3hLQflS7d6nZk4mFJN
   s8N96+1MqIr8MGp3fdqXBcNFyyCRp7qpzllSgCD5SWTZXSP3Tn1LRy01J
   J97kDagumjpFW4KbLJqcS9YWkLUPzI7HHbP/YetV8isgrwwOFY+ACxbVH
   0hA+8041RoIDx0FgWQeDrjnPxNRXSq+YEHfxFxcTKhYBWaFBg0c7ctf0a
   A==;
IronPort-SDR: jA0N5KsExEkhKl/7oQm7jWQj0QAQR1yq82J5XqJB22AIEKvPWaLNwPPdQPZyVKNpFIRBkd/bSD
 cF8PFDC3iqw9FXDua0bxU2qloMKH7bMMV3Jb/MkEJhS1Q0l+1/4U5rirkKWY3O3TQJ2v8HoGfc
 WNxVoWT72U5PHTIoS+6T9P1T92ynT3skKpYwgFxL1RbroUsCwZAfPO3y4JzHVg5oiAFVXChdPK
 MfHOnV2fum1BYfcAOjZT6Q1+ttQD//c8NRLwHVSYOdVBWWvmh2aoaNrC8/08iwkMRtHarS/R0w
 YikCcC7Q4cVvJkdph4/3lY6W
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="138300081"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:45:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:44:58 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:44:57 -0700
Subject: [PATCH 04/11] smartpqi: update LUN reset handler
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 28 Sep 2021 13:44:57 -0500
Message-ID: <163285469778.194893.1076744560412693133.stgit@brunhilda.pdev.net>
In-Reply-To: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
References: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.1+40.g1b20.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


