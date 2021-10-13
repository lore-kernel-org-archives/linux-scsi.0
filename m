Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B589C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 17:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 545F4610FE
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 17:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhJMRgt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:36:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1660 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhJMRgs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 13:36:48 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19DGJURv020660;
        Wed, 13 Oct 2021 13:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=UpaJ9LfYVr98ljuqfJdJcBNu68DCZkrF9ck2+xfaNMA=;
 b=ZJ6C+gGVVdEvz/uL/OQW+rP2pEwE1BNOqnwfCw1eiRZFUVw9bdSOfKA4bwdZHQW6cKTO
 eCLdpkqmzEtBIbdy8tRTJrTnx+A41jmdzHgVKdEFlbY3v4jqm7n8ELXF4e6O/DM8o1a8
 O6ucoRAkERwhIGYw3YwSk3hX/Mo8tBCVk0v++7qjzzN/DR1CO9GZrSpydZwV5BNIfH1a
 v9aTT2h8DUd3R4fybAZfByhdEjB77Q6TSrSsS3iDem3b6qYFi12WxlHmC7O6kj0Iw3/G
 K2c/+3fln5GIi2s8kAQx7tngxthKHQMA8cqF2EY5k7mxLm6aFpNQ53Uv11nJi2wiyiw+ 0Q== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnwb5hk2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 13:34:40 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DHHWno023130;
        Wed, 13 Oct 2021 17:34:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3bk2qad7p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 17:34:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DHYY4859310504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 17:34:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B149BAE053;
        Wed, 13 Oct 2021 17:34:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EFECAE051;
        Wed, 13 Oct 2021 17:34:34 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.52.41])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 13 Oct 2021 17:34:34 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mai9C-000fcO-4m; Wed, 13 Oct 2021 19:34:34 +0200
Date:   Wed, 13 Oct 2021 19:34:34 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v4 06/46] scsi: zfcp: Switch to attribute groups
Message-ID: <YWcYqmyLbzEU2fd5@t480-pf1aa2c2.linux.ibm.com>
References: <20211012233558.4066756-1-bvanassche@acm.org>
 <20211012233558.4066756-7-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20211012233558.4066756-7-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8deFJnKe19vPRaQ1nMkv-cTAQDFZCv3A
X-Proofpoint-ORIG-GUID: 8deFJnKe19vPRaQ1nMkv-cTAQDFZCv3A
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_06,2021-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110130106
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hey Bart,

thanks for the change.

On Tue, Oct 12, 2021 at 04:35:18PM -0700, Bart Van Assche wrote:
> struct device supports attribute groups directly but does not support
> struct device_attribute directly. Hence switch to attribute groups.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/s390/scsi/zfcp_ext.h   |  4 +--
>  drivers/s390/scsi/zfcp_scsi.c  |  4 +--
>  drivers/s390/scsi/zfcp_sysfs.c | 52 +++++++++++++++++++++++-----------
>  3 files changed, 39 insertions(+), 21 deletions(-)
> 

Acked-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
