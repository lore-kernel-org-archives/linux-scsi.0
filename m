Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90802EB64D7
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jun 2023 20:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjFZUfa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jun 2023 16:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjFZUfa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2023 16:35:30 -0400
Received: from gw.rozsnyo.com (gw.rozsnyo.com [77.240.102.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE16798
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 13:35:27 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by gw.rozsnyo.com (Postfix) with ESMTP id 183681033FA9
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 22:35:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at rozsnyo.com
Received: from gw.rozsnyo.com ([127.0.0.1])
        by localhost (hosting.rozsnyo.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7EtXeKLvJ1Xk for <linux-scsi@vger.kernel.org>;
        Mon, 26 Jun 2023 22:35:26 +0200 (CEST)
Received: from [192.168.68.7] (gw.rozsnyo.com [77.240.102.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by gw.rozsnyo.com (Postfix) with ESMTPSA id 7FACE1033F9F
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jun 2023 22:35:26 +0200 (CEST)
Message-ID: <c6499ed7-d049-5714-f827-734cff3f6305@rozsnyo.com>
Date:   Mon, 26 Jun 2023 22:35:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From:   =?UTF-8?Q?Daniel_Rozsny=c3=b3?= <daniel@rozsnyo.com>
Subject: [RFC] Support for Write-and-Verify only drives
To:     linux-scsi@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGVsbG8sDQoNCiDCoMKgIGhhZCBhbnlib2R5IGNvbnNpZGVyZWQgaW1wbGVtZW50aW5nIGEg
dG9nZ2xlIHN3aXRjaCBmb3IgdGhlICJzZCIgZHJpdmVyIHRoYXQgd291bGQgc2VuZCBhIGRp
ZmZlcmVudCB3cml0ZSBjb21tYW5kIGNvZGUsIHRoYW4gdGhlIHN0YW5kYXJkIFdyaXRlPw0K
DQogwqDCoCBUaGUgb25lIEkgd291bGQgbmVlZCBpbnN0ZWFkIG9mIFdyaXRlIGlzIHRoZSBX
cml0ZS1BbmQtVmVyaWZ5IGFuZCBpdCBjb21lcyBpbiB2YXJpb3VzIGNvbnRyb2wgYmxvY2sg
c2l6ZSBmbGF2b3JzIG9mIGNvdXJzZS4NCg0KIMKgwqAgVGhlcmUgYXJlIHNvbWUgZHJpdmVz
LCBvciBtb3JlIHByZWNpc2VseSAtIG5vcm1hbCBkcml2ZXMgd2l0aCBhIGN1c3RvbSBmaXJt
d2FyZSwgdGhhdCBzaW1wbHkgcmVqZWN0IGEgcmVndWxhciBXcml0ZSAtIGxpa2VseSBhcyBu
b3QgYmVpbmcgZ29vZCBlbm91Z2ggZm9yIHRoZSBpbnRlbmRlZCBoaWdoLXJlbCBhcHBsaWNh
dGlvbiAtIHdoaWNoIEkgY2FuIHVuZGVyc3RhbmQsIGJ1dCBldmVuIGFmdGVyIHJlZm9ybWF0
dGluZyB0aGUgZHJpdmUgdG8gbm8tUEkgYW5kIGdvaW5nIHRvICJwb29yIiA1MTJCIHNlY3Rv
ciANCnNpemUsIHRoZXkgc3RpbGwgcmVmdXNlIHRvIGRvIGFuIGVhc3kgV3JpdGUgb3BlcmF0
aW9uLiBJIGhhZCB2ZXJpZmllZCB0aGF0IGJ5IHVzaW5nIHRoZSBzZ193cml0ZV92ZXJpZnkg
KHRoYXQgdXNlcyBhbiBpb2N0bCkgSSBjYW4gcmVhbGx5IHdyaXRlIGRhdGEgdG8gdGhlc2Ug
ZHJpdmVzLiBUaGUgcmVhZGluZyBwYXRoIGlzIHdvcmtpbmcgb2theSBhbmQgYm90aCBkZCBh
bmQgaGRwYXJtIHdvcmtzIGF0IGV4cGVjdGVkIHNwZWVkcy4NCg0KIMKgwqAgSSBoYWQgYSBs
b29rIGluIHRoZSBzb3VyY2UgY29kZSwgYW5kIGl0IHNlZW1zIHRoYXQgbWFraW5nIHN1Y2gg
Y2hhbmdlIHdvdWxkIG5lZWQganVzdCBhIG5ldyBiaW5hcnkgZmxhZyBwZXIgZHJpdmUgLSBh
bmQgdGhlIG1vc3QgY29tcGxpY2F0ZWQgdGhpbmcgYmVpbmcgdGhlIGFjdHVhbCBhdXRvLWRl
dGVjdGlvbiBvZiBzdWNoIGFuICJlbmhhbmNlZCB0byBiZWluZyBwaWNreSIgZmlybXdhcmUu
IEluaXRpYWxseSBJIGNvdWxkIGxpdmUgd2l0aCB0aGUgZmxhZyBleHBvc2VkIG9uIHN5c2Zz
LCBhbmQgc2V0IGl0IHVwIA0KYnkgYW4gdWRldiBiYXNlZCB1c2VyLXNwYWNlIHNjcmlwdCB0
aGF0IGFjdGl2YXRlcyBvbiBkcml2ZSBkZXRlY3Rpb24vaG90LXBsdWcuDQoNCiDCoMKgIEEg
YmV0dGVyIG9uZSBjb3VsZCBwcmVzZXQgdGhlIGZsYWcgYmFzZWQgb24gbW9kZWwgbmFtZXMg
LSBidXQgdGhlIGxpc3Qgd2lsbCBiZSBsb25nIGFuZCBoYXJkIHRvIG1haW50YWluIGluLWtl
cm5lbCwgd2hpbGUgYSB0cnktd3JpdGUscmV0cnktd3JpdGV2ZXJpZnkgbGlrZSBhdXRvLWRl
dGVjdGlvbiBhdCBmaXJzdCBvY2N1cnJlbmNlIG9mIGEgd3JpdGUgbmVlZHMgdG8gaGFuZGxl
IHZhcmlvdXMgZXhwZWN0ZWQgYW5kIHVuZXhwZWN0ZWQgZXJyb3JzIGFuZCBJIGRvIG5vdCBz
ZWUgaXQgYXMgYSBjbGVhbiB0aGluZyANCmZvciB0aGUga2VybmVsLg0KDQogwqDCoCBBbnlv
bmUgdXAgdG8gdGhlIHRhc2s/DQoNCiDCoMKgIE9yIGlmIEkgZG8gaXQgbXlzZWxmIGFuZCBz
ZW5kIGhlcmUgc29tZSBwYXRjaGVzLCB3aGF0IHRvIGJlIGF3YXJlIG9mPw0KDQoNCkRhbmll
bA0KDQo=
