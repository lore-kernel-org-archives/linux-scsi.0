Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91916C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 00:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbiGTAsf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 20:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiGTAse (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 20:48:34 -0400
Received: from m1550.mail.126.com (m1550.mail.126.com [220.181.15.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E4911BE86
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 17:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=exbQz
        IXTMuBf36yYRbfmwnkJOHXFy+VFLD95n7cDs3s=; b=iA763LtFcOGsOq+pyi8G8
        Y0JPtpYt0pmJE4+9rCYx40HTU1Gn+CSuU10B+hB+Cx/4uwuTPfAXT36OrclrGM/D
        HIm02rm7pHjWbweUI7cL7vtHrrzYpOE7MD5YTkhSZpqH0Dt4h1zK5gZPi2ZZZ9L8
        wfwAdo8eAHe/OVaTWnodtM=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr50
 (Coremail) ; Wed, 20 Jul 2022 08:48:06 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Wed, 20 Jul 2022 08:48:06 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Bart Van Assche" <bvanassche@acm.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re:Re: [PATCH v2] ufs: host: ufschd-pltfrm: Hold reference returned
 by of_parse_phandle()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <554f38b5-8506-2ab3-dbff-bcc18b00000f@acm.org>
References: <20220715001703.389981-1-windhl@126.com>
 <0209504a-fdd5-5987-4772-dfb14c6ceafc@acm.org>
 <741595c3.743.1820a1c502e.Coremail.windhl@126.com>
 <6e005dc0-720e-41b1-10df-cc088245bccb@acm.org>
 <23e4cd6a.1fef.18214599628.Coremail.windhl@126.com>
 <554f38b5-8506-2ab3-dbff-bcc18b00000f@acm.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <77c15dc7.730.1821913894e.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: MsqowADHHPHIUNdi_UVMAA--.21294W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGg1EF1-HZh4n-QABs-
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CkF0IDIwMjItMDctMjAgMDI6MTI6MzYsICJCYXJ0IFZhbiBBc3NjaGUiIDxidmFuYXNzY2hlQGFj
bS5vcmc+IHdyb3RlOgo+T24gNy8xOC8yMiAxOTo0NiwgTGlhbmcgSGUgd3JvdGU6Cj4+IENhbiB5
b3UgaGVscCBtZSBhcyBJIGhhdmUgYSB0cm91YmxlIGFib3V0IHRoZSBpbmRlbnRhdGlvbi4KPj4g
Cj4+IFdoZW4gSSBhbGlnbiBkZXNjZW5kYW50cyB0byBhIGZ1bmN0aW9uIG9wZW4gcGFyZW50aGVz
aXMgaW4gVklNIGVkaXRvciwKPj4gYnV0IHdoZW4gSSBnZW5lcmF0ZSB0aGUgcGF0Y2gsIEkgZmlu
ZCB0aGUgc2Vjb25kIGxpbmUgYWx3YXlzIG1pc3Npbmcgb25lIHNwYWNlIGluCj4+IHBhdGNoIGZv
cm1hdC4gU28gaXMgdGhlcmUgYW55IHByb2JsZW0gaWYgSSBzZW5kIHRoaXMgcGF0Y2g/Cj4+IAo+
PiBJIG1ha2Ugc3VyZSB0aGF0IHRoZSBhbGlnbm1lbnQgaW4gVklNIGlzIE9LLgo+Cj5IaSBMaWFu
ZywKPgo+UGxlYXNlIGRvbid0IHdvcnJ5IGFib3V0IHRoaXMuIFdoZW4gYSBjb2RlIGNoYW5nZSBp
cyBjb252ZXJ0ZWQgaW50byBhIAo+cGF0Y2gsIGEgc2luZ2xlIGNoYXJhY3RlciBpcyBpbnNlcnRl
ZCBhdCB0aGUgc3RhcnQgb2YgZWFjaCBsaW5lIChwbHVzLCAKPm1pbnVzIG9yIHNwYWNlKS4gVGhh
dCBtYWtlcyBjb2RlIHRoYXQgaXMgaW5kZW50ZWQgd2l0aCB0YWJzIGxvb2sgd2VpcmQuIAo+VGhp
cyBpcyBub3JtYWwuCj4KPkJhcnQuCgpUaGFua3MgdmVyeSBtdWNoIGZvciBhbGwgeW91ciBoZWxw
IGFuZCB5b3VyIGVmZm9ydCB0byByZXZpZXcgbXkgY29kZS4KCkxpYW5nCg==
