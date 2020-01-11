Return-Path: <SRS0=vbb9=3A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDC7C33C9E
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 07:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DDDE206DA
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jan 2020 07:21:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YC9QHauc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgAKHVZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jan 2020 02:21:25 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:16752 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728506AbgAKHVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jan 2020 02:21:25 -0500
X-UUID: fa7eec1aea814d15bc591475fc7bf00d-20200111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=UIl2WHNGAdH8h4XL4fSauTcsgNMglNAkpBeSnsVSD2c=;
        b=YC9QHaucfAv4FXkX/r8oZiSygvx61f2BPVnTyVQSy7nuo6xMz+7xFlXcO/a2hGTWS3z6O+Fm7dhaceI9sEnhhov6PCJMbspEIFcuhWGRzkaeJvJm0SmslXbMtPkcaD59OQg/QCE7im2BykyUuThaTxrCQ6rzSauhuxi9zseDoA8=;
X-UUID: fa7eec1aea814d15bc591475fc7bf00d-20200111
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 484932982; Sat, 11 Jan 2020 15:21:21 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Sat, 11 Jan 2020 15:20:11 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Sat, 11 Jan 2020 15:22:00 +0800
Message-ID: <1578727279.17435.9.camel@mtkswgap22>
Subject: Re: [PATCH 3/4] ufs: Simplify two tests
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, "Christoph Hellwig" <hch@lst.de>
Date:   Sat, 11 Jan 2020 15:21:19 +0800
In-Reply-To: <20200107192531.73802-4-bvanassche@acm.org>
References: <20200107192531.73802-1-bvanassche@acm.org>
         <20200107192531.73802-4-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: DC1383E3E1A717781C0B51E97AC2F9F3C342689D943FC14E431A96A89E7998042000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIwLTAxLTA3IGF0IDExOjI1IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IGxyYnAtPmNtZCBpcyBzZXQgb25seSBmb3IgU0NTSSBjb21tYW5kcy4gVXNlIHRoaXMga25v
d2xlZGdlIHRvIHNpbXBsaWZ5DQo+IHR3byBib29sZWFuIGV4cHJlc3Npb25zLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQoNClJldmll
d2VkLWJ5OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQoNCg==

