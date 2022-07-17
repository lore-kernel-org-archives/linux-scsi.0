Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032BDC43334
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Jul 2022 03:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiGQDD7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Jul 2022 23:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiGQDD6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jul 2022 23:03:58 -0400
Received: from m1550.mail.126.com (m1550.mail.126.com [220.181.15.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F01AA195
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022 20:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=ZNFZD
        Rd4shsVjgME4RMCXwqDuHFn6kFR8t7zxSBSzpI=; b=kktDWhyWRfusKGsU9WGbe
        7hNhFLO1Ly1mpITLFuiy6WI1ik4dRy68828p7ycfkboCIynPJv26piQlWZ7p79UD
        oIK7JLhGdkVwmzqRcFb6rbBca7kh6XtH7H/rAleNhuhA4t5yd0Owr8ZVAT/ZmpbR
        r1+vMZjDDW+nwdgefaMLnI=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr50
 (Coremail) ; Sun, 17 Jul 2022 11:03:23 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Sun, 17 Jul 2022 11:03:23 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Bart Van Assche" <bvanassche@acm.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re:Re: [PATCH v2] ufs: host: ufschd-pltfrm: Hold reference returned
 by of_parse_phandle()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <0209504a-fdd5-5987-4772-dfb14c6ceafc@acm.org>
References: <20220715001703.389981-1-windhl@126.com>
 <0209504a-fdd5-5987-4772-dfb14c6ceafc@acm.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <741595c3.743.1820a1c502e.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: MsqowABnvfH7e9Ni9aBKAA--.14825W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi7RNBF1pEAacvFgABso
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CkF0IDIwMjItMDctMTYgMjE6NTA6MDgsICJCYXJ0IFZhbiBBc3NjaGUiIDxidmFuYXNzY2hlQGFj
bS5vcmc+IHdyb3RlOgo+T24gNy8xNC8yMiAxNzoxNywgTGlhbmcgSGUgd3JvdGU6Cj4+ICtzdGF0
aWMgYm9vbCBwaGFuZGxlX2V4aXN0cyhjb25zdCBzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wLAo+PiAr
CQkJCQkJY29uc3QgY2hhciAqcGhhbmRsZV9uYW1lLAo+PiArCQkJCQkJaW50IGluZGV4KQo+Cj5J
bmRlbnRhdGlvbiBvZiB0aGUgYXJndW1lbnRzIG5vdyBsb29rcyByZWFsbHkgb2RkIDotKAoKWWVz
LCBCYXJ0LCBJIGFsc28gd29uZGVyIHRoaXMgY29kaW5nIHN0eWxlLCBob3dldmVyIEkgbGVhcm5l
ZCB0aGF0IApmcm9tIHRoZSBkZWZpbml0aW9uIG9mICdvZl9wYXJzZV9waGFuZGxlJyBpbiBvZi5o
LgoKSXMgaXQgT0sgaWYgSSBwdXQgYWxsIG9mIHRoZW0gaW4gb25lIGxpbmWjvwoKVGhhbmtzLAoK
Pgo+PiArewo+PiArCXN0cnVjdCBkZXZpY2Vfbm9kZSAqcGFyc2VfbnAgPSBvZl9wYXJzZV9waGFu
ZGxlKG5wLCBwaGFuZGxlX25hbWUsIGluZGV4KTsKPj4gKwlib29sIHJldCA9IGZhbHNlOwo+PiAr
Cj4+ICsJaWYgKHBhcnNlX25wKSB7Cj4+ICsJCXJldCA9IHRydWU7Cj4+ICsJCW9mX25vZGVfcHV0
KHBhcnNlX25wKTsKPj4gKwl9Cj4+ICsKPj4gKwlyZXR1cm4gcmV0Owo+PiArfQo+Cj5UaGUgJ3Jl
dCcgdmFyaWFibGUgaXMgbm90IG5lY2Vzc2FyeS4gSWYgInJldHVybiByZXQiIGlzIGNoYW5nZWQg
aW50byAKPiJyZXR1cm4gcGFyc2VfbnAiIHRoZW4gdGhlIHZhcmlhYmxlICdyZXQnIGNhbiBiZSBs
ZWZ0IG91dC4KPgoKT0ssIEkgd2lsbCB1c2UgJ3JldHVybiBwYXJzZV9ucCcgaW4gbmV3IHZlcnNp
b24gd2hlbiB5b3UgY29uZmlybSBhYm92ZSBjb2Rpbmcgc3R5bGUuCgo+VGhhbmtzLAo+Cj5CYXJ0
LgoKVGhhbmtzLCAKCkxpYW5nCg==
