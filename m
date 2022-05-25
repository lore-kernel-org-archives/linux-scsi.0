Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E08C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 11:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbiEYLUr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 07:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiEYLUq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 07:20:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C55E6FA1D
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 04:20:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 51ECE218F4;
        Wed, 25 May 2022 11:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653477643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QeoMYs1TAIBbUrGXT1bWBD0qaSwjxeu2Y+SdqwRbP+E=;
        b=ilXzV/Y+HZpTS4JaarzA5hLBYQ0aTnXXB4cPovBtRIy/xp9l/s+MQVw1LJkZJjFp5PMNMM
        nSfSjTRSeCD3PRx26fRYosnYYgwA8tEBTTRiJjWgy+S5lpOlekjlngjO7GG9fRsR5VKcgI
        50fMBvLeYY1d7dQ09SOT0M+jKKsHaxo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1192E13ADF;
        Wed, 25 May 2022 11:20:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id h4C/AgsRjmLbCwAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 25 May 2022 11:20:43 +0000
Message-ID: <37b61d6b956c18bf4a56d14b5746dab2719ef20d.camel@suse.com>
Subject: Re: [PATCH] scsi_dh_alua: mark port group as failed after ALUA
 transitioning timeout
From:   Martin Wilck <mwilck@suse.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
        Martin Wilck <mwilck@suse.de>
Date:   Wed, 25 May 2022 13:20:42 +0200
In-Reply-To: <20220525081139.88165-1-hare@suse.de>
References: <20220525081139.88165-1-hare@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIyLTA1LTI1IGF0IDEwOjExICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
Cj4gV2hlbiBBTFVBIHRyYW5zaXRpb25pbmcgdGltZW91dCB0cmlnZ2VycyB0aGUgcGF0aCBncm91
cCBzdGF0ZSBtdXN0Cj4gYmUgY29uc2lkZXJlZCBpbnZhbGlkLiBTbyBhZGQgYSBuZXcgZmxhZyBB
TFVBX1BHX0ZBSUxFRCB0byBpbmRpY2F0ZQo+IHRoYXQgdGhlIHBhdGggc3RhdGUgaXNuJ3QgbmVj
ZXNzYXJpbHkgdmFsaWQsIGFuZCBrZWVwIHRoZSBleGlzdGluZwo+IHBhdGggc3RhdGUgdW50aWwg
d2UgZ2V0IGEgdmFsaWQgcmVzcG9uc2UgZnJvbSBhIFJUUEcuCj4gCj4gQ2M6IEJyaWFuIEJ1bmtl
ciA8YnJpYW5AcHVyZXN0b3JhZ2UuY29tPgo+IENjOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNl
LmRlPgo+IFNpZ25lZC1vZmYtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgo+IC0t
LQo+IKBkcml2ZXJzL3Njc2kvZGV2aWNlX2hhbmRsZXIvc2NzaV9kaF9hbHVhLmMgfCAyNCArKysr
KysrLS0tLS0tLS0tLS0tLQo+IC0tCj4goDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyks
IDE3IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvZGV2aWNlX2hh
bmRsZXIvc2NzaV9kaF9hbHVhLmMKPiBiL2RyaXZlcnMvc2NzaS9kZXZpY2VfaGFuZGxlci9zY3Np
X2RoX2FsdWEuYwo+IGluZGV4IDFkOWJlNzcxZjNlZS4uNjkyMTQ5MGE1ZTY1IDEwMDY0NAo+IC0t
LSBhL2RyaXZlcnMvc2NzaS9kZXZpY2VfaGFuZGxlci9zY3NpX2RoX2FsdWEuYwo+ICsrKyBiL2Ry
aXZlcnMvc2NzaS9kZXZpY2VfaGFuZGxlci9zY3NpX2RoX2FsdWEuYwo+IEBAIC00OSw2ICs0OSw3
IEBACj4goCNkZWZpbmUgQUxVQV9QR19SVU5fUlRQR6CgoKCgoKCgoKCgoKCgoDB4MTAKPiCgI2Rl
ZmluZSBBTFVBX1BHX1JVTl9TVFBHoKCgoKCgoKCgoKCgoKCgMHgyMAo+IKAjZGVmaW5lIEFMVUFf
UEdfUlVOTklOR6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoDB4NDAKPiArI2RlZmluZSBBTFVBX1BH
X0ZBSUxFRKCgoKCgoKCgoKCgoKCgoKCgMHg4MAo+IKAKPiCgc3RhdGljIHVpbnQgb3B0aW1pemVf
c3RwZzsKPiCgbW9kdWxlX3BhcmFtKG9wdGltaXplX3N0cGcsIHVpbnQsIFNfSVJVR098U19JV1VT
Uik7Cj4gQEAgLTQyMCw3ICs0MjEsNyBAQCBzdGF0aWMgZW51bSBzY3NpX2Rpc3Bvc2l0aW9uCj4g
YWx1YV9jaGVja19zZW5zZShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYsCj4goKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgICovCj4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgcmN1X3JlYWRfbG9jaygp
Owo+IKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoHBnID0gcmN1X2RlcmVmZXJlbmNlKGgtPnBnKTsK
PiAtoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBpZiAocGcpCj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgaWYgKHBnICYmICEocGctPmZsYWdzICYgQUxVQV9QR19GQUlMRUQpKQo+IKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgcGctPnN0YXRlID0KPiBTQ1NJX0FDQ0VTU19TVEFURV9UUkFO
U0lUSU9OSU5HOwo+IKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoHJjdV9yZWFkX3VubG9jaygpOwo+
IKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoGFsdWFfY2hlY2soc2RldiwgZmFsc2UpOwoKWW91IHN0
aWxsIHJldHVybiBORUVEU19SRVRSWSBmcm9tIGFsdWFfY2hlY2tfc2Vuc2UoKSwgZXZlbiBpZgpB
TFVBX1BHX0ZBSUxFRCBpcyBzZXQ/Cgo+IEBAIC02OTQsNyArNjk1LDcgQEAgc3RhdGljIGludCBh
bHVhX3J0cGcoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LAo+IHN0cnVjdCBhbHVhX3BvcnRfZ3Jv
dXAgKnBnKQo+IKAKPiCgIHNraXBfcnRwZzoKPiCgoKCgoKCgoHNwaW5fbG9ja19pcnFzYXZlKCZw
Zy0+bG9jaywgZmxhZ3MpOwo+IC2goKCgoKCgaWYgKHRyYW5zaXRpb25pbmdfc2Vuc2UpCj4gK6Cg
oKCgoKBpZiAodHJhbnNpdGlvbmluZ19zZW5zZSAmJiAhKHBnLT5mbGFncyAmIEFMVUFfUEdfRkFJ
TEVEKSkKPiCgoKCgoKCgoKCgoKCgoKCgcGctPnN0YXRlID0gU0NTSV9BQ0NFU1NfU1RBVEVfVFJB
TlNJVElPTklORzsKPiCgCj4goKCgoKCgoKBpZiAoZ3JvdXBfaWRfb2xkICE9IHBnLT5ncm91cF9p
ZCB8fCBzdGF0ZV9vbGQgIT0gcGctPnN0YXRlIHx8Cj4gQEAgLTcxOCwyMyArNzE5LDEwIEBAIHN0
YXRpYyBpbnQgYWx1YV9ydHBnKHN0cnVjdCBzY3NpX2RldmljZSAqc2RldiwKPiBzdHJ1Y3QgYWx1
YV9wb3J0X2dyb3VwICpwZykKPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBwZy0+aW50ZXJ2YWwg
PSBBTFVBX1JUUEdfUkVUUllfREVMQVk7Cj4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgZXJyID0g
U0NTSV9ESF9SRVRSWTsKPiCgoKCgoKCgoKCgoKCgoKCgfSBlbHNlIHsKPiAtoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKBzdHJ1Y3QgYWx1YV9kaF9kYXRhICpoOwo+IC0KPiAtoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKAvKiBUcmFuc2l0aW9uaW5nIHRpbWUgZXhjZWVkZWQsIHNldCBwb3J0IHRvCj4gc3Rh
bmRieSAqLwo+ICugoKCgoKCgoKCgoKCgoKCgoKCgoKCgoC8qIFRyYW5zaXRpb25pbmcgdGltZSBl
eGNlZWRlZCwgbWFyayBwZyBhcwo+IGZhaWxlZCAqLwo+IKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oGVyciA9IFNDU0lfREhfSU87Cj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgcGctPnN0YXRlID0g
U0NTSV9BQ0NFU1NfU1RBVEVfU1RBTkRCWTsKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBwZy0+
ZmxhZ3MgfD0gQUxVQV9QR19GQUlMRUQ7Cj4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgcGctPmV4
cGlyeSA9IDA7Cj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgcmN1X3JlYWRfbG9jaygpOwo+IC2g
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoGxpc3RfZm9yX2VhY2hfZW50cnlfcmN1KGgsICZwZy0+ZGhf
bGlzdCwKPiBub2RlKSB7Cj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBpZiAoIWgt
PnNkZXYpCj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoGNvbnRpbnVl
Owo+IC2goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgaC0+c2Rldi0+YWNjZXNzX3N0YXRl
ID0KPiAtoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgKHBnLT5zdGF0ZSAm
Cj4gU0NTSV9BQ0NFU1NfU1RBVEVfTUFTSyk7Cj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKBpZiAocGctPnByZWYpCj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoGgtPnNkZXYtPmFjY2Vzc19zdGF0ZSB8PQo+IC0KPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoFNDU0lfQUNDRVNTX1NUQVRFX1BSRUZFCj4gUlJFRDsK
PiAtoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKB9Cj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgcmN1
X3JlYWRfdW5sb2NrKCk7Cj4goKCgoKCgoKCgoKCgoKCgoH0KPiCgoKCgoKCgoKCgoKCgoKCgYnJl
YWs7Cj4goKCgoKCgoKBjYXNlIFNDU0lfQUNDRVNTX1NUQVRFX09GRkxJTkU6Cj4gQEAgLTc0Niw2
ICs3MzQsOCBAQCBzdGF0aWMgaW50IGFsdWFfcnRwZyhzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYs
Cj4gc3RydWN0IGFsdWFfcG9ydF9ncm91cCAqcGcpCj4goKCgoKCgoKCgoKCgoKCgoC8qIFVzZWFi
bGUgcGF0aCBpZiBhY3RpdmUgKi8KPiCgoKCgoKCgoKCgoKCgoKCgZXJyID0gU0NTSV9ESF9PSzsK
PiCgoKCgoKCgoKCgoKCgoKCgcGctPmV4cGlyeSA9IDA7Cj4gK6CgoKCgoKCgoKCgoKCgoC8qIFJU
UEcgc3VjY2VlZGVkLCBjbGVhciBBTFVBX1BHX0ZBSUxFRCAqLwo+ICugoKCgoKCgoKCgoKCgoKBw
Zy0+ZmxhZ3MgJj0gfkFMVUFfUEdfRkFJTEVEOwoKU2hvdWxkbid0IHRoaXMgYmUgZG9uZSBmb3Ig
YW55IHN0YXRlIGV4Y2VwdCBUUkFOU0lUSU9OSU5HPwoKQnR3IEkndmUgcmUtcmVhZCBTUEM2IGFu
ZCBmb3VuZCAiVGhlIElNUExJQ0lUIFRSQU5TSVRJT04gVElNRSBmaWVsZAppbmRpY2F0ZXMgdGhl
IG1pbmltdW0gYW1vdW50IG9mIHRpbWUgaW4gc2Vjb25kcyB0aGUgYXBwbGljYXRpb24gY2xpZW50
CnNob3VsZCB3YWl0IHByaW9yIHRvIHRpbWluZyBvdXQgYW4gaW1wbGljaXQgc3RhdGUgdHJhbnNp
dGlvbiAoc2VlCjUuMTguMi4zKSIuoAoKVGhpcyBpcyB1bmNsZWFyIHRvIG1lLiAibWluaW11bSBh
bW91bnQgb2YgdGltZSIgc3VnZ2VzdHMgdGhhdCB0aGUgaG9zdApjb3VsZCBkZWNpZGUgdG8gd2Fp
dCBsb25nZXIgdW50aWwgaXQgdGltZXMgb3V0IHRoZSB0cmFuc2l0aW9uLiBXb3JzZSwKdGhlIHNw
ZWMgZG9lc24ndCBjbGVhcmx5IGRlZmluZSB3aGVuIHRoZSB0cmFuc2l0aW9uIGlzIHN1cHBvc2Vk
IHRvIGhhdmUKc3RhcnRlZC4gRnJvbSB0aGUgaG9zdCdzIFBvViBpdCBtYWtlcyBzZW5zZSB0byBh
c3N1bWUgdGhlIHN0YXJ0IHRpbWUgaXMKd2hlbiBpdCBmaXJzdCBlbmNvdW50ZXJzIGVpdGhlciBU
UkFOU0lUSU9OSU5HIGZyb20gYW4gUlRQRywgb3IgTk9UClJFQURZIC8gMDQgLyAwYSBmcm9tIGEg
cmVndWxhciBJL08sIHdoaWNoIGlzIHdoYXQgd2UgY3VycmVudGx5IGRvLiBCdXQKdGhlIHNwZWMg
aXMgcmVtYXJrYWJseSB1bmNsZWFyIGFib3V0IGl0LiBGaW5hbGx5LCB0aGUgc3BlYyBleHBsaWNp
dGx5CnNheXMgdGhhdCB0aGUgdGltZW91dCBhcHBsaWVzIG9ubHkgdG8gaW1wbGljaXQgdHJhbnNp
dGlvbnMsIHdpdGhvdXQKc2F5aW5nIHdoYXQgdG8gZG8gaW4gdGhlIGNhc2Ugb2YgYW4gZXhwbGlj
aXQgdHJhbnNpdGlvbi4uLgoKUmVnYXJkcywKTWFydGluCgo=

