Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA7AC2BA19
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 18:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E7FC20735
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 18:04:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IghDO4kx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387591AbgDMSEI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 14:04:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58424 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387498AbgDMSEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 14:04:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DI43BD070597;
        Mon, 13 Apr 2020 18:04:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=M7F/dkEI3zQA+iFig6tmIddxh46FLaQYLZmVLWQR3+s=;
 b=IghDO4kxnxSSbuZAJ791e3xcrD9taq1NlUYXSoEbzddoQe3faFu8yA/B/tb7IAKeohCH
 tsmDQGWnIFfGlBd0rRt7FpShbShnaTEL0gTLVeGyeqmxrCsu/fGb14ebidglOOJSEOo2
 ac/Xfqn6Rt68Zf8HqmoHksxH6n5kvsmC7Go+6EuK0rwIqGsRp9V8oVfY4ec+KVX6LBvR
 oLUIJYpX9vZvrd/eXlq3xqpF+m4QuG4YaCiEgyK47u0igI6Ilgy5lDvBG1ST1d907o50
 v+vJ4DXFgZjA2dPdRIrkv09kztu6rV6EgZAroYFiCXgbAjX16dV8z6MFJ9xTru68MZa1 Ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30b5um02vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 18:04:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DI1uaR095859;
        Mon, 13 Apr 2020 18:01:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30bqpcs8ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 18:01:58 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03DI1gti004951;
        Mon, 13 Apr 2020 18:01:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 11:01:42 -0700
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mchristi@redhat.com, martin.petersen@oracle.com
Subject: Re: [PATCH 0/2] target: small fixes in pr
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200408132610.14623-1-bstroesser@ts.fujitsu.com>
Date:   Mon, 13 Apr 2020 14:01:40 -0400
In-Reply-To: <20200408132610.14623-1-bstroesser@ts.fujitsu.com> (Bodo
        Stroesser's message of "Wed, 8 Apr 2020 15:26:08 +0200")
Message-ID: <yq1k12jxo1n.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=919 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 bulkscore=0 mlxscore=0
 mlxlogscore=982 lowpriorityscore=0 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130138
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bodo,

> The patches fix two issues in target core pr handling.

Applied to 5.7/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
