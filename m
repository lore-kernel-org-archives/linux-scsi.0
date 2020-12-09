Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA19CC4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CBF223B51
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730848AbgLIR1D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:27:03 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36896 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732360AbgLIR05 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:26:57 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HPOre064148;
        Wed, 9 Dec 2020 17:26:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PnwL1t36QAzy4Z0CyQFFNGR0pO0nbAzqjsSAVUWwyM0=;
 b=gYMKZgrYBXaNaZFAGzgD5UjpVS4Xyn/2mVrLsw/wo6/T/+yJa1AayJtAV2PqHFcw2S9J
 hKPQXRvGJtdwzCyt39qlxrejQJ/2bnpgoJhJm+J/YLo+czZPkmj+OxBLkcJAoKZNjFKO
 /vI+ycS8UsTIz/++y0h61NX3vZyTgvMMsgf/FgqRYfYUEWJHcozcrobcE75EkWKzTP73
 PrHTz91KeCheOd86MVSqNvDFi3bwK78WyVCQCLcTuNfwMgFBRG3kBqnAMNaCP+5+/qrF
 wLwujtYmNE7b7Zds1vxm4m7mrUQZbGdFqpAB2COTjdL2Qw9cTQZNMAcTiamI5PB2SU3Q aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 357yqc1fyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:26:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HKjg8142428;
        Wed, 9 Dec 2020 17:24:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 358kyv0h7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:24:02 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9HO0Ib014388;
        Wed, 9 Dec 2020 17:24:00 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:24:00 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Stanley Chu <stanley.chu@mediatek.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jiajie.hao@mediatek.com, beanhuo@micron.com,
        chun-hung.wu@mediatek.com, cc.chou@mediatek.com,
        asutoshd@codeaurora.org, chaotian.jing@mediatek.com,
        matthias.bgg@gmail.com, kuohong.wang@mediatek.com,
        alice.chao@mediatek.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, andy.teng@mediatek.com,
        bvanassche@acm.org, cang@codeaurora.org,
        linux-mediatek@lists.infradead.org, peter.wang@mediatek.com
Subject: Re: [PATCH v3] scsi: ufs: Remove pre-defined initial voltage values of device powers
Date:   Wed,  9 Dec 2020 12:23:22 -0500
Message-Id: <160753457754.14816.2412706138431491646.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202091819.22363-1-stanley.chu@mediatek.com>
References: <20201202091819.22363-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090123
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Dec 2020 17:18:19 +0800, Stanley Chu wrote:

> UFS specficication allows different VCC configurations for UFS devices,
> for example,
> 	(1). 2.70V - 3.60V (Activated by default in UFS core driver)
> 	(2). 1.70V - 1.95V (Activated if "vcc-supply-1p8" is declared in
>                           device tree)
> 	(3). 2.40V - 2.70V (Supported since UFS 3.x)
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: ufs: Remove pre-defined initial voltage values of device powers
      https://git.kernel.org/mkp/scsi/c/5b44a07b6bb2

-- 
Martin K. Petersen	Oracle Linux Engineering
