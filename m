Return-Path: <SRS0=D4W/=WL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DF6C32753
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Aug 2019 02:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECC422084F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Aug 2019 02:08:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YdY6yWrc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbfHOCIN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 22:08:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48266 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfHOCIN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 22:08:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7F24Hqg095620;
        Thu, 15 Aug 2019 02:08:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=VxLmr9MZqCUudawHF9F7DevlO0oFU6kLk/mFs1jZ0yY=;
 b=YdY6yWrcsQznBZtVWGuaPs1k3+9DzM/oAkQzqGCHlUUqdE7jjGgfezj+MVcdlWyJnD6z
 bi35BObCTPyHwc6JLfRiO0thDlVwQCrUdolD5+Ys2x5xTGK8dc2u1cLkRUxZyP+kfVYD
 tWIv9KSOhfmZPK19uvBy7108ZgyYNSETLgXnn8/8zqOCs4IAkCDArC+dWaTtb2hGcfGw
 CsfGzjfNUnEqwpAIBbvIb11X1soK2422I7bFhcT6VESrkbpgUCaRD1UZ/d1mAHcwTfos
 eBj9aFwWR0wyBlS88Izsy9XxAIk/1VHfV+ALTQYuQ4NoS2erzK5CzhrgXJVDsnQThqXx TQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjqr3p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 02:08:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7F284A8100917;
        Thu, 15 Aug 2019 02:08:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ucgf0g2b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 02:08:04 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7F282PB002400;
        Thu, 15 Aug 2019 02:08:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Aug 2019 19:08:02 -0700
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>
Subject: Re: [PATCH] scsi: ufs: Fix NULL pointer dereference in ufshcd_config_vreg_hpm()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190814125950.22850-1-adrian.hunter@intel.com>
Date:   Wed, 14 Aug 2019 22:08:00 -0400
In-Reply-To: <20190814125950.22850-1-adrian.hunter@intel.com> (Adrian Hunter's
        message of "Wed, 14 Aug 2019 15:59:50 +0300")
Message-ID: <yq1d0h72nb3.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9349 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=818
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908150021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9349 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=868 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150021
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Fix the following BUG:
>
>   [ 187.065689] BUG: kernel NULL pointer dereference, address: 000000000000001c
>   [ 187.065790] RIP: 0010:ufshcd_vreg_set_hpm+0x3c/0x110 [ufshcd_core]
>   [ 187.065938] Call Trace:
>   [ 187.065959] ufshcd_resume+0x72/0x290 [ufshcd_core]
>   [ 187.065980] ufshcd_system_resume+0x54/0x140 [ufshcd_core]
>   [ 187.065993] ? pci_pm_restore+0xb0/0xb0
>   [ 187.066005] ufshcd_pci_resume+0x15/0x20 [ufshcd_pci]
>   [ 187.066017] pci_pm_thaw+0x4c/0x90
>   [ 187.066030] dpm_run_callback+0x5b/0x150
>   [ 187.066043] device_resume+0x11b/0x220
>
> Voltage regulators are optional, so functions must check they exist
> before dereferencing.
>
> Note this issue is hidden if CONFIG_REGULATORS is not set, because the
> offending code is optimised away.

Applied to 5.3/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
