Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20233C55178
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 00:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A4D2080A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 00:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yiyxJxk0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409415AbgJ0AqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:46:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60780 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409103AbgJ0AoL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 20:44:11 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R0doD4109419;
        Tue, 27 Oct 2020 00:44:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=DsEaClwT4IlQR9GhL2BKtnhIXq7/s/Ze5WzXcRrv260=;
 b=yiyxJxk0aMJIWSwn7MWHgj18rn9WIyEJKl2st2WGz/r9Wr5rn+9jXOK88DmQFRft5s/B
 jwaM4sdewWMY9XpT4ngw5+YXxZY98pL3BLOXHxCrK0s8f57036Nirp8mcniSvIDDbPCp
 U/5iT+S3f5kpjIgKEtE63ZAcGgATKQifwjz/W+MHauCQ0WZynQbJnO3VLoOj2BMVafCf
 dTInTU5JwlzK+aG2eAqyYpm79XOTIDg0iHPYsMXtj78mNfwUaMrLbE9a1EReYRxL2N2r
 CaoEfNue4BvD4zUv6lwNCFZq5b+z0DAymU9YHhJu0iaSXGCpaB6FdM5REsPAh4jVTP3Z uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9saqgnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 00:44:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R0eOio028526;
        Tue, 27 Oct 2020 00:42:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34cwuksf7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 00:42:03 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09R0g1Eh029395;
        Tue, 27 Oct 2020 00:42:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 17:42:01 -0700
To:     Viswas G <Viswas.G@microchip.com.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        <Viswas.G@microchip.com>, "peter chang" <dpf@google.com>,
        <vishakhavc@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: Re: [PATCH 1/4] pm80xx: make mpi_build_cmd locking consistent
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnzc5x5s.fsf@ca-mkp.ca.oracle.com>
References: <20201012052415.18963-1-Viswas.G@microchip.com.com>
        <20201012052415.18963-2-Viswas.G@microchip.com.com>
Date:   Mon, 26 Oct 2020 20:41:59 -0400
In-Reply-To: <20201012052415.18963-2-Viswas.G@microchip.com.com> (Viswas G.'s
        message of "Mon, 12 Oct 2020 10:54:12 +0530")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270003
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Viswas,

Your patch descriptions need some work. See

     Documentation/process/submitting-patches.rst

Specifically the section named "Describe your changes".

> the missing task completions appear to be

Which missing completions are these?

[...]

> if a sata request issues from cpu zero when a management request
> issues, then there is some 'tearing' and the issue queue is sort of
> broken and we lose track of issues.

Too vague for a problem description.

> disabling interrupts may be overkill because there may not be cases
> where we're using this from interrupt context (the interrupt path
> has a different per-queue lock).

No clear description of what the fix is.

Please reword your patch descriptions so it is clear to the reviewer
what the problem is and how it is being addressed in the code changes
that follow.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
