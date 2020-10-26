Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F755C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 21:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A25D20829
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 21:49:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i9S/CPzM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390552AbgJZVtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 17:49:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390490AbgJZVtU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 17:49:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QLZ6gW168672;
        Mon, 26 Oct 2020 21:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=2X3YcfcTT6osreVd59azJkjkTihIedx3qJ0QrfQX8AA=;
 b=i9S/CPzMjMRZ6Gtskvz1LRg0QqRN77cLbcXPnn/PK0A55NwKB6ApGhcBO722Wo8bYm+U
 8lqdbqJCGMXnuNpLvb9P/SRN8uA/gkhQm/jqfjIM0S8OuB0hlW1Wv7v750CGJ87luspj
 aBzHRojQbs0OiJwMv2CVfJ8Z7F3LsBF8VtPZTRZ8ZaefFXqdvppN8CDT+7JGECftgFW2
 lUsTPjkKea/2/5VJox4al/KZuXaQIYqnxJ+g2mDtFkCC7D97bB5yiMhwYTc/UnSuN+P3
 gKpXoc/0Msg7PEVKMVg7z7Txw7frVsEopBKWI3JJs0wfWugjXXHDa+ZtuIi/HPkALACb qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kpypa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 21:49:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QLTxn7027379;
        Mon, 26 Oct 2020 21:49:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5wdh43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 21:49:13 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QLn7AE023460;
        Mon, 26 Oct 2020 21:49:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 14:49:07 -0700
To:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     takafumi@sslab.ics.keio.ac.jp, Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kevin Barnett <kevin.barnett@microsemi.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Scott Teel <scott.teel@microsemi.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2] scsi: hpsa: fix memory leak in hpsa_init_one
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1d0148xza.fsf@ca-mkp.ca.oracle.com>
References: <20200930155100.11528-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
Date:   Mon, 26 Oct 2020 17:49:04 -0400
In-Reply-To: <20200930155100.11528-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
        (Keita Suzuki's message of "Wed, 30 Sep 2020 15:50:59 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=608
 suspectscore=5 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1011 mlxscore=0 suspectscore=5
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=601 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Keita,

> When hpsa_scsi_add_host fails, h->lastlogicals is leaked since it lacks
> free in the error handler.
>
> Fix this by adding free when hpsa_scsi_add_host fails.
>
> This patch also renames the numbered labels to detailed names.

While I am no fan of numbered labels, these initialization stages are
referenced several other places in the driver. As a result, renaming the
labels makes the rest of the code harder to follow.

I suggest you submit a fix for just the leak. And then, if the hpsa
maintainers agree, we can entertain a separate patch to improve the
naming.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
