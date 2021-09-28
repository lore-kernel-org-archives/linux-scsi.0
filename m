Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193EBC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E47206128E
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 18:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242184AbhI1SqV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 14:46:21 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:31160 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhI1SqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 14:46:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632854681; x=1664390681;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=AzKtKy3ZlY6xoY4x/E3caJvmuf+QAPpisFnI7/6sF0dC4qspNygfrGho
   0HQhQMQYMAvzzn1YnVgPJbrzdeKf+KhOxTbWhtnxNC6sVYd/psYzUxADq
   d/RxNt5de5TtXAtMoZ0DtK9gX0gTssBUlHGlEpieu3GZElOz4Y8olWWIc
   ricZWuC60sTkagnWgnTkvOb3/PbLG7gmrvvzB1ROZcJLmAqYnLEgRJmvI
   0qj6j+gHDMioYai1HdibCzBLHoVtbdiyhjOYddUyVefIAk+JP8wQmepjb
   ddGjaEyhMBnUz9c7EnD9rkEKsetI1PQx/gmVVgCBG8zti4wV/UzGx7L5V
   g==;
IronPort-SDR: 6oAkt0DWrDR8LjH3w0OwHZq0Z9l7xTd+i35RgcEZQlDg6nxF0ZIHC5HtHtw7vz8I/P6kyP08VN
 PqYYCcEcaEMLaLl7smwoRWUg6ERVtgjy2W8gwwSrF7v8c32TMfZJBHCtBrgNFbpADt/aE6RQj4
 c/KhU6OCJp+be9Skd+w4XjGmfjFNYQ7xYbMBT7h3nS4uiim8b0jlp4REhLg+x8h9Qlw0fL+X4G
 Oqpw50nRHMCkf71uVyez3SVdPS3CgkAA6QB664xg1QHYrsccNptQApx1XVlq9wVwxl95wbTmi1
 8KL9aV16epEyRUhfCHDzSHCR
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="138300013"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 11:44:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 11:44:40 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 11:44:40 -0700
Subject: [PATCH 01/11] smartpqi: update device removal management
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 28 Sep 2021 13:44:40 -0500
Message-ID: <163285468012.194893.4519022239645312644.stgit@brunhilda.pdev.net>
In-Reply-To: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
References: <163285461769.194893.178408874562704189.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.1+40.g1b20.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


