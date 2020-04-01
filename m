Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769DBC43331
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 02:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 483BA20757
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 02:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DDBRuW5o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbgDACJs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 22:09:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60494 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731550AbgDACJs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2020 22:09:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03129fxV181105;
        Wed, 1 Apr 2020 02:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Whb7+PbqdP5ghvNd35p5CEt4BdoytEdxpGu3io8LXLU=;
 b=DDBRuW5oALa/WCrOWq6gcWqTY0pKuEtuz0ZR0Jl8axriFviwNose2sm6pL2xeXBiRIup
 sCXpw9v7+FXJT5wGGDXv9x3X4eKcBP1STafeVoGPrhxRpz0ZCMLNucrPQrUntVN4JG4p
 H2Kc2weHak4E1ihEDhaXlnilGY5HqTyVU0V7ZEP2j5TQLXJVoQk0v138795qjfqPj1hg
 qB0QivezG43fHmoel4a+zUQqoT1FPVB0es6+g4hwK9yHPSsuW5DcyaXbukvI5qq5SMNN
 I8t3IBEu1NsoPeDlzJ1lwp27omBhYu5+D9Dua1Eo69RbDzm/jMS46WVwrs0kB2xWTktO Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 303cev2rfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 02:09:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 031277Na086386;
        Wed, 1 Apr 2020 02:07:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 302gcece5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Apr 2020 02:07:40 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03127bnX023995;
        Wed, 1 Apr 2020 02:07:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Mar 2020 19:07:37 -0700
To:     Alex Dewar <alex.dewar@gmx.co.uk>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Remove more FreeBSD-specific code from aic7xxx_core.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <yq15zepbsve.fsf@oracle.com>
        <20200327191102.78554-1-alex.dewar@gmx.co.uk>
Date:   Tue, 31 Mar 2020 22:07:34 -0400
In-Reply-To: <20200327191102.78554-1-alex.dewar@gmx.co.uk> (Alex Dewar's
        message of "Fri, 27 Mar 2020 19:11:02 +0000")
Message-ID: <yq18sjg6jrt.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9577 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004010017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alex,

> Remove additional code for FreeBSD in aic7xxx_core.c, which is
> unneeded since commit cca6cb8ad7a8 ("scsi: aic7xxx: Fix build using
> bare-metal toolchain").

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
