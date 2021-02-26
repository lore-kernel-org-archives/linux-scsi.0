Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35900C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 16:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BFB964F0D
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 16:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhBZQkC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 11:40:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229993AbhBZQj6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Feb 2021 11:39:58 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11QGXMxZ013154;
        Fri, 26 Feb 2021 11:39:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pqOo7IEXZuN4o2GJtHjkXskjvWSpvNljjvnukPmdQyc=;
 b=f8e9Vi8/lklPfvZdQ8ZWF5Y6vjqXxp7Ukz7d2dGtXKlWCyJgKexLqxzHPoxq6mo0pnee
 ohKUFJAICiUi+GzSdaM0ggkf0aq5mEyYLHwW9fRHu/rk52PQTqJQsxiDWuOvKRLVda++
 o9RQSuQBb103x0zxYod13oqjRy87VvFdubKwhxMRCZ5zW9GPb4s76XmKDPoLC8NiGrDU
 9ym8rrn7m3kakbq5VYsAWu07svLpZAvhnEN/kqJcDeDPPFPFJ8upkmDAZb0IwsQoMmCu
 fGgvIf48oTeDX4FVsTHeZMeYkbRlE3jpX5rdA9Wv4l2IiQEhvMBBn3MTF5uWGPA8a2BQ ig== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xphv13vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 11:39:09 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11QGVvqt010940;
        Fri, 26 Feb 2021 16:39:07 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma05wdc.us.ibm.com with ESMTP id 36y2re0vph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 16:39:07 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11QGd7QZ14680536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 16:39:07 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 598B328064;
        Fri, 26 Feb 2021 16:39:07 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55C932805A;
        Fri, 26 Feb 2021 16:39:06 +0000 (GMT)
Received: from oc6034535106.ibm.com (unknown [9.211.115.75])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 26 Feb 2021 16:39:06 +0000 (GMT)
Subject: Re: [PATCH v4 2/5] ibmvfc: fix invalid sub-CRQ handles after hard
 reset
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
References: <20210225215057.23020-1-tyreld@linux.ibm.com>
 <20210225215057.23020-3-tyreld@linux.ibm.com>
From:   Brian King <brking@linux.vnet.ibm.com>
Message-ID: <3309f472-51ca-e2f5-8b74-0dfb9382e53a@linux.vnet.ibm.com>
Date:   Fri, 26 Feb 2021 10:39:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210225215057.23020-3-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-26_05:2021-02-26,2021-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=885
 malwarescore=0 suspectscore=0 priorityscore=1501 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260123
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

