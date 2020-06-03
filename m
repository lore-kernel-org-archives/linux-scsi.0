Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D413C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BDA7206E9
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 02:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OBqT39h6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgFCCcG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 22:32:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgFCCcG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 22:32:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532Rlek188123;
        Wed, 3 Jun 2020 02:31:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=zzVHRLOiQYXnYFpDFmw0PZpsKu82bGLV3htgEoTFfZg=;
 b=OBqT39h6c9yfr0rXQsvTEvI+Hegp4MputnxHqQ+as6oadEciK+Yyz1ugGd98JvAeYYK8
 xyLDx+1cUyGm7RGfq23qrAdUdzuw6hcOz+MzNS5quTVVwBtAhx8rHqlF5ddVs0G7i3Ql
 u+zE/pgtQnm7q9ZzPNQiE3SQ5PzWO00ttrUt3Q/ZvwlV4Infbn0XHLcZ0iMF87j1liN4
 KgS8q/vs40ev/mQqpFA3PAf9PAy561LU1UU8O1KUS0ISb1QKa0lXNSNwBF8nDsuXWC9R
 FDpMaRiO+xfcas8FikwXFWwKtaSSfxl9lqee84YDsZNugYt06V1vW9DZ1AjmPOI0wHDu Tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31bfem6s9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 02:31:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0532TPrb164237;
        Wed, 3 Jun 2020 02:31:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31c12q5d4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 02:31:56 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0532Vnnm015051;
        Wed, 3 Jun 2020 02:31:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 19:31:49 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     kjlu@umn.edu, "wu000273@umn.edu" <wu000273@umn.edu>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Fix reference count leak in iscsi_boot_create_kobj.
Date:   Tue,  2 Jun 2020 22:31:38 -0400
Message-Id: <159114947917.26776.6215710664403797046.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528201353.14849-1-wu000273@umn.edu>
References: <20200528201353.14849-1-wu000273@umn.edu>
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

On Thu, 28 May 2020 15:13:53 -0500, wu000273@umn.edu wrote:

> kobject_init_and_add() should be handled when it return an error,
> because kobject_init_and_add() takes reference even when it fails.
> If this function returns an error, kobject_put() must be called to
> properly clean up the memory associated with the object. Previous
> commit "b8eb718348b8" fixed a similar problem. Thus replace calling
> kfree() by calling kobject_put().

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: iscsi: Fix reference count leak in iscsi_boot_create_kobj
      https://git.kernel.org/mkp/scsi/c/0267ffce562c

-- 
Martin K. Petersen	Oracle Linux Engineering
