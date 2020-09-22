Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAC1C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B4723A34
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AamEdkB5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgIVD5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48718 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgIVD5t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3n9Pu077357;
        Tue, 22 Sep 2020 03:57:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=RepHb6veFr2raelR7pvQEkD+f3BJJVONKcPrS0KZWpA=;
 b=AamEdkB5j8i7IqWXUDKeoKeHWCy41RwbyFOJptTdE7nM5L8RD+tajO8rJBzatcsvAz0y
 kiBz5DsXfaoD7QVRa/GZVbAgOkfIgYBYmL7zAYp1EzENwgoHTCOheY1gMvXfVHee7tie
 jPAQ4rcSPXA3tPU71kVfaoRFEKlCiRlIjiA0G+dHcgeIkTlmxnTYe2ce25/ivJBeVuTI
 eg4IjvcGwzBDHbz870oAwfPI4bZxqF+bEDyJjejP7MMmCsb7ZnFpstPHHG5AwrbHR+RB
 C5ob+ADjYmJXznd4f2pnCCvkaRPOOn23DNFnvax+3N6MQosyZj5XkeuMhpVmnaQCIXCU 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33q5rg8t80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3u2ei017790;
        Tue, 22 Sep 2020 03:57:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33nuw2pkjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:39 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vc3q032743;
        Tue, 22 Sep 2020 03:57:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:38 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        hmadhani@marvell.com, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: qla2xxx: remove unneeded variable 'rval'
Date:   Mon, 21 Sep 2020 23:57:05 -0400
Message-Id: <160074695007.411.7560960223283458998.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911091021.2937708-1-yanaijie@huawei.com>
References: <20200911091021.2937708-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 11 Sep 2020 17:10:21 +0800, Jason Yan wrote:

> This addresses the following coccinelle warning:
> 
> drivers/scsi/qla2xxx/qla_init.c:7112:5-9: Unneeded variable: "rval".
> Return "QLA_SUCCESS" on line 7115

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Remove unneeded variable 'rval'
      https://git.kernel.org/mkp/scsi/c/34eb5ccf35da

-- 
Martin K. Petersen	Oracle Linux Engineering
