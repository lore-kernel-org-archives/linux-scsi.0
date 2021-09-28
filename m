Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C4AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CB7B61262
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbhI1Sqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:46:45 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18610 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242153AbhI1Sqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:46:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854704; x=1664390704;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=v4Y4LY1pxyCUt3CHP0EF8ZWZdo2eytD2SNiTKv3GlziGyh8Br7rLECOa
   3/vNzdHK4q8ZeQvHAI6x+v5349dzGfNf6UcycEjvnSpvzULGhCjCu/4wg
   E2T35KjXxbU6qAW95QRuB9h+mvO204xHyL0gn7uor9VhejRgrnMsEMfr5
   p0v07Y1dXOo+2oAzFCuIKjVaESzfPn+8HKvx9ItJpjI4gFR58rLVAwvd+
   J7byIo/X/VSPd8NP6XbezxlKCA14y6oF40yFutlqFY/ygwVFsakpRDN+O
   6RNiGE1J+ylgZgVGtca59unmm2U8M3dwB3UBiyTwen/Uu+mTu0RnUduMn
   A==;
IronPort-SDR: vewux1p6TZZP6y+LTPFXocFND2gmHKsv64R0PtNeisCNDU+rRS9nrvA88bthD14lsPYNh+3tE7
 fClM4zj4rbZ8GGRH28fdXCFRJk7hqlqcNrZBPjfL+yR2t2YGJHjp63YlUCl1bUIKUPlZZAjpKX
 7E/EDQWLFEbJa4Shclum25D28p7ppxrntxU4Kx+Ukxf7X1xesLsFLkvcqUNy13YdQ6mNwLg96z
 66fyc/2Oh+LZuusqh9mIH0pxaUEqAVurDGHkE3GRdL3cOL9b3d5xTtCO7q4UoXie93CCQZbayV
 gTOqbcNcud1NB+Gg9xnGyN2M
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="130992436"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:45:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:45:04 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:45:03 -0700
Subject: [PATCH 05/11] smartpqi: add tur check for sanitize operation
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 28 Sep 2021 13:45:03 -0500
Message-ID: <163285470363.194893.15584783823342548307.stgit@brunhilda.pdev.net>
In-Reply-To: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
References: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.1+40.g1b20.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


