Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AECC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 19:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiEYTdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 15:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiEYTdq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 15:33:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDE21260C
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 12:33:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9F70D21982;
        Wed, 25 May 2022 19:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653507223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ZfEWOfSE8ohd4PpAK42AepitR5XuIcj0TpU27Kbrwk=;
        b=FNig6IHplHG8sCdzhkWIuFRjVOKZ7kQBXX2L4AVgsuIM0HkpgCrv52TPhFaFpX3nFDhdS7
        AMLPUpi3DddJplzqiRwbBARYOQpGPJE5VoKhnjweZPTB6oUfgVKqzEn5PKXX9cTjVzod7g
        zhqGOoaczP/23uAgfg8ortwoy5CBLGs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 597A313ADF;
        Wed, 25 May 2022 19:33:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gCTkE5eEjmKhawAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 25 May 2022 19:33:43 +0000
Message-ID: <3161c450d78c79c3dbc8f471fd9d387f32f92d09.camel@suse.com>
Subject: Re: [PATCH] scsi_dh_alua: mark port group as failed after ALUA
 transitioning timeout
From:   Martin Wilck <mwilck@suse.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
        Martin Wilck <mwilck@suse.de>
Date:   Wed, 25 May 2022 21:33:42 +0200
In-Reply-To: <afa5f370-4e16-319f-ded8-49e11f12ff56@suse.de>
References: <20220525081139.88165-1-hare@suse.de>
         <37b61d6b956c18bf4a56d14b5746dab2719ef20d.camel@suse.com>
         <afa5f370-4e16-319f-ded8-49e11f12ff56@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIyLTA1LTI1IGF0IDE0OjA3ICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
Cj4gT24gNS8yNS8yMiAxMzoyMCwgTWFydGluIFdpbGNrIHdyb3RlOgo+ID4gT24gV2VkLCAyMDIy
LTA1LTI1IGF0IDEwOjExICswMjAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4gPiA+IFdoZW4g
QUxVQSB0cmFuc2l0aW9uaW5nIHRpbWVvdXQgdHJpZ2dlcnMgdGhlIHBhdGggZ3JvdXAgc3RhdGUK
PiA+ID4gbXVzdAo+ID4gPiBiZSBjb25zaWRlcmVkIGludmFsaWQuIFNvIGFkZCBhIG5ldyBmbGFn
IEFMVUFfUEdfRkFJTEVEIHRvCj4gPiA+IGluZGljYXRlCj4gPiA+IHRoYXQgdGhlIHBhdGggc3Rh
dGUgaXNuJ3QgbmVjZXNzYXJpbHkgdmFsaWQsIGFuZCBrZWVwIHRoZQo+ID4gPiBleGlzdGluZwo+
ID4gPiBwYXRoIHN0YXRlIHVudGlsIHdlIGdldCBhIHZhbGlkIHJlc3BvbnNlIGZyb20gYSBSVFBH
Lgo+ID4gPiAKPiA+ID4gQ2M6IEJyaWFuIEJ1bmtlciA8YnJpYW5AcHVyZXN0b3JhZ2UuY29tPgo+
ID4gPiBDYzogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5kZT4KPiA+ID4gU2lnbmVkLW9mZi1i
eTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+Cj4gPiA+IC0tLQo+ID4gPiCgoGRyaXZl
cnMvc2NzaS9kZXZpY2VfaGFuZGxlci9zY3NpX2RoX2FsdWEuYyB8IDI0ICsrKysrKystLS0tLS0t
LQo+ID4gPiAtLS0tLQo+ID4gPiAtLQo+ID4gPiCgoDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlv
bnMoKyksIDE3IGRlbGV0aW9ucygtKQo+ID4gPiAKPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c2NzaS9kZXZpY2VfaGFuZGxlci9zY3NpX2RoX2FsdWEuYwo+ID4gPiBiL2RyaXZlcnMvc2NzaS9k
ZXZpY2VfaGFuZGxlci9zY3NpX2RoX2FsdWEuYwo+ID4gPiBpbmRleCAxZDliZTc3MWYzZWUuLjY5
MjE0OTBhNWU2NSAxMDA2NDQKPiA+ID4gLS0tIGEvZHJpdmVycy9zY3NpL2RldmljZV9oYW5kbGVy
L3Njc2lfZGhfYWx1YS5jCj4gPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9kZXZpY2VfaGFuZGxlci9z
Y3NpX2RoX2FsdWEuYwo+ID4gPiBAQCAtNDksNiArNDksNyBAQAo+ID4gPiCgoCNkZWZpbmUgQUxV
QV9QR19SVU5fUlRQR6CgoKCgoKCgoKCgoKCgoDB4MTAKPiA+ID4goKAjZGVmaW5lIEFMVUFfUEdf
UlVOX1NUUEegoKCgoKCgoKCgoKCgoKAweDIwCj4gPiA+IKCgI2RlZmluZSBBTFVBX1BHX1JVTk5J
TkegoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAweDQwCj4gPiA+ICsjZGVmaW5lIEFMVUFfUEdfRkFJ
TEVEoKCgoKCgoKCgoKCgoKCgoKAweDgwCj4gPiA+IKAgCj4gPiA+IKCgc3RhdGljIHVpbnQgb3B0
aW1pemVfc3RwZzsKPiA+ID4goKBtb2R1bGVfcGFyYW0ob3B0aW1pemVfc3RwZywgdWludCwgU19J
UlVHT3xTX0lXVVNSKTsKPiA+ID4gQEAgLTQyMCw3ICs0MjEsNyBAQCBzdGF0aWMgZW51bSBzY3Np
X2Rpc3Bvc2l0aW9uCj4gPiA+IGFsdWFfY2hlY2tfc2Vuc2Uoc3RydWN0IHNjc2lfZGV2aWNlICpz
ZGV2LAo+ID4gPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgICovCj4gPiA+IKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKByY3VfcmVhZF9sb2NrKCk7Cj4gPiA+IKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKBwZyA9IHJjdV9kZXJlZmVyZW5jZShoLT5wZyk7Cj4gPiA+IC2goKCgoKCgoKCgoKCgoKCg
oKCgoKCgoGlmIChwZykKPiA+ID4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgaWYgKHBnICYmICEo
cGctPmZsYWdzICYgQUxVQV9QR19GQUlMRUQpKQo+ID4gPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKBwZy0+c3RhdGUgPQo+ID4gPiBTQ1NJX0FDQ0VTU19TVEFURV9UUkFOU0lUSU9O
SU5HOwo+ID4gPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgcmN1X3JlYWRfdW5sb2NrKCk7Cj4g
PiA+IKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBhbHVhX2NoZWNrKHNkZXYsIGZhbHNlKTsKPiA+
IAo+ID4gWW91IHN0aWxsIHJldHVybiBORUVEU19SRVRSWSBmcm9tIGFsdWFfY2hlY2tfc2Vuc2Uo
KSwgZXZlbiBpZgo+ID4gQUxVQV9QR19GQUlMRUQgaXMgc2V0Pwo+ID4gCj4gPiA+IEBAIC02OTQs
NyArNjk1LDcgQEAgc3RhdGljIGludCBhbHVhX3J0cGcoc3RydWN0IHNjc2lfZGV2aWNlCj4gPiA+
ICpzZGV2LAo+ID4gPiBzdHJ1Y3QgYWx1YV9wb3J0X2dyb3VwICpwZykKPiA+ID4goCAKPiA+ID4g
oKAgc2tpcF9ydHBnOgo+ID4gPiCgoKCgoKCgoKBzcGluX2xvY2tfaXJxc2F2ZSgmcGctPmxvY2ss
IGZsYWdzKTsKPiA+ID4gLaCgoKCgoKBpZiAodHJhbnNpdGlvbmluZ19zZW5zZSkKPiA+ID4gK6Cg
oKCgoKBpZiAodHJhbnNpdGlvbmluZ19zZW5zZSAmJiAhKHBnLT5mbGFncyAmIEFMVUFfUEdfRkFJ
TEVEKSkKPiA+ID4goKCgoKCgoKCgoKCgoKCgoKBwZy0+c3RhdGUgPSBTQ1NJX0FDQ0VTU19TVEFU
RV9UUkFOU0lUSU9OSU5HOwo+ID4gPiCgIAo+ID4gPiCgoKCgoKCgoKBpZiAoZ3JvdXBfaWRfb2xk
ICE9IHBnLT5ncm91cF9pZCB8fCBzdGF0ZV9vbGQgIT0gcGctCj4gPiA+ID5zdGF0ZSB8fAo+ID4g
PiBAQCAtNzE4LDIzICs3MTksMTAgQEAgc3RhdGljIGludCBhbHVhX3J0cGcoc3RydWN0IHNjc2lf
ZGV2aWNlCj4gPiA+ICpzZGV2LAo+ID4gPiBzdHJ1Y3QgYWx1YV9wb3J0X2dyb3VwICpwZykKPiA+
ID4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoHBnLT5pbnRlcnZhbCA9IEFMVUFfUlRQR19SRVRS
WV9ERUxBWTsKPiA+ID4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoGVyciA9IFNDU0lfREhfUkVU
Ulk7Cj4gPiA+IKCgoKCgoKCgoKCgoKCgoKCgfSBlbHNlIHsKPiA+ID4gLaCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgc3RydWN0IGFsdWFfZGhfZGF0YSAqaDsKPiA+ID4gLQo+ID4gPiAtoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKAvKiBUcmFuc2l0aW9uaW5nIHRpbWUgZXhjZWVkZWQsIHNldCBwb3J0Cj4g
PiA+IHRvCj4gPiA+IHN0YW5kYnkgKi8KPiA+ID4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgLyog
VHJhbnNpdGlvbmluZyB0aW1lIGV4Y2VlZGVkLCBtYXJrIHBnCj4gPiA+IGFzCj4gPiA+IGZhaWxl
ZCAqLwo+ID4gPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgZXJyID0gU0NTSV9ESF9JTzsKPiA+
ID4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgcGctPnN0YXRlID0gU0NTSV9BQ0NFU1NfU1RBVEVf
U1RBTkRCWTsKPiA+ID4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgcGctPmZsYWdzIHw9IEFMVUFf
UEdfRkFJTEVEOwo+ID4gPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgcGctPmV4cGlyeSA9IDA7
Cj4gPiA+IC2goKCgoKCgoKCgoKCgoKCgoKCgoKCgoHJjdV9yZWFkX2xvY2soKTsKPiA+ID4gLaCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgbGlzdF9mb3JfZWFjaF9lbnRyeV9yY3UoaCwgJnBnLT5kaF9s
aXN0LAo+ID4gPiBub2RlKSB7Cj4gPiA+IC2goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
aWYgKCFoLT5zZGV2KQo+ID4gPiAtoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgY29udGludWU7Cj4gPiA+IC2goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgaC0+c2Rl
di0+YWNjZXNzX3N0YXRlID0KPiA+ID4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoChwZy0+c3RhdGUgJgo+ID4gPiBTQ1NJX0FDQ0VTU19TVEFURV9NQVNLKTsKPiA+ID4g
LaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBpZiAocGctPnByZWYpCj4gPiA+IC2goKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBoLT5zZGV2LT5hY2Nlc3Nfc3RhdGUg
fD0KPiA+ID4gLQo+ID4gPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKBTQ1NJX0FDQ0VTU19TVEFURQo+ID4gPiBfUFJFRkUKPiA+ID4gUlJFRDsKPiA+ID4g
LaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgfQo+ID4gPiAtoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBy
Y3VfcmVhZF91bmxvY2soKTsKPiA+ID4goKCgoKCgoKCgoKCgoKCgoKB9Cj4gPiA+IKCgoKCgoKCg
oKCgoKCgoKCgYnJlYWs7Cj4gPiA+IKCgoKCgoKCgoGNhc2UgU0NTSV9BQ0NFU1NfU1RBVEVfT0ZG
TElORToKPiA+ID4gQEAgLTc0Niw2ICs3MzQsOCBAQCBzdGF0aWMgaW50IGFsdWFfcnRwZyhzdHJ1
Y3Qgc2NzaV9kZXZpY2UKPiA+ID4gKnNkZXYsCj4gPiA+IHN0cnVjdCBhbHVhX3BvcnRfZ3JvdXAg
KnBnKQo+ID4gPiCgoKCgoKCgoKCgoKCgoKCgoC8qIFVzZWFibGUgcGF0aCBpZiBhY3RpdmUgKi8K
PiA+ID4goKCgoKCgoKCgoKCgoKCgoKBlcnIgPSBTQ1NJX0RIX09LOwo+ID4gPiCgoKCgoKCgoKCg
oKCgoKCgoHBnLT5leHBpcnkgPSAwOwo+ID4gPiAroKCgoKCgoKCgoKCgoKCgLyogUlRQRyBzdWNj
ZWVkZWQsIGNsZWFyIEFMVUFfUEdfRkFJTEVEICovCj4gPiA+ICugoKCgoKCgoKCgoKCgoKBwZy0+
ZmxhZ3MgJj0gfkFMVUFfUEdfRkFJTEVEOwo+ID4gCj4gPiBTaG91bGRuJ3QgdGhpcyBiZSBkb25l
IGZvciBhbnkgc3RhdGUgZXhjZXB0IFRSQU5TSVRJT05JTkc/Cj4gPiAKPiBXaHksIGJ1dCBpdCBk
b2VzLgo+IFdlJ3JlIG9ubHkgZW50ZXJpbmcgdGhpcyBibG9jayBpZiB0aGUgc3RhdGUgaXMgbm90
IFRSQU5TSVRJT05JTkcuCj4gKEl0J3MgcGFydCBvZiBhICdzd2l0Y2gnIHN0YXRlbWVudCkKClJp
Z2h0LCB0aGUgb25seSBleGNlcHRpb24gaXMgU0NTSV9BQ0NFU1NfU1RBVEVfT0ZGTElORSwgZm9y
IHdoaWNoIHRoZQpBTFVBX1BHX0ZBSUxFRCBzdGF0ZSBzaG91bGQgb2YgY2F1c2UgcGVyc2lzdC4g
U29ycnkgZm9yIGJvdGhlcmluZy4KCgpNYXJ0aW4K

