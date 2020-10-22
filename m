Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039B7C4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 10:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95E9E223BF
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 10:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896288AbgJVKJT convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 06:09:19 -0400
Received: from smtp.h3c.com ([60.191.123.56]:60869 "EHLO h3cspam01-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896261AbgJVKJS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Oct 2020 06:09:18 -0400
Received: from DAG2EX02-BASE.srv.huawei-3com.com ([10.8.0.65])
        by h3cspam01-ex.h3c.com with ESMTPS id 09MA8w1e086358
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Oct 2020 18:08:58 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66) by
 DAG2EX02-BASE.srv.huawei-3com.com (10.8.0.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 22 Oct 2020 18:09:01 +0800
Received: from DAG2EX03-BASE.srv.huawei-3com.com ([fe80::5d18:e01c:bbbd:c074])
 by DAG2EX03-BASE.srv.huawei-3com.com ([fe80::5d18:e01c:bbbd:c074%7]) with
 mapi id 15.01.2106.002; Thu, 22 Oct 2020 18:09:01 +0800
From:   Tianxianting <tian.xianting@h3c.com>
To:     Finn Thain <fthain@telegraphics.com.au>
CC:     "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>,
        "shivasharan.srikanteshwara@broadcom.com" 
        <shivasharan.srikanteshwara@broadcom.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: megaraid_sas: use spin_lock() in hard IRQ
Thread-Topic: [PATCH] scsi: megaraid_sas: use spin_lock() in hard IRQ
Thread-Index: AQHWp3ceROYVx1Vy20ukToM9T7xND6miYAoAgACPazD//4KKAIAA9PNA
Date:   Thu, 22 Oct 2020 10:09:00 +0000
Message-ID: <89c5cb05cb844939ae684db0077f675f@h3c.com>
References: <20201021064502.35469-1-tian.xianting@h3c.com>
 <alpine.LNX.2.23.453.2010221312460.6@nippy.intranet>
 <9923f28dd2b34499a17c53e8fa33f1ca@h3c.com>
 <alpine.LNX.2.23.453.2010221424390.6@nippy.intranet>
In-Reply-To: <alpine.LNX.2.23.453.2010221424390.6@nippy.intranet>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.141.128]
x-sender-location: DAG2
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DNSRBL: 
X-MAIL: h3cspam01-ex.h3c.com 09MA8w1e086358
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Yes, thanks
I see, If we add this patch, we need to get all cpu arch that support nested interrupts.

-----Original Message-----
From: Finn Thain [mailto:fthain@telegraphics.com.au] 
Sent: Thursday, October 22, 2020 11:29 AM
To: tianxianting (RD) <tian.xianting@h3c.com>
Cc: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com; shivasharan.srikanteshwara@broadcom.com; jejb@linux.ibm.com; martin.petersen@oracle.com; megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: RE: [PATCH] scsi: megaraid_sas: use spin_lock() in hard IRQ

On Thu, 22 Oct 2020, Tianxianting wrote:

> Do you mean Megasas raid can be used in m68k arch?

m68k is one example of an architecture on which the unstated assumptions in your patch would be invalid. Does this help to clarify what I wrote?

If Megasas raid did work on m68k, I'm sure it could potentially benefit from the theoretical performance improvement from your patch.

So perhaps you would consider adding support for slower CPUs like m68k.
