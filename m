Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0184C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 05:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9332C21D46
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 05:21:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PbOSy2t+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgIIFVX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 01:21:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16562 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725826AbgIIFVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 01:21:21 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 089515oj052409;
        Wed, 9 Sep 2020 01:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Nw8TOQQ9zm+FwON85mt+CB23ciXM3ZURviO0Ezct4mo=;
 b=PbOSy2t+XO5oMshNxFAEkxFbT8UXBgFT34QSyPy69IIs+oDLL8OzgUUzgujsCp1SKGuJ
 aY42n099F9JZWka0UijXaddo6HD6GAo86pS46WX0PPZbkFJx7oGeUOTu/N0hDHYSs5gk
 idkGVWmFNGCImI5BqYZnSaqIhCWbK/NVMlbfhwds/Bi1i79Ni58uwlseTWtxVHLTBxXb
 FhimzVh9XYa6rkXZyy2ADgSEAuMm+2W9/g1MuzWq9LgYH+Ztz5QWKCMhnkZyFbRCmM08
 CfjnAkd4Qui88xtcZtWcCsHnskb0uicoKUH4LbH3voeiU9juH5CwwhiT0O0HSYySApDa UQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33eqgwt0fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 01:21:11 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0895GQjA013550;
        Wed, 9 Sep 2020 05:21:11 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 33c2a9by1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 05:21:11 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0895L9x162652800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Sep 2020 05:21:10 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D98A47805C;
        Wed,  9 Sep 2020 05:21:09 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 890D37805F;
        Wed,  9 Sep 2020 05:21:07 +0000 (GMT)
Received: from [153.66.254.174] (unknown [9.85.154.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  9 Sep 2020 05:21:07 +0000 (GMT)
Message-ID: <1599628866.10803.68.camel@linux.ibm.com>
Subject: Re: [PATCH v4 1/2] ufs: introduce skipping manual flush for wb
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com
Date:   Tue, 08 Sep 2020 22:21:06 -0700
In-Reply-To: <3cf3e93696510922b775d8887ca8408dd384648b.1599285983.git.kwmad.kim@samsung.com>
References: <cover.1599285983.git.kwmad.kim@samsung.com>
         <CGME20200905061549epcas2p3e3554be6bb9737f3133529ebac4ce99a@epcas2p3.samsung.com>
         <3cf3e93696510922b775d8887ca8408dd384648b.1599285983.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_02:2020-09-08,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxlogscore=723
 impostorscore=0 mlxscore=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090040
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-09-05 at 15:06 +0900, Kiwoong Kim wrote:
[...]
> +
> +	/*
> +	 * This quirk needs to disable manual flush for write booster
> +	 */
> +	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 11,

You can't have 1 << 11 it's already taken by:

8da76f71fef7 scsi: ufs-pci: Add quirk for broken auto-hibernate for Intel EHL

	/*
         * This quirk needs to disable manual flush for write booster
         */
        UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL          = 1 << 11,

I take it 1 << 12 is OK?

James


