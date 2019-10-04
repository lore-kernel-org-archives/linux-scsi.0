Return-Path: <SRS0=tG2Y=X5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C9AC10F14
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 02:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC5C4207FF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 02:11:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HyeGMiSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbfJDCLM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Oct 2019 22:11:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34808 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730272AbfJDCLL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2019 22:11:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9429W0q056974;
        Fri, 4 Oct 2019 02:09:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=8FXA0zgZoIW7W0Aa4N8qSvofqWT8uPjI9bd0eZsFQYo=;
 b=HyeGMiSoRNxqiiYAwQ/TW6dEe9h8314AVISrwnAulCy3Lm7Ryd9WUOD633pWVHm2hyI0
 elmpW5ZwRXsUG7cXMAxtEN3GvEGPsf2eJjZE4uvrkdY48iVPsJe2F9JwTRecmo2u+tBb
 M8DsTTsgXvSMjlVRt8Q+nvwVFK9QxGodEmGUcJbIUEK1jzpppG159unfC7BoaW0HKGWQ
 JfF7TUvTPx70gLfEOhv7HVnUSG3h49OtatR92VmdjuFT2Jf6/bFztx345DfvVZFTK3PD
 ul4du3cNzY7xNflQ2SuTfKBf3vko3lCXNnchv+nZ0r3HA4Z9a2+5JqsbfV8M5Z9UMvxo TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2va05s83x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 02:09:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9429FBv124671;
        Fri, 4 Oct 2019 02:09:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2vdt3nr1tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 02:09:43 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9429a6k020968;
        Fri, 4 Oct 2019 02:09:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 19:09:35 -0700
To:     paulmck@kernel.org
Cc:     rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 4/9] drivers/scsi: Replace rcu_swap_protected() with rcu_replace()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191003014153.GA13156@paulmck-ThinkPad-P72>
        <20191003014310.13262-4-paulmck@kernel.org>
Date:   Thu, 03 Oct 2019 22:09:31 -0400
In-Reply-To: <20191003014310.13262-4-paulmck@kernel.org> (paulmck@kernel.org's
        message of "Wed, 2 Oct 2019 18:43:05 -0700")
Message-ID: <yq1zhihqn1g.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=717
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9399 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=804 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040015
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Paul,

No objections from me.

> +	vpd_pg80 = rcu_replace(sdev->vpd_pg80, vpd_pg80,
> +			       lockdep_is_held(&sdev->inquiry_mutex));
> +	vpd_pg83 = rcu_replace(sdev->vpd_pg83, vpd_pg83,
> +			       lockdep_is_held(&sdev->inquiry_mutex));

Just a heads-up that we have added a couple of additional VPD pages so
my 5.5 tree will need additional calls to be updated to rcu_replace().

-- 
Martin K. Petersen	Oracle Linux Engineering
