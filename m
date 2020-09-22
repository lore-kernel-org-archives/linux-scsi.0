Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E561C4741F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F415F23A34
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UT0xb+hH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgIVD5x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48640 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728342AbgIVD5p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3oKki078106;
        Tue, 22 Sep 2020 03:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=pF/gyMur7Wy1Fyy/scVF6tYTjUqf4AmctCR4ED3cT08=;
 b=UT0xb+hHn6Zoog666cb6kAXJ8cLC2yoQHMSQUEekai7fMqRJM5PvqXRxNeZdKqWS4QGZ
 kS2/2DaYTmKr1c0IedFHtLh9H8heEtHYIhfFaccK1amLiOsqi+0B2V+BS5WlWNrGiZdr
 F5yJUyuk0w2nVZRDWIqSEduh3PKyfoMvkd9RLnSdO8HCAUDc3XZ+Z9mwgIojoRk/5m5D
 88Sn+JJR2AnzWdHSOVWqNfMqtF1Yco5aT7jLmdwQOFcKD6ntKAmDaXUkuUmMBLc4sHgB
 /IxmTdl2HJXX/RPZc+gqYgafWjQgWHTEjRbgqI86dYzMDJAUPmjaZAwDi4rPr0NWFDrZ sA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33q5rg8t72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3uOqT073696;
        Tue, 22 Sep 2020 03:57:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33nurs30tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:23 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08M3vL9P012125;
        Tue, 22 Sep 2020 03:57:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:20 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Long Li <longli@microsoft.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
Subject: Re: [PATCH V7] scsi: core: only re-run queue in scsi_end_request() if device queue is busy
Date:   Mon, 21 Sep 2020 23:56:51 -0400
Message-Id: <160074695012.411.7029631610688832124.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910075056.36509-1-ming.lei@redhat.com>
References: <20200910075056.36509-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Sep 2020 15:50:56 +0800, Ming Lei wrote:

> Now the request queue is run in scsi_end_request() unconditionally if both
> target queue and host queue is ready. We should have re-run request queue
> only after this device queue becomes busy for restarting this LUN only.
> 
> Recently Long Li reported that cost of run queue may be very heavy in
> case of high queue depth. So improve this situation by only running
> the request queue when this LUN is busy.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: core: Only re-run queue in scsi_end_request() if device queue is busy
      https://git.kernel.org/mkp/scsi/c/ed5dd6a67d5e

-- 
Martin K. Petersen	Oracle Linux Engineering
