Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1AEC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 15:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3F8223A04
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 15:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730981AbhAUP0i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 10:26:38 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:42970 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732345AbhAUPZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 10:25:19 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 43E3241364;
        Thu, 21 Jan 2021 15:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        mime-version:content-transfer-encoding:content-id:content-type
        :content-type:content-language:accept-language:in-reply-to
        :references:message-id:date:date:subject:subject:from:from
        :received:received:received:received; s=mta-01; t=1611242673; x=
        1613057074; bh=mfnnHUBis89XQEwFI+ZjsP8ISLbJZer+HpOVTE+4EWc=; b=S
        Ce3+S9ZFGfUpMs0t7eXIUxUwSLODtHsMd4zwFGOe11wTHHOPGI+UEvx8qK68QS26
        lsAbcmSDo4rwNeqh1ljsHGjgzie3KD1mpHyYhBmMJNgwDXBwpp2HetFZ22LLUCQ6
        soRGm2yExz+VmKaqE1o7CjeirWROQUawNKlhPWd0uQ=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JfylFlvp_xFO; Thu, 21 Jan 2021 18:24:33 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id DA7254135E;
        Thu, 21 Jan 2021 18:24:33 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (172.17.100.103) by
 T-EXCH-03.corp.yadro.com (172.17.100.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 21 Jan 2021 18:24:33 +0300
Received: from T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272]) by
 T-EXCH-03.corp.yadro.com ([fe80::39f4:7b05:b1d3:5272%14]) with mapi id
 15.01.0669.032; Thu, 21 Jan 2021 18:24:33 +0300
From:   Anastasia Kovaleva <a.kovaleva@yadro.com>
To:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>
Subject: Re: [RESEND PATCH 0/3] scsi: target: Set correct residual data
Thread-Topic: [RESEND PATCH 0/3] scsi: target: Set correct residual data
Thread-Index: AQHWyU0/4PeqapwhvkiV8Nbm2ITN9aoygG2A
Date:   Thu, 21 Jan 2021 15:24:33 +0000
Message-ID: <D7B55F16-12CB-42BE-9ED7-B5E7577E71C2@yadro.com>
References: <20201203082035.54566-1-a.kovaleva@yadro.com>
In-Reply-To: <20201203082035.54566-1-a.kovaleva@yadro.com>
Accept-Language: ru-RU, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [10.199.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8A915FFC7E8934D8D1A9B46C43BDE41@yadro.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksDQoNCkNvdWxkIHlvdSBwbGVhc2UgdGVsbCBtZSBpZiB0aGVyZSBhcmUgYW55IG9iamVjdGlv
bnMgdG8gdGhlc2UgY2hhbmdlcz8NClRoZXNlIHBhdGNoZXMgYXJlIGFwcGxpY2FibGUgdG8gNS4x
Mi9zY3NpLXF1ZXVlLg0KDQpUaGFua3MsDQpBbmFzdGFzaWENCg0K77u/T24gMDMuMTIuMjAyMCwg
MTE6MjEsICJBbmFzdGFzaWEgS292YWxldmEiIDxhLmtvdmFsZXZhQHlhZHJvLmNvbT4gd3JvdGU6
DQoNCiAgICBIaSBNYXJ0aW4sDQogICAgUGxlYXNlIGFwcGx5IHRoZSBjaGFuZ2VzIHRvIDUuMTEv
c2NzaS1xdWV1ZSBhdCB5b3VyIGVhcmxpZXN0DQogICAgY29udmVuaWVuY2UuDQoNCiAgICBUaGUg
c2VyaWVzIGNoYW5nZXMgdGhlIGJlaGF2aW9yIG9mIHRoZSB0YXJnZXQgaW4gcmVnYXJkIHRvIHBy
b2Nlc3NpbmcNCiAgICBjb21tYW5kcyB3aXRoIG92ZXJmbG93L3VuZGVyZmxvdyBpbiBhY2NvcmRh
bmNlIHdpdGggdGhlIHN0YW5kYXJ0cy4NCg0KICAgIFRoZSB0YXJnZXQgZHJpdmVyIHVzZWQgdG8g
cHJvY2VzcyB0aGUgRE1BX1RPX0RFVklDRSBjb21tYW5kcyB3aXRoDQogICAgcmVzaWR1YWxzIChp
biBwYXJ0aWN1bGFyLCBXUklURSBjb21tYW5kKSBpbmNvcnJlY3RseS4gVGhlIHRhcmdldA0KICAg
IHJlc3BvbnNlIGNvbnRhaW5lZCBuZWl0aGVyIGEgcmVzaWR1YWwgY291bnQsIG5vciBhbiBPVkVS
RkxPVy9VTkRFUkZMT1cNCiAgICBiaXQuIFN1Y2ggYmVoYXZpb3IgZGlkIG5vdCBjb21wbHkgd2l0
aCB0aGUgUkZDIDcxNDMuIEFsc28gdGhlDQogICAgcmV0dXJuZWQgQVNDIGFuZCBBU0NRIHdlcmUg
aW5jb3JyZWN0IGFjY29yZGluZyB0byBGQ1AtNCwNCiAgICBhbmQgcmVzaWR1YWxzIHdlcmUgbm90
IHNldCBmb3IgdGhlIDRLbiBkZXZpY2VzLg0KDQogICAgVGhpcyBwYXRjaGVzIGZpeCB0aGUgbWFq
b3IgaW5jb25zaXN0YW5jZXMgaW4gcHJvY2Vzc2luZyB0aGVzZSBraW5kIG9mDQogICAgY29tbWFu
ZHMuDQoNCiAgICBUaGlzIHBhdGNoIHNlcmllcyBoYXMgYmVlbiB0ZXN0ZWQgd2l0aCBhIG1vZGlm
aWVkIGxpYmlzY3NpIHRlc3RpbmcNCiAgICBsaWJyYXJ5Lg0KICAgIFRoZSBsaW5rIHRvIHRoZSBw
dWxsIHJlcXVlc3Q6DQogICAgaHR0cHM6Ly9naXRodWIuY29tL3NhaGxiZXJnL2xpYmlzY3NpL3B1
bGwvMzQ1DQoNCiAgICBXcml0ZTEwUmVzaWR1YWxzLCBXcml0ZTEyUmVzaWR1YWxzLCBXcml0ZTE2
UmVzaWR1YWxzIHRlc3RzIGhhdmUgcGFzc2VkLg0KDQogICAgVGhhbmtzLA0KICAgIEFuYXN0YXNp
YQ0KDQogICAgQW5hc3Rhc2lhIEtvdmFsZXZhICgyKToNCiAgICAgIHNjc2k6IHRhcmdldDogY29y
ZTogU2lnbmFsIFdSSVRFIHJlc2lkdWFscw0KICAgICAgc2NzaTogdGFyZ2V0OiBjb3JlOiBDaGFu
Z2UgQVNDUSBmb3IgcmVzaWR1YWwgd3JpdGUNCg0KICAgIFJvbWFuIEJvbHNoYWtvdiAoMSk6DQog
ICAgICBzY3NpOiB0YXJnZXQ6IGNvcmU6IFNldCByZXNpZHVhbHMgZm9yIDRLbiBkZXZpY2VzDQoN
CiAgICAgZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfdHJhbnNwb3J0LmMgfCA1MyArKysrKysr
KysrKysrLS0tLS0tLS0tLS0tLQ0KICAgICBpbmNsdWRlL3RhcmdldC90YXJnZXRfY29yZV9iYXNl
LmggICAgICB8ICAxICsNCiAgICAgMiBmaWxlcyBjaGFuZ2VkLCAyOCBpbnNlcnRpb25zKCspLCAy
NiBkZWxldGlvbnMoLSkNCg0KICAgIC0tIA0KICAgIDIuMjQuMyAoQXBwbGUgR2l0LTEyOCkNCg0K
DQo=
