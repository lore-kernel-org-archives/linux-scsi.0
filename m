Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87802C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 08:04:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 662742064C
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 08:04:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="reS72Ix1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgGOIEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 04:04:30 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37148 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729001AbgGOIEa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Jul 2020 04:04:30 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06F80OOv012822;
        Wed, 15 Jul 2020 01:04:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=nQO1sTy3EPPXhJpw/eO51rOXi+oyZ2SGhKZFS5KYe3k=;
 b=reS72Ix1DtwEhFFEHyagsEye8Ser3G9QFPhuWRbRsNPfdfoZXCr4y+5TG69i2qSaFf19
 xa4VNlvyPpC6aRfkqyKvjYna2QjcL4KNvHCV/iAVpfmKnNK0TTCeQAHkhwYDzT/bglDu
 WKVS53V7zkay6WFQ1hjsAkQoIK8UmOln7lskLqiNSl/KAL7Mhl8oEwC8CK1Pp7YyFI9x
 oXKFvStaYLu/U1Lxwtp+3oDSHEoipB9quRNmfPGSqlLSn0vO3RFyxoSHYy8SEaRgld9O
 f/xCWYShWASp/dIK0ekvWzXWBY04omYxca4gWuZGbSHao9hgWdmoJYTSfUCdmZuMjCRh Ug== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 328mmhsry6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 15 Jul 2020 01:04:26 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 01:04:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 15 Jul 2020 01:04:25 -0700
Received: from [10.193.54.28] (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id F027E3F703F;
        Wed, 15 Jul 2020 01:04:22 -0700 (PDT)
Subject: Re: [EXT] [PATCH net] qed: Disable "MFW indication via attention"
 SPAM every 5 minutes
To:     Laurence Oberman <loberman@redhat.com>,
        <linux-scsi@vger.kernel.org>, <QLogic-Storage-Upstream@cavium.com>,
        <netdev@vger.kernel.org>, Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
References: <1594764485-682-1-git-send-email-loberman@redhat.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <b6bc0689-368a-dbcf-00c1-9471330aa555@marvell.com>
Date:   Wed, 15 Jul 2020 11:04:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <1594764485-682-1-git-send-email-loberman@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_05:2020-07-15,2020-07-15 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> ----------------------------------------------------------------------
> This is likely firmware causing this but its starting to annoy customers.
> Change the message level to verbose to prevent the spam.
> Note that this seems to only show up with ISCSI enabled on the HBA via the
> 
> qedi driver.
> 
> Signed-off-by: Laurence Oberman <loberman@redhat.com>

Thanks for handling this, Laurence, we actually had the same fix in out of
tree driver recently, just missed upstreaming it.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
