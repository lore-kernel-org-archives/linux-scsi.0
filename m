Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7504C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6EE020768
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D5W4ihra"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgG2ELK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 00:11:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgG2ELK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 00:11:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T43OLU179316;
        Wed, 29 Jul 2020 04:10:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=id7C7n+jUhumjsERzSUGa3dPkmeF+wO+aUQY58h5H8Y=;
 b=D5W4ihraf+rBnrDLBhlAu+ByO6bjk0IfKP3Y9SIuIcIMR1qlTJKBCgOseDKzzxkBYT0L
 L7hpGpo4j8DNqH6kuvTyophnUM+5juQ3U7gyx4K57Hg1h/gm5p8yYkmR7DFlOEXmpXXN
 8ZyoLJQaGS9o6p3ToNvXcj4OeXluzao2p09+9Vbi63lYpNhuFEMBIVjo6DF81rPh4s0Y
 hfDJJTgIEB0v4QEMGRWamdR32y0h1M55wpQa1rboqED2p9G8nLdaRyLMslLNRAoWAu0R
 zQMh4zS4ZIgH3oubYm873NiwYbopVAY0xNvOAcVUoa7CWGRrJtWVCwCnhOS6iHn+4/ty 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32hu1jk62m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 04:10:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T42aoQ023694;
        Wed, 29 Jul 2020 04:10:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32hu5u1pxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 04:10:51 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06T4AmQZ030771;
        Wed, 29 Jul 2020 04:10:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 21:10:48 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Stanley Chu <stanley.chu@mediatek.com>, alim.akhtar@samsung.com,
        linux-scsi@vger.kernel.org, bvanassche@acm.org,
        avri.altman@wdc.com, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org,
        asutoshd@codeaurora.org, chaotian.jing@mediatek.com,
        linux-kernel@vger.kernel.org, chun-hung.wu@mediatek.com,
        cc.chou@mediatek.com, kuohong.wang@mediatek.com,
        andy.teng@mediatek.com, peter.wang@mediatek.com,
        linux-mediatek@lists.infradead.org, beanhuo@micron.com,
        cang@codeaurora.org
Subject: Re: [PATCH v1] scsi: ufs-mediatek: Prevent LPM operation on undeclared VCC
Date:   Wed, 29 Jul 2020 00:10:39 -0400
Message-Id: <159599579269.11289.6290519953354146093.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724141627.20094-1-stanley.chu@mediatek.com>
References: <20200724141627.20094-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=940 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=951
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 24 Jul 2020 22:16:27 +0800, Stanley Chu wrote:

> In some platforms, VCC regulator may not be declared in device tree
> to keep itself "always-on". In this case, hba->vreg_info.vcc is NULL
> and shall not be operated during any flow.
> 
> Prevent possible NULL hba->vreg_info.vcc access in LPM mode by checking
> if it is valid first.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: ufs-mediatek: Prevent LPM operation on undeclared VCC
      https://git.kernel.org/mkp/scsi/c/0255b1e3d849

-- 
Martin K. Petersen	Oracle Linux Engineering
