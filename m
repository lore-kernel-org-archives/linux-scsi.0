Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2A9C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Oct 2022 13:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJGNXz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Oct 2022 09:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiJGNXx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2022 09:23:53 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F33BD01BF;
        Fri,  7 Oct 2022 06:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665149032; x=1696685032;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Trw3Ky/wAlHOsMe0Ydt3F+ofzQMskwlHAG5u+ZUCpns=;
  b=PHJFXGoIkiv7QMWyU0GW5I20AhMUwZkC/oGy0ub/RQ1spAa+NpKYUPPb
   sQ0gzM75czDB/w2BOvnB1v+wN7Cos/LTKk3PLXqcGdRuv/kwE3ZZ2R6Y0
   pfOki6od1xenEZJN4H2FE7wXmTGYqAYRCsYKdXd+JNo/QBTj6fzwXMtfx
   ghylyz5nKgPoPaK0+JOtbPTCgoOxuTvZHVELKvIzKyMAoDgyI3h6WBQim
   IAkcdUTt73CGmg+MQso91M5SC9b68Fr/P0t6qdg3wadgdF05F+TEAAUJM
   wZK9GqDF+qE0sntkQrG+IVdKhCrgohq8BBAR9E+BcQaJjFWayqD/JERKv
   g==;
X-IronPort-AV: E=Sophos;i="5.95,166,1661788800"; 
   d="scan'208";a="213238163"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Oct 2022 21:23:51 +0800
IronPort-SDR: pLoQKAQjAwifzffBs/sn5nnu/8JwGum1FuwtbX4U06U3N/LNedWF++d6KtmRhvQrb2k74oTP31
 B7fRe1/xRxJKEe8U4GUGWGSe9BWzyE/aBlKiWkLMqm7aWAqjJuopeeAnNBWbkyfWgTX7HTNnZj
 WOlJ82ay80/RcKgvzdYxsUi7s3rJRfCuvW0EMXlzZyYQUuyYoVPOm7/kB3IgW95cmyAVuhHCRO
 40lQlAzKz48dVJGADAjil0pDSKYbv6zvJn+jnhJJrdtdO2v5g8gwg3J8sf1+l9Y125Rot2aovi
 CevAsvGSfRhozGUzkdE1P+nQ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2022 05:38:01 -0700
IronPort-SDR: llWtY2KT8NYGk93HadKKuMhNrbG57wcKi/6fwxK+0xLVbJBoGJyDJtXFsqxZQEsp8JIbL9RYfd
 c6vONeZklHHcI56tu9bmhL0tlJ4l1Z7Ixjouabc21o88RMw/c1DKyWOCbS7NKU4hYO5kpLOiz5
 hFIE+ZCtxeAeM/WdMW3rsjcrlBDkp3+GZwh95Xnp5BDC4zP3sMe0Zd7eSSC4dyYCE61btrgGQL
 6164/PDAG0fEZbE1WVrDrMMbKVGLKomo9/j5Js/QtFMzerGcZUc6894Qc5lyXKiYwXOtIrsayt
 kBU=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.69])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Oct 2022 06:23:48 -0700
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     john.garry@huawei.com, Niklas Cassel <niklas.cassel@wdc.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 0/4] libata: misc frozen port cleanups
Date:   Fri,  7 Oct 2022 15:23:36 +0200
Message-Id: <20221007132342.1590367-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello there,

This series adds a new ata_port_is_frozen() helper function,
and makes use of it in ata and libsas.

Additionally, improve ata_read_log_page() to avoid a futile
retry while the port is frozen.

Kind regards,
Niklas


Niklas Cassel (4):
  ata: add ata_port_is_frozen() helper
  ata: make use of ata_port_is_frozen() helper
  scsi: libsas: make use of ata_port_is_frozen() helper
  ata: libata-core: do not retry reading the log on timeout

 drivers/ata/libahci.c         |  6 +++---
 drivers/ata/libata-acpi.c     |  4 ++--
 drivers/ata/libata-core.c     |  7 ++++---
 drivers/ata/libata-eh.c       | 21 ++++++++++-----------
 drivers/ata/libata-sata.c     |  2 +-
 drivers/ata/libata-scsi.c     |  2 +-
 drivers/ata/sata_nv.c         |  2 +-
 drivers/ata/sata_promise.c    |  2 +-
 drivers/ata/sata_sx4.c        |  2 +-
 drivers/scsi/libsas/sas_ata.c |  2 +-
 include/linux/libata.h        |  5 +++++
 11 files changed, 30 insertions(+), 25 deletions(-)

-- 
2.37.3

