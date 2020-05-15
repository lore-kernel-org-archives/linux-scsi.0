Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15615C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 01:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6D3D206D8
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 01:11:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gU+howcS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgEOBK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 21:10:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37608 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgEOBK5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 21:10:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F13BTV130944;
        Fri, 15 May 2020 01:10:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=uzWUKK8WSe769UBEv6C+kY5NI1d1U8HUxPG8v/sJW80=;
 b=gU+howcSEUQ7AlT/CKnH5zts96yW/9T/6okbxANBpEgaYAy6lETJYL039gJGC+5szh6R
 1iRaFQfzYswZymyfLsB+gONFIPVEhPYCSNenayNga0lWsuOfSjx/WVMDnqQCNzWG8rym
 8ueWDwnsxoWGndqYheBAcuEQqXUQq144hw5LSXB5zNQVpyZZTTtR9bj/3rPz8VwEE0X4
 J4b69sV+R+rWji7GiPfaB5m5BEZHX+Hq8K/phzXi4+ITlA/HmbJDNy1R/BnJnresKZrp
 gkhRTgQdaVxjkvoSdsaqx37uIytL0pfFBxx8kkS7UQHpv9nEaidjhbEVrPBNk1f5JJ3F 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3100xwxp99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 01:10:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04F12kqR161267;
        Fri, 15 May 2020 01:10:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3100yqf3x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 01:10:35 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04F1AWJC017962;
        Fri, 15 May 2020 01:10:33 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 18:10:32 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, matthias.bgg@gmail.com,
        ChenTao <chentao107@huawei.com>, stanley.chu@mediatek.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: ufs-mediatek: Make ufs_mtk_fixup_dev_quirks static
Date:   Thu, 14 May 2020 21:10:26 -0400
Message-Id: <158950485295.8169.16456174061063737853.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514012655.127202-1-chentao107@huawei.com>
References: <20200514012655.127202-1-chentao107@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=941 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=970 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150007
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 14 May 2020 09:26:55 +0800, ChenTao wrote:

> Fix the following warning:
> 
> drivers/scsi/ufs/ufs-mediatek.c:585:6: warning:
> symbol 'ufs_mtk_fixup_dev_quirks' was not declared. Should it be static?

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: ufs-mediatek: Make ufs_mtk_fixup_dev_quirks static
      https://git.kernel.org/mkp/scsi/c/21d2b76831fd

-- 
Martin K. Petersen	Oracle Linux Engineering
