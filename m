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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA2CDC4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2D7F23A5B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgLHE5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 23:57:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48286 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgLHE5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 23:57:17 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84sDrB137149;
        Tue, 8 Dec 2020 04:56:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=CoweoxuGlCgynmvnxd6flXk5XEw6m10Qkg2hjLlcmnE=;
 b=j5tzoSzoG+npDI5mZWbGSLarIrcYTqtRTS01tJAeLJR+B8tmaZofBo53Dd6m4amFuMsz
 eGeSFbN3ZA59P7MR3FnAxWzJuTgWRLPIDScyntkb9CLdo2YmYeMaAvKN6DPHlbv6AK1p
 RTC9+Rl41/bDn0Joo6Y0OuKokN3f9Z4xfNIInShxatuCcmR5snOzhSfKjiuZVA+CDUUK
 9ya9YrpK4zkdZpNwAuccXqAlH+rnBMYv690FelOq3c/fDePbez/OA9jaiOIeZMTObIo6
 ced9yUQ5rcYLQxoEjp/nWnR2HkzgrtqjZwFWpQ12V9L4vmk5wY5UcM+VDvJsMCP9VVBP Vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3581mqrrvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 04:56:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84ochp155403;
        Tue, 8 Dec 2020 04:56:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 358kys9q5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 04:56:04 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B84u3C7007563;
        Tue, 8 Dec 2020 04:56:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 20:56:02 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>,
        Long Li <longli@microsoft.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: core: fix race between handling STS_RESOURCE and completion
Date:   Mon,  7 Dec 2020 23:56:00 -0500
Message-Id: <160740334901.1739.17146806621392153901.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202100419.525144-1-ming.lei@redhat.com>
References: <20201202100419.525144-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Dec 2020 18:04:19 +0800, Ming Lei wrote:

> When queuing IO request to LLD, STS_RESOURCE may be returned because:
> 
> - host in recovery or blocked
> - target queue throttling or blocked
> - LLD rejection
> 
> Any one of the above doesn't happen frequently enough.
> 
> [...]

Applied to 5.10/scsi-fixes, thanks!

[1/1] scsi: core: fix race between handling STS_RESOURCE and completion
      https://git.kernel.org/mkp/scsi/c/673235f91531

-- 
Martin K. Petersen	Oracle Linux Engineering
