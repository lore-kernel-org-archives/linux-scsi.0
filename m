Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8026DC43331
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 01:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50D1C20BED
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 01:53:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mqo52Tbq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731565AbgDABxE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 21:53:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51084 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731506AbgDABxD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2020 21:53:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0311lYDH018671;
        Wed, 1 Apr 2020 01:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=1xjwF4s66rqmiegCQAkE3SaaJURKMcHv5WS1gGuV51Y=;
 b=Mqo52TbqR3zTM8izSDZtQwdBHMpvR+05RLOc2YDwxzCnot0P6lKNJk8rcwiaEoe4TApz
 knrW5YPnTlagR1npAcA984kJ0bow/QYH6HxJwh0uF1834cE0Lm+3MoSTLFbvPJC0VTcX
 c0pAA+IhpT4OHDDMjwli91xYVhWzoUgW0CFwmZZtiXKYmMYFNxl/b0xzob+q7GdIbbSv
 rSrUvMO+Au/Ru4OugzyTtP08g8jba+4GTOE/u3dUrskfXfGSVVsEbus4Lg6PBe68p4m/
 M2T3XP8OSr1Nlua7KUk9kiOzUxjbMcNEzOKKpAbtMpeT2m8z0cp8IEBxRsXhXh51JNnf ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 303cev2pw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 01:52:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0311qFkn167712;
        Wed, 1 Apr 2020 01:52:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 302g4smw9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 01:52:43 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0311qfHn016831;
        Wed, 1 Apr 2020 01:52:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Mar 2020 18:52:41 -0700
To:     Wu Bo <wubo40@huawei.com>
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        liuzhiqiang <liuzhiqiang26@huawei.com>, <linfeilong@huawei.com>
Subject: Re: [PATCH] iscsi:report unbind session event when the target has been removed
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <7cce97f2-4dab-5105-a477-8869d5a4f150@huawei.com>
Date:   Tue, 31 Mar 2020 21:52:38 -0400
In-Reply-To: <7cce97f2-4dab-5105-a477-8869d5a4f150@huawei.com> (Wu Bo's
        message of "Tue, 24 Mar 2020 15:58:50 +0800")
Message-ID: <yq1mu7w6kgp.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Wu,

> The daemon is restarted or crashed while logging out of a session.
> The unbind session event sent by the kernel is not be processed or be
> lost.  When the daemon runs again, the session will never be able to
> logout.

I had to apply this by hand as the patch was completely mangled. Please
use git send-email to submit patches in the future! Thanks!

Applied to 5.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
