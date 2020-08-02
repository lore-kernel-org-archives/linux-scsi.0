Return-Path: <SRS0=GQ+9=BM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3B3C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Aug 2020 15:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B001D207BB
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Aug 2020 15:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgHBPrf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Aug 2020 11:47:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31704 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725768AbgHBPrf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2020 11:47:35 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 072FUkEA102520;
        Sun, 2 Aug 2020 11:47:25 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32nnk2tqvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 02 Aug 2020 11:47:25 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 072FjWvU025884;
        Sun, 2 Aug 2020 15:47:24 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 32n018husa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 02 Aug 2020 15:47:24 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 072FlNlp13959650
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 2 Aug 2020 15:47:23 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE36A7805E;
        Sun,  2 Aug 2020 15:47:23 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 592E77805C;
        Sun,  2 Aug 2020 15:47:22 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.85.201.133])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun,  2 Aug 2020 15:47:22 +0000 (GMT)
Message-ID: <1596383240.4087.8.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: esas2r: fix possible buffer overflow caused by
 bad DMA value in esas2r_process_fs_ioctl()
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Jia-Ju Bai <baijiaju@tsinghua.edu.cn>, linuxdrivers@attotech.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 02 Aug 2020 08:47:20 -0700
In-Reply-To: <20200802152145.4387-1-baijiaju@tsinghua.edu.cn>
References: <20200802152145.4387-1-baijiaju@tsinghua.edu.cn>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-02_10:2020-07-31,2020-08-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 spamscore=0 impostorscore=0 clxscore=1011 phishscore=0 suspectscore=18
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008020118
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-08-02 at 23:21 +0800, Jia-Ju Bai wrote:
> Because "fs" is mapped to DMA, its data can be modified at anytime by
> malicious or malfunctioning hardware. In this case, the check 
> "if (fsc->command >= cmdcnt)" can be passed, and then "fsc->command" 
> can be modified by hardware to cause buffer overflow.

This threat model seems to be completely bogus.  If the device were
malicious it would have given the mailbox incorrect values a priori ...
it wouldn't give the correct value then update it.  For most systems we
do assume correct operation of the device but if there's a worry about
incorrect operation, the usual approach is to guard the device with an
IOMMU which, again, would make this sort of fix unnecessary because the
IOMMU will have removed access to the buffer after the command
completed.

James

