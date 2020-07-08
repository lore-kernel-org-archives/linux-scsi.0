Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7ACAC433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8DBE2078A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:07:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xv39Amhx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgGHGHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:07:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35314 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgGHGHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:07:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 068672Lv097537;
        Wed, 8 Jul 2020 06:07:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=gUNxfEBRJOOR1NIelKsewkZgfCzGZ9BJHGW+jcEvAaA=;
 b=xv39Amhxfxb6AE6/VVOJVQyIvkdeUbab0RYh16roqgr0CN/VSRDFptasDowahQ333bf3
 rqDnhmmb7kmQUweNXR2oR55pwSBlS9dNQcbaAtwjkYhlRBZnioTNHeewMl0djx+N4+Ny
 d1/Zr6PsG3NnMgq4VkA7fhNNUQlGx3ISSWqIcXIVA/Yab1fXDyF79nGAxlzSCn2RtTCt
 lH+CliIzedrdE+eIJiskVLnq0toUuzZCuTTOIojGktnoGKSgDfxAAyyQw6c/snmuKHQh
 peJtobT991w2Kr4HYQ/m/+W7Cb83QVOqyb63se9LpKsDGeIGxJFZM188OY7IE1VIUUgE Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 323sxxvqm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 06:07:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0685xDfw105110;
        Wed, 8 Jul 2020 06:07:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3233bqb3qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 06:07:07 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 068676SL024893;
        Wed, 8 Jul 2020 06:07:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 23:07:06 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/10] Fix a bunch SCSI related W=1 warnings
Date:   Wed,  8 Jul 2020 02:06:51 -0400
Message-Id: <159418828150.5152.12521251265216774568.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200707140055.2956235-1-lee.jones@linaro.org>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 adultscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080042
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 7 Jul 2020 15:00:45 +0100, Lee Jones wrote:

> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
> 
> There are a whole lot more of these.  More fixes to follow.
> 
> Lee Jones (10):
>   scsi: megaraid: megaraid_mm: Strip excess function param description
>   scsi: megaraid: megaraid_mbox: Fix some kerneldoc bitrot
>   scsi: fdomain: Mark 'fdomain_pm_ops' as __maybe_unused
>   scsi: megaraid: megaraid_sas_fusion: Fix-up a whole myriad of
>     kerneldoc misdemeanours
>   scsi: megaraid: megaraid_sas_base: Provide prototypes for non-static
>     functions
>   scsi: aha152x: Remove unused variable 'ret'
>   scsi: pcmcia: nsp_cs: Use new __printf() format notation
>   scsi: pcmcia: nsp_cs: Remove unused variable 'dummy'
>   scsi: libfc: fc_disc: Fix-up some incorrectly referenced function
>     parameters
>   scsi: megaraid: megaraid_sas: Convert forward-declarations to
>     prototypes
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[03/10] scsi: fdomain: Mark 'fdomain_pm_ops' as __maybe_unused
        https://git.kernel.org/mkp/scsi/c/4be1fa2b55a8
[06/10] scsi: aha152x: Remove unused variable 'ret'
        https://git.kernel.org/mkp/scsi/c/3c011793aca7
[07/10] scsi: pcmcia: nsp_cs: Use new __printf() format notation
        https://git.kernel.org/mkp/scsi/c/af0b55d06004
[08/10] scsi: pcmcia: nsp_cs: Remove unused variable 'dummy'
        https://git.kernel.org/mkp/scsi/c/97a33483425d
[09/10] scsi: libfc: fc_disc: Fix-up some incorrectly referenced function parameters
        https://git.kernel.org/mkp/scsi/c/b1987c884585

-- 
Martin K. Petersen	Oracle Linux Engineering
