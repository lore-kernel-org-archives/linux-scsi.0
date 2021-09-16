Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB405C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 02:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95D5A611CB
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 02:33:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhIPCeZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 22:34:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19062 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbhIPCeY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 22:34:24 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210916023303epoutp0352b3e58b9e04d0d9449846dc93091a46~lLLIjnGc-1707417074epoutp03m
        for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2021 02:33:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210916023303epoutp0352b3e58b9e04d0d9449846dc93091a46~lLLIjnGc-1707417074epoutp03m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631759583;
        bh=ljGSippabUdmaUmpB0srgCUxBu6tUejORTZv7oYqZsU=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=khOqZ/Xutmt4a2Pwh699ITchjDNRJJoyvWWJDdwhCmGfeIrhcx1xBkWv3ds9crYFV
         RUGihpkodryjim8z8cLbS+F0F4z/uajknRRUTdjN7VLHCovqf8jHkki90c+vuFBdWS
         gzh92ZfcjUR9dDEpz5O9Mo6d5UEkZBq2Ay0/NSOY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210916023303epcas3p1bf119ddce1332e3418b47406a0d113b5~lLLIIBUBG3166531665epcas3p1Y;
        Thu, 16 Sep 2021 02:33:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4H91Mz0gNpz4x9Q3; Thu, 16 Sep 2021 02:33:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v7 1/2] scsi: ufs: Probe for temperature notification
 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210915060407.40-2-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01631759583079.JavaMail.epsvc@epcpadp4>
Date:   Thu, 16 Sep 2021 11:30:11 +0900
X-CMS-MailID: 20210916023011epcms2p3f3dba820d03b315d0e0198394c8cb1ae
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210915060437epcas2p1f8bcdda5911050391b82be6c9831e4c2
References: <20210915060407.40-2-avri.altman@wdc.com>
        <20210915060407.40-1-avri.altman@wdc.com>
        <CGME20210915060437epcas2p1f8bcdda5911050391b82be6c9831e4c2@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

>+config SCSI_UFS_HWMON
>+        bool "UFS  Temperature Notification"
It has double space.

>+        depends on SCSI_UFSHCD && HWMON
>+        help
>+          This provides support for UFS hardware monitoring. If enabled,
>+          a hardware monitoring device will be created for the UFS device.
>+
>+          If unsure, say N.

Anyway,
Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
