Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85785C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 02:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiGSCrL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 22:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235414AbiGSCrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 22:47:07 -0400
Received: from m1524.mail.126.com (m1524.mail.126.com [220.181.15.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19E4633347
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 19:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=U8puc
        /zndrsziKCjhSqBKO0n2tz3ouR3TOGtNWTbS5o=; b=BlBFAhQyQRQRXUDiqY6UT
        po+SPmmmhCJJifdu2zygi4smXnH/+p+h7YN4lqPbKyoujLZ6jmgv42DstnrlNyug
        pZ62oQviQ9hI+/RhHG1obs8VuRGc54OiGB+NtENPJX2dgHmjNkBTKQKsYvkfIEWz
        aGMmmAa7O7AIvpnC+oCXXc=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr24
 (Coremail) ; Tue, 19 Jul 2022 10:46:31 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Tue, 19 Jul 2022 10:46:31 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Bart Van Assche" <bvanassche@acm.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re:Re: [PATCH v2] ufs: host: ufschd-pltfrm: Hold reference returned
 by of_parse_phandle()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <6e005dc0-720e-41b1-10df-cc088245bccb@acm.org>
References: <20220715001703.389981-1-windhl@126.com>
 <0209504a-fdd5-5987-4772-dfb14c6ceafc@acm.org>
 <741595c3.743.1820a1c502e.Coremail.windhl@126.com>
 <6e005dc0-720e-41b1-10df-cc088245bccb@acm.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <23e4cd6a.1fef.18214599628.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: GMqowADXOEQIG9Zia4ZKAA--.30797W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGgFDF1-HZhjJywABsq
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CkF0IDIwMjItMDctMTcgMjI6NTg6NDUsICJCYXJ0IFZhbiBBc3NjaGUiIDxidmFuYXNzY2hlQGFj
bS5vcmc+IHdyb3RlOgo+T24gNy8xNi8yMiAyMDowMywgTGlhbmcgSGUgd3JvdGU6Cj4+IEF0IDIw
MjItMDctMTYgMjE6NTA6MDgsICJCYXJ0IFZhbiBBc3NjaGUiIDxidmFuYXNzY2hlQGFjbS5vcmc+
IHdyb3RlOgo+Pj4gT24gNy8xNC8yMiAxNzoxNywgTGlhbmcgSGUgd3JvdGU6Cj4+Pj4gK3N0YXRp
YyBib29sIHBoYW5kbGVfZXhpc3RzKGNvbnN0IHN0cnVjdCBkZXZpY2Vfbm9kZSAqbnAsCj4+Pj4g
KwkJCQkJCWNvbnN0IGNoYXIgKnBoYW5kbGVfbmFtZSwKPj4+PiArCQkJCQkJaW50IGluZGV4KQo+
Pj4KPj4+IEluZGVudGF0aW9uIG9mIHRoZSBhcmd1bWVudHMgbm93IGxvb2tzIHJlYWxseSBvZGQg
Oi0oCj4+IAo+PiBZZXMsIEJhcnQsIEkgYWxzbyB3b25kZXIgdGhpcyBjb2Rpbmcgc3R5bGUsIGhv
d2V2ZXIgSSBsZWFybmVkIHRoYXQKPj4gZnJvbSB0aGUgZGVmaW5pdGlvbiBvZiAnb2ZfcGFyc2Vf
cGhhbmRsZScgaW4gb2YuaC4KPj4gCj4+IElzIGl0IE9LIGlmIEkgcHV0IGFsbCBvZiB0aGVtIGlu
IG9uZSBsaW5lo78KPgo+Tm8uIEZyb20gRG9jdW1lbnRhdGlvbi9wcm9jZXNzL2NvZGluZy1zdHls
ZS5yc3QgKHBsZWFzZSByZWFkIHRoYXQgCj5kb2N1bWVudCBpbiBpdHMgZW50aXJldHkpOiAiVGhl
IHByZWZlcnJlZCBsaW1pdCBvbiB0aGUgbGVuZ3RoIG9mIGEgCj5zaW5nbGUgbGluZSBpcyA4MCBj
b2x1bW5zLiBbLi4uXSBBIHZlcnkgY29tbW9ubHkgdXNlZCBzdHlsZQo+aXMgdG8gYWxpZ24gZGVz
Y2VuZGFudHMgdG8gYSBmdW5jdGlvbiBvcGVuIHBhcmVudGhlc2lzLiIKPgo+Q29uc2lkZXIgdG8g
dXNlIHRoZSBmb2xsb3dpbmcgZm9ybWF0dGluZzoKPgo+c3RhdGljIGJvb2wgcGhhbmRsZV9leGlz
dHMoY29uc3Qgc3RydWN0IGRldmljZV9ub2RlICpucCwKPgkJCSAgIGNvbnN0IGNoYXIgKnBoYW5k
bGVfbmFtZSwgaW50IGluZGV4KQo+ewo+CVsgLi4uIF0KPn0KPgoKSGksIEJhcnQsIAoKQ2FuIHlv
dSBoZWxwIG1lIGFzIEkgaGF2ZSBhIHRyb3VibGUgYWJvdXQgdGhlIGluZGVudGF0aW9uLgoKV2hl
biBJIGFsaWduIGRlc2NlbmRhbnRzIHRvIGEgZnVuY3Rpb24gb3BlbiBwYXJlbnRoZXNpcyBpbiBW
SU0gZWRpdG9yLApidXQgd2hlbiBJIGdlbmVyYXRlIHRoZSBwYXRjaCwgSSBmaW5kIHRoZSBzZWNv
bmQgbGluZSBhbHdheXMgbWlzc2luZyBvbmUgc3BhY2UgaW4KcGF0Y2ggZm9ybWF0LiBTbyBpcyB0
aGVyZSBhbnkgcHJvYmxlbSBpZiBJIHNlbmQgdGhpcyBwYXRjaD8KCkkgbWFrZSBzdXJlIHRoYXQg
dGhlIGFsaWdubWVudCBpbiBWSU0gaXMgT0suCgpUaGFua3MsIApMaWFuZwoKCj4+Pj4gK3sKPj4+
PiArCXN0cnVjdCBkZXZpY2Vfbm9kZSAqcGFyc2VfbnAgPSBvZl9wYXJzZV9waGFuZGxlKG5wLCBw
aGFuZGxlX25hbWUsIGluZGV4KTsKPj4+PiArCWJvb2wgcmV0ID0gZmFsc2U7Cj4+Pj4gKwo+Pj4+
ICsJaWYgKHBhcnNlX25wKSB7Cj4+Pj4gKwkJcmV0ID0gdHJ1ZTsKPj4+PiArCQlvZl9ub2RlX3B1
dChwYXJzZV9ucCk7Cj4+Pj4gKwl9Cj4+Pj4gKwo+Pj4+ICsJcmV0dXJuIHJldDsKPj4+PiArfQo+
Pj4KPj4+IFRoZSAncmV0JyB2YXJpYWJsZSBpcyBub3QgbmVjZXNzYXJ5LiBJZiAicmV0dXJuIHJl
dCIgaXMgY2hhbmdlZCBpbnRvCj4+PiAicmV0dXJuIHBhcnNlX25wIiB0aGVuIHRoZSB2YXJpYWJs
ZSAncmV0JyBjYW4gYmUgbGVmdCBvdXQuCj4+Pgo+PiAKPj4gT0ssIEkgd2lsbCB1c2UgJ3JldHVy
biBwYXJzZV9ucCcgaW4gbmV3IHZlcnNpb24gd2hlbiB5b3UgY29uZmlybSBhYm92ZSBjb2Rpbmcg
c3R5bGUuCj4KPllvdSBtYXkgd2FudCB0byB1c2UgInJldHVybiBwYXJzZV9ucCAhPSBOVUxMIiBp
ZiB5b3Ugd2FudCB0byBiZSBzdXJlIAo+dGhhdCBub2JvZHkgZWxzZSB3aWxsIGNvbXBsYWluIGFi
b3V0IGFuIGltcGxpY2l0IGNvbnZlcnNpb24gb2YgYSBwb2ludGVyIAo+dG8gYSBib29sZWFuIHR5
cGUuCj4KPlRoYW5rcywKPgo+QmFydC4K
