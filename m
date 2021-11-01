Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A06C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 07:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F64560F46
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 07:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhKAHrl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 03:47:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15816 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhKAHrj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 03:47:39 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211101074501epoutp01424e49ccf6edc970a42d0477920a8ee2~zXGp2baJv1371613716epoutp01r
        for <linux-scsi@vger.kernel.org>; Mon,  1 Nov 2021 07:45:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211101074501epoutp01424e49ccf6edc970a42d0477920a8ee2~zXGp2baJv1371613716epoutp01r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635752702;
        bh=C2vRlVeW74o4dsN9nH8xz3Cp8TBOqVAWGXZh6qi3tzQ=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=OPCgxhZZZF4NEuzrzmaI3eqZsVXTjcPHKMOmrFCnkER0NMZl/TxI7w7kumq75pmCG
         cN9O3ShZFs7N5dXDv5WzQVdA3f21pfcEKuy4gUJfGQ1gEsEh6RR3tSHPemSlBn0F9E
         HNEKYv8nIGDmKM/6d4mshJyvkXf6W6Zj+ODpPdj0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20211101074501epcas3p2f9c3679bc19571f9d4a801b828df11ef~zXGpahMV_1938919389epcas3p2b;
        Mon,  1 Nov 2021 07:45:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4HjQ6j3NByz4x9QL; Mon,  1 Nov 2021 07:45:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH] scsi: ufshpb: Properly handle max-single-cmd
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
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20211031123654.17719-1-avri.altman@wdc.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01635752701431.JavaMail.epsvc@epcpadp3>
Date:   Mon, 01 Nov 2021 16:22:58 +0900
X-CMS-MailID: 20211101072258epcms2p77234fb52a6fb6e756d15a61e235fada2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20211031123708epcas2p16645db36a077acf3bd6c0138e50fedc8
References: <20211031123654.17719-1-avri.altman@wdc.com>
        <CGME20211031123708epcas2p16645db36a077acf3bd6c0138e50fedc8@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> The spec recommends that for transfer length larger than the
> max-single-cmd attribute (bMAX_ DATA_SIZE_FOR_HPB_SINGLE_CMD) it is
> possible to couple pre-reqs with the HPB-READ command.  Being a
> recommendation, using pre-reqs can be perceived merely as a mean of
> optimization.  A common practice was to send pre-reqs for chunks within
> some interval, and leave the READ10 untouched if larger.
>  
> Anyway, now that the pre-reqs flows have been opt-out, all the commands
> are single commands.  So properly handle this attribute and do not send
> HPB-READ for transfer lengths larger than max-single-cmd.
>  
> Fixes: 09d9e4d04187 (scsi: ufs: ufshpb: Remove HPB2.0 flows)
>  
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 29 +++++++++++++++--------------
>  drivers/scsi/ufs/ufshpb.h |  1 -
>  2 files changed, 15 insertions(+), 15 deletions(-)

Reviewed-by: Daejun Park <daejun7.park@samsung.com>
