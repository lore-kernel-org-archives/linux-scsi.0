Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA65C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AE2423A32
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CCdksDxO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgIVD5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41928 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbgIVD5U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3s0nd152026;
        Tue, 22 Sep 2020 03:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=k56RZ1+6batOQrM+U46U6x8O6Vt4h0LfiekgDtRCG6E=;
 b=CCdksDxOrEYHzBe3YXzU3IZMqiFhjrc0IAxYz3TGcOpt45nvo15PvXKUlve1ASqiLHCW
 rOUbMfgWT+wfBVu1CnbuE4jdkraN1yA3/Ov01PCMcA9eRoxoyRdS589ybYPpLHEk4Q5I
 RO6cPtQP40VcsttfQ9h057JESxSDCiUbUKKcAwM0FoQwKINWAu6nbbD7ResOWe6v7Ieu
 Ta7px6wBpvDWIl6oZzNXYdIqgFXG0CsguRr+hchGYpvLr6bWsNsne7n4VO7cFkMm4BkF
 e30mVA9f8ysrRqcJpwsPEyz2OSloOrDLmkBWO3HtYcACkbN/CgWyC6th77oodYrTYWXz tw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33n7gad5ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3tnS6017421;
        Tue, 22 Sep 2020 03:57:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33nuw2pkca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:12 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vBg8032444;
        Tue, 22 Sep 2020 03:57:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:10 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH V2] scsi: ufs-pci: Add LTR support for Intel controllers
Date:   Mon, 21 Sep 2020 23:56:43 -0400
Message-Id: <160074695007.411.12863504368818318757.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200827072030.24655-1-adrian.hunter@intel.com>
References: <20200827072030.24655-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 27 Aug 2020 10:20:30 +0300, Adrian Hunter wrote:

> Intel host controllers support the setting of latency tolerance.
> Accordingly, implement the PM QoS ->set_latency_tolerance() callback. The
> raw register values are also exposed via debugfs.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: ufs-pci: Add LTR support for Intel controllers
      https://git.kernel.org/mkp/scsi/c/247f99445938

-- 
Martin K. Petersen	Oracle Linux Engineering
