Return-Path: <SRS0=gfFE=7Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80239C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 01:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F46020757
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Jun 2020 01:02:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AWJlgZGz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgFCBC0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 21:02:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39590 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFCBC0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 21:02:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0530sTUS051785;
        Wed, 3 Jun 2020 01:01:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=3/STZ1SexWREBvXya0wbTc4mMqOFMgMJt3fHBvJ6Xvk=;
 b=AWJlgZGzySIv3D62CcQ4wK42T3+MtmHtpOEMbBF4Bey50Hdrx3qiu367Hol1Xdo8oy85
 2XLAPbnSclJzz53AjoGAyz2fubguWcpV6ydiJK7H15esEEKRp0SFlRkzwjTHOqoFkoeD
 oM9Vaz9N0dBHVX2iOrS30OXo4uIUSM9VfT52r3R4xgqdnecvNMDghKg0Ri2nIDVwYK3S
 q7j6D3YXSVm8kwyistCNsQ6NbQEAIzbZBajp/HiOSOBFSsLWbrXyGt7XTslswNFX8At6
 tuNKKpMAg4XaUXjTE/Iuk5YuM1R77o89/T+yi5b1h6oWRh+wmkN6URQ8qQOmAg0gBJS2 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfem6kfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 01:01:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0530w0kp182355;
        Wed, 3 Jun 2020 01:01:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31dju2c62d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 01:01:49 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05311fRO017194;
        Wed, 3 Jun 2020 01:01:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 18:01:41 -0700
To:     Chris Boot <bootc@bootc.net>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Chuhong Yuan <hslester96@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sbp-target: add the missed kfree() in an error path
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1img99d4k.fsf@ca-mkp.ca.oracle.com>
References: <20200528102056.911825-1-hslester96@gmail.com>
        <475e4f50-6d20-d653-8288-0676bc708bcc@acm.org>
        <dcb29beb-0996-a141-89af-ac9c9c5fd5c0@bootc.net>
Date:   Tue, 02 Jun 2020 21:01:38 -0400
In-Reply-To: <dcb29beb-0996-a141-89af-ac9c9c5fd5c0@bootc.net> (Chris Boot's
        message of "Thu, 28 May 2020 16:16:51 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=885
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 mlxlogscore=927 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1011
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030003
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chris,

> I think you might be right. I also don't have much time to maintain it
> these days and the hardware I had is long dead.

In that case I'd appreciate a patch to remove it.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
