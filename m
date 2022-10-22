Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28891C04A95
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Oct 2022 03:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiJVDwg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 23:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJVDwd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 23:52:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043432958FE
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 20:52:33 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29M1htbI007730;
        Sat, 22 Oct 2022 03:52:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=yZEsjrjdwol8QcUOZpvcm2hX0Z9teHkM0JcprodIqCc=;
 b=bIlyeSj4kxyYqKve8gwvIRAZ63ZJYwVvoTKS2pZ+6AcoFbsskYivGUVj1SuwmxHxGsgy
 mmRqmpqHbmcfITvAlNIdueqnFHqlzacfmj0ZZKxqEszxVT88tRP4Gi3/1B8J4hQvJ5lr
 5eUqVTRRg/0clAXWQiYFxwr6IFt9T/yCQkw3n+oAUVOldkJ7b9mhtZxUnSAV54I85Lz8
 +ud66z5i9Ea6K2F6uk6yoXAFmqJJjh7bUQZXKwf91twA+kVoT7/O4up0dzdwcPKdLP7S
 oV014yoz7XDQV3c5V9Ar4gRr/kmgU1T/b61n3Czga5WBB7FSv0HBl0L1N6EDKAi4z4Zq Qw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741g2mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:52:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29M1XXv8015255;
        Sat, 22 Oct 2022 03:52:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y8hk7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Oct 2022 03:52:26 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29M3qOMI004796;
        Sat, 22 Oct 2022 03:52:26 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kc6y8hk7g-3;
        Sat, 22 Oct 2022 03:52:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Andrew Konecki <awkonecki@google.com>,
        Jolly Shah <jollys@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Display proc_name in sysfs
Date:   Fri, 21 Oct 2022 23:52:18 -0400
Message-Id: <166641048598.3488171.18052773811685140212.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221007230651.308969-1-ipylypiv@google.com>
References: <20221007230651.308969-1-ipylypiv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=833 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210220021
X-Proofpoint-GUID: fh-9_apgVW7OkoR71gzZb6zQc-rRf_gl
X-Proofpoint-ORIG-GUID: fh-9_apgVW7OkoR71gzZb6zQc-rRf_gl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 7 Oct 2022 16:06:51 -0700, Igor Pylypiv wrote:

> The proc_name entry in sysfs for pm80xx is "(null)" because it is
> not initialized in scsi_host_template:
> 
> Before:
> host:~# cat /sys/class/scsi_host/host6/proc_name
> (null)
> 
> [...]

Applied to 6.1/scsi-fixes, thanks!

[1/1] scsi: pm80xx: Display proc_name in sysfs
      https://git.kernel.org/mkp/scsi/c/181dfce9b63b

-- 
Martin K. Petersen	Oracle Linux Engineering
