Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AF6C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Dec 2021 02:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhLMCAD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Dec 2021 21:00:03 -0500
Received: from out203-205-221-231.mail.qq.com ([203.205.221.231]:39490 "EHLO
        out203-205-221-231.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhLMCAC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Dec 2021 21:00:02 -0500
X-Greylist: delayed 114250 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2021 21:00:02 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1639360800;
        bh=wzS2xWxHM5A13F3v6NonK+vEbuO0WWSCa0N4yWUEdjs=;
        h=From:To:Cc:Subject:Date;
        b=JEqCyDk2OAccZXFycP52Na49GQDeMj3jArhcxLAHFW0XAo9kWEuMsVyb/kr1vskGz
         Sd5yqZWjSsHmswrSfGzt7JfWtz3yU5378VGXVwfXDeV4ts9XOb4O39HMtmKbJAlNhS
         hbNuKfnUCo+yv3suJsfD5yS/wfdBPVFOYNhwTesw=
X-QQ-FEAT: oHWrrGTW1dB69m49duS3mdhuyhfj4A9h
X-QQ-SSF: 00000000000000F000000000000000Z
X-QQ-XMAILINFO: NwIPvWX4YDagat/12IputSOyaxDs/aXfb8URbK/DtpGvQV74EVVAF2nwQYH53N
         THujscHl/HKbOon3MEbX94+kIXbIVK/KDF7EMreHOghpuW8cY4GtCqQBLyEgDWRNWNFHzt3ohG1x9
         a9EEu81s0VrmwRrJFaTzJHrVkkSkv+BSh3UhhAWTyL2ORlWepzf4zoe/Qoe7i6t8ofF2FC9ye5DrE
         mtkxecfs88E+4ulp6bZQUOCHSoz0V9yqjLrj0h45Qk4yF1FStkzRbMPXf017Aarz/sfX5Kkn5C+7z
         aUOMWwJJamjd/m3++isc5HVWp+W2bzJsX+9NW+9J+ggAvxfb4pnksEb+fiJlMJ4zWDRF3INYDP26h
         7S6uka05Uz+g39Nh47UDjbaLx7IKgONHJAZtFp6Vf8WAIHYzzEfMboUPGwnfhrq7atPMYuTb2pZNb
         pqQX0BGUkpIioHCPt/xf/TpAvsvegoRKW5Rm2obnMnTmDyio670szqwJrnGdP1SBmw/enAPWWdfJ4
         1x2EQYTmRuFEkEqx4rdSQ7dJujV0x+h7hGF24VN9OlU570BmGLtxf+KNxfGlx8VoNEl9vgqCeAgG9
         rq8F6efj+T86uLNSG6iVekSiNmD6/xCkwa/6IuLwkbOMRKsSbJTeXv3XoJUBCbM80HnvPtmna/2WB
         rZHPaROqk6N9JZ+IvGCA8BVw9uXtFqqs9wXFuljFMmKrY3Pkt1zX0lmPpOCIw9bi6kt9pU9j1rr/N
         r5grxPeBSUpoiaTm5PqJG4L3PxSjzR79LKQju+6w2czono18D82uVBNmUme1Z4Rx4B80aGZDNyIRL
         TcyAWAX6xiVSAmTxdRiLfUi6RFrwt2OR6fOcT8N2IdySpQryCxVp1R8=
X-HAS-ATTACH: no
X-QQ-BUSINESS-ORIGIN: 2
X-Originating-IP: 223.75.155.17
X-QQ-STYLE: 
X-QQ-mid: webmail813t1639360609t9919530
From:   "=?ISO-8859-1?B?WGlhb2tlIFdhbmc=?=" <xkernel.wang@foxmail.com>
To:     "=?ISO-8859-1?B?QmFydCBWYW4gQXNzY2hl?=" <bvanassche@acm.org>,
        "=?ISO-8859-1?B?amVqYg==?=" <jejb@linux.ibm.com>,
        "=?ISO-8859-1?B?bWFydGluLnBldGVyc2Vu?=" <martin.petersen@oracle.com>
Cc:     "=?ISO-8859-1?B?bGludXgtc2NzaQ==?=" <linux-scsi@vger.kernel.org>,
        "=?ISO-8859-1?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>,
        "=?ISO-8859-1?B?YWxpbS5ha2h0YXI=?=" <alim.akhtar@samsung.com>,
        "=?ISO-8859-1?B?YXZyaS5hbHRtYW4=?=" <avri.altman@wdc.com>
Subject: Re: [PATCH] scsi: ufs: ufshcd-pltfrm: check the return value of kstrdup()
Mime-Version: 1.0
Content-Type: text/plain;
        charset="ISO-8859-1"
Content-Transfer-Encoding: base64
Date:   Mon, 13 Dec 2021 09:56:49 +0800
X-Priority: 3
Message-ID: <tencent_29819C31A7E71A71105124840B2855FD970A@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTIvMTIvMjEgMjI6MzIsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPiBJcyB4a2VybmVs
IHRoZSBuYW1lIG9mIGEgcGVyc29uIG9yIHRoZSBuYW1lIG9mIGEgcm9ib3Q/IFBhdGNoZXMg
c2hvdWxkIAo+IGJlIHNpZ25lZCBieSBhIHBlcnNvbiBldmVuIGlmIHRoZXNlIGhhdmUgYmVl
biBnZW5lcmF0ZWQgYnkgYSByb2JvdC4KPgo+ID4gKwkJY2xraS0+bmFtZSA9IGtzdHJkdXAo
bmFtZSwgR0ZQX0tFUk5FTCk7Cj4gPiArCQlpZiAoIWNsa2ktPm5hbWUpIHsKPiA+ICsJCQly
ZXQgPSAtRU5PTUVNOwo+ID4gKwkJCWRldm1fa2ZyZWUoZGV2LCBjbGtpKTsKPiA+ICsJCQln
b3RvIG91dDsKPiA+ICsJCX0KPgo+IElzIHRoZSBkZXZtX2tmcmVlKCkgY2FsbCBuZWNlc3Nh
cnk/IElzIGl0IHVzZWZ1bD8KCk5vdGU6IHRoZSBsYXN0IG1haWwgc2VlbXMgZmFpbCBiZWNh
dXNlIG9mIHRoZSBodG1sIGNvbnRlbnQuCgpTb3JyeSBhYm91dCB0aGF0LCB4a2VybmVsIGlz
IG15IEVuZ2xpc2ggbmFtZSBJIG5hbWVkIG15c2VsZiwgbXkgZnVsbApuYW1lIGluIENoaW5l
c2UgZm9ybWF0IGlzICJYaWFva2UgV2FuZyIuIFRoYW5rIHlvdSBmb3IgeW91cgpzdWdnZXN0
aW9uLCBJIHdpbGwgY29uc2lkZXIgdXNpbmcgbXkgb2ZmaWNpYWwgbmFtZSBpbiB0aGUgZnV0
dXJlLgoKY2xraSBpcyBhbGxvY2F0ZWQgb24gYWJvdmUgb2Yga3N0cmR1cCgpLCBsaW5lIDg2
LTkwLCBhbmQgaWYgY2xraSBpcyBOVUxMCndpbGwgcmV0dXJuIC1FTk9NRU0gd2hpY2ggaXMg
dGhlIHNhbWUgcmV0dXJuIHZhbHVlIHdpdGggdGhlIHBhdGNoLiBTbwpJIHRoaW5rIGNsa2kg
c2hvdWxkIGJlIGZyZWVkIHRvIHByZXZlbnQgcG90ZW50aWFsIG1lbW9yeSBsZWFrOgo+CQlj
bGtpID0gZGV2bV9remFsbG9jKGRldiwgc2l6ZW9mKCpjbGtpKSwgR0ZQX0tFUk5FTCk7Cj4J
CWlmICghY2xraSkgewo+CQkJcmV0ID0gLUVOT01FTTsKPgkJCWdvdG8gb3V0Owo+CQl9Cgp2
cmVnIGlzIGluIHNpbWlsYXIgY2FzZS4=

