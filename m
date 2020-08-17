Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12045C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 14:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E35352075B
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 14:42:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Nhzf/OK0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgHQOmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 10:42:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15582 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728666AbgHQOmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Aug 2020 10:42:18 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07HEVXkY130903;
        Mon, 17 Aug 2020 10:42:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=CP6vcSYBECD3e0xjbwnlOIXeRbFh5BiaUL23BY56z1c=;
 b=Nhzf/OK0HRa6jhfq+1WQh2FYIffI+MN0yP4+ma0LxSCvE3RziTnuPH6aDEjYn/wfuFCk
 t4QGGdJh/QO0BngPpkrXJv2H79601e5DZAYJnl2GHDEzJpFz7im6JcqvdKJa0p9A3gvy
 ETKoqi1qYRkvTeEpdj1haD39nFCu7FisnHv95+vl5gXkioT2sI6fUUcVixSoVQbneADw
 OoLTXzytblxZysMYm0fjJ5+BD9xAIWn9f2GlWP1BhSV+9GZ0q9Ea/X3FCZyA5QB1LUuN
 4Pc9x0r9qjdzqZCQj5cBAwOAMSdPE6nFvrj1xP9Zc1KtA4F7eAMrhnJP4gM68/ZBj0Na oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32y7tps5wa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Aug 2020 10:42:04 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07HEWMvk134326;
        Mon, 17 Aug 2020 10:42:03 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32y7tps5vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Aug 2020 10:42:03 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07HEaB6i026893;
        Mon, 17 Aug 2020 14:42:02 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 32yaeqp643-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Aug 2020 14:42:02 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07HEg19x44761428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 14:42:01 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD4E67805C;
        Mon, 17 Aug 2020 14:42:01 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 854C97805E;
        Mon, 17 Aug 2020 14:41:59 +0000 (GMT)
Received: from [153.66.254.174] (unknown [9.80.233.55])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 17 Aug 2020 14:41:59 +0000 (GMT)
Message-ID: <1597675318.4475.11.camel@linux.ibm.com>
Subject: Re: [PATCH 0/8] scsi: convert tasklets to use new tasklet_setup()
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Allen Pais <allen.cryptic@gmail.com>, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Cc:     keescook@chromium.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        Allen Pais <allen.lkml@gmail.com>
Date:   Mon, 17 Aug 2020 07:41:58 -0700
In-Reply-To: <20200817085409.25268-1-allen.cryptic@gmail.com>
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-17_10:2020-08-17,2020-08-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170108
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-08-17 at 14:24 +0530, Allen Pais wrote:
> From: Allen Pais <allen.lkml@gmail.com>
> 
> Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
> introduced a new tasklet initialization API. This series converts 
> all the scsi drivers to use the new tasklet_setup() API

I've got to say I agree with Jens, this was a silly obfuscation:

+#define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
+       container_of(callback_tasklet, typeof(*var), tasklet_fieldname)

Just use container_of directly since we all understand what it does.

James

