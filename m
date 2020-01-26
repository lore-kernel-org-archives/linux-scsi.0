Return-Path: <SRS0=GUYw=3P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01AE4C2D0DB
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 16:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D55062071E
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 16:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgAZQSc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jan 2020 11:18:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725838AbgAZQSc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jan 2020 11:18:32 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00QGEEH3153606;
        Sun, 26 Jan 2020 11:18:28 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xrg6142hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 26 Jan 2020 11:18:27 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 00QGF2jp014682;
        Sun, 26 Jan 2020 16:18:27 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 2xrda5wk0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 26 Jan 2020 16:18:27 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00QGIQKc48365894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 16:18:26 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70468AC05F;
        Sun, 26 Jan 2020 16:18:26 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 906EBAC05E;
        Sun, 26 Jan 2020 16:18:25 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.85.196.120])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 26 Jan 2020 16:18:25 +0000 (GMT)
Message-ID: <1580055504.4964.2.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: mvsas: ensure loop counter phy_no  does not wrap
 and cause an infinite loop
From:   James Bottomley <jejb@linux.ibm.com>
To:     Colin King <colin.king@canonical.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 26 Jan 2020 08:18:24 -0800
In-Reply-To: <20200126151747.33320-1-colin.king@canonical.com>
References: <20200126151747.33320-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-26_02:2020-01-24,2020-01-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001260140
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-01-26 at 15:17 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The loop counter phy_no is a u8 where as the upper limit of the loop
> is a u32. In the event that upper limit is greater than 255 we end
> up with an infinite loop since phy_no will wrap around an never reach
> upper loop limit. Fix this by making phy_no a u32.

This value is limited to MVS_MAX_PHYS (i.e. 8) so I don't see where the
concern comes from.  If we were ever to overrun that, we'd corrupt the
chip info structure, because it only allows MVS_MAX_PHYS for the amount
of space.

James

