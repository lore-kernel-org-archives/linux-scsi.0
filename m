Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE9EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 329E060F9D
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhI1Sqe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:46:34 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:11308 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242212AbhI1Sqc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:46:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854693; x=1664390693;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=emOCz4ScSZuQ5f+mUEBORmYA95zLp8qgrgYTtBak+HU63f7vkS7X+KRz
   QmRwEXfklE3fekzu4BOGd7LVrmFQ0leSvY+wpHfNXCMmEawTt4mqO9r+R
   rcW98kofcx3XSVgRM1Hby6ochOzFJ0zfyyzmVTfg6oEwoDmRFWwbqRHnZ
   ba6fToLf8WwM5kKdmpm+pub9cuGmWxfFxBj92UC5ytxN+lOF5oRG7/tk1
   RIls73vGTw2l0YXKlFWu+ptBacQjuziNfLsAnIpZD93aC0HjV5bbRKLlt
   BUXqUg4wYI0Z3UCCHEhoEBmUDEuuyFpRKx9RxeDjisrcMtnMgg5ZBU4iO
   A==;
IronPort-SDR: I2Zip4luJQd5YrqbKjryzofKB6vxL+Qlt1Vd5AU+OKYwsio31RXUcKlJRMv1MD5lsFSA8w58my
 dHwMPobO6q6eAVHuAQuJGsMhgaoRk7nm8ZMHMKEgLM2dX7maKeHPVDuYnUGwiM4sUscui4Akix
 AU0Lkt+LPNgpFid6fNgJJAuEvoeD+lEVQoEtMc4FE4Yexp4swj0Z3J0wGsOkwVTLTwoALV/sEU
 +3YqmRSu1Qs2MHRmuGLpoAGUPKUo3jUEDabaoylqs1e4XrzIMRVTJ67ADJOe7GELsd6amFM0uW
 AAwk+v5ISHSQ3O5E9Rzlbe4t
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="145976843"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:44:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:44:52 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:44:52 -0700
Subject: [PATCH 03/11] smartpqi: capture controller reason codes
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 28 Sep 2021 13:44:51 -0500
Message-ID: <163285469188.194893.10173689687332879917.stgit@brunhilda.pdev.net>
In-Reply-To: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
References: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.1+40.g1b20.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


