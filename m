Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065D8C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA7CB206E9
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:32:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kcVvjWPA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgFCCc1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 22:32:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59266 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgFCCc1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 22:32:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532QVmr187569;
        Wed, 3 Jun 2020 02:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=cJZJ6Aemad1d2VN1fwzQIoXZHDszWIODTXRnH8VAsQo=;
 b=kcVvjWPAJ4lmtKEbJXD+WlDXIVCFMMHnjWMAO6LbG0h+AsBi+iHosXwow+Ac7fWNgRtH
 LGIDm/tsI3QaGrU+s1pTAZ5BS52SdYDAKtefH2iULK7Y6p/fRRLlhN3KVXiPutLHHbJB
 NxYz37iXvjvQM3qQj90k86lHeKRjQfzdxhm5Zk60uoYZDAFPmoeqpImzq7yXEVarbRI3
 k5/fm4mDP5Am47EXUpBwRh6djaRHjPyf4VxodjkqRbFHOUzQj4sPScyDR+iiPXHFHcWm
 x6L25QNWabEyMA7weqqS/gbiehUR3nyK0F1QBy8wE1sel0BCHaLG3eucBAIXcUylBjUv 0Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31bfem6s9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 02:31:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532TQZP164353;
        Wed, 3 Jun 2020 02:31:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31c12q5cuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 02:31:50 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0532Vlbq032618;
        Wed, 3 Jun 2020 02:31:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 19:31:46 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        Stanley Chu <stanley.chu@mediatek.com>,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        chun-hung.wu@mediatek.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, beanhuo@micron.com,
        kuohong.wang@mediatek.com, bvanassche@acm.org,
        linux-arm-kernel@lists.infradead.org, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        cang@codeaurora.org, linux-mediatek@lists.infradead.org,
        peter.wang@mediatek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Remove redundant urgent_bkop_lvl initialization
Date:   Tue,  2 Jun 2020 22:31:36 -0400
Message-Id: <159114947917.26776.10217919465331125285.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530141200.4616-1-stanley.chu@mediatek.com>
References: <20200530141200.4616-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1011
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 30 May 2020 22:12:00 +0800, Stanley Chu wrote:

> In ufshcd_probe_hba(), all BKOP SW tracking variables can be reset
> together in ufshcd_force_reset_auto_bkops(), thus urgent_bkop_lvl
> initialization in the beginning of ufshcd_probe_hba() can be merged
> into ufshcd_force_reset_auto_bkops().

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: ufs: Remove redundant urgent_bkop_lvl initialization
      https://git.kernel.org/mkp/scsi/c/7b6668d8b806

-- 
Martin K. Petersen	Oracle Linux Engineering
