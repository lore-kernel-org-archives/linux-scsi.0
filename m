Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91DC3C3F2D7
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 09:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6719A208CD
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 09:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EF6LLhF6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgCEJKC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 04:10:02 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:41311 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725816AbgCEJKC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 04:10:02 -0500
X-UUID: 49dc4ff74c7643aa9c70799fe0c93137-20200305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=lb8cJIrdrjqVwgkadpjFpgOFoiVn2GTpdvZVTRhG89U=;
        b=EF6LLhF61AymTFvSM0TxDMZgRMHD5Q6q2bgGM8pMvNVlYeBLEgpmvDV//bbRqUqlDrp+RygCDVaIIgDbwKMIZnQehhMrzcofCsPNrd9ApcWQbvrIvCjtzY2Wx3ZxyizAf4XbdpdAubDqj516ZVwMuGcbH69JuhnSJcL6HUo2A4M=;
X-UUID: 49dc4ff74c7643aa9c70799fe0c93137-20200305
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 822943832; Thu, 05 Mar 2020 17:09:55 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkexhb02.mediatek.inc
 (172.21.101.103) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 5 Mar
 2020 17:08:31 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 5 Mar 2020 17:09:07 +0800
Message-ID: <1583399393.14250.5.camel@mtksdccf07>
Subject: Re: [PATCH v1 1/1] scsi: ufs: Fix possible unclocked access to auto
 hibern8 timer register
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     <asutoshd@codeaurora.org>, <nguyenb@codeaurora.org>,
        <hongwus@codeaurora.org>, <rnayak@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <kernel-team@android.com>,
        <saravanak@google.com>, <salyzyn@google.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        "open list" <linux-kernel@vger.kernel.org>
Date:   Thu, 5 Mar 2020 17:09:53 +0800
In-Reply-To: <1583398391-14273-1-git-send-email-cang@codeaurora.org>
References: <1583398391-14273-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQ2FuLA0KDQpPbiBUaHUsIDIwMjAtMDMtMDUgYXQgMDA6NTMgLTA4MDAsIENhbiBHdW8gd3Jv
dGU6DQo+IEJlZm9yZSBhY2Nlc3MgYXV0byBoaWJuZXI4IHRpbWVyIHJlZ2lzdGVyLCBtYWtlIHN1
cmUgcG93ZXIgYW5kIGNsb2NrIGFyZQ0KPiBwcm9wZXJseSBjb25maWd1cmVkIHRvIGF2b2lkIHVu
Y2xvY2tlZCByZWdpc3RlciBhY2Nlc3MuDQo+IA0KPiBGaXhlczogYmE3YWY1ZWM1MTI2ICgic2Nz
aTogdWZzOiBleHBvcnQgdWZzaGNkX2F1dG9faGliZXJuOF91cGRhdGUgZm9yIHZlbmRvciB1c2Fn
ZSIpDQo+IFNpZ25lZC1vZmYtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQoNClRo
YW5rcyBmb3IgZml4aW5nIHRoaXMhDQoNClJldmlld2VkLWJ5OiBTdGFubGV5IENodSA8c3Rhbmxl
eS5jaHVAbWVkaWF0ZWsuY29tPg0KDQo=

