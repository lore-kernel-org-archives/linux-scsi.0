Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6A1C38A29
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 21:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC9E32137B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 21:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iTI07E8S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgDQV3H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 17:29:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60018 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgDQV3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 17:29:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLIKgx016831;
        Fri, 17 Apr 2020 21:28:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ioRkr8UA3rZ8RZNxmbnIqzvkarX1kRih80H9E5siYQU=;
 b=iTI07E8SKS/cBHsKrg5tZlQLT9iHVI+NR5dxIsbDtQCck1/9gnMODqglqUNpzBEsDVm9
 I1FVDOieQodR6VHpWQEEGEK2250hSV75EOMAzz0dikSQ+WCXYBkfEPGFsf7ADHCKHpS4
 cXn11G0+Q9kH/IpCohMpxatnZD6zsJS9o2e68FDp6m3l/fbzzFgj7Zqt1/Qg6ocqLD4z
 Ged0iMLBzfMP0OwbQuHE1bSZF2nxV/mb7qmHKk7uYaQ9VhM9vP7tKRXte6O7Yi6IUxxs
 KyEqaOJSJzZQ3J9U5vWxhRvGg3qxSFv6M1cH8Rmhx9/qBiZ2/5RTZ5UQisUzJubp8Qlj oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30dn961bvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:28:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLDKOp100481;
        Fri, 17 Apr 2020 21:26:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30dn92860j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:26:44 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03HLQftr025383;
        Fri, 17 Apr 2020 21:26:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 14:26:41 -0700
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: Re: [PATCH v2 1/1] scsi: ufs: full reinit upon resume if link was off
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1586844892-22720-1-git-send-email-cang@codeaurora.org>
Date:   Fri, 17 Apr 2020 17:26:37 -0400
In-Reply-To: <1586844892-22720-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Mon, 13 Apr 2020 23:14:48 -0700")
Message-ID: <yq1d085olbm.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170155
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> During suspend, if the link is put to off, it would require a full
> initialization during resume. This patch resets and restores both the
> host and the card during initialization, otherwise, host only reset
> and restore may fail occasionally.

Applied to 5.8/scsi-queue, thanks!

> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
> Acked-by: Stanley Chu <stanley.chu@mediatek.com>
>
> Change since v1:
> - Incorporated Alim's comments.
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Don't forget to put the changelog after the "---" separator.

-- 
Martin K. Petersen	Oracle Linux Engineering
