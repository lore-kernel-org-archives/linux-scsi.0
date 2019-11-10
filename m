Return-Path: <SRS0=5ueY=ZC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C4CC17443
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 19:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A6EA20818
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 19:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfKJTfZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 14:35:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbfKJTfZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Nov 2019 14:35:25 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAAJWegn062982;
        Sun, 10 Nov 2019 14:35:17 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w6be838yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Nov 2019 14:35:17 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id xAAJXEfi064039;
        Sun, 10 Nov 2019 14:35:16 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w6be838yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Nov 2019 14:35:16 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAAJP597011453;
        Sun, 10 Nov 2019 19:35:15 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 2w5n35j5x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Nov 2019 19:35:15 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAAJZFbC36897122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Nov 2019 19:35:15 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0CC6112062;
        Sun, 10 Nov 2019 19:35:14 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20BA7112063;
        Sun, 10 Nov 2019 19:35:14 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.85.190.120])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 10 Nov 2019 19:35:13 +0000 (GMT)
Message-ID: <1573414513.3230.4.camel@linux.ibm.com>
Subject: Re: [PATCH] zorro_esp: increase maximum dma length to 65536 bytes
From:   James Bottomley <jejb@linux.ibm.com>
To:     Michael Schmitz <schmitzmic@gmail.com>,
        Kars de Jong <jongk@linux-m68k.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Date:   Sun, 10 Nov 2019 11:35:13 -0800
In-Reply-To: <6b914b12-cbc7-6fe6-7cba-3e89b2f6f19b@gmail.com>
References: <CACz-3rh9ZCyU1825yU8xxty5BGrwFhpbjKNoWnn0mGiv_h2Kag@mail.gmail.com>
         <20191109191400.8999-1-jongk@linux-m68k.org>
         <1573330351.3650.4.camel@linux.ibm.com>
         <6b914b12-cbc7-6fe6-7cba-3e89b2f6f19b@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-10_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=828 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911100194
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2019-11-10 at 15:36 +1300, Michael Schmitz wrote:
> All of the old board-specific drivers used a max transfer length of 
> 0x1000000, only the fastlane driver used 0xfffc. That lower limit
> might be due to a DMA limitation on the fastlane board. We could
> accommodate  the different limit for this board by using a board-
> specific  dma_length_limit() callback...

Sure, that implies the minimum dma burst length is 4 bytes ...

> > case for any of the cards the zorro_esp drives, it might be better
> > to lower the max length to 61440 (64k-4k) so the residual is a
> > page.
> 
> For the benefit of keeping the code simple, and avoid retesting the 
> fastlane board, that might indeed be the better solution.

... which means you don't have to lower the limit by 4k as I suggested,
 because I was being incredibly conservative about what the dma burst
length might be, just use 0xfffc as the default.  I think raising to
0x1000000 for boards which can support it is fine too if you want to
add the extra logic to the driver.

James

