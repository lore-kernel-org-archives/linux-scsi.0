Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9D0C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 21:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiDMWAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Apr 2022 18:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbiDMWAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2022 18:00:34 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB871DA51
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 14:58:09 -0700 (PDT)
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220413215802epoutp0364aad78c03dea5bf27ff01a23ea778a8~lk49bSWmN3234432344epoutp03j
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 21:58:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220413215802epoutp0364aad78c03dea5bf27ff01a23ea778a8~lk49bSWmN3234432344epoutp03j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1649887082;
        bh=TVjtkp//1USqWfRLTx7nmSZ5eT3ctN7CpfIO5RSOBkM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=LDPmiVktPFWpQUPMtzEznmHRLIpah4g87k7X3eddnpBbrR8RStkAW7kzrSaMWrTrc
         Z0ROjTzUmc83HMaNk5y17Wv1W7S0uTAGimTPHpo0+T5LV7OjErv4Nay53xD0m8BYbl
         JAx7NF+Wic4fro2WBKTyXtuQfjTRIoTdms1kkHw4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20220413215801epcas3p36ee852cf1a363837e1dde6f15fa80ed4~lk484V4Rv1438314383epcas3p3x;
        Wed, 13 Apr 2022 21:58:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4KdxKj5gFcz4x9Pr; Wed, 13 Apr 2022 21:58:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v2 04/29] scsi: ufs: Simplify statements that return a
 boolean
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <e946d403-8bf9-5c88-d502-353faf50c6b7@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01649887081779.JavaMail.epsvc@epcpadp4>
Date:   Wed, 13 Apr 2022 14:18:48 +0900
X-CMS-MailID: 20220413051848epcms2p3e5c3a4dbbe74e76d11c14626048d72ae
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20220412181947epcas2p18ab1ae9013aeb1f261fb46cb60881263
References: <e946d403-8bf9-5c88-d502-353faf50c6b7@acm.org>
        <20220412181853.3715080-5-bvanassche@acm.org>
        <20220412181853.3715080-1-bvanassche@acm.org>
        <1889248251.21649817605815.JavaMail.epsvc@epcpadp3>
        <CGME20220412181947epcas2p18ab1ae9013aeb1f261fb46cb60881263@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On 4/12/22 19:33, Keoseong Park wrote:
>> Hi Bart,
>> 
>>> Convert "if (expr) return true; else return false;" into "return expr;"
>>> if either 'expr' is a boolean expression or the return type of the
>>> function is 'bool'.
>> 
>> How about adding ufshcd_is_pwr_mode_restore_needed()?
>
>Hi Keoseong,
>
>I'd like to keep that function as-is because it has three return 
>statements instead of two.
>
>Thanks,
>
>Bart.

I get it.

Reviewed-by: Keoseong Park <keosung.park@samsung.com>

Best Regards,
Keoseong Park

