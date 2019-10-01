Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF82C32793
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD2E42133F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 03:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ALeKHNTx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbfJAD0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 23:26:30 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42688 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbfJAD0a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 23:26:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913PnZY099699;
        Tue, 1 Oct 2019 03:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=/gwoLd8ZqCTgMPyHlGIuDepylY6kL58VDPF1PVUuwIs=;
 b=ALeKHNTxYHJICxXrRPJgXb+9y6AYqqGUzuU5bksXZlTKUFGbd1fRi56Qt1ik/jOamb1K
 HCk/Ne1yII5cWPs6lWn7gVOV4S6Lo3Z56mU9E2pnNhxp1h5YCgAGRNzXSqlGVU1mVg82
 dBKe6WJpCk/gJ797IyQumHlm+fklyZiv7ePVx/Jl2e/s8tuygKUHiUhIn8mcjF1K+pkh
 xJ133xIAjo3J+o/L5orPwvxkafmM/WHJjMXu36JWx+08m5q+eyUtF5Pk+SxklQPpW4hY
 W3rckNh4wNzPGEZ6+KuSUtUpNsWdyUC3SMnqG80dxx8FRtRV4IeZocVvO0H6tVi+SJhV kQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v9yfq2xc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:26:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x913PdLQ095359;
        Tue, 1 Oct 2019 03:26:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vbmpxjv69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 03:26:20 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x913QIAX013627;
        Tue, 1 Oct 2019 03:26:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 20:26:18 -0700
To:     Ryan Attard <ryanattard@ryanattard.info>
Cc:     jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: Add sysfs attributes for VPD pages 0h and 89h
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190926162216.56591-1-ryanattard@ryanattard.info>
Date:   Mon, 30 Sep 2019 23:26:16 -0400
In-Reply-To: <20190926162216.56591-1-ryanattard@ryanattard.info> (Ryan
        Attard's message of "Thu, 26 Sep 2019 11:22:17 -0500")
Message-ID: <yq1tv8tw3hj.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=962
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ryan,

> Add sysfs attributes for the ATA information page and Supported VPD
> Pages page.

Applied to 5.5/scsi-queue, thank you.

-- 
Martin K. Petersen	Oracle Linux Engineering
