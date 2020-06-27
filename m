Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA75C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63D2E2081A
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:09:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WFs+ObC1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgF0DJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 23:09:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48688 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgF0DJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 23:09:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R38Pqa106117;
        Sat, 27 Jun 2020 03:09:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=kWmIZR3qrWv9Wbf06UsNxAbwpC9Qmn+wYlBkQdrluCI=;
 b=WFs+ObC1AJcvu7mZ5b0q+yn9Zru4rLEy2OW9VHT+65swLrqR7JfNvSX3zFsiZgEF23u5
 GTTFtp7WREy9HrqvYeR3JUsku7L+gEO/+LgoR56rE5RBJfJNpYHErARmBN+eCgZUpk7K
 Zxg4ruDYrq/ksK3HWEv+jmt5+Lyp505F59NdPELOwCRuY2/dFDKshpeANTGbGmT5aLbK
 kb1C1XvWRg0vQz0YzDKjG5gjTsjU/HJJpMpwECVtnyOxGswHvmaSh1HpkQuXDCg6iUkd
 HHqli63UfuoUB8QRUL0e3fuX551D+0BCxfEuEEG6myQpcPC/8D1qFLzI1kUA5iwVkj/z /w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31uusu8wjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 03:09:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R38A1C099266;
        Sat, 27 Jun 2020 03:09:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31wv58tejs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 03:09:16 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05R39ESo011694;
        Sat, 27 Jun 2020 03:09:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 03:09:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 0/2] libfc: Handling of extra kref.
Date:   Fri, 26 Jun 2020 23:09:11 -0400
Message-Id: <159322725421.11274.1724284827781560113.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622101212.3922-1-jhasan@marvell.com>
References: <20200622101212.3922-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=819 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=849 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Jun 2020 03:12:10 -0700, Javed Hasan wrote:

> Kindly apply this series to scsi tree at your earliest convenience.
> 
> Thanks,
> Javed
> 
> Javed Hasan (2):
>   scsi: libfc: Handling of extra kref.
>   scsi: libfc: Skip additional kref updating work event.
> 
> [...]

Applied to 5.8/scsi-fixes, thanks!

[1/2] scsi: libfc: Handling of extra kref
      https://git.kernel.org/mkp/scsi/c/71f2bf85e90d
[2/2] scsi: libfc: Skip additional kref updating work event
      https://git.kernel.org/mkp/scsi/c/823a65409c89

-- 
Martin K. Petersen	Oracle Linux Engineering
