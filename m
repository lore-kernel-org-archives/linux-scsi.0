Return-Path: <SRS0=dDgG=ZB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134A7C17440
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 20:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E837321882
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 20:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfKIUMk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 15:12:40 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49520 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726349AbfKIUMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2019 15:12:40 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA9KCEBX110576;
        Sat, 9 Nov 2019 15:12:34 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w5t7479jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 09 Nov 2019 15:12:34 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xA9K9pdd011837;
        Sat, 9 Nov 2019 20:12:33 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma05wdc.us.ibm.com with ESMTP id 2w5n35e5na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 09 Nov 2019 20:12:33 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA9KCX3842926470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 9 Nov 2019 20:12:33 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45EF728058;
        Sat,  9 Nov 2019 20:12:33 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D30428059;
        Sat,  9 Nov 2019 20:12:32 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.85.190.120])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat,  9 Nov 2019 20:12:32 +0000 (GMT)
Message-ID: <1573330351.3650.4.camel@linux.ibm.com>
Subject: Re: [PATCH] zorro_esp: increase maximum dma length to 65536 bytes
From:   James Bottomley <jejb@linux.ibm.com>
To:     Kars de Jong <jongk@linux-m68k.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Date:   Sat, 09 Nov 2019 12:12:31 -0800
In-Reply-To: <20191109191400.8999-1-jongk@linux-m68k.org>
References: <CACz-3rh9ZCyU1825yU8xxty5BGrwFhpbjKNoWnn0mGiv_h2Kag@mail.gmail.com>
         <20191109191400.8999-1-jongk@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-09_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911090207
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2019-11-09 at 20:14 +0100, Kars de Jong wrote:
> When using this driver on a Blizzard 1260, there were failures
> whenever DMA transfers from the SCSI bus to memory of 65535 bytes
> were followed by a DMA transfer of 1 byte. This caused the byte at
> offset 65535 to be overwritten with 0xff. The Blizzard hardware can't
> handle single byte DMA transfers.
> 
> Besides this issue, limiting the DMA length to something that is not
> a multiple of the page size is very inefficient on most file systems.
> 
> It seems this limit was chosen because the DMA transfer counter of
> the ESP by default is 16 bits wide, thus limiting the length to 65535
> bytes. However, the value 0 means 65536 bytes, which is handled by
> the ESP and the Blizzard just fine. It is also the default maximum
> used by esp_scsi when drivers don't provide their own
> dma_length_limit() function.

Have you tested this on any other hardware?  the reason most legacy
hardware would have a setting like this is because they have a two byte
transfer length register and zero doesn't mean 65536.  If this is the
case for any of the cards the zorro_esp drives, it might be better to
lower the max length to 61440 (64k-4k) so the residual is a page.

James

