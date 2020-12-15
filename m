Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2E6C4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 05:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC8772078B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 05:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgLOF44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 00:56:56 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:58117 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726176AbgLOF4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 00:56:43 -0500
X-UUID: ae992032e7e349888f38e9bc98d40e7f-20201215
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=CYiOZ6PdNxQ0j+f8JPGmAHyNbWoWuF7ovz3Dtyhtmk8=;
        b=SuI65ctyGlnxgCCu+cQ1MFtmO+P0mcW6ExMirH/b3OZwaDmpHbDOHoHOb+02WvH07JvKi+7KT0RX4eRZXTNKWO526OxG5jLXQV/JQX5F+dnSwy0fzuCI7vA7qY6oImxWf6QDDFbFtrf81yvu46eU+bdSq2xAFz3bY5TyIXj79Is=;
X-UUID: ae992032e7e349888f38e9bc98d40e7f-20201215
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 852235717; Tue, 15 Dec 2020 13:55:54 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 15 Dec 2020 13:55:53 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Dec 2020 13:55:53 +0800
Message-ID: <1608011753.10163.10.camel@mtkswgap22>
Subject: Re: [PATCH v4 2/3] scsi: ufs: Clean up
 ufshcd_exit_clk_scaling/gating()
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
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 15 Dec 2020 13:55:53 +0800
In-Reply-To: <1607877104-8916-3-git-send-email-cang@codeaurora.org>
References: <1607877104-8916-1-git-send-email-cang@codeaurora.org>
         <1607877104-8916-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gU3VuLCAyMDIwLTEyLTEzIGF0IDA4OjMxIC0wODAwLCBDYW4gR3VvIHdyb3RlOg0KPiB1ZnNo
Y2RfaGJhX2V4aXQoKSBpcyBhbHdheXMgY2FsbGVkIGFmdGVyIHVmc2hjZF9leGl0X2Nsa19zY2Fs
aW5nKCkgYW5kDQo+IHVmc2hjZF9leGl0X2Nsa19nYXRpbmcoKSwgc28gbW92ZSB1ZnNoY2RfZXhp
dF9jbGtfc2NhbGluZy9nYXRpbmcoKSB0bw0KPiB1ZnNoY2RfaGJhX2V4aXQoKS4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IENhbiBHdW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQoNClJldmlld2VkLWJ5
OiBTdGFubGV5IENodSA8c3RhbmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KDQoNCg==

