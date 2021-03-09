Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EF61C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 13:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4511B650E6
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 13:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhCIN1w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 08:27:52 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:40103 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhCIN1a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 08:27:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615296450; x=1646832450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o801WpJ7u1Na+IXF41rulbrs+RI+ZynTaPoiXJhQhac=;
  b=I/KZiv7MWtnzEUqe222Er+LOM1JyUNTs3xsJnf6hxsD2qVmHxJLidRJ0
   cbz5xB4WWexZtpLEA7JvFfYxwuZtu96o8TPI7Vw4A9eAnybaIdZz7QEgn
   FeHxZku78upomqASjcDAEDPUHjPRH5PSJCeimHHMeLRROtAkJt3gZDlwV
   Botz8AQ6ueWqTsG6X3bc+hYmoODJjzMEyN/0YYZ7rMpRxG8krwe31dMPw
   ksI0n7WIwST4YhAJfirf+Jymq4E4KcpCxawuy4oE3NuYDOsKlqXlMFFft
   dnFUMf3j1X4/jTVwNNBuCwKpmKJc2m7slbqJoT8EkH6Vsbm7ihRZyqswd
   Q==;
IronPort-SDR: bb5Qj5aFlibhloSNhnNWgOxiB8Knn7JLEZ0JI1kK0d27u5JQIK2bSq5fMDTdPM2N1Aj1G/qiVc
 NZLcb7ji/1W7pk+/chsQJevrPsJ3pZQlqg1UPclYsfsNBNWjOocUNEB/sD/3c5fkpTZgA+4TI7
 tPL1JezL4OMMD5+X+iTTpbzlRN/pPvtqDgC9rNJ2kWRq5ryHiuTqH8L+0gB6UVL6PAZ2t5AvS6
 mz1dIQooB2Y0YsJjLdpq9na969dxn/E6ajF5ictoFHx+JuQLE51rKHdQgpaOt5EY6REKnVAgne
 33c=
X-IronPort-AV: E=Sophos;i="5.81,234,1610380800"; 
   d="scan'208";a="166215158"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Mar 2021 21:27:29 +0800
IronPort-SDR: uDJkKXOJG/HW+wiBSdkuUZ225av7y+g333NjvAXkiYsfXh33hhGMmIc/I6/Y+LLL2Vkjwm33pa
 0AMZnF2laaRQ9Y2mf/t7V23DnOPWwUdUTCbNy6hHYEFC8o9a0lyG5ZqsB8BKpMXAANpLyzMnsK
 Py10AjYOOCF2rW6+fz3ZviXmuktMPJVMyOb87HFEN8LNWD2F/8DvjwQ3X2Jo4LarBovxHWFg3L
 4I7wa7Tz62AFYrG6um1IwUPzq56Qo7geA3zOLe1bW2sS0iggzkmK6Uni+quujp7Ij1vcHmUJoc
 XlzgoCvk74O3Vq8/disvl84e
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 05:08:27 -0800
IronPort-SDR: V1pvUC/GOU87ho1DuYSPyyj3+CKrO7ouUqgyOB9kBlbD2VRqRpELWgFP/7i2D2w4Vkiyy3qZo1
 yOwqrrSxmuRb208CcUoXLIQG56i3npT2y1SHck9c/hbHotzhdnXRJAcSkE8TWFQ/qR/hX47uIt
 GlPJrbe6GP/jvv5E0tFHaInLn9dAAMC1ediwC2zHG17fhPb6/fapIicqKMpYxHSITsCM2ofO75
 EeyiCRYHKtG5IKTzVwtIqB7m6WLp9saXK/wzhA7ytJIzb2VJ+jArmAw6bNolwM20fvfa3njg3G
 0oo=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Mar 2021 05:27:26 -0800
From:   Avri Altman <avri.altman@wdc.com>
To:     alex.bennee@linaro.org
Cc:     Matti.Moell@opensynergy.com, arnd@linaro.org, bing.zhu@intel.com,
        hmo@opensynergy.com, ilias.apalodimas@linaro.org,
        joakim.bech@linaro.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvme@vger.kernel.org,
        linux-scsi@vger.kernel.org, maxim.uvarov@linaro.org,
        ruchika.gupta@linaro.org, tomas.winkler@intel.com,
        yang.huang@intel.com
Subject: [RFC PATCH  0/5] RPMB internal and user-space API + WIP virtio-rpmb frontend
Date:   Tue,  9 Mar 2021 15:27:25 +0200
Message-Id: <20210309132725.638205-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210303135500.24673-1-alex.bennee@linaro.org>
References: <20210303135500.24673-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The mmc driver has some hooks to support rpmb access, but access is
mainly facilitated from user space, e.g. mmc-utils.

The ufs driver has no concept of rpmb access - it is facilitated via
user space, e.g. ufs-utils and similar.

Both for ufs and mmc, rpmb access is defined in their applicable jedec
specs. This is the case for few years now - AFAIK No new rpmb-related
stuff is expected to be introduced in the near future.

What problems, as far as mmc and ufs, are you trying to solve by this new subsystem?

Thanks,
Avri

