Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56BB0C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E327208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:31:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A9WeRogc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgHEBbo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:31:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59780 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgHEBbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:31:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751TPkm169942;
        Wed, 5 Aug 2020 01:31:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KAY8jIDQwbUNhrpR/XmkpPgt//2GIsPpz1VpkrJ2DgQ=;
 b=A9WeRogcXcnozTNkmQ07mXXkOhu6FDlcV33O8Nsxqvga0tU8rVzb+K1N38quSsHbli7d
 uzsjZOj6ii0Jeh03ZICMOSgd98olv+bEXxGnN4cTdbz1iGWz8gz4wxqz7+TNf/oiBSCi
 z0ag39Mo9mS86JiB3EvDMj48Bjxccd5uZR+glaLMmmreAfrZ3Vkl+EPNT5x/GltZaVhd
 pK1TrFnZUHltRNRtis9LsCAmNSrOH2q9fnjL5el+bnlKANcNDSdAPzuKj8XUtulxL3Q0
 9vewA1WkBbvUsrdkR7ozChrfgKonaRfBejCxYLa1WuE92uCsLjh/xKpmLR5nJYbC97Qw 8g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32n11n7bk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 01:31:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751MrNk019436;
        Wed, 5 Aug 2020 01:31:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32pdnruuwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 01:31:22 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0751VHaD022032;
        Wed, 5 Aug 2020 01:31:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Aug 2020 18:31:16 -0700
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v9 8/9] scsi: ufs: Fix a racing problem btw error
 handler and runtime PM ops
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1slzxoh.fsf@ca-mkp.ca.oracle.com>
References: <1596445485-19834-1-git-send-email-cang@codeaurora.org>
        <1596445485-19834-9-git-send-email-cang@codeaurora.org>
Date:   Tue, 04 Aug 2020 21:31:13 -0400
In-Reply-To: <1596445485-19834-9-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Mon, 3 Aug 2020 02:04:43 -0700")
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=2 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050010
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> Current IRQ handler blocks scsi requests before scheduling eh_work,
> when error handler calls pm_runtime_get_sync, if ufshcd_suspend/resume
> sends a scsi cmd, most likely the SSU cmd, since scsi requests are
> blocked, pm_runtime_get_sync() will never return because
> ufshcd_suspend/reusme is blocked by the scsi cmd. Some changes and
> code re-arrangement can be made to resolve it.

  CC [M]  drivers/scsi/ufs/ufshcd.o
drivers/scsi/ufs/ufshcd.c: In function =E2=80=98ufshcd_queuecommand=E2=80=
=99:
drivers/scsi/ufs/ufshcd.c:2570:6: error: this statement may fall through [-=
Werror=3Dimplicit-fallthrough=3D]
 2570 |   if (hba->pm_op_in_progress) {
      |      ^
drivers/scsi/ufs/ufshcd.c:2575:2: note: here
 2575 |  case UFSHCD_STATE_RESET:
      |  ^~~~
cc1: all warnings being treated as errors
make[3]: *** [scripts/Makefile.build:280: drivers/scsi/ufs/ufshcd.o] Error 1
make[2]: *** [scripts/Makefile.build:497: drivers/scsi/ufs] Error 2
make[1]: *** [scripts/Makefile.build:497: drivers/scsi] Error 2
make: *** [Makefile:1764: drivers] Error 2

--=20
Martin K. Petersen	Oracle Linux Engineering
