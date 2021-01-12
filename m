Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A7DC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F2392222B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406623AbhALQTp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 11:19:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406051AbhALQTk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 11:19:40 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CG62ld109811;
        Tue, 12 Jan 2021 11:09:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=eYhDlcctcc2cD1XoD7ylVybwm8pGhznp/qXjIgMQu1Y=;
 b=C+yzlHCew57SVpERqqp/3stoYEmzr08wu4sVsXHSYyYzvdvgDVTU5wQ+1VdmEdXQGGCd
 XBgzuZ+RI4dadDikdeYVS0V7R4E1VHeipm5MT51I3EiUvA7W6hPuamPzXgHBYiSK2c+O
 ogqpmhgExFs/N9MTwfD/gzDl5IcpqQOtZU0yW0Dya6UGA0N7rsNsP3bHSW7Rg332i6H0
 tXVwxL/sgO6EnKj1fVEPRKJhwyovx9MlqfXEnik5y/KQwwUQ0cO3PRJ/nlgcMA1bqv77
 AKPULazwPQsllLcdUBqkmUTz1Xu2CP+eUhl4aGVqskN/BtS2aPvoLpGYUJU6jwgXqDCf 1A== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361e7yshen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 11:09:39 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CG83PX031695;
        Tue, 12 Jan 2021 16:09:38 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 35y449cy5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 16:09:38 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CG9bHU15073756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 16:09:37 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 494D378064;
        Tue, 12 Jan 2021 16:09:37 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02D297805F;
        Tue, 12 Jan 2021 16:09:35 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.180.222])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 16:09:35 +0000 (GMT)
Message-ID: <b2a24db42b66ffbc6a9a39bf36ed31875795ae31.camel@linux.ibm.com>
Subject: Re: [PATCH 0/3] Improve comments in Adaptec AHA-154x driver
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ondrej Zary <linux@zary.sk>
Date:   Tue, 12 Jan 2021 08:09:34 -0800
In-Reply-To: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
References: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_10:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 mlxlogscore=993 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1011 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120090
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2021-01-10 at 19:45 +0300, Sergey Shtylyov wrote:
> Here are 3 patches against the 'for-next' branch of Martin Petersen's
> 'scsi.git' repo.
> I'm trying to clean up and improve the driver comments...

Do you actually have one of these?  The last known working one was
owned by Ondrej Zary (added to cc).  Since they're ISA only and that
hardware is pretty much dead, this class of drivers might be a good
candidate for removal.

James


