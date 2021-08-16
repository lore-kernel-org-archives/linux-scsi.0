Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1130BC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 18:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E71B660560
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 18:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhHPSWy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 14:22:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229722AbhHPSWx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 14:22:53 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GI2wGs185705;
        Mon, 16 Aug 2021 14:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ya7isapEC7ii6M1NCENtt8/TMcpfolcMJmHp87dY/T4=;
 b=Qci393ROx3mlC05Q2lpQ/x0CILYf7to4UdngVzr2KMiHYTa8oPgUvNhYHkWtMXanVIYU
 bcYEHSbcXIN9MZu4jHJNsfz5Kdt00KXS9OlUFFZhX/QI2YL7W+mPIH4QvYKqJXHWffbD
 jXMQwH0AGP8qG/yGRmzCcNidBlFRUY0ilumwv4+E2/IQCmnzCkq3osO+6i6KfPQpgsmW
 PvGOztgUJq2GsaOEZ9gxt5AENTefdJyCWfysqsioHkTkngKRZzm9H/P0nS7AUsShSwq7
 Y+jLOnuU5HmaJGW0SBA8xg0n5iNRetL1nHM26XIwUYIK4QzmsQP51zjYPtI/THDE4HYc 7g== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3afjmght8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 14:22:14 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GIIu0V005409;
        Mon, 16 Aug 2021 18:22:13 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 3ae5fbtrj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 18:22:13 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GIMCof6947506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 18:22:12 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A659B12405E;
        Mon, 16 Aug 2021 18:22:12 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB167124066;
        Mon, 16 Aug 2021 18:22:11 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.160.81.220])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 18:22:11 +0000 (GMT)
Subject: Re: [PATCH] ibmvfc: do not wait for initial device scan
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org
References: <20210809094929.3987-1-mwilck@suse.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <3d109139-679d-0f75-6bf7-dd93accc6a01@linux.ibm.com>
Date:   Mon, 16 Aug 2021 11:22:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809094929.3987-1-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TNev3xWqa3d9Fp4hS6u1XaEBMd-21ts_
X-Proofpoint-ORIG-GUID: TNev3xWqa3d9Fp4hS6u1XaEBMd-21ts_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_06:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 clxscore=1011 phishscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/21 2:49 AM, mwilck@suse.com wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> The initial device scan might take some time, and there really is
> no need to wait for it during probe().
> So return immediately from scsi_scan_host() during probe() and avoid
> any udev stalls during booting.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Pending a SOB from Martin...

Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>

