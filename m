Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8542DC3DA79
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 17:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiL2RAT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 12:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiL2RAP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 12:00:15 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA821F5A7;
        Thu, 29 Dec 2022 09:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672333210; x=1703869210;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I7Ty6nXAeA3K0Mt+020OEEFpqiOrEDImBcneZVHCPtQ=;
  b=e6+7FhbHFQg3ql+6/bPwGY3lCDBv+VR7gBQRvR/6ejNmpW8XQ8Hr2JEq
   Hrq3OgxrpS5C+LSbti5flOgW5gzmZAi/1RHwtzrkCFcM+JM555t4icj8m
   GlQcxydV0Rf0QVAhlUlMrC5PNeiDoGdVBOcxAUz//mD/OqRrTXZylmAPw
   TdzWNaHVJQu4obUTT+eQKgpKVuOCw+QrSJ3wn8knzTgaYqk/Ozy0geYUF
   kaP4HBdajpOCEtixluYTCOs5t9jGcoavuy5ltSE3gupMHAnhywUXwPRCD
   PAVh8zkJTFTzQxa5alehO63S9heu6VyMlLsOUffQboG+H98tC9LgTmTfd
   g==;
X-IronPort-AV: E=Sophos;i="5.96,284,1665417600"; 
   d="scan'208";a="323990960"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Dec 2022 01:00:10 +0800
IronPort-SDR: FKlLMhvy4NjIBaE7BFvQwexVHE6X1W7FroIPNKY75BIYDIat/VHwDO0hK12pFSsZS1NJiEEdPH
 f+kDQlyo+xrw+un/2vg0y84z1AlgEQQWE0VZh/NYTZ/keJfmHmjGhA8UrOjgl9uTBdEbeo8Z3e
 acLRoz/98cNr/2pSsgnpSk+NZF7QMD5AltbAdlizQewm7mbh9EGoeDzzgJWG2YW6xyg9l87tO5
 8N0xIHjcrJ9p604Ka/joxZk6yL3wGGWtpo/jQJx/kuBcWSENlM3wCYqZIBSRS6fFXBQWQgpnQu
 J9A=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Dec 2022 08:18:14 -0800
IronPort-SDR: P4GILmDQHIY93RS5cZP1jiVb7hCqC9CE60g6XDsTyB5POf95Mhfc7CMJWfu2zL8Jlqzu+alKIu
 CqMMoiARvGjSZjAKVClVjoSbqYG3jpmZqiLlMOYRANOqpZqYD6PVLVBh+VrdTqcg0kkucOpBHz
 TAFyn3dg0rg3msUexzFtlbV8aJ4NfcllNCfd4LTcNguY3YUMK1RlodobMkNyImkoLVyGc0Ji88
 YLX/h719XH6xHsI1YlW+CBKkV+xT7LRaZIIAgUbNfsnd8bfrBDLC5qJES8trDbZRTVsvIZRIlI
 DO8=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.9])
  by uls-op-cesaip02.wdc.com with ESMTP; 29 Dec 2022 09:00:09 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH v2 0/7] misc libata improvements
Date:   Thu, 29 Dec 2022 17:59:56 +0100
Message-Id: <20221229170005.49118-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello there,

This series contains misc libata improvements.

These improvements were identified while developing support for Command
Duration Limits (CDL). All patches in this series (i.e. V1 of these
patches) were orignally sent out as part of the CDL series, found here:
https://lore.kernel.org/linux-scsi/510732e0-7962-cf54-c22c-f1d7066895f5@opensource.wdc.com/T/

However, as these improvements are completely unrelated to CDL, they can
be merged independently, and should not need to wait for other patches.


Kind regards,
Niklas


Changes since V1:
-Added missing chain sign-off (in addition to author sign-off).
-Picked up tags from John.
-Rephrased commit message for patch 1/7 as suggested by John.
-Rephrased commit subject for patch 3/7 to more clearly hightlight
 that this is simply an improvement, and not strictly a bug fix.

Damien Le Moal (2):
  ata: libata: simplify qc_fill_rtf port operation interface
  ata: libata-scsi: improve ata_scsiop_maint_in()

Niklas Cassel (5):
  ata: scsi: rename flag ATA_QCFLAG_FAILED to ATA_QCFLAG_EH
  ata: libata: read the shared status for successful NCQ commands once
  ata: libata: respect successfully completed commands during errors
  ata: libata: move NCQ related ATA_DFLAGs
  ata: libata-scsi: do not overwrite SCSI ML and status bytes

 drivers/ata/acard-ahci.c      |   8 +-
 drivers/ata/libahci.c         | 171 ++++++++++++++++++++++++++--------
 drivers/ata/libata-core.c     |  12 +--
 drivers/ata/libata-eh.c       |  22 ++---
 drivers/ata/libata-sata.c     |   7 +-
 drivers/ata/libata-scsi.c     |  11 ++-
 drivers/ata/libata-sff.c      |  10 +-
 drivers/ata/libata-trace.c    |   2 +-
 drivers/ata/sata_fsl.c        |   5 +-
 drivers/ata/sata_inic162x.c   |  14 ++-
 drivers/ata/sata_promise.c    |   2 +-
 drivers/ata/sata_sil24.c      |   7 +-
 drivers/ata/sata_sx4.c        |   2 +-
 drivers/scsi/ipr.c            |  11 +--
 drivers/scsi/libsas/sas_ata.c |  11 +--
 include/linux/libata.h        |  25 ++---
 16 files changed, 201 insertions(+), 119 deletions(-)

-- 
2.38.1

