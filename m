Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C41DC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 04:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63F5A610A5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 04:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhJ0EDS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 00:03:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61102 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229885AbhJ0EDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 00:03:10 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R0n0C0015474;
        Wed, 27 Oct 2021 04:00:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=+4BgIZY4lR/vnCmrk0RUztBT8gXJqQuyjlRcNq3Iq/A=;
 b=ZKY4weGxKtTxJlztsUYMbvHGn5ahrKFmfYe5beyTkWs9G2Z6EXk8krTslC0xihftzaBW
 uu06Yfw8TJVu7ntgFnu9EgqAqFRy/r8dwN7cMheD34M1TK3/5pCnfobv2uzDWOEhcLSz
 wtz+xjOuj9J+zIbhRHRAakjseLsX/JmWTVxx+FJuqpwV2tCgoHb+nQvXGW84kqNAShQ9
 Bbcqu4UZY7A0vka2XMHwuFEyvkgVZ04jvho40z50Blv/A/ii5y6KEWWJzNysK17PdCiP
 Hc7wmYDOfF3DY7bSvUICVg+0RojewKQ5of6LRGIBvrET1CIgwQUnqenBqQel9CkrD//J kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fj0tb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 04:00:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19R400wR068907;
        Wed, 27 Oct 2021 04:00:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3bx4gqcn9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 04:00:25 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19R40O5C070915;
        Wed, 27 Oct 2021 04:00:24 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3bx4gqcn88-1;
        Wed, 27 Oct 2021 04:00:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] scsi: ufs: mediatek: avoid sched_clock() misuse
Date:   Wed, 27 Oct 2021 00:00:19 -0400
Message-Id: <163530706457.10775.2217918948361073974.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018132022.2281589-1-arnd@kernel.org>
References: <20211018132022.2281589-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: IxSGowgx6TWOB-i5UsoImQPLxaD-JNJd
X-Proofpoint-GUID: IxSGowgx6TWOB-i5UsoImQPLxaD-JNJd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Oct 2021 15:20:01 +0200, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> sched_clock() is not meant to be used in portable driver code,
> and assuming a particular clock frequency is not how this is
> meant to be used. It also causes a build failure because of
> a missing header inclusion:
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: ufs: mediatek: avoid sched_clock() misuse
      https://git.kernel.org/mkp/scsi/c/bb4a8dcb4e94

-- 
Martin K. Petersen	Oracle Linux Engineering
