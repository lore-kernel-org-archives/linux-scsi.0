Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77E6C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 07:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 795CF2467F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 07:58:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VbstpHrD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfLTH60 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:58:26 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:17693 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfLTH60 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 02:58:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576828705; x=1608364705;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4A7JEOCV6cDP8zEOWHFOh9MlzL2HHjW9+wQkj3bxrkk=;
  b=VbstpHrD+Fif/q0B6xd6ZixSCKuBUZ07Zv66PwqNauLxQ6VAQ2eUCUYE
   VH/zalRFKLuVZViZYnrAv2Y7oP28s6AdeeeWjH18d6MRnre27qS76tP8X
   YgqpdaqDT7Aq/VViOmhFlXlgStjq4kf4VPOpxVYK9HAOcq1yAxh0qXEyg
   5vmq63lcus0Oe035A0FJb2tae7UgTxPi7MyLz/qHwmPEwRhP7GeOsqkaP
   KmpjwsMApcEGNNR5DnnqtaWHs8BccDp3sSxse5LolAA16xUdaBXDxHwUs
   paXQG1UXb88QCut4LLncM+SMVIZ8fUF69rHS39+AIxOgE4jddj19R/9xF
   Q==;
IronPort-SDR: N/fr9cQHMiB89gVvohWi2ya2vNDH8jhCk4bBF8PeUVVgwiSkTFhAMXgzfDfH+PnGi1ckO7TUSJ
 C3yeQzA0rIPxrNb1QoBrcGvn7VXy+KpD74iKLd+fbmxkrBiMqWNsOknIDoWr8PDdMMVArclTkm
 /4D21yA74+kJW9MDWeIK8EAl6B2kWIL5hIcTMRBf1WVdSVukoXeZ2AMrnPwJri5hMVXeeDMPoH
 sYGZBK6EIFhnOyuhpGMWXK/tsqmXR5Ku1Sx06crBEJ9Nc2QWS9hj8spW9gjhYPUZOSxxgzBxnU
 788=
X-IronPort-AV: E=Sophos;i="5.69,335,1571673600"; 
   d="scan'208";a="233424638"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Dec 2019 15:58:25 +0800
IronPort-SDR: Cn2nkl6LsUsODJu/JufJch6CMaQlJf8Iais+khQm2oCQc4G5R85xfDZiwuATHCbPFdeXNY0IGy
 Kds01fq8O+jeF6roASyGLFjkyBN4Bysm90fUGVFVMc7YY9cnQdZ1SEFOr0OrCeTefn7ZwIx93k
 yZfaKTuAxVyCUMYskqn5cyT5m4a+Ao+FC2pZ1vvQ6y2TNrbtbSvEr8Xj4JvfZuUiSZSSHHwDYY
 YzELedN9sCUCJo7B12VFiMAYAgfAvCi0xVAASmic0/VZmN5JjJgBNgTTdBKXY+0sjQjZWsr69e
 PxrVUc8KOeKMGFakkJ/mrEyV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 23:52:44 -0800
IronPort-SDR: 8B+zOU1E9oikjMH3UzNteqXbnOIvzQowpiCEiFzo2HOTrlT7ak2iGfUuhdPvB3ZszfnljSakSL
 6w0vrVxBRH2/C7PTltbalQVRceOhpV/kTUXqbfkIoUBWxolROVPP7BIb+VrB7e7K0LyuCqmO/B
 vSB0r4vp9Apz3sOw+H5fR8lA6/fGJJYR2cmdNXlBbyHv7asOViCmQgJsrDWDE1aVYZwEyO+bTM
 CjkfKHhJfiVGVJo1yurhPGe89vJQSUWGyk+myPEOn4dzyoixxXcDuHdtXfyAup47zWYKnhahp8
 3HY=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Dec 2019 23:58:25 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0/2] Cleanup sd_zbc zone checks.
Date:   Fri, 20 Dec 2019 16:58:21 +0900
Message-Id: <20191220075823.400072-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A couple of small patches to cleanup sd_zbc zone checks formerly
implemented in sd_zbc_check_zones() and now moved to the block layer as
generic code. The first patch removes a superfluous check present in the
block layer. The second patch renames sd_zbc_check_zones() to be clear
about the function role.

Damien Le Moal (2):
  scsi: sd_zbc: Simplify sd_zbc_check_zones()
  scsi: sd_zbc: Rename sd_zbc_check_zones()

 drivers/scsi/sd_zbc.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

-- 
2.23.0

