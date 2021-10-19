Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8C3C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 11:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C7C461360
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 11:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhJSLwD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 07:52:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235389AbhJSLwD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 07:52:03 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JBMpk0018507;
        Tue, 19 Oct 2021 07:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=YVym69FC3F6RBxqQCTeNOTA6/17KkVrLpsXQothSL9c=;
 b=FGnVuyehNIsy0kBoiF943lImDn4eJuv2Nf9aX4DfLTOw2Sph7x85ERxpXcTrSzCNLVCZ
 z6gE+8Xi5fuPC4b+qmMvsZT2H/EtbM4THAiX+Ayl0jZjF1V0/81JE9laQq0rYfzc+1MH
 HOilGUoTTf4ShV/L2fwGDUU2ni1sPXIPwXUepxhcTDaYv4nw4Z4soGM0duzperldEzcT
 V4O3Y5N/f5VNZn5MhEDTeQ2sBSY8yBVcNFVY4j+wnElO7M5NhM1Exva4s5qcGD5/tRUo
 JwUc16XsuBQfS8zdQ9YhkSJyhphJvnhJ3sshV+IDfusP4swrq4TtggYkbiXhN7NBRaBQ tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bsw3j8fkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 07:49:46 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19JBTWU0020883;
        Tue, 19 Oct 2021 07:49:46 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bsw3j8fks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 07:49:45 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19JBlQNn028301;
        Tue, 19 Oct 2021 11:49:45 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 3bqpcbqtnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 11:49:45 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19JBnhJr35127564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 11:49:43 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C005D78060;
        Tue, 19 Oct 2021 11:49:43 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 106F47805F;
        Tue, 19 Oct 2021 11:49:42 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.211.92.132])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 19 Oct 2021 11:49:42 +0000 (GMT)
Message-ID: <85c7ad79ae3b99f92a98e08ca30c4a1763dc3517.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: core: return -ENOMEM on ips_init_phase1()
 allocation failure
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        aacraid@microsemi.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 19 Oct 2021 07:49:41 -0400
In-Reply-To: <1634640655-20667-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1634640655-20667-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RQbYUKnLy0WPGXiNM5OZ44jXzPsv2QFI
X-Proofpoint-GUID: GS98lFS_ZCGUlM3kZqdJ1blu58ESlnrs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_01,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxlogscore=999
 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190068
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-10-19 at 18:50 +0800, Jiapeng Chong wrote:
> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> 
> Fixes the following smatch warning:
> 
> drivers/scsi/ips.c:6901 ips_init_phase1() warn: returning -1 instead
> of -ENOMEM is sloppy.

Really, like megaraid, it's not.  ips_init_phase1() returns either
Success or -1.  If it returns -1, that gets translated to -ENODEV so,
again, we'd lose this nuanced return completely.

James


