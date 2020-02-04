Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC20C3524A
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 06:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05D9E20674
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 06:16:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rmUKf7PL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgBDGQN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 01:16:13 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:56447 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726230AbgBDGQM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 01:16:12 -0500
X-UUID: 4bc5ab67a75149aa849307972e40adcf-20200204
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=jSycVRSOFd2olBoUxTQ1F0UloNW9XP6EQGdyyzGjoj4=;
        b=rmUKf7PL2J+9qtVAMyutow0HN4h2jEKjyEobYnrAtPMYJAQ+rVvPxjg1Bdn8H3Pq5j9ifmniUR3jZMB5RRgLcztJOULHnxJTisZNHiFvvP/tLIsSJoy/kWdcraegYLelpn8JatnjubYzyeCcbhWpP1T2bSP5Y0yBSUCkBeYNWy0=;
X-UUID: 4bc5ab67a75149aa849307972e40adcf-20200204
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 311145982; Tue, 04 Feb 2020 14:16:04 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 4 Feb 2020 14:15:19 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 4 Feb 2020 14:15:45 +0800
Message-ID: <1580796963.21785.1.camel@mtksdccf07>
Subject: Re: [PATCH v5 2/8] scsi: ufs: set load before setting voltage in
 regulators
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
Date:   Tue, 4 Feb 2020 14:16:03 +0800
In-Reply-To: <1580721472-10784-3-git-send-email-cang@codeaurora.org>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
         <1580721472-10784-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIwLTAyLTAzIGF0IDAxOjE3IC0wODAwLCBDYW4gR3VvIHdyb3RlOg0KPiBGcm9t
OiBBc3V0b3NoIERhcyA8YXN1dG9zaGRAY29kZWF1cm9yYS5vcmc+DQo+IA0KPiBUaGlzIHNlcXVl
bmNlIGNoYW5nZSBpcyByZXF1aXJlZCB0byBhdm9pZCBkaXBzIGluIHZvbHRhZ2UNCj4gZHVyaW5n
IGJvb3QtdXAuDQo+IA0KPiBBcHBhcmVudGx5LCB0aGlzIGRpcCBpcyBjYXVzZWQgYmVjYXVzZSBp
biB0aGUgb3JpZ2luYWwNCj4gc2VxdWVuY2UsIHRoZSByZWd1bGF0b3JzIGFyZSBpbml0aWFsaXpl
ZCBpbiBscG0gbW9kZS4NCj4gQW5kIHRoZW4gd2hlbiB0aGUgbG9hZCBpcyBzZXQgdG8gaGlnaCwg
YW5kIG1vcmUgY3VycmVudA0KPiBpcyBkcmF3biwgdGhhbiBpcyBhbGxvd2VkIGluIGxwbSwgdGhl
IGRpcCBpcyBzZWVuLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQXN1dG9zaCBEYXMgPGFzdXRvc2hk
QGNvZGVhdXJvcmEub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJv
cmEub3JnPg0KPiBSZXZpZXdlZC1ieTogSG9uZ3d1IFN1IDxob25nd3VzQGNvZGVhdXJvcmEub3Jn
Pg0KDQpSZXZpZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4N
Cg0K

