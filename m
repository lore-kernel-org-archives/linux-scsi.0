Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060D5C2D0DA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 07:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCAD12072E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 07:17:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="p9ibBBgP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfLYHRH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 02:17:07 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:7734 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725865AbfLYHRH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Dec 2019 02:17:07 -0500
X-UUID: f73835c1815f4f68a7ac744339a7c98c-20191225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=OsJGu/f4HnjBQe/OqgxeEK3PDF5UIGwctdknZieqxPc=;
        b=p9ibBBgPuokglKAIdlDLGXyR5QN8R9aSCKyzOgFPiRfw9cmmpqJmQFfCh2cqN4ueFOXVDT430VxTMDeAyAuH9N86ETiwQ5j5k7T3eXeozlVOnNYI/C5tI+dxDuDXWylv2P1ifu3ZkrG+WMh4GpiD3eNOgrdNuh78l3cP9RKd5uQ=;
X-UUID: f73835c1815f4f68a7ac744339a7c98c-20191225
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1471422872; Wed, 25 Dec 2019 15:17:02 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 25 Dec 2019 15:16:15 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 25 Dec 2019 15:15:54 +0800
Message-ID: <1577258218.13056.50.camel@mtkswgap22>
Subject: Re: [PATCH 2/6] ufs: Make ufshcd_add_command_trace() easier to read
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Bean Huo <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Date:   Wed, 25 Dec 2019 15:16:58 +0800
In-Reply-To: <20191224220248.30138-3-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
         <20191224220248.30138-3-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 480F8C7DCB97FA1D58A95F933BF54CF893188918EA5E9BD75363FFE78CA0CCA72000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KT24gVHVlLCAyMDE5LTEyLTI0IGF0IDE0OjAyIC0wODAwLCBCYXJ0IFZhbiBB
c3NjaGUgd3JvdGU6DQo+IFNpbmNlIHRoZSBscmJwLT5jbWQgZXhwcmVzc2lvbiBvY2N1cnMgbXVs
dGlwbGUgdGltZXMsIGludHJvZHVjZSBhIG5ldw0KPiBsb2NhbCB2YXJpYWJsZSB0byBob2xkIHRo
YXQgcG9pbnRlci4gVGhpcyBwYXRjaCBkb2VzIG5vdCBjaGFuZ2UgYW55DQo+IGZ1bmN0aW9uYWxp
dHkuDQo+IA0KPiBDYzogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gQ2M6IENhbiBH
dW8gPGNhbmdAY29kZWF1cm9yYS5vcmc+DQo+IENjOiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5A
d2RjLmNvbT4NCj4gQ2M6IFN0YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQo+
IENjOiBUb21hcyBXaW5rbGVyIDx0b21hcy53aW5rbGVyQGludGVsLmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IC0tLQ0KDQpSZXZp
ZXdlZC1ieTogU3RhbmxleSBDaHUgPHN0YW5sZXkuY2h1QG1lZGlhdGVrLmNvbT4NCg0K

