Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AA6C2BA19
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 17:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 157E820735
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 17:51:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fz3laViR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387456AbgDMRvl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 13:51:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387436AbgDMRvl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 13:51:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DHnGpK059494;
        Mon, 13 Apr 2020 17:51:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=WyvyD8fkR43Fmm1eZQNxVtNikVgJ6QpZU17W31tbyz0=;
 b=fz3laViRxWavRfBg38tc1iC6EWtatytjkWPg/1zWivActwxYXLZFyhI7GctkR8xMmSb3
 vItpylXfg+Xnie1peFO+/4QD2VDlmUp+8GMCLPg5mgd4L+tb9TyUaYbhur5KwOLHTIUo
 1zMgDcufE7oXjGB4JAElTkyj17Grc2bWbsk5N4uczCK2EFRWgfIUzIABPZPptmPPHee+
 3inVcveb+3WUrPy7/UhvY4Sln/w3/oj6PEe6C3fH9BjfuuSV33dc8nOWgWeliFLDvJ1X
 CCMWJlj2LOJhITcc69mQkDUrQShmupNx43AobAwR4XLpMSoT5AttM/f+kH9r7woJvf/1 og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30b6hpfxw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 17:51:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DHl4JL144669;
        Mon, 13 Apr 2020 17:51:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30cta7mgg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 17:51:27 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03DHpPi5032403;
        Mon, 13 Apr 2020 17:51:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 10:51:25 -0700
To:     Douglas Anderson <dianders@chromium.org>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        paolo.valente@linaro.org, groeck@chromium.org,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, sqazi@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] Revert "scsi: core: run queue if SCSI device queue isn't ready and queue is idle"
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200408150402.21208-1-dianders@chromium.org>
        <20200408080255.v4.4.I630e6ca4cdcf9ab13ea899274745f9e3174eb12b@changeid>
Date:   Mon, 13 Apr 2020 13:51:22 -0400
In-Reply-To: <20200408080255.v4.4.I630e6ca4cdcf9ab13ea899274745f9e3174eb12b@changeid>
        (Douglas Anderson's message of "Wed, 8 Apr 2020 08:04:02 -0700")
Message-ID: <yq1o8rvxoit.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 clxscore=1011 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130135
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Douglas,

> This reverts commit 7e70aa789d4a0c89dbfbd2c8a974a4df717475ec.
>
> Now that we have the patches ("blk-mq: In blk_mq_dispatch_rq_list()
> "no budget" is a reason to kick") and ("blk-mq: Rerun dispatching in
> the case of budget contention") we should no longer need the fix in
> the SCSI code.  Revert it, resolving conflicts with other patches that
> have touched this code.
>
> With this revert (and the two new patches) I can run the script that
> was in commit 7e70aa789d4a ("scsi: core: run queue if SCSI device
> queue isn't ready and queue is idle") in a loop with no failure.  If I
> do this revert without the two new patches I can easily get a failure.
>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>

Looks good to me, never really liked the original commit.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
