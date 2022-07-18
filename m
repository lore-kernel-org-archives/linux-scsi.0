Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A098FC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 08:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiGRIbS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 04:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiGRIbR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 04:31:17 -0400
Received: from m151.mail.126.com (m151.mail.126.com [220.181.15.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E16C018E3D
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 01:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=w0Zly
        cFUKUeKowevLO6R+JOpaZL1j/GeA9JEKQ71PtI=; b=RTyLWdjMwVQgI/jyYsS/v
        jF0jb1/kxGiUJFYOkBXeGDBdDRXIWilW9I1OzfFCY7qJ+W5cFWd8kYsV10DCmwtQ
        AGWS8I/swi9bSOjipgQ7zZjRfjvMWAjADUSYAGcq4it2tufZDSgXYRO1E69V5t4E
        ia5FJFnvBqXxfYoKEaquIE=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr1
 (Coremail) ; Mon, 18 Jul 2022 16:30:50 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Mon, 18 Jul 2022 16:30:50 +0800 (CST)
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
Message-ID: <17e51061.2bac.182106e747f.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AcqowADXwbE6GtVikeYiAA--.61233W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbizgBCF18RPg79WQACsD
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CgpBdCAyMDIyLTA3LTE3IDIyOjU4OjQ1LCAiQmFydCBWYW4gQXNzY2hlIiA8YnZhbmFzc2NoZUBh
Y20ub3JnPiB3cm90ZToKPk9uIDcvMTYvMjIgMjA6MDMsIExpYW5nIEhlIHdyb3RlOgo+PiBBdCAy
MDIyLTA3LTE2IDIxOjUwOjA4LCAiQmFydCBWYW4gQXNzY2hlIiA8YnZhbmFzc2NoZUBhY20ub3Jn
PiB3cm90ZToKPj4+IE9uIDcvMTQvMjIgMTc6MTcsIExpYW5nIEhlIHdyb3RlOgo+Pj4+ICtzdGF0
aWMgYm9vbCBwaGFuZGxlX2V4aXN0cyhjb25zdCBzdHJ1Y3QgZGV2aWNlX25vZGUgKm5wLAo+Pj4+
ICsJCQkJCQljb25zdCBjaGFyICpwaGFuZGxlX25hbWUsCj4+Pj4gKwkJCQkJCWludCBpbmRleCkK
Pj4+Cj4+PiBJbmRlbnRhdGlvbiBvZiB0aGUgYXJndW1lbnRzIG5vdyBsb29rcyByZWFsbHkgb2Rk
IDotKAo+PiAKPj4gWWVzLCBCYXJ0LCBJIGFsc28gd29uZGVyIHRoaXMgY29kaW5nIHN0eWxlLCBo
b3dldmVyIEkgbGVhcm5lZCB0aGF0Cj4+IGZyb20gdGhlIGRlZmluaXRpb24gb2YgJ29mX3BhcnNl
X3BoYW5kbGUnIGluIG9mLmguCj4+IAo+PiBJcyBpdCBPSyBpZiBJIHB1dCBhbGwgb2YgdGhlbSBp
biBvbmUgbGluZaO/Cj4KPk5vLiBGcm9tIERvY3VtZW50YXRpb24vcHJvY2Vzcy9jb2Rpbmctc3R5
bGUucnN0IChwbGVhc2UgcmVhZCB0aGF0IAo+ZG9jdW1lbnQgaW4gaXRzIGVudGlyZXR5KTogIlRo
ZSBwcmVmZXJyZWQgbGltaXQgb24gdGhlIGxlbmd0aCBvZiBhIAo+c2luZ2xlIGxpbmUgaXMgODAg
Y29sdW1ucy4gWy4uLl0gQSB2ZXJ5IGNvbW1vbmx5IHVzZWQgc3R5bGUKPmlzIHRvIGFsaWduIGRl
c2NlbmRhbnRzIHRvIGEgZnVuY3Rpb24gb3BlbiBwYXJlbnRoZXNpcy4iCj4KPkNvbnNpZGVyIHRv
IHVzZSB0aGUgZm9sbG93aW5nIGZvcm1hdHRpbmc6Cj4KPnN0YXRpYyBib29sIHBoYW5kbGVfZXhp
c3RzKGNvbnN0IHN0cnVjdCBkZXZpY2Vfbm9kZSAqbnAsCj4JCQkgICBjb25zdCBjaGFyICpwaGFu
ZGxlX25hbWUsIGludCBpbmRleCkKPnsKPglbIC4uLiBdCj59Cj4KClRoYW5rcyB2ZXJ5IG11Y2gs
IEJhcnQsCgpJIHdpbGwgZm9sbG93IHlvdXIgYWR2aWNlIGFuZCBJIHdpbGwgcmVhZCBjYXJlZnVs
bHkgdGhlIERvY3VtZW50YXRpb24vcHJvY2Vzcy9jb2Rpbmctc3R5bGUucnN0CgpMaWFuZwoKPj4+
PiArewo+Pj4+ICsJc3RydWN0IGRldmljZV9ub2RlICpwYXJzZV9ucCA9IG9mX3BhcnNlX3BoYW5k
bGUobnAsIHBoYW5kbGVfbmFtZSwgaW5kZXgpOwo+Pj4+ICsJYm9vbCByZXQgPSBmYWxzZTsKPj4+
PiArCj4+Pj4gKwlpZiAocGFyc2VfbnApIHsKPj4+PiArCQlyZXQgPSB0cnVlOwo+Pj4+ICsJCW9m
X25vZGVfcHV0KHBhcnNlX25wKTsKPj4+PiArCX0KPj4+PiArCj4+Pj4gKwlyZXR1cm4gcmV0Owo+
Pj4+ICt9Cj4+Pgo+Pj4gVGhlICdyZXQnIHZhcmlhYmxlIGlzIG5vdCBuZWNlc3NhcnkuIElmICJy
ZXR1cm4gcmV0IiBpcyBjaGFuZ2VkIGludG8KPj4+ICJyZXR1cm4gcGFyc2VfbnAiIHRoZW4gdGhl
IHZhcmlhYmxlICdyZXQnIGNhbiBiZSBsZWZ0IG91dC4KPj4+Cj4+IAo+PiBPSywgSSB3aWxsIHVz
ZSAncmV0dXJuIHBhcnNlX25wJyBpbiBuZXcgdmVyc2lvbiB3aGVuIHlvdSBjb25maXJtIGFib3Zl
IGNvZGluZyBzdHlsZS4KPgo+WW91IG1heSB3YW50IHRvIHVzZSAicmV0dXJuIHBhcnNlX25wICE9
IE5VTEwiIGlmIHlvdSB3YW50IHRvIGJlIHN1cmUgCj50aGF0IG5vYm9keSBlbHNlIHdpbGwgY29t
cGxhaW4gYWJvdXQgYW4gaW1wbGljaXQgY29udmVyc2lvbiBvZiBhIHBvaW50ZXIgCj50byBhIGJv
b2xlYW4gdHlwZS4KPgpPSywgSSB0aGluayAncmV0dXJuIHBhcnNlX25wICE9IE5VTEwnIGlzIGJl
dHRlci4KCkkgd2lsbCBwcmVwYXJlIG5ldyB2ZXJzaW9uIHBhdGNoIHNvb24uCgo+VGhhbmtzLAo+
Cj5CYXJ0LgoKVGhhbmtzLCAKTGlhbmcK
