Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D54CA9EAF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 00:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48A0B205F4
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 00:37:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m+P8VO1c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731979AbfJYAhs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 20:37:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47492 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfJYAhr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 20:37:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P0T4Ig086745;
        Fri, 25 Oct 2019 00:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=EjKfMrJwarv8V/qONtqDS3HsrzYTv0MzJrzGQNpCHT0=;
 b=m+P8VO1ckPD2ridBaFXsh1+n2L+h8gHixICx3PNuXH3V887l+MUDif1EPJTSJaS/443I
 lIlUsv3R9KHgHq2nllc3hj7s1piE+G8sXiZ8jgBn6IXD8eYR4FR8+dRhUJU/QCnDPTD4
 54jf6sfzTXUVIiQeMw0H4+00c98ZFpe9DGr1Sx+fLdLFjGZa4EgN381XGWGLm/6ZbES2
 bIuyTXGp/qDinbgE3vY8q6frj/U/9hxSO+NNyzqBfOANhUkBjTAswGuAWzcu+XhKoMiC
 X0hpaPMYEy4cKr+WVZe1zDqM0HmrzxMLpvJQMn4plyVY1S/dNhiWMiDlO6ICD/Hs2uhu gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vqteq70y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 00:37:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P0SwqH119970;
        Fri, 25 Oct 2019 00:35:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2vug0cpdmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 00:35:34 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9P0ZUhb022707;
        Fri, 25 Oct 2019 00:35:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 17:35:30 -0700
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <john.garry@huawei.com>
Subject: Re: [PATCH] scsi:sd: define variable dif as unsigned int instead of bool
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1571725628-132736-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Thu, 24 Oct 2019 20:35:28 -0400
In-Reply-To: <1571725628-132736-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Tue, 22 Oct 2019 14:27:08 +0800")
Message-ID: <yq1blu5d5m7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=783
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=885 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250004
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Variable dif in function sd_setup_read_write_cmnd() is the return
> value of function scsi_host_dif_capable() which returns dif capability
> of disks.  If define it as bool, even for the disks which support
> DIF3, the function still return dif=1, which causes IO error. So
> define variable dif as unsigned int instead of bool.

Applied to 5.4/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
