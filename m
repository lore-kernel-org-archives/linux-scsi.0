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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CA8C56201
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 04:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8013B2085B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 04:00:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yCNohhaN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgKXEAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 23:00:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgKXEAR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 23:00:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3sUKr153270;
        Tue, 24 Nov 2020 04:00:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wai7PN+m9rpCxiSYaXn6Er4f3zaHuPQsdQ+NcGDALKE=;
 b=yCNohhaNM5xJmfxwuOwULRE5WwELqowLwkb0Se+IQj+SxZHuYwCJG0yP532j7CcmjPlp
 qdM58d4xzx7CZscnXhQhh4fuC230p3s+GTxCJDBXQ2KuiUNMxIJzyrWlZjBnvmHBTmgz
 vULNGZKlspmbSFXeiSxINnPMJbuK3dKcwokgMzURNWZjKc+3NXASxCVv0ucjX3rzxPOA
 H69s/Zh53SRdFlJ16PjqWHUl/6efo9h4T9Q6kQhGJLnac/6pXUzZcN8gkvWHpyxpfJW/
 LEyfNNm3b/r5t9v8OolbHb+G4D9qG7+XCBBfK5nIDmriFGuP+va+76iJEbH7+D3eznpn Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34xtum0e86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 04:00:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3tdij066535;
        Tue, 24 Nov 2020 03:58:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34yx8ja376-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:58:12 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO3wAES028290;
        Tue, 24 Nov 2020 03:58:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:58:10 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: lpfc: Fix memory leak on lcb_context
Date:   Mon, 23 Nov 2020 22:57:59 -0500
Message-Id: <160618683552.24173.1098115721701350297.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118141314.462471-1-colin.king@canonical.com>
References: <20201118141314.462471-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 18 Nov 2020 14:13:14 +0000, Colin King wrote:

> Currently there is an error return path that neglects to free the
> allocation for lcb_context.  Fix this by adding a new error free
> exit path that kfree's lcb_context before returning.  Use this new
> kfree exit path in another exit error path that also kfree's the same
> object, allowing a line of code to be removed.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix memory leak on lcb_context
      https://git.kernel.org/mkp/scsi/c/14c1dd950411

-- 
Martin K. Petersen	Oracle Linux Engineering
