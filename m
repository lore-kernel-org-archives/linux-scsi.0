Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5288FC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 06:47:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 309ED20809
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 06:47:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AjKvVfah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgG2Grq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 02:47:46 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:41461 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726992AbgG2Grp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 02:47:45 -0400
X-UUID: 72d84b59dde74e75b23aca5bac4e0f35-20200729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=4Wp6qYtVm3ruKgDXHtkTEVIVi35QXL1gY0DmVlHqw0s=;
        b=AjKvVfahjhvuIXrKbgQhZ0NDfn5E6NF1LkrBZn3iHMcc8nxsi4sxqYYckPwF25iioamXVNirh8OmH5Rz9bypFYPhiLkuy7SiNTVZFeFivD5na428w/HpCOFVvvYnesL2hkkTfpfEQcjXrmBAdUW5GGX08Ol3TgziL4nVAztYn0c=;
X-UUID: 72d84b59dde74e75b23aca5bac4e0f35-20200729
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 317222806; Wed, 29 Jul 2020 14:47:41 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Jul 2020 14:47:32 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by mtkcas07.mediatek.inc
 (172.21.101.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 14:47:33 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Jul 2020 14:47:28 +0800
Message-ID: <1596005252.17247.6.camel@mtkswgap22>
Subject: Re: [PATCH v7 1/8] scsi: ufs: Add checks before setting clk-gating
 states
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Can Guo <cang@codeaurora.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 29 Jul 2020 14:47:32 +0800
In-Reply-To: <1595912460-8860-2-git-send-email-cang@codeaurora.org>
References: <1595912460-8860-1-git-send-email-cang@codeaurora.org>
         <1595912460-8860-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTI4IGF0IDEzOjAwICswODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBDbG9j
ayBnYXRpbmcgZmVhdHVyZXMgY2FuIGJlIHR1cm5lZCBvbi9vZmYgc2VsZWN0aXZlbHkgd2hpY2gg
bWVhbnMgaXRzDQo+IHN0YXRlIGluZm9ybWF0aW9uIGlzIG9ubHkgaW1wb3J0YW50IGlmIGl0IGlz
IGVuYWJsZWQuIFRoaXMgY2hhbmdlIG1ha2VzDQo+IHN1cmUgdGhhdCB3ZSBvbmx5IGxvb2sgYXQg
c3RhdGUgb2YgY2xrLWdhdGluZyBpZiBpdCBpcyBlbmFibGVkLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogQ2FuIEd1byA8Y2FuZ0Bjb2RlYXVyb3JhLm9yZz4NCj4gUmV2aWV3ZWQtYnk6IEF2cmkgQWx0
bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KPiBSZXZpZXdlZC1ieTogSG9uZ3d1IFN1IDxob25n
d3VzQGNvZGVhdXJvcmEub3JnPg0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXku
Y2h1QG1lZGlhdGVrLmNvbT4NCg0KDQoNCg==

