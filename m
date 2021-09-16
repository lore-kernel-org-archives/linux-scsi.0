Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D238CC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 02:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8069611CE
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 02:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbhIPCe0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 22:34:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59760 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbhIPCeZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 22:34:25 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210916023304epoutp041abe8f75fc5a02613a2a7763f39e5c17~lLLJIYblv0827008270epoutp04h
        for <linux-scsi@vger.kernel.org>; Thu, 16 Sep 2021 02:33:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210916023304epoutp041abe8f75fc5a02613a2a7763f39e5c17~lLLJIYblv0827008270epoutp04h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631759584;
        bh=jCN5a4cEt/+80CdNBFg0IKWnkC6hHe+XrSi7ZI8RTDw=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=jc60G35jsA/3AHOls/bTNbNL9roBWRI//ChjuBOEJVvTzzCvxz7MkOWbsLCFU40Qe
         D45veEIHDGjba9W6nn2jOMrK0tVDrnShBJKdiIphoUS0hhn2buy23GLUMFlWnC2NGR
         VQVvNRl1HFGU/bRaSRq8xltErhVLhC9ULr57AOIY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210916023303epcas3p175841196653ecc38e2727269387273af~lLLImkK443077630776epcas3p1g;
        Thu, 16 Sep 2021 02:33:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4H91Mz4Pccz4x9Q2; Thu, 16 Sep 2021 02:33:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v7 2/2] scsi: ufs: Add temperature notification
 exception handling
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
In-Reply-To: <20210915060407.40-3-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <513700442.21631759583614.JavaMail.epsvc@epcpadp4>
Date:   Thu, 16 Sep 2021 11:31:25 +0900
X-CMS-MailID: 20210916023125epcms2p3066f4ba490e7677c63c7f8f4c11ce6cc
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210915060436epcas2p326d8663ed23430529a5b4f9407eca8c9
References: <20210915060407.40-3-avri.altman@wdc.com>
        <20210915060407.40-1-avri.altman@wdc.com>
        <CGME20210915060436epcas2p326d8663ed23430529a5b4f9407eca8c9@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

>The device may notify the host of an extreme temperature by using the
>exception event mechanism. The exception can be raised when the device=E2=
=80=99s
>Tcase temperature is either too high or too low.
>=20
>It is essentially up to the platform to decide what further actions need
>to be taken. leave a placeholder for a designated vop for that.
>=20
>Signed-off-by: Avri Altman <avri.altman@wdc.com>

Reviewed-by: Daejun Park <daejun7.park@samsung.com>
