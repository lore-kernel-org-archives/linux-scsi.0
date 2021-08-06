Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA825C4320E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89FE161186
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 11:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241023AbhHFLML (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:12:11 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47118 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbhHFLMH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 07:12:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628248313; x=1659784313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uUZ1+YSkY07S1sOnW9DMCk0sb8DSqpYgvgs5GZz3c34=;
  b=hPlKBo/6Od7CbghNo3sqXDU2vxczim+9iWKZTenXWO800VGUHm3DUBCM
   t2O1HyK6AOKESDVEE5vHLSaGuhjoFbdJA0YryD7usVVhmQwhpJahnF901
   iR8e/GRt1SsyQzWILfCF4OeSqMHWko8VMaueGi1JV8mzTacMWke6daaUt
   ACrisa22m8wD4fK7jct55MfvVIIq2apOVCRskpydy4/qh/zDQfUigXt2r
   UNxaNWXg8pYd1h0Lno2BpP5lECp9wIVI/rUwpkXrHpKUsfhOSHSmi2fa1
   w5WJxKynAqNCW93fMmbC8UOL4wdIbg6SzJZbF1T6S9O/TfzFegGUYxG4l
   w==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="177055542"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 19:11:53 +0800
IronPort-SDR: OCHyHL7fk+QXyt4f9WbHAmqSAtFxrwlg31L/EZgHOtuTwHgUF8QA7N2BzLjvCShj7dmsWbAOd8
 8gEBfxJPw1Tfe7r3jrlqUEKxvZzUpdLsUmHoVebSvfaR/4sC8pIiITCduDvryvYPvqAbriWlby
 s+t+KvJhN1zjdJ0/zEv/WDk7thSwI0h0KvKxv7XLIaQ7h4nQ3NldZODTLdeUSkLv/DvpqWNwJD
 IADfziuNnTnA90bzHsCwCZ2oE5sIVKW5ZuPX63zx/go/KdEd2v5JX7x+ijjuQ19E3s+0VfMktA
 BDvWCxGHQn/i/siZU9l6XMhA
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 03:47:28 -0700
IronPort-SDR: 7P/QsreECFL24yf6c16ivDSqmJDfjQVSO6xjp8HBcTljsoUGnCfjLivyCcvwiEcpZ1NEkcdugM
 mwuHgrnsQUnkM/nb0FdhqXdQT4EkVBh6Wg2zyI3zKmC4fCshes71+QISy7jaevXvyzDS29gE2j
 v8St3UDekvsavAQIZXi6ZvKMWy4SkItJs2+3cNUCAC69U4jdFcHWdVE+pW22ombYTydhbBX/kn
 n+gEG00Mf2FAnpUmAqApdPiJseQRkQQFgDtgWgWboVjzN3pB7M0jdgUG+qE4SPjmiumyoTwlPC
 qOI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 04:11:51 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v3 2/9] libata: fix ata_host_start()
Date:   Fri,  6 Aug 2021 20:11:38 +0900
Message-Id: <20210806111145.445697-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806111145.445697-1-damien.lemoal@wdc.com>
References: <20210806111145.445697-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The loop on entry of ata_host_start() may not initialize host->ops to a
non NULL value. The test on the host_stop field of host->ops must then
be preceded by a check that host->ops is not NULL.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ea8b91297f12..fe49197caf99 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5573,7 +5573,7 @@ int ata_host_start(struct ata_host *host)
 			have_stop = 1;
 	}
 
-	if (host->ops->host_stop)
+	if (host->ops && host->ops->host_stop)
 		have_stop = 1;
 
 	if (have_stop) {
-- 
2.31.1

