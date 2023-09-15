Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13EBC46CA1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 20:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbjIOUqo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 16:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbjIOUqL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 16:46:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E91186
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:46:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A97181FD7D;
        Fri, 15 Sep 2023 20:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694810764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HPF86OLAijoZtJMxzWcWLVnCNBYE3xMaEXO3JKecllo=;
        b=kf2ZmuUcm7OtNrnmr6g/Z3/NsvDeITekK9iH1RgKOKjDAkskUOf+a6ZioLilRQyBAWxhKS
        F2XtI0X3dgaoSPWZz1J/KMZHcI7+CQc1ztI4FS0Ycwh/VJxioh102Th0ZsahMymgK4UdqP
        hel9Zxe+aZhP/EDpIM+WG0YzSSIs/Zo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 518531358A;
        Fri, 15 Sep 2023 20:46:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GCAeEozCBGXSGAAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 20:46:04 +0000
Message-ID: <c83a61021ecc165d20bfd0fee47ca83233e3078f.camel@suse.com>
Subject: Re: [PATCH v11 10/34] scsi: Have scsi-ml retry sd_spinup_disk errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 22:46:03 +0200
In-Reply-To: <20230905231547.83945-11-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-11-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIzLTA5LTA1IGF0IDE4OjE1IC0wNTAwLCBNaWtlIENocmlzdGllIHdyb3RlOgo+
IFRoaXMgc2ltcGxpZmllcyBzZF9zcGludXBfZGlzayBzbyBzY3NpLW1sIHJldHJpZXMgZXJyb3Jz
IGZvciBpdC4gTm90ZQo+IHRoYXQKPiB3ZSByZXRyaWVkIHNwZWNpZmljYWxseSBvbiBhIFVBIGFu
ZCBhbHNvIGlmIHNjc2lfc3RhdHVzX2lzX2dvb2QKPiByZXR1cm5lZAo+IGZhaWxlZCB3aGljaCB3
b3VsZCBoYXBwZW4gZm9yIGFsbCBjaGVjayBjb25kaXRpb25zLiBJbiB0aGlzIHBhdGNoIHdlCj4g
dXNlCj4gU0NNRF9GQUlMVVJFX1NUQVRfQU5ZIHdoaWNoIHdpbGwgdHJpZ2dlciBmb3IgdGhlIHNh
bWUgY29uZGl0aW9ucyBhcwo+IHdoZW4gc2NzaV9zdGF0dXNfaXNfZ29vZCByZXR1cm5zIGZhbHNl
LiBUaGlzIHdpbGwgY292ZXIgYWxsIENDcwo+IGluY2x1ZGluZwo+IFVBcyBzbyB0aGVyZSBpcyBu
byBleHBsaWNpdCBmYWlsdXJlcyBhcnJhcnkgZW50cnkgZm9yIFVBcy4KPiAKPiBXZSBkbyBub3Qg
aGFuZGxlIHRoZSBvdXRzaWRlIGxvb3AncyByZXRyaWVzIGJlY2F1c2Ugd2Ugd2FudCB0byBzbGVl
cAo+IGJldHdlZW4gdHJpZXMgYW5kIHdlIGRvbid0IHN1cHBvcnQgdGhhdCB5ZXQuCj4gCj4gU2ln
bmVkLW9mZi1ieTogTWlrZSBDaHJpc3RpZSA8bWljaGFlbC5jaHJpc3RpZUBvcmFjbGUuY29tPgo+
IFJldmlld2VkLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KPiBSZXZpZXdlZC1i
eTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+Cj4gLS0tCj4goGRyaXZlcnMv
c2NzaS9zZC5jIHwgNzMgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0t
LS0tCj4gLS0KPiCgMSBmaWxlIGNoYW5nZWQsIDQxIGluc2VydGlvbnMoKyksIDMyIGRlbGV0aW9u
cygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc2QuYyBiL2RyaXZlcnMvc2NzaS9z
ZC5jCj4gaW5kZXggNzQ5NjdlMWIxOWRhLi5mNWU2YjVjYzc2MmYgMTAwNjQ0Cj4gLS0tIGEvZHJp
dmVycy9zY3NpL3NkLmMKPiArKysgYi9kcml2ZXJzL3Njc2kvc2QuYwo+IEBAIC0yMTUxLDU1ICsy
MTUxLDY0IEBAIHN0YXRpYyBpbnQgc2RfZG9uZShzdHJ1Y3Qgc2NzaV9jbW5kICpTQ3BudCkKPiCg
c3RhdGljIHZvaWQKPiCgc2Rfc3BpbnVwX2Rpc2soc3RydWN0IHNjc2lfZGlzayAqc2RrcCkKPiCg
ewo+IC2goKCgoKCgdW5zaWduZWQgY2hhciBjbWRbMTBdOwo+ICugoKCgoKCgc3RhdGljIGNvbnN0
IHU4IGNtZFsxMF0gPSB7IFRFU1RfVU5JVF9SRUFEWSB9Owo+IKCgoKCgoKCgdW5zaWduZWQgbG9u
ZyBzcGludGltZV9leHBpcmUgPSAwOwo+IC2goKCgoKCgaW50IHJldHJpZXMsIHNwaW50aW1lOwo+
ICugoKCgoKCgaW50IHNwaW50aW1lLCBzZW5zZV92YWxpZCA9IDA7Cj4goKCgoKCgoKB1bnNpZ25l
ZCBpbnQgdGhlX3Jlc3VsdDsKPiCgoKCgoKCgoHN0cnVjdCBzY3NpX3NlbnNlX2hkciBzc2hkcjsK
PiAroKCgoKCgoHN0cnVjdCBzY3NpX2ZhaWx1cmUgZmFpbHVyZXNbXSA9IHsKPiAroKCgoKCgoKCg
oKCgoKCgLyogRmFpbCBpbW1lZGlhdGVseSBmb3IgTWVkaXVtIE5vdCBQcmVzZW50ICovCj4gK6Cg
oKCgoKCgoKCgoKCgoHsKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAuc2Vuc2UgPSBVTklUX0FU
VEVOVElPTiwKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAuYXNjID0gMHgzQSwKClNob3VsZG4n
dCB5b3Ugc2V0IC5hc2NxID0gU0NNRF9GQUlMVVJFX0FTQ1FfQU5ZIGhlcmUsIGFuZCBiZWxvdyBh
cwp3ZWxsPwoKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAuYWxsb3dlZCA9IDAsCj4gK6CgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgLnJlc3VsdCA9IFNBTV9TVEFUX0NIRUNLX0NPTkRJVElPTiwKPiAr
oKCgoKCgoKCgoKCgoKCgfSwKPiAroKCgoKCgoKCgoKCgoKCgewo+ICugoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoC5zZW5zZSA9IE5PVF9SRUFEWSwKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAuYXNj
ID0gMHgzQSwKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAuYWxsb3dlZCA9IDAsCj4gK6CgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgLnJlc3VsdCA9IFNBTV9TVEFUX0NIRUNLX0NPTkRJVElPTiwKPiAr
oKCgoKCgoKCgoKCgoKCgfSwKPiAroKCgoKCgoKCgoKCgoKCgewo+ICugoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoC5yZXN1bHQgPSBTQ01EX0ZBSUxVUkVfU1RBVF9BTlksCj4gK6CgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgLmFsbG93ZWQgPSAzLAo+ICugoKCgoKCgoKCgoKCgoKB9LAo+ICugoKCgoKCgoKCg
oKCgoKB7fQo+ICugoKCgoKCgfTsKPiCgoKCgoKCgoGNvbnN0IHN0cnVjdCBzY3NpX2V4ZWNfYXJn
cyBleGVjX2FyZ3MgPSB7Cj4goKCgoKCgoKCgoKCgoKCgoC5zc2hkciA9ICZzc2hkciwKPiAroKCg
oKCgoKCgoKCgoKCgLmZhaWx1cmVzID0gZmFpbHVyZXMsCj4goKCgoKCgoKB9Owo+IC2goKCgoKCg
aW50IHNlbnNlX3ZhbGlkID0gMDsKPiCgCj4goKCgoKCgoKBzcGludGltZSA9IDA7Cj4goAo+IKCg
oKCgoKCgLyogU3BpbiB1cCBkcml2ZXMsIGFzIHJlcXVpcmVkLqAgT25seSBkbyB0aGlzIGF0IGJv
b3QgdGltZSAqLwo+IKCgoKCgoKCgLyogU3BpbnVwIG5lZWRzIHRvIGJlIGRvbmUgZm9yIG1vZHVs
ZSBsb2FkcyB0b28uICovCj4goKCgoKCgoKBkbyB7Cj4gLaCgoKCgoKCgoKCgoKCgoHJldHJpZXMg
PSAwOwo+IC0KPiAtoKCgoKCgoKCgoKCgoKCgZG8gewo+IC2goKCgoKCgoKCgoKCgoKCgoKCgoKCg
oGJvb2wgbWVkaWFfd2FzX3ByZXNlbnQgPSBzZGtwLT5tZWRpYV9wcmVzZW50Owo+ICugoKCgoKCg
oKCgoKCgoKBib29sIG1lZGlhX3dhc19wcmVzZW50ID0gc2RrcC0+bWVkaWFfcHJlc2VudDsKPiCg
Cj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgY21kWzBdID0gVEVTVF9VTklUX1JFQURZOwo+IC2g
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoG1lbXNldCgodm9pZCAqKSAmY21kWzFdLCAwLCA5KTsKPiAr
oKCgoKCgoKCgoKCgoKCgc2NzaV9yZXNldF9mYWlsdXJlcyhmYWlsdXJlcyk7Cj4goAo+IC2goKCg
oKCgoKCgoKCgoKCgoKCgoKCgoHRoZV9yZXN1bHQgPSBzY3NpX2V4ZWN1dGVfY21kKHNka3AtPmRl
dmljZSwKPiBjbWQsCj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKAgUkVRX09QX0RSVl9JTiwKPiBOVUxMLCAwLAo+IC2goKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIFNEX1RJTUVPVVQsCj4gLaCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgc2RrcC0KPiA+
bWF4X3JldHJpZXMsCj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKAgJmV4ZWNfYXJncyk7Cj4gK6CgoKCgoKCgoKCgoKCgoHRoZV9yZXN1bHQgPSBz
Y3NpX2V4ZWN1dGVfY21kKHNka3AtPmRldmljZSwgY21kLAo+IFJFUV9PUF9EUlZfSU4sCj4gK6Cg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIE5VTEwsIDAsIFNEX1RJ
TUVPVVQsCj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIHNk
a3AtPm1heF9yZXRyaWVzLAo+ICZleGVjX2FyZ3MpOwo+IKAKPiAtoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKBpZiAodGhlX3Jlc3VsdCA+IDApIHsKPiAtoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoC8qCj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgKiBJZiB0aGUgZHJpdmUg
aGFzIGluZGljYXRlZCB0byB1cwo+IHRoYXQgaXQKPiAtoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoCAqIGRvZXNuJ3QgaGF2ZSBhbnkgbWVkaWEgaW4gaXQsCj4gZG9uJ3QgYm90aGVyCj4g
LaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgKiB3aXRoIGFueSBtb3JlIHBvbGxpbmcu
Cj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgKi8KPiAtoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoGlmIChtZWRpYV9ub3RfcHJlc2VudChzZGtwLCAmc3NoZHIpKQo+IHsK
PiAtoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgaWYgKG1lZGlhX3dhc19w
cmVzZW50KQo+IC0KPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoHNkX3ByaW50ayhLRVJOX05PVElDRSwKPiBzZGtwLAo+IC2goKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCAiTWVkaWEKPiByZW1vdmVkLCBz
dG9wcGVkIHBvbGxpbmdcbiIpOwo+IC2goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKByZXR1cm47Cj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKB9Cj4goAo+IC2g
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgc2Vuc2VfdmFsaWQgPQo+IHNjc2lfc2Vuc2Vf
dmFsaWQoJnNzaGRyKTsKPiAroKCgoKCgoKCgoKCgoKCgaWYgKHRoZV9yZXN1bHQgPiAwKSB7Cj4g
K6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgLyoKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgKiBJ
ZiB0aGUgZHJpdmUgaGFzIGluZGljYXRlZCB0byB1cyB0aGF0IGl0Cj4gZG9lc24ndAo+ICugoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoCAqIGhhdmUgYW55IG1lZGlhIGluIGl0LCBkb24ndCBib3RoZXIg
d2l0aAo+IGFueSBtb3JlCj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgICogcG9sbGluZy4KPiAr
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgKi8KPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBpZiAo
bWVkaWFfbm90X3ByZXNlbnQoc2RrcCwgJnNzaGRyKSkgewo+ICugoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgaWYgKG1lZGlhX3dhc19wcmVzZW50KQo+ICugoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKBzZF9wcmludGsoS0VSTl9OT1RJQ0UsIHNka3AsCj4gK6CgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCAiTWVkaWEgcmVtb3Zl
ZCwKPiBzdG9wcGVkIHBvbGxpbmdcbiIpOwo+ICugoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgcmV0dXJuOwo+IKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoH0KPiAtoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKByZXRyaWVzKys7Cj4gLaCgoKCgoKCgoKCgoKCgoH0gd2hpbGUgKHJldHJpZXMgPCAz
ICYmCj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgICghc2NzaV9zdGF0dXNfaXNfZ29vZCh0aGVf
cmVzdWx0KSB8fAo+IC2goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgKHNjc2lfc3RhdHVzX2lzX2No
ZWNrX2NvbmRpdGlvbih0aGVfcmVzdWx0KQo+ICYmCj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oCBzZW5zZV92YWxpZCAmJiBzc2hkci5zZW5zZV9rZXkgPT0KPiBVTklUX0FUVEVOVElPTikpKTsK
PiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBzZW5zZV92YWxpZCA9IHNjc2lfc2Vuc2VfdmFsaWQo
JnNzaGRyKTsKPiAroKCgoKCgoKCgoKCgoKCgfQo+IKAKPiCgoKCgoKCgoKCgoKCgoKCgaWYgKCFz
Y3NpX3N0YXR1c19pc19jaGVja19jb25kaXRpb24odGhlX3Jlc3VsdCkpIHsKPiCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKAvKiBubyBzZW5zZSwgVFVSIGVpdGhlciBzdWNjZWVkZWQgb3IgZmFpbGVk
Cgo=

