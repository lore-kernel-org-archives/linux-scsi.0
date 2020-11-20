Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7CCC5519F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C36122249
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 03:19:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zs4kb1Aj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgKTDTU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 22:19:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38702 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgKTDTU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 22:19:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK3AgTr044992;
        Fri, 20 Nov 2020 03:19:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=kzhRRpx5yRu6Z9t5GD0RCUXCFpjzDl5U8XfrLeTFP+g=;
 b=Zs4kb1AjNGaftfwGu0N6OezyO8gydHwP+aN/vltVazFoFRMTOZwidSohYh+Ifmws0mmv
 sx/rVR3aNGNpF4ULmchHvpcxXiY3SckP8ZeZFPUTL6av8UqzwD8Q+mJEhI87LdHEYksj
 iQYxXxNnbctLL0mg1KgS2uWw0HzniUAScX5Z/RMnehJU+ImNDSZ5he324Ts/0cB0GkRt
 Z4V1Zvh6cyGhIhy2zWi+qvm5Xn4oqVuqKdAffuJrpJnkhgFN2PdtNVMAWyGTZciwJVQ4
 keVHR08r3HIBBWFblv/VBNmjjJ3vu3kHl6r2lgeAQX09DftQQ2Vyivrvx5pZvqYyNMoY Tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4rb8t9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 03:19:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK35ijx166517;
        Fri, 20 Nov 2020 03:17:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34uspx23u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 03:17:15 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AK3HErV019707;
        Fri, 20 Nov 2020 03:17:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 19:17:14 -0800
To:     Colin King <colin.king@canonical.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: lpfc: remove dead code on second !ndlp check
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tutkwwcx.fsf@ca-mkp.ca.oracle.com>
References: <20201118133744.461385-1-colin.king@canonical.com>
Date:   Thu, 19 Nov 2020 22:17:12 -0500
In-Reply-To: <20201118133744.461385-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 18 Nov 2020 13:37:44 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> Currently there is a null check on the pointer ndlp that exits via
> error path issue_ct_rsp_exit followed by another null check on the
> same pointer that is almost identical to the previous null check
> stanza and yet can never can be reached because the previous check
> exited via issue_ct_rsp_exit. This is deadcode and can be removed.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
