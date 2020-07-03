Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F8EC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6063220724
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 04:05:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vxfM/NdZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgGCEFI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 00:05:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40138 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCEFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 00:05:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06342phs076008;
        Fri, 3 Jul 2020 04:05:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=WXC2XKuef+UGQ4utKiWeWQ7HRrRs6+/KMWdOoX23qxU=;
 b=vxfM/NdZpR6Kqv1N+Pjgrx/ukswQTc8sep/32pAgf0X6R/FjwgoiZ+X1RGBrc+c/uoIV
 EgEf+eTkdcQk9Eihtl71/QADftxegNaFQ/fJMIF9peTl6VNuriSQ8+3viMm0cfySztY/
 KCuSnPmEZYLyVkwuN2+6UadwDPl+s0t9n7s87J6IxK+qAnbjFk+lxlCRisQIgd7zMdPS
 VguvrpGxaO1vqipfN8/NpzabS1cK98oy2WuG94k22zniQlSuIZudgd+8FApRJSSVLsjz
 1T4T6SbvIV69PS6F8XMOrChwDPEd++qpZGk5+eUV6aB6ODz6huLqZKUK7+TrU3IJzvRL UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31xx1e8hpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 04:05:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0633whI4161859;
        Fri, 3 Jul 2020 04:03:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31xfvwnane-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 04:03:01 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 063430as001043;
        Fri, 3 Jul 2020 04:03:01 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 04:03:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bob Liu <bob.liu@oracle.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        lduncan@suse.com, michael.christie@oracle.com,
        open-iscsi@googlegroups.com
Subject: Re: [PATCH 1/2] scsi: iscsi: change back iscsi workqueue max_active argu to 1
Date:   Fri,  3 Jul 2020 00:02:57 -0400
Message-Id: <159374890395.14616.7502772614929277035.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701030745.16897-1-bob.liu@oracle.com>
References: <20200701030745.16897-1-bob.liu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 1 Jul 2020 11:07:44 +0800, Bob Liu wrote:

> Commit 3ce4196 (scsi: iscsi: Register sysfs for iscsi workqueue) enables
> 'cpumask' support for iscsi workqueues.
> 
> While there is a mistake in that commit, it's unnecessary to set
> max_active = 2 since 'cpumask' can be modified when max_active = 1.
> 
> This patch change back max_active to 1 so as to keep the same behaviour as
> before.

Applied to 5.8/scsi-fixes, thanks!

[1/2] scsi: iscsi: Change iSCSI workqueue max_active back to 1
      https://git.kernel.org/mkp/scsi/c/1a9826204109

-- 
Martin K. Petersen	Oracle Linux Engineering
