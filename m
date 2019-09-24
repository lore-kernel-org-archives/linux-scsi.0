Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FC3C432C1
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 02:20:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8F4B2064A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 02:20:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gHvb5JZr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404271AbfIXCUq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 22:20:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53380 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729139AbfIXCUq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2019 22:20:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O2IuYQ059462;
        Tue, 24 Sep 2019 02:19:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=x9Jb3TUiZn7b1gM7a4ycdi6IT2FKgxtzaWd5zh8dq8k=;
 b=gHvb5JZrjmcgIuM2w0+CgPQxWGRdGZMjZ8AVvJQUmxQYISXB/xSsTznHbjd2h7HcjROi
 EFyaAf6cfXM9yQSwsZBSVyaKczdDgG90XVaXyhyRY1vm661mUwuon5CnXZJY1sqFothk
 myCGVUmttzuwKOxUDJ4ZKlz6TVRNMrzAOGHUdVyq0QLAopexNd8wSBRTN7UXB+y7RBoF
 em+AUWrZfhhI0D2VxduZX8n6GQNtlKsbvQQahR2Tal9JK0Tnplm3pL1A3xrine0NQ0a7
 K0ld1Kp18ZncjfZ9xTApvyDtXctNUsvqTHp6NJa1y9BA0jV9I9Gf+y6riYM48dU44tUl Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2v5btpttu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 02:19:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O2I810021017;
        Tue, 24 Sep 2019 02:19:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2v6yvp4485-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 02:19:58 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8O2JscP005095;
        Tue, 24 Sep 2019 02:19:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 19:19:53 -0700
To:     Laurence Oberman <loberman@redhat.com>
Cc:     djeffery@redhat.com, cdupuis1@gmail.com, lduncan@suse.com,
        martin.petersen@oracle.com, QLogic-Storage-Upstream@qlogic.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] bnx2fc: Handle scope bits when array returns BUSY or TASK_SET_FULL
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1568210202-12794-1-git-send-email-loberman@redhat.com>
Date:   Mon, 23 Sep 2019 22:19:51 -0400
In-Reply-To: <1568210202-12794-1-git-send-email-loberman@redhat.com> (Laurence
        Oberman's message of "Wed, 11 Sep 2019 09:56:42 -0400")
Message-ID: <yq11rw65tbs.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909240022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909240022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Laurence,

> The qla2xxx driver had this issue as well when the newer array
> firmware returned the retry_delay_timer in the fcp_rsp.
> The bnx2fc is not handling the masking of the scope bits either
> so the retry_delay_timestamp value lands up being a large value
> added to the timer timestamp delaying I/O for up to 27 Minutes.
> This patch adds similar code to handle this to the
> bnx2fc driver to avoid the huge delay.
> ---
> V2. Fix Indent for comments (Chad)
> V3. Kbuild robot reported uninitialized variable scope
>     Initialize scope to 0
>
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> Reported-by: David Jeffery <djeffery@redhat.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c | 29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)

Applied to 5.4/scsi-fixes.

Please read Documentation/process/submitting-patches.rst. Your patch got
all mangled since you put tags after the --- separator.

Also, please use the -vN option when submitting updated patches.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
