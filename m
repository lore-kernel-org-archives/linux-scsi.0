Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83444C433E5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 20:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FF3E2065D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 20:15:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NBWTbLiJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGOUPm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:15:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39030 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgGOUPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 16:15:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FKCALc035647;
        Wed, 15 Jul 2020 20:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=jYA/oNKDV5tuYlRC12bb44dQzKeSWg1Z+Lr/djLF7Xo=;
 b=NBWTbLiJ78ctYZAn84xzzyBw9i5TTW+BinidJ4Mfoe6Fx1nyH9QZvHLYSrp6kKI8sKZ0
 El7xeqLtQxdayLS1ob/SmYiR/atq8a+3fWQ6Jz80E6zPf6iIJdxUqq/xrN7fpzqzHCW2
 NA2Iku9ONLl+ZiDyW5oY3UInGZVcAd8Y1zVQmIUS4n+7gXzNaJ7yvGUKvZyecTDudQZC
 S7TdOyG9wAGZMS5/pjnkHMP3q1Yh71TLOYKhArpz91MPnq+3hBbZwmeoJ9D9QHtUK058
 NjJDUzBPqD/uNuDPmR9d+0JLY3IZDjoqKEIJrNvJZnq1Ki2kyfLuEfglFZM8swALIRzf 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274urdn2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 20:14:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FKCh4i018101;
        Wed, 15 Jul 2020 20:14:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 327qc1n1tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 20:14:37 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FKERjY002445;
        Wed, 15 Jul 2020 20:14:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 13:14:27 -0700
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Simon Arlott <simon@octiron.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Pavel Machek <pavel@ucw.cz>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 1/2] reboot: add a "power cycle" quirk to prepare for a
 power off on reboot
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Message-ID: <yq1sgdso7sc.fsf@ca-mkp.ca.oracle.com>
References: <f4a7b539-eeac-1a59-2350-3eefc8c17801@0882a8b5-c6c3-11e9-b005-00805fc181fe>
        <20200715181145.GA17753@infradead.org>
Date:   Wed, 15 Jul 2020 16:14:23 -0400
In-Reply-To: <20200715181145.GA17753@infradead.org> (Christoph Hellwig's
        message of "Wed, 15 Jul 2020 19:11:45 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150155
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Except for the fact that I think that usage of the BIT() macro is
> a horrible pattern, this looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good to me too.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
