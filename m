Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB04C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 20:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F27C26527E
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Mar 2021 20:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhCHUNN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:13:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231804AbhCHUNI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2021 15:13:08 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128K4aUi120413;
        Mon, 8 Mar 2021 15:13:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=Sfe7yhnJHrvEXiZOi0yOBXaWoC/v+Z66cKHjYJi3lRQ=;
 b=FysPKlCqSkPFL/qEueVHo/BMZrn4jDZnLGMH3IcDFihYdCMo37AXKccWtGgICXZ1GEEm
 2bJYV2UfEMonqFXBZHGhhIp5kkWoQ1QA5PlQBECfwvae5L3sHnzhu8dkKO/VbvD7RMiZ
 +5TusWzuY4SPg0znD3cyvhojfqSn1rUXU6Mp3hMMm61iVvo+X2RTDErG0QgdoVzxp0Tq
 Uvb1vIHTp7cbFipm7tc18w8t0LODs0bSFmaKY7VQtITSD1JV41X5VocUkTeC9ZDUq3Bv
 YmygPWjI7xUKbSXY1m15RjRV3VN4wq2Ze78F3m6VSYht7XJDApztR7i6xGE8c9SN+Y6c 5A== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375s27tvsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 15:13:04 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128KCrFG017862;
        Mon, 8 Mar 2021 20:13:04 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02dal.us.ibm.com with ESMTP id 3741c95gat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 20:13:04 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128KD2bs22413808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 20:13:02 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A0707807D;
        Mon,  8 Mar 2021 20:13:02 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B91A17808D;
        Mon,  8 Mar 2021 20:13:00 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.211.242])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 20:13:00 +0000 (GMT)
Message-ID: <88d9dda39a70df25b48e72247b9752d3dc5e2e8d.camel@linux.ibm.com>
Subject: Re: [PATCH v2][next] scsi: mpt3sas: Replace one-element array with
 flexible-array in struct _MPI2_CONFIG_PAGE_IO_UNIT_3
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Date:   Mon, 08 Mar 2021 12:12:59 -0800
In-Reply-To: <20210308193237.GA212624@embeddedor>
References: <20210202235118.GA314410@embeddedor>
         <20210308193237.GA212624@embeddedor>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_17:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=957 clxscore=1011 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103080104
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-03-08 at 13:32 -0600, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping: who can review/take this, please?

Well, before embarking on a huge dynamic update, let's ask Broadcom the
simpler question of why isn't MPI2_IO_UNIT_PAGE_3_GPIO_VAL_MAX simply
set to 36?  There's no dynamic allocation of anything in the current
code ... it's all hard coded to allocate 36 entries.  If there's no
need for anything dynamic then the kzalloc could become 

	io_unit_pg3 = kzalloc(sizeof(*io_unit_pg3), GFP_KERNEL);

James


