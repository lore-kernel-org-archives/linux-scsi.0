Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2967CECAAD8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 04:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiIVE0o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 00:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiIVE0n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 00:26:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E10AE9CA;
        Wed, 21 Sep 2022 21:26:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD240B8225A;
        Thu, 22 Sep 2022 04:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3D3C433D6;
        Thu, 22 Sep 2022 04:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663820799;
        bh=h/gWxVwFGF8y1DWQKw50ktTmRYac11ZGNHJ3I0HSjwk=;
        h=Date:From:To:Cc:Subject:From;
        b=qaSE8faMuf45dfzKy5oiaS1Iecj+0dBguqPvVpVeWBFW+4ENZREvE3E9ldFUPyKxc
         gAUiyU50Q8cMfXShnymiFa3bYWkD01oNmprTOebONPhwN2Z4T8R4w8WK32ggRCI343
         zRqLAKxYVuHHKnhwTdxQnpcMcqClEtFIw3yqRJJxF8LE8eV6yAPpo6qAndDM1Q9/CV
         z0JRjaI5BThIrXSbF6BxaL2NuQxu2RoyIvEQA7BCEdSlPpBRCKiVo+jL/kHwqSUe9j
         ZHYwhphgKFDsYC0B3WqmIvx57WkuaOWkxYu3sRzsGq71aiuRRAx11i2vfcyq6OrsDZ
         3x5i4jwrxkjVQ==
Date:   Wed, 21 Sep 2022 23:26:33 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kevin Barnett <kevin.barnett@microsemi.com>,
        Don Brace <don.brace@microchip.com>, storagedev@microchip.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 0/3][next] scsi: smartpqi: Replace one-element arrays with
 flexible-array members
Message-ID: <cover.1663816572.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi!

This series aims to replace one-element arrays with flexible-array
members in drivers/scsi/smartpqi/smartpqi.h

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://en.wikipedia.org/wiki/Flexible_array_member
Link: https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101836 [1]

Gustavo A. R. Silva (3):
  scsi: smartpqi: Replace one-element array with flexible-array member
  scsi: smartpqi: Replace one-element arrays with flexible-array members
  scsi: smartpqi: Use struct_size() helper in pqi_report_phys_luns()

 drivers/scsi/smartpqi/smartpqi.h      |  6 +++---
 drivers/scsi/smartpqi/smartpqi_init.c | 12 ++++--------
 2 files changed, 7 insertions(+), 11 deletions(-)

-- 
2.34.1

