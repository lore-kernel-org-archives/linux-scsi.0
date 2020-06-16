Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C717AC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A432D20739
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 04:00:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nPdg4EU7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgFPEAb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 00:00:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50812 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgFPEAa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 00:00:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3upAV054158;
        Tue, 16 Jun 2020 04:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=6gt66nmNkN8e5xAv4On8mJpvQuFVMs7mSPf10c7iWbI=;
 b=nPdg4EU7JQvgPCbaC5hwzhb/sju3oUhOfTmJ4Lj1CrR9EExJU2mhU0UG3QlBhbj9EuQp
 gLePJyZ4y+AfQq+Luk+GTqxAwyR85a2M4Ojxus4dm0/Oor6eRhTnPSkOngB/mNHDEf8K
 ARaZ0yoszniFfLG/9xprTB8z9zlr3vWxUwNySnob7vjQIAvlJt/lUwo16c2w6sQxXITF
 WfJp81aWa7JdPlqR275UDSO39ltrsyH/1oY3JqI/JsJByjbYuqWHjVMmKaFAtCUSUARc
 u0+k+9B8TLTrEOckkjNNJShc592wX3dtPPgl0Uy84ASOHikrWMBoJbhHB1mL5pgdRRdK ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31p6e7vdky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 04:00:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05G3xQB5131356;
        Tue, 16 Jun 2020 04:00:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31p6dcae0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 04:00:15 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05G40DVJ021424;
        Tue, 16 Jun 2020 04:00:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jun 2020 21:00:13 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        avri.altman@wdc.com, Stanley Chu <stanley.chu@mediatek.com>,
        asutoshd@codeaurora.org, alim.akhtar@samsung.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        peter.wang@mediatek.com, beanhuo@micron.com,
        matthias.bgg@gmail.com, chaotian.jing@mediatek.com,
        bvanassche@acm.org, linux-arm-kernel@lists.infradead.org,
        kuohong.wang@mediatek.com, linux-kernel@vger.kernel.org,
        andy.teng@mediatek.com, cang@codeaurora.org, cc.chou@mediatek.com,
        chun-hung.wu@mediatek.com, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 0/2] scsi: ufs: Fix and cleanup device quirks
Date:   Mon, 15 Jun 2020 23:59:56 -0400
Message-Id: <159227986422.24883.11135974078256491088.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200612012625.6615-1-stanley.chu@mediatek.com>
References: <20200612012625.6615-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9653 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 cotscore=-2147483648 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 12 Jun 2020 09:26:23 +0800, Stanley Chu wrote:

> this series provides some device quirk fixes and cleanups.
> 
> v1 -> v2:
>   - Sort device quirks in alphabetical order (Alim Akhtar)
> 
> Stanley Chu (2):
>   scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices
>   scsi: ufs: Cleanup device vendor name and device quirk table
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices
      https://git.kernel.org/mkp/scsi/c/c0a18ee0ce78
[2/2] scsi: ufs: Clean up device vendor name and device quirk table
      https://git.kernel.org/mkp/scsi/c/ed0b40ffa364

-- 
Martin K. Petersen	Oracle Linux Engineering
