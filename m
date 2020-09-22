Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BB1C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E399523A32
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:59:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0RRPl4Cn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgIVD7z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:59:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42800 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgIVD7z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:59:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3xRBU159649;
        Tue, 22 Sep 2020 03:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=71zvkSYXJ+il36NVw8yR0dE4/qSKaW5N+i3lvo/bvzw=;
 b=0RRPl4CnVLiLVeqMYp7wfi8Wt+oIk9ySzNMhXeaRBsguBEU/HS92IN9z+bGlMjfElI8J
 lIpP2VKS4yduB2/HJfHllMHe74Ub2NdDb3HyKep6glg2J9934JhqAAiTeWgo+XA9/abr
 rGyvOIWgMrU3WkK2V06R0JpV/jTFSzD2MmG0X9sxqhmXGqfgmdRpdVGC0oPz1CGYfHCH
 6RrWWCwd+DCZDVyq3H12gW9xJ71UXLlLS8ry+/b2wEhdNwJ+VZL75U3eVLdL7LVdzaO6
 IiEp2SNVyL8ikbh+MMx5Ns1SMSNiW8PC0ggdgfZ0MTXJXtsr0+GBKHaTYS8E2nDSDC7M fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33n7gad602-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:59:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3uMAI073630;
        Tue, 22 Sep 2020 03:57:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33nurs31q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vjdf000369;
        Tue, 22 Sep 2020 03:57:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:45 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hare@suse.de, jejb@linux.ibm.com,
        YueHaibing <yuehaibing@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] scsi: libfc: Fix passing zero to 'PTR_ERR' warning
Date:   Mon, 21 Sep 2020 23:57:09 -0400
Message-Id: <160074695008.411.12945752939427447705.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200909135432.36772-1-yuehaibing@huawei.com>
References: <20200818114235.51052-1-yuehaibing@huawei.com> <20200909135432.36772-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=855 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=887 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 9 Sep 2020 21:54:32 +0800, YueHaibing wrote:

> drivers/scsi/libfc/fc_disc.c:304
>  fc_disc_error() warn: passing zero to 'PTR_ERR'
> 
> fp maybe NULL in fc_disc_error(), use PTR_ERR_OR_ZERO to handle this.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: libfc: Fix passing zero to 'PTR_ERR' warning
      https://git.kernel.org/mkp/scsi/c/a9e81c2922bf

-- 
Martin K. Petersen	Oracle Linux Engineering
