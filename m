Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3EEC33C99
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CA9720721
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="accAK9zN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731581AbgAJGgm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 01:36:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49896 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731530AbgAJGgm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 01:36:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A6X4jR091289;
        Fri, 10 Jan 2020 06:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=oHy/1g6410Fiq149LW49xiyCvvvm9JGeeMkNOJCYjCw=;
 b=accAK9zN7k9ivYBhpO7vHEIp1zPgX/5rdz2531uEMJf+fWNfWHGILpo7J6BsrBxZyvYW
 OPCzDi6wujGbv8XHsGDnG96sA4ySJbfucUb93Xl2w3fwtMTN5e2NsDUMgaagauuFNHf5
 vhJ1fY+0DcnmmFWeLM7LP4s38CtsZP+JVHVe5agBldKPNWOTY0sjHMYtnW4BgundCnCQ
 r4W6YYq7KS5na8Q1yUk7+DBgYzmrQatkwltMtiHLrrRZrqVEQrvQdXg4XKa+7n3+R+PY
 LJmuA4eeRMXcgrJCKYb9OMEKK88oMnVGeO1AW2bkHlvGfV4iVPChIfdfERmJznPyucfl qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbr7x6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:36:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A6XvIG121063;
        Fri, 10 Jan 2020 06:36:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xeh901xse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:36:11 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00A6a9ie021235;
        Fri, 10 Jan 2020 06:36:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 22:36:08 -0800
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: sd: Clear sdkp->protection_type when the disk isn't DIF in sd_read_protection_type()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1578532344-101668-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Fri, 10 Jan 2020 01:36:06 -0500
In-Reply-To: <1578532344-101668-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Thu, 9 Jan 2020 09:12:24 +0800")
Message-ID: <yq1tv53vmw9.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=944
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100054
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100054
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> For a SAS disk, format it as a SAS DIF disk, then if re-format SAS DIF
> disk to normal SAS disk,it will report errors as follows:

Clarified commit description. Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
