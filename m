Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F18C2D0E2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 21:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3433A22262
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 21:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w34FK/fi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgIVVjr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 17:39:47 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57972 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgIVVjr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 17:39:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MLPSt4120802;
        Tue, 22 Sep 2020 21:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=bKqjb3mPd/FBc/U8jba5rQrhQlBL5Tw/ZK1EsTH3wXk=;
 b=w34FK/fiMhH83aXlrNHCm/7IjPByMdEKIkmJs0ro6KLa9XHDSi76FX7s9sJeaBzum/OC
 97rsoGplD5XSayYjAGwBVvtfxJS9xngjonOPUvDlBKSWdpM/+m6k3qvpgfRJCS//rti4
 MJ194Ku+gNRVFrXkI09NWEHUWqPixwpk+H2zBHQp3r5g/0LX2fRxp8NlQYC47Hbq1DPU
 bpwumjoyqvOTG0luZerWSG1Gixvfo3Rfm2Jho5/H7IEG08mlbSf321mF6GSdTdpPCHvH
 33gWMTpvj8duOf9NA/+QCLJ9XICdgFI7V0weOfFrn8t5npmP9za0HOJHSW2Tfy14+O0X Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33qcptv7mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 21:39:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MLPNhO019063;
        Tue, 22 Sep 2020 21:39:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33nux028vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 21:39:38 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08MLdauB010911;
        Tue, 22 Sep 2020 21:39:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 14:39:36 -0700
To:     Brian King <brking@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, tyreld@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, martin.petersen@oracle.com
Subject: Re: [PATCH] ibmvfc: Protect vhost->task_set increment by the host lock
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1blhxpk36.fsf@ca-mkp.ca.oracle.com>
References: <1600286999-22059-1-git-send-email-brking@linux.vnet.ibm.com>
Date:   Tue, 22 Sep 2020 17:39:34 -0400
In-Reply-To: <1600286999-22059-1-git-send-email-brking@linux.vnet.ibm.com>
        (Brian King's message of "Wed, 16 Sep 2020 15:09:59 -0500")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=1 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220167
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Brian,

> In the discovery thread, ibmvfc does a vhost->task_set++ without any
> lock held. This could result in two targets getting the same cancel
> key, which could have strange effects in error recovery.  The actual
> probability of this occurring should be extremely small, since this
> should all be done in a single threaded loop from the discovery
> thread, but let's fix it up anyway to be safe.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
