Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE501C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 16:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7182723C19
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 16:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgLIQvx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 11:51:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44984 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731919AbgLIQvo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 11:51:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9GnveJ006038;
        Wed, 9 Dec 2020 16:49:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=aRzahDN3jrem43Dn7bs3wc1568IMmJINjeUBUe+Oeqg=;
 b=np0QO0hOj3BMAFZtfgednlvJm2gcmb+elYDY6Cpw9zoYFbzRNf2Rf7CiX9GruqbfSC6O
 bNDWHiPtNnTtSCB+WJdhLpbOSIssHY6Un+Ox7y+1zm231EAMoDwMXTvUXZuaV3Y+jx9z
 pgegtWjc8qjnG4XV6IejkkAmUZVxnP/6TNEWrvcShTPfQpGCz34ic1sc2Tz36JvK6E2T
 szl9FTs7rQHiMW8fbGWXIxVMq53dcXqXCz3d2hLqP/af2Jq+mTG/UxRFJyPG1CJmZrlr
 88dbnOffSbGN3k/sGMfzZdUm69LPypn6/gJwyGzb3p49kwVdkYf/6ELRdeh481ZTHTE5 lQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3581mr1424-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 16:49:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9Gjm9S157085;
        Wed, 9 Dec 2020 16:47:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 358m50uye0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 16:47:53 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9GlmPJ026437;
        Wed, 9 Dec 2020 16:47:49 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 08:47:48 -0800
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nicolas.palix@univ-grenoble-alpes.fr,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: problem booting 5.10
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg8fq641.fsf@ca-mkp.ca.oracle.com>
References: <alpine.DEB.2.22.394.2012081813310.2680@hadrien>
        <CAHk-=wi=R7uAoaVK9ewDPdCYDn1i3i19uoOzXEW5Nn8UV-1_AA@mail.gmail.com>
        <yq1sg8gunxy.fsf@ca-mkp.ca.oracle.com>
        <CAHk-=whThuW=OckyeH0rkJ5vbbbpJzMdt3YiMEE7Y5JuU1EkUQ@mail.gmail.com>
        <9106e994-bb4b-4148-1280-f08f71427420@huawei.com>
        <CAHk-=wjsWB612YA0OSpVPkzePxQWyqcSGDaY1-x3R2AgjOCqSQ@mail.gmail.com>
        <alpine.DEB.2.22.394.2012082339470.16458@hadrien>
        <yq1sg8fud7y.fsf@ca-mkp.ca.oracle.com>
        <4f3cd4d4-87d3-dc9a-027d-293cba469d5a@huawei.com>
        <alpine.DEB.2.22.394.2012091644010.2691@hadrien>
Date:   Wed, 09 Dec 2020 11:47:46 -0500
In-Reply-To: <alpine.DEB.2.22.394.2012091644010.2691@hadrien> (Julia Lawall's
        message of "Wed, 9 Dec 2020 16:44:29 +0100 (CET)")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=980
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=992
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090118
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Julia,

> 5.10-rc7 plus these three commits boots fine.

Great! Thanks for confirming.

-- 
Martin K. Petersen	Oracle Linux Engineering
