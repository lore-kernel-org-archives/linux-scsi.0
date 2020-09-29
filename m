Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE538C4741F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 17:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4770F20C09
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 17:02:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HBAu4YtQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgI2RCH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:02:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35652 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbgI2RCF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 13:02:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TGxVCY162688;
        Tue, 29 Sep 2020 17:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=V78XnH59zPxYBfPldhojs7jz16esqpSY6uy+P3aFU18=;
 b=HBAu4YtQeoVnwLi7ce4t/m/FJuDWTg6XssUDjeGBt9AG/xCvDcHT/nD1ONit/VHYWzkX
 i8mNoAi87pOE5ejLG4tpAATeYBwByKab4VKpTuUkQbUvYN1nAnSE9SeP6z1h2WZiApgr
 Uu4giVRr5jkA9i1w/IMG4tXuiD4IAjxpcUBegeBeZpjvOksO0Ty9pXCrREHmMcsDfRTO
 fNfbFuZkn8J6duvp9hjxe30mPMb9WFD4CWlf+JBq0LKZLZJlbVEj2MC/orVTc/WPdd9l
 1GCE/KSj94tHzyReKJRn8eF1XU2lwzh3x5u4LED9TMgNNidSe9rw90srmdl1o9KhhPdb aQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33swkkv46b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 17:01:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TGxk5a131526;
        Tue, 29 Sep 2020 17:01:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33tfjx3y6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 17:01:58 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08TH1tDv006238;
        Tue, 29 Sep 2020 17:01:56 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 10:01:54 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [PATCH 0/2] scsi/sd: make disk cmd retries configurable V2
Date:   Tue, 29 Sep 2020 12:01:46 -0500
Message-Id: <1601398908-28443-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=822 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=835 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290144
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Martin's staging branch allow
the user to config sd cmd retries. I didn't allow the user to
set any old value and kept the max at 5. However, you can now
turn it off and rely on the transport error handler to decide
when to stop retrying. You can also decrease retries for cases
for disks where there is no use in retrying 5 times.

V2:
- Drop excess ()
- Add comment about forcing completion in the request sense
case
- Use kstrtoint

