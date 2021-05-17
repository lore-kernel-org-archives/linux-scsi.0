Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FD2C43461
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 09:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93AB5611CC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 09:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbhEQJlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 05:41:36 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:55296 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S235911AbhEQJlf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 05:41:35 -0400
X-UUID: 5c00150027c94e02bfb9a20166af0631-20210517
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=SwmJAU6PHX2QVvfHtgJD3Qr9dI/zcQK933lin5zqpPY=;
        b=mZVKfoBu58fBrfRSpQJGtAcTwZxPCGhOYWtLhesJb4gd6sO1ApgUO+DBQ3wkJkRTrhOwG/ywlkEnBnBEQF+IUV3eSUm/YjsJwhvovJ7jymIsMDlko+2xyRfa5dFXc0yw/DN8gPE4BcINTI7ebIe3zsVNIvhE2/LCVK5E0nUlFtU=;
X-UUID: 5c00150027c94e02bfb9a20166af0631-20210517
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 258853058; Mon, 17 May 2021 17:40:16 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:40:15 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 17 May 2021 17:40:15 +0800
Message-ID: <1621244415.21674.8.camel@mtkswgap22>
Subject: Re: [PATCH v34 1/4] scsi: ufs: Introduce HPB feature
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     <daejun7.park@samsung.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Date:   Mon, 17 May 2021 17:40:15 +0800
In-Reply-To: <20210428232340epcms2p4b8b34353e93495895b76f062207a6697@epcms2p4>
References: <20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb@epcms2p8>
         <CGME20210428232257epcms2p8602b29d63529fca8a06010a21157d5cb@epcms2p4>
         <20210428232340epcms2p4b8b34353e93495895b76f062207a6697@epcms2p4>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgRGFlanVuLA0KDQpTb3JyeSBJIGxvc3QgdGhlIGNvdmVyIGxldHRlciBzbyBJIHJlcGxpZWQg
dGhpcyBtYWlsIGluc3RlYWQuDQoNCkZvciB0aGlzIHNlcmllcywNCg0KUmV2aWV3ZWQtYnk6IFN0
YW5sZXkgQ2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQpUZXN0ZWQtYnk6IFN0YW5sZXkg
Q2h1IDxzdGFubGV5LmNodUBtZWRpYXRlay5jb20+DQoNCg0KT24gVGh1LCAyMDIxLTA0LTI5IGF0
IDA4OjIzICswOTAwLCBEYWVqdW4gUGFyayB3cm90ZToNCj4gVGhpcyBpcyBhIHBhdGNoIGZvciB0
aGUgSFBCIGluaXRpYWxpemF0aW9uIGFuZCBhZGRzIEhQQiBmdW5jdGlvbiBjYWxscyB0bw0KPiBV
RlMgY29yZSBkcml2ZXIuDQo+IA0KPiBOQU5EIGZsYXNoLWJhc2VkIHN0b3JhZ2UgZGV2aWNlcywg
aW5jbHVkaW5nIFVGUywgaGF2ZSBtZWNoYW5pc21zIHRvDQo+IHRyYW5zbGF0ZSBsb2dpY2FsIGFk
ZHJlc3NlcyBvZiBJTyByZXF1ZXN0cyB0byB0aGUgY29ycmVzcG9uZGluZyBwaHlzaWNhbA0KPiBh
ZGRyZXNzZXMgb2YgdGhlIGZsYXNoIHN0b3JhZ2UuDQo+IEluIFVGUywgTG9naWNhbC1hZGRyZXNz
LXRvLVBoeXNpY2FsLWFkZHJlc3MgKEwyUCkgbWFwIGRhdGEsIHdoaWNoIGlzDQo+IHJlcXVpcmVk
IHRvIGlkZW50aWZ5IHRoZSBwaHlzaWNhbCBhZGRyZXNzIGZvciB0aGUgcmVxdWVzdGVkIElPcywg
Y2FuIG9ubHkNCj4gYmUgcGFydGlhbGx5IHN0b3JlZCBpbiBTUkFNIGZyb20gTkFORCBmbGFzaC4g
RHVlIHRvIHRoaXMgcGFydGlhbCBsb2FkaW5nLA0KPiBhY2Nlc3NpbmcgdGhlIGZsYXNoIGFkZHJl
c3MgYXJlYSB3aGVyZSB0aGUgTDJQIGluZm9ybWF0aW9uIGZvciB0aGF0IGFkZHJlc3MNCj4gaXMg
bm90IGxvYWRlZCBpbiB0aGUgU1JBTSBjYW4gcmVzdWx0IGluIHNlcmlvdXMgcGVyZm9ybWFuY2Ug
ZGVncmFkYXRpb24uDQo+IA0KPiBUaGUgYmFzaWMgY29uY2VwdCBvZiBIUEIgaXMgdG8gY2FjaGUg
TDJQIG1hcHBpbmcgZW50cmllcyBpbiBob3N0IHN5c3RlbQ0KPiBtZW1vcnkgc28gdGhhdCBib3Ro
IHBoeXNpY2FsIGJsb2NrIGFkZHJlc3MgKFBCQSkgYW5kIGxvZ2ljYWwgYmxvY2sgYWRkcmVzcw0K
PiAoTEJBKSBjYW4gYmUgZGVsaXZlcmVkIGluIEhQQiByZWFkIGNvbW1hbmQuDQo+IFRoZSBIUEIg
UkVBRCBjb21tYW5kIGFsbG93cyB0byByZWFkIGRhdGEgZmFzdGVyIHRoYW4gYSByZWFkIGNvbW1h
bmQgaW4gVUZTDQo+IHNpbmNlIGl0IHByb3ZpZGVzIHRoZSBwaHlzaWNhbCBhZGRyZXNzIChIUEIg
RW50cnkpIG9mIHRoZSBkZXNpcmVkIGxvZ2ljYWwNCj4gYmxvY2sgaW4gYWRkaXRpb24gdG8gaXRz
IGxvZ2ljYWwgYWRkcmVzcy4gVGhlIFVGUyBkZXZpY2UgY2FuIGFjY2VzcyB0aGUNCj4gcGh5c2lj
YWwgYmxvY2sgaW4gTkFORCBkaXJlY3RseSB3aXRob3V0IHNlYXJjaGluZyBhbmQgdXBsb2FkaW5n
IEwyUCBtYXBwaW5nDQo+IHRhYmxlLiBUaGlzIGltcHJvdmVzIHJlYWQgcGVyZm9ybWFuY2UgYmVj
YXVzZSB0aGUgTkFORCByZWFkIG9wZXJhdGlvbiBmb3INCj4gdXBsb2FkaW5nIEwyUCBtYXBwaW5n
IHRhYmxlIGlzIHJlbW92ZWQuDQo+IA0KPiBJbiBIUEIgaW5pdGlhbGl6YXRpb24sIHRoZSBob3N0
IGNoZWNrcyBpZiB0aGUgVUZTIGRldmljZSBzdXBwb3J0cyBIUEINCj4gZmVhdHVyZSBhbmQgcmV0
cmlldmVzIHJlbGF0ZWQgZGV2aWNlIGNhcGFiaWxpdGllcy4gVGhlbiwgc29tZSBIUEINCj4gcGFy
YW1ldGVycyBhcmUgY29uZmlndXJlZCBpbiB0aGUgZGV2aWNlLg0KPiANCj4gV2UgbWVhc3VyZWQg
dGhlIHRvdGFsIHN0YXJ0LXVwIHRpbWUgb2YgcG9wdWxhciBhcHBsaWNhdGlvbnMgYW5kIG9ic2Vy
dmVkDQo+IHRoZSBkaWZmZXJlbmNlIGJ5IGVuYWJsaW5nIHRoZSBIUEIuDQo+IFBvcHVsYXIgYXBw
bGljYXRpb25zIGFyZSAxMiBnYW1lIGFwcHMgYW5kIDI0IG5vbi1nYW1lIGFwcHMuIEVhY2ggdGFy
Z2V0DQo+IGFwcGxpY2F0aW9ucyB3ZXJlIGxhdW5jaGVkIGluIG9yZGVyLiBUaGUgY3ljbGUgY29u
c2lzdHMgb2YgcnVubmluZyAzNg0KPiBhcHBsaWNhdGlvbnMgaW4gc2VxdWVuY2UuIFdlIHJlcGVh
dGVkIHRoZSBjeWNsZSBmb3Igb2JzZXJ2aW5nIHBlcmZvcm1hbmNlDQo+IGltcHJvdmVtZW50IGJ5
IEwyUCBtYXBwaW5nIGNhY2hlIGhpdCBpbiBIUEIuDQo+IA0KPiBUaGUgRm9sbG93aW5nIGlzIGV4
cGVyaW1lbnQgZW52aXJvbm1lbnQ6DQo+ICAtIGtlcm5lbCB2ZXJzaW9uOiA0LjQuMA0KPiAgLSBS
QU06IDhHQg0KPiAgLSBVRlMgMi4xICg2NEdCKQ0KPiANCj4gUmVzdWx0Og0KPiArLS0tLS0tLSst
LS0tLS0tLS0tKy0tLS0tLS0tLS0rLS0tLS0tLSsNCj4gfCBjeWNsZSB8IGJhc2VsaW5lIHwgd2l0
aCBIUEIgfCBkaWZmICB8DQo+ICstLS0tLS0tKy0tLS0tLS0tLS0rLS0tLS0tLS0tLSstLS0tLS0t
Kw0KPiB8IDEgICAgIHwgMjcyLjQgICAgfCAyNjQuOSAgICB8IC03LjUgIHwNCj4gfCAyICAgICB8
IDI1MC40ICAgIHwgMjQ4LjIgICAgfCAtMi4yICB8DQo+IHwgMyAgICAgfCAyMjYuMiAgICB8IDIx
NS42ICAgIHwgLTEwLjYgfA0KPiB8IDQgICAgIHwgMjMwLjYgICAgfCAyMTQuOCAgICB8IC0xNS44
IHwNCj4gfCA1ICAgICB8IDIzMi4wICAgIHwgMjE4LjEgICAgfCAtMTMuOSB8DQo+IHwgNiAgICAg
fCAyMzEuOSAgICB8IDIxMi42ICAgIHwgLTE5LjMgfA0KPiArLS0tLS0tLSstLS0tLS0tLS0tKy0t
LS0tLS0tLS0rLS0tLS0tLSsNCj4gDQo+IFdlIGFsc28gbWVhc3VyZWQgSFBCIHBlcmZvcm1hbmNl
IHVzaW5nIGlvem9uZS4NCj4gSGVyZSBpcyBteSBpb3pvbmUgc2NyaXB0Og0KPiBpb3pvbmUgLXIg
NGsgLStuIC1pMiAtZWNJIC10IDE2IC1sIDE2IC11IDE2DQo+IC1zICRJT19SQU5HRS8xNiAtRiBt
bnQvdG1wXzEgbW50L3RtcF8yIG1udC90bXBfMyBtbnQvdG1wXzQgbW50L3RtcF81DQo+IG1udC90
bXBfNiBtbnQvdG1wXzcgbW50L3RtcF84IG1udC90bXBfOSBtbnQvdG1wXzEwIG1udC90bXBfMTEg
bW50L3RtcF8xMg0KPiBtbnQvdG1wXzEzIG1udC90bXBfMTQgbW50L3RtcF8xNSBtbnQvdG1wXzE2
DQo+IA0KPiBSZXN1bHQ6DQo+ICstLS0tLS0tLS0tKy0tLS0tLS0tKy0tLS0tLS0tLSsNCj4gfCBJ
TyByYW5nZSB8IEhQQiBvbiB8IEhQQiBvZmYgfA0KPiArLS0tLS0tLS0tLSstLS0tLS0tLSstLS0t
LS0tLS0rDQo+IHwgICAxIEdCICAgfCAyOTQuOCAgfCAzMDAuODcgIHwNCj4gfCAgIDQgR0IgICB8
IDI5My41MSB8IDE3OS4zNSAgfA0KPiB8ICAgOCBHQiAgIHwgMjk0Ljg1IHwgMTYyLjUyICB8DQo+
IHwgIDE2IEdCICAgfCAyOTMuNDUgfCAxNTYuMjYgIHwNCj4gfCAgMzIgR0IgICB8IDI3Ny40ICB8
IDE1My4yNSAgfA0KPiArLS0tLS0tLS0tLSstLS0tLS0tLSstLS0tLS0tLS0rDQoNCg==

