Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE49C4727C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 15:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F220020872
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 15:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0N7wyDcf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732684AbgJAPgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 11:36:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732242AbgJAPgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 11:36:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091FJAP8003683;
        Thu, 1 Oct 2020 15:36:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=8j0r9HunbbhhtCewGaKaLxFAUl8qWmmj+I3MhH1vbqI=;
 b=0N7wyDcfcSHkq95e3RFHAgk/1vTWScKKsRyMKWWLqlawLRitCStR07A50crUYQDykEdz
 vEMoPRECuSQEZhuJdIJCy0xS7e/o9zCg66fmQerj/kLPQ8Rl2wwo997QMIP0hg6NFq6P
 dGeZDjs4MlhDASMBwZfhUB1Dm4nSkePSuChYWMM+BStQOyNjeNO1NY+uXMrAMjXIGjfu
 /jcWCDC1s42083UPXGCJrg2w/wYL0xiJLjj8fwTMgNES1Nq/7gu6vzZA6f0YPD+bE/09
 WfwM/8mmGRtM17Q75IUD6ua4GzhvqVz+Irw1V1Vzew1XxenoUXjqfNfcEcgvzwq9PReZ eQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33sx9nepe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 15:36:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091FJqxL176466;
        Thu, 1 Oct 2020 15:36:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33tfk1r961-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 15:36:02 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 091Fa1wU017635;
        Thu, 1 Oct 2020 15:36:01 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 08:36:01 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [PATCH V3 0/2] scsi/sd: make disk cmd retries configurable
Date:   Thu,  1 Oct 2020 10:35:52 -0500
Message-Id: <1601566554-26752-1-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxlogscore=798 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=813 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over Martin's staging branch allow
the user to config sd cmd retries. I didn't allow the user to
set any old value and kept the max at 5. However, you can now
turn it off and rely on the transport error handler to decide
when to stop retrying. You can also decrease retries for cases
for disks where there is no use in retrying 5 times.

V3:
- really drop excess ()s

V2:
- Drop excess ()
- Add comment about forcing completion in the request sense
case
- Use kstrtoint

