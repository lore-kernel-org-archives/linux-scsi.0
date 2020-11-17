Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B86C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B55B246A4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:30:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0gTUy7z9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgKQDa0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 22:30:26 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58912 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgKQDaZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 22:30:25 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3Njt5142948;
        Tue, 17 Nov 2020 03:30:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=qweyjsE70Kc/vnBe27sbtYCFutzRNvXC0sByxfHTK2o=;
 b=0gTUy7z9QBBxP80qP4H423iGy7j4rXv7tWVCnd+WautnTJfFVJSQyzg3LOY52g9D38Kh
 LcGpEJ8HiQw5UG3LrpZ5/wX/1FWUckVuKU2Ba2u43NWegN/wlJz4Dq/pxBXs9J4JYtlb
 D8cn0pFzhAiJElOxJEVwLpjSwwN6YiM0CbuUfVXSr23qfGGMit1EqlvWYb/aFap+QvJy
 U+JfnJEmr0QajNDA++2TsRwTlTwX5NwmVypyMdoh90TIqRPJfdujxu3rd8pI90xP+FnP
 Vl3Bs4cIqvfYRdcQkZ1TFHtYSuLtf3QwGZeHNSenFPL2u7ByFhhePek8PSjLIWxJEr0W AA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34t7vn0apg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 03:30:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3PEgb166686;
        Tue, 17 Nov 2020 03:30:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34umcxm5pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 03:30:16 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AH3UExD023405;
        Tue, 17 Nov 2020 03:30:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 19:30:14 -0800
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] scsi: scsi_vpd_lun_id(): fix designator priorities
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq136187j9k.fsf@ca-mkp.ca.oracle.com>
References: <20201029170846.14786-1-mwilck@suse.com>
Date:   Mon, 16 Nov 2020 22:30:12 -0500
In-Reply-To: <20201029170846.14786-1-mwilck@suse.com> (mwilck@suse.com's
        message of "Thu, 29 Oct 2020 18:08:45 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=896 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=926 suspectscore=3
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> The current implementation of scsi_vpd_lun_id() uses the designator
> length as an implicit measure of priority. This works most of the
> time, but not always. For example, some Hitachi storage arrays return
> this in VPD 0x83:

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
