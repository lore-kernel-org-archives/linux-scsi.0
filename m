Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA99C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2AA220768
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="njcRa/yO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgG2EKw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 00:10:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43276 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbgG2EKw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 00:10:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T42uRx073257;
        Wed, 29 Jul 2020 04:10:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=XueOXxLQeIjV+JoPeqbJC3BcZPWy2GOjTuyUdd0mwx8=;
 b=njcRa/yOy4SdlqV2A8J/f8IaUk2rAp5kYSBrmqUSEMIqdXEa6tgTbC8y+XN2CaWhdqpD
 d4e5nhgPePErHepvyTl65mxz4Gu4mZJ7148wDsATfGVSl3HW+owLuP6ImUFCaNBHejfq
 xtPHzmmbP1ANMl5MdwYWE7st+ay1wqfMZxdxwXJ6Q3Ak0OQh5Vx95ncN6mpjeO3vquRo
 KGf1O/bb5aBYAmc09A4u2w37h5n6bLJCcKU54INEmb4K8S6WTbJyK06EW5GQgyLycFIE
 yxzWout0e+B6vjSAtf3aX+T9CD0F3l4bMQfC80aDe0NAFuVipUbLfqrTZpMBOlGu2StM CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32hu1jb6df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 04:10:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T42jNj150822;
        Wed, 29 Jul 2020 04:10:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32hu5v59p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 04:10:43 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06T4AfIf024992;
        Wed, 29 Jul 2020 04:10:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 21:10:41 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.vnet.ibm.com, hare@suse.de
Subject: Re: [PATCH] scsi_debug: fix request sense
Date:   Wed, 29 Jul 2020 00:10:33 -0400
Message-Id: <159599579269.11289.9432858399966383235.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723194819.545573-1-dgilbert@interlog.com>
References: <20200723194819.545573-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 23 Jul 2020 15:48:19 -0400, Douglas Gilbert wrote:

> The SCSI REQUEST SENSE command emulation was found to be broken.
> It is a quite complex command so try and make it do a subset of
> what it should do. Remove the attempt to mimic SCSI-1 REQUEST
> SENSE (i.e. return the sense data for the previous failed
> command). Add some reporting of "pollable" sense data [see
> spc6r02: 5.12.2]. Keep the IEC mode page MRIE=6 TEST=1
> predictive failure reporting.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: scsi_debug: Fix request sense
      https://git.kernel.org/mkp/scsi/c/84905d34f149

-- 
Martin K. Petersen	Oracle Linux Engineering
