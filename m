Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C31FECE58C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75B9921848
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CwzrNEv8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732696AbfJJChq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 22:37:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43592 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfJJChp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 22:37:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2ZRnJ051274;
        Thu, 10 Oct 2019 02:36:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=HLpJ521dAVqJPRo7fHZd9sZkQJoK+QqcR5GYvbJTWE8=;
 b=CwzrNEv8Cxtgjf1v6Jgb4MVmJDxy8t1A/GSCMH4qZHhYyDYmFBrWdVQ72H+Pz5Ne3Rzx
 4c4l7fO/LyNWIAiJeiGz7BfjisjZOc6LmXCZtTyRtNViT/4k/9hw/6XjWFiDGgK8pheT
 C+riumATjwgomYenEKTS3GY+y+pa6sGprpQYcdiLS1r0Jj5gIM9ns7rLR54zFHbiR1LC
 YPNQGqsjQCvhIWh1u1l3ToP3/Y6UGoQyYpUsXv7phBu1f2B+JHtY/94E0+zq9e0ICT71
 HrlMftwye8jRHQJoaQRUSE/6VtFe8AIKwiRGgpdEpuFvdwavEHsdxxmFX6Dw36Ny7Yie fA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vek4qr7d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:36:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2Xwxp046336;
        Thu, 10 Oct 2019 02:36:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vhrxcjc1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:36:18 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9A2aDLL026415;
        Thu, 10 Oct 2019 02:36:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Oct 2019 02:36:13 +0000
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 4/9] drivers/scsi: Replace rcu_swap_protected() with rcu_replace()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20191005160653.GD2689@paulmck-ThinkPad-P72> (Paul E. McKenney's
        message of "Sat, 5 Oct 2019 09:06:53 -0700")
Organization: Oracle Corporation
References: <20191003014153.GA13156@paulmck-ThinkPad-P72>
        <20191003014310.13262-4-paulmck@kernel.org>
        <yq1zhihqn1g.fsf@oracle.com>
        <20191005160653.GD2689@paulmck-ThinkPad-P72>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
Date:   Wed, 09 Oct 2019 22:36:09 -0400
Message-ID: <yq136g1jpie.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=740
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=827 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100024
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Paul,

> I do not intend to actually remove rcu_swap_protected() until 5.6 for
> exactly this sort of thing.  My plan is to take another pass through
> the tree after 5.5 comes out, and these will be caught at that time.
>
> Does that work for you?

Yep, that's great. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
