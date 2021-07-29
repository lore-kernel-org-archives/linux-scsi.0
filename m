Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5F8C4320E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78FFE60FD7
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhG2A6K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 20:58:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28342 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbhG2A6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 20:58:08 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210729005804epoutp039d0c6859c9ea73c366f840f4f688253f~WHRN3KxW70207902079epoutp03I
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 00:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210729005804epoutp039d0c6859c9ea73c366f840f4f688253f~WHRN3KxW70207902079epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627520284;
        bh=1+1j0xT8px/pbohTmjReOTlDRXB0aN0TnSAmNUQezVw=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Nc5nEZOdiS37nZRK0oDmOOBf4+1rUdKwOWUf5ycQ3LCe7Sj1Cgilg1E+659f9W6WI
         fLGKKWY+vcPcNqeOxwlAQM6Fztqn1rya+gGLE21kQuayY2zVPtg/fFPqeIFAunoUNG
         rtcd4RTG5qnNCJ77KP53tt/xZlAkL5b8y1BdzBKc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210729005804epcas3p3e27ac74d448fdccff6fcec41256246e2~WHRNcZQIv2558225582epcas3p3q;
        Thu, 29 Jul 2021 00:58:04 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4GZsb0275nz4x9QG; Thu, 29 Jul 2021 00:58:04 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 07/18] scsi: ufs: Verify UIC locking requirements at
 runtime
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-8-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1652149987.141627520284286.JavaMail.epsvc@epcpadp4>
Date:   Thu, 29 Jul 2021 09:57:18 +0900
X-CMS-MailID: 20210729005718epcms2p4cd83e29482f0520a2095d8ac2766a7bc
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033527epcas2p384eefb77dff85f5d8d59beede98b6bdc
References: <20210722033439.26550-8-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033527epcas2p384eefb77dff85f5d8d59beede98b6bdc@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>Instead of documenting the locking requirements of the UIC code as comments,
>use lockdep_assert_held() such that lockdep verifies the lockdep
>requirements at runtime if lockdep is enabled.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
