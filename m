Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC76C4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D8620B1F
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C6DCMtyR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgJGDsp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36368 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgJGDsa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973i2Rh044838;
        Wed, 7 Oct 2020 03:48:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=uaPS7rQkw/qxlSO0nZEyhtX30Ykq97d2sf26PJGm6q8=;
 b=C6DCMtyRZDo0ATi4HVogMXQnV8LutyOHI7HW5pVBeG9sy8KuBpNzc+M6jQayl4nghG20
 Tz1X0AweZrdHQWLffsGvL2fQoM4dkNcboIGdbAK08LFLtBtPM+qr8y+7UF54uLLuSp2y
 sEP59Qzu/IKOW0DXqqPOGvNvW9T2VF63AqooobXJGIodlAayL8aWqivB3KWtiGv8Nvqu
 KvwxCdG50bzGsuNF6ZUC8xfJxjviI6hHiXqw18jdzuGs/JcjRk6KCLnHrE+5XKoh4OfL
 7Sij9yMhJG3KoeDU3WxcM9ATomorTEaTeKWr3ft2gRbDv2xnFhRX59hm7RFC1e+aeyxr IQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33ym34mjyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973ip99194632;
        Wed, 7 Oct 2020 03:48:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3410jy2s76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:25 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0973mPTg002158;
        Wed, 7 Oct 2020 03:48:25 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:24 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        aacraid@microsemi.com, Dave.Carroll@microchip.com,
        Mahesh.Rajashekhara@microchip.com, Balsundar.P@microchip.com,
        Sagar.Biradar@microchip.com
Subject: Re: [PATCH] aacraid: add a missing iounmap call
Date:   Tue,  6 Oct 2020 23:48:02 -0400
Message-Id: <160204240578.16940.13153614318633367713.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200926150015.6187-1-thenzl@redhat.com>
References: <20200926150015.6187-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=811 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=843 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 26 Sep 2020 17:00:15 +0200, Tomas Henzl wrote:

> Add a missing resource cleanup in _aac_reset_adapter

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: aacraid: Add a missing iounmap call
      https://git.kernel.org/mkp/scsi/c/66ab2fa37216

-- 
Martin K. Petersen	Oracle Linux Engineering
