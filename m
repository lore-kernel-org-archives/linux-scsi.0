Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066E7C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA41323A61
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgLHE7D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 23:59:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33144 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgLHE7D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 23:59:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84tGiW067890;
        Tue, 8 Dec 2020 04:58:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AX0EbBAXwT94+urtCpFX1/8eXIvPah3QksJytH+HXaw=;
 b=dY5jD5NCaGmy7hb0AN8XtW/iqbJcydVA2UdZ4Lgcs+13Fv0WuKqucwC1bC7dKh1LZfP4
 NUhnuQVsjVT7s/k5nfzpIlsQQEDn11p/xBhQahYOjFYTt6mleQ1JxlonDhU+pXmqStYr
 3u+BCCuIl1EjdIblfiNBodkP5rk22R2XeA7O94QzHCRPln4Q2LecBh3zs0eJfEj18Hb/
 CQ2gx5va69uJ5lcudawTMqWiMVE+fX5HhKtcv+yzdQGevXiMh0ALYtD5LIiLOLzM1Y0j
 moMddsBh8zXUIQrpus17sWerBWJsW1hAkY8FMt2oceRxuhTqjjQAHdEjLBmkOyHk9p1w 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825m0t24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 08 Dec 2020 04:58:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B84oSLP160782;
        Tue, 8 Dec 2020 04:56:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 358m3x7kh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Dec 2020 04:56:03 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B84u1PP017394;
        Tue, 8 Dec 2020 04:56:01 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 20:56:01 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linuxarm@huawei.com, hare@suse.de, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: Re: [PATCH] scsi: hisi_sas: Select a suitable queue for internal IOs
Date:   Mon,  7 Dec 2020 23:55:59 -0500
Message-Id: <160740334901.1739.7752701168354918221.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1607347855-59091-1-git-send-email-john.garry@huawei.com>
References: <1607347855-59091-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9828 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012080030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 7 Dec 2020 21:30:55 +0800, John Garry wrote:

> For when managed interrupts are used (and shost->nr_hw_queues is set), a
> fixed queue - set per-device - is still used for internal IOs.
> 
> If all the CPUs mapped to that queue are offlined, then the completions
> for that queue are not serviced and any internal IOs will timeout.
> 
> Fix by selecting a queue for internal IOs from the queue mapped from
> the current CPU in this scenario.
> 
> [...]

Applied to 5.10/scsi-fixes, thanks!

[1/1] scsi: hisi_sas: Select a suitable queue for internal IOs
      https://git.kernel.org/mkp/scsi/c/359db63378ed

-- 
Martin K. Petersen	Oracle Linux Engineering
