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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E265AC63777
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81E012085B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vP41p4Js"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgKXD6U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:58:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50500 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727869AbgKXD6T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:58:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3saNm090548;
        Tue, 24 Nov 2020 03:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/ZLENeEnN2+0E1PCxRwxG5g88lZ4hV6KzJ9wcqHyiEc=;
 b=vP41p4Js/JD286n9Nno0u5Zwaih/AJYPAC0oHTzgAw/oNlzK0NxJyT9kI8nWNavYk2zC
 ccz9jTBeXGtjAe6VWPd0Mz9ftzUsRPyuiw1c1Cy3DVOS1Nokb9RX+JU6nGze6zV1fGF+
 61hQ5ujUM9I9jY6yiCOrtJBYJmFvk61Ifxw/x96s9S50ExiLUiHR61asmy327i+T3it3
 c3I2mT3ooIkUGdHv5v9TmQbN3eAhmuJ+l2e6bp7Tb1PXhollUAXy0OdmzFgiTyNXnA8T
 iESzu25K2QkoCgCxWs6xzUUYrT7xGYbNo5h9WPlb10cuUx4dM6Fl7SOKsBwCpyRkIXvR bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34xrdarmbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:58:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3twOf140274;
        Tue, 24 Nov 2020 03:58:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34ycfmr826-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:58:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AO3wDtM006109;
        Tue, 24 Nov 2020 03:58:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:58:12 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][next] scsi: lpfc: remove dead code on second !ndlp check
Date:   Mon, 23 Nov 2020 22:58:01 -0500
Message-Id: <160618683552.24173.9532956225953675883.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118133744.461385-1-colin.king@canonical.com>
References: <20201118133744.461385-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 18 Nov 2020 13:37:44 +0000, Colin King wrote:

> Currently there is a null check on the pointer ndlp that exits via
> error path issue_ct_rsp_exit followed by another null check on the
> same pointer that is almost identical to the previous null check
> stanza and yet can never can be reached because the previous check
> exited via issue_ct_rsp_exit. This is deadcode and can be removed.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: lpfc: Remove dead code on second !ndlp check
      https://git.kernel.org/mkp/scsi/c/61795a5316ad

-- 
Martin K. Petersen	Oracle Linux Engineering
