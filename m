Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB308C2D0E2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6DE823A5F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l8hzRE4e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgIVD5d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60668 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728574AbgIVD5b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3n0bl040825;
        Tue, 22 Sep 2020 03:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=54syU8j8eHmmZ9ZJeNZIlFzAfcYFNhwG2ub6nWKqMb8=;
 b=l8hzRE4eLx/5vlMZgn2HuFhbW4OXkR0h93xZbeNQdq3UxYxeS2YUGa2X6sf8v0JvWTGF
 65qa39axurFHyZu8mwJi8vAoFfnTmBDqJmE1OIYDFOc69aKbNKSm2FvZG7N1ptDFxDq1
 gRdrrtLbLJ5jHWf4bIsnTynPJXh9OelGAbKFmqQUb/kb0mfk/nHDTOB6U8hgGlxTi83w
 SWdjubWTzneW1FyiRnFD0rmcpalu2ewUOCx3WpfuzhVOjnL/zidh/RcT1fb026L+qIbk
 dt+IWH+MzQilJf4/SOKlZCkESkbuDQATDEyyL6o6lN9geyxkX0nKB//cB8mN65uiHujK JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33ndnuagng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3tKsQ020609;
        Tue, 22 Sep 2020 03:57:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33nuwxk72v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:21 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vJT8009443;
        Tue, 22 Sep 2020 03:57:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:19 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Matej Genci <matej.genci@nutanix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "mst@redhat.com" <mst@redhat.com>,
        Felipe Franciosi <felipe@nutanix.com>
Subject: Re: [PATCH] Rescan the entire target on transport reset when LUN is 0
Date:   Mon, 21 Sep 2020 23:56:50 -0400
Message-Id: <160074695011.411.12240453136529320837.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <CY4PR02MB33354370E0A81E75DD9DFE74FB520@CY4PR02MB3335.namprd02.prod.outlook.com>
References: <CY4PR02MB33354370E0A81E75DD9DFE74FB520@CY4PR02MB3335.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 Aug 2020 12:21:35 +0000, Matej Genci wrote:

> VirtIO 1.0 spec says
>     The removed and rescan events ... when sent for LUN 0, they MAY
>     apply to the entire target so the driver can ask the initiator
>     to rescan the target to detect this.
> 
> This change introduces the behaviour described above by scanning the
> entire scsi target when LUN is set to 0. This is both a functional and a
> performance fix. It aligns the driver with the spec and allows control
> planes to hotplug targets with large numbers of LUNs without having to
> request a RESCAN for each one of them.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: virtio_scsi: Rescan the entire target on transport reset when LUN is 0
      https://git.kernel.org/mkp/scsi/c/beef6fd02b90

-- 
Martin K. Petersen	Oracle Linux Engineering
