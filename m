Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBE4C77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 12:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbjDYMTU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 08:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbjDYMTT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 08:19:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C71BCC27
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 05:19:18 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PC6EjK031686;
        Tue, 25 Apr 2023 12:19:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=9lXsso5Y+woH23HTY390bpxId6Mi/5U0ojGHRtGvO98=;
 b=F4MdArobEtn1b3/Kgku/leLQnHQeg9jcN1jGdFeew/Sh2zMsh9As0ovos0+vF0cQOtZr
 OU/Z3Ld0Lvgf0xoJxRYOl4uFHqKN3CzZPyMXcGzrDbEPLrHRtC3CDmqBCl4Ju1y95XjK
 NIyHNMUCyHWSazJjTAuDVk3baLvRB4u3mLTzCEiz6FWXC96D5L+bz3mVJNkFRRdAM8h8
 ufH6Aqqg1F6vj7Dre4nX03DTrxzH3zf2+u4mwXeJGjXYADMhr1iLxc7XxB1C0UJCVy5M
 5FkYh8vZGv3CP3wXbgNRNHbejDqbffy+Eke6eV16j8+wLZHzYnhRv9cTlsaFKRq+xT4X jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6dweswrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 12:19:15 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33PCJEhm012754;
        Tue, 25 Apr 2023 12:19:14 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6dweswqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 12:19:14 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33PCDa3d016584;
        Tue, 25 Apr 2023 12:19:12 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([9.208.129.118])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3q477846ft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 12:19:12 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33PCJBNx5177926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 12:19:11 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1FB458059;
        Tue, 25 Apr 2023 12:19:10 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BD4E58057;
        Tue, 25 Apr 2023 12:19:10 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.118.80])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Apr 2023 12:19:10 +0000 (GMT)
Message-ID: <3d6d4bdfb945af6787f2d1184ddb6eb9968fd753.camel@linux.ibm.com>
Subject: Re: [PATCH] Add a parameter to set sd driver's probe mode.
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "longguang.yue" <bigclouds@163.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 25 Apr 2023 08:19:09 -0400
In-Reply-To: <20230425075948.87632-1-bigclouds@163.com>
References: <20230425075948.87632-1-bigclouds@163.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M-cNpReNRvKBgDj6P_RVYJKENf-UjG8a
X-Proofpoint-ORIG-GUID: T6qWMaioWRUbtIh9B-Eu6jzZL9BuX-sT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_05,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304250108
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-04-25 at 15:59 +0800, longguang.yue wrote:
> Asynchronous probe leads to the change of disk name, so it is hard
> to trace disk by its name for monitoring system.

This won't work: just not doing async sd attach doesn't fix all the
other causes of asynchronicity that cause sd names to change. You need
to look at addressing disks by one of the permanent /dev/disk/by-*
device files.

James

