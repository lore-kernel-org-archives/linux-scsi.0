Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D45C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 14:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiI2OQ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbiI2OQ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 10:16:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BD1153ED9
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 07:16:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4DA1E1F976;
        Thu, 29 Sep 2022 14:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664460985; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uTfPcPotHuHkeuVC8PIQfVO+dJ2mVTIEBd6Wyabu8qc=;
        b=AlbagWoW5QOZAOzIav69pUwxGQC/9fWd3Ji6dVAR8kqkpynKk/80jk1Wv3Cw8ubF900lga
        GG0Plze/bKpmNtUmZxQ6mvu0Z8quEw0su5hzMMKouFzwmyx8FNkC/paPBA1HNCx7Es2wpp
        F4Ixx4f/rDV4QKAaYLNQaPP93wt1ma0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 13A1713A71;
        Thu, 29 Sep 2022 14:16:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5XI7A7moNWMNPQAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 29 Sep 2022 14:16:25 +0000
Message-ID: <b9909eb1604176071fa26f59904fd620f9e47a10.camel@suse.com>
Subject: Re: [PATCH v2 24/35] scsi: hp_sw: Have scsi-ml retry scsi_exec_req
 errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Thu, 29 Sep 2022 16:16:24 +0200
In-Reply-To: <20220929025407.119804-25-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
         <20220929025407.119804-25-michael.christie@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIyLTA5LTI4IGF0IDIxOjUzIC0wNTAwLCBNaWtlIENocmlzdGllIHdyb3RlOgo+
IFRoaXMgaGFzIGhwX3N3IGhhdmUgc2NzaS1tbCByZXRyeSBzY3NpX2V4ZWNfcmVxIGVycm9ycyBp
bnN0ZWFkIG9mCj4gZHJpdmluZwo+IHRoZW0gaXRzZWxmLgo+IAo+IFNpZ25lZC1vZmYtYnk6IE1p
a2UgQ2hyaXN0aWUgPG1pY2hhZWwuY2hyaXN0aWVAb3JhY2xlLmNvbT4KPiAtLS0KPiCgZHJpdmVy
cy9zY3NpL2RldmljZV9oYW5kbGVyL3Njc2lfZGhfaHBfc3cuYyB8IDU4ICsrKysrKysrKysrKyst
LS0tLS0KPiAtLQo+IKAxIGZpbGUgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgMjMgZGVsZXRp
b25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9kZXZpY2VfaGFuZGxlci9zY3Np
X2RoX2hwX3N3LmMKPiBiL2RyaXZlcnMvc2NzaS9kZXZpY2VfaGFuZGxlci9zY3NpX2RoX2hwX3N3
LmMKPiBpbmRleCBhZGNiZTNiODgzYjcuLmMxODY4MDlmMmUxNyAxMDA2NDQKPiAtLS0gYS9kcml2
ZXJzL3Njc2kvZGV2aWNlX2hhbmRsZXIvc2NzaV9kaF9ocF9zdy5jCj4gKysrIGIvZHJpdmVycy9z
Y3NpL2RldmljZV9oYW5kbGVyL3Njc2lfZGhfaHBfc3cuYwo+IEBAIC00Niw5ICs0Niw2IEBAIHN0
YXRpYyBpbnQgdHVyX2RvbmUoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LAo+IHN0cnVjdCBocF9z
d19kaF9kYXRhICpoLAo+IKCgoKCgoKCgaW50IHJldCA9IFNDU0lfREhfSU87Cj4goAo+IKCgoKCg
oKCgc3dpdGNoIChzc2hkci0+c2Vuc2Vfa2V5KSB7Cj4gLaCgoKCgoKBjYXNlIFVOSVRfQVRURU5U
SU9OOgo+IC2goKCgoKCgoKCgoKCgoKByZXQgPSBTQ1NJX0RIX0lNTV9SRVRSWTsKPiAtoKCgoKCg
oKCgoKCgoKCgYnJlYWs7Cj4goKCgoKCgoKBjYXNlIE5PVF9SRUFEWToKPiCgoKCgoKCgoKCgoKCg
oKCgaWYgKHNzaGRyLT5hc2MgPT0gMHgwNCAmJiBzc2hkci0+YXNjcSA9PSAyKSB7Cj4goKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgLyoKPiBAQCAtODUsOCArODIsMTcgQEAgc3RhdGljIGludCBocF9z
d190dXIoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LAo+IHN0cnVjdCBocF9zd19kaF9kYXRhICpo
KQo+IKCgoKCgoKCgaW50IHJldCA9IFNDU0lfREhfT0ssIHJlczsKPiCgoKCgoKCgoGJsa19vcGZf
dCByZXFfZmxhZ3MgPSBSRVFfRkFJTEZBU1RfREVWIHwKPiBSRVFfRkFJTEZBU1RfVFJBTlNQT1JU
IHwKPiCgoKCgoKCgoKCgoKCgoKCgUkVRX0ZBSUxGQVNUX0RSSVZFUjsKPiAroKCgoKCgoHN0cnVj
dCBzY3NpX2ZhaWx1cmUgZmFpbHVyZXNbXSA9IHsKPiAroKCgoKCgoKCgoKCgoKCgewo+ICugoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoC5zZW5zZSA9IFVOSVRfQVRURU5USU9OLAo+ICugoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoC5hc2MgPSBTQ01EX0ZBSUxVUkVfQVNDX0FOWSwKPiAroKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKAuYXNjcSA9IFNDTURfRkFJTFVSRV9BU0NRX0FOWSwKPiAroKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKAuYWxsb3dlZCA9IFNDTURfRkFJTFVSRV9OT19MSU1JVCwKPiAroKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKAucmVzdWx0ID0gU0FNX1NUQVRfQ0hFQ0tfQ09ORElUSU9OLAo+ICugoKCg
oKCgoKCgoKCgoKB9LAo+ICugoKCgoKCgoKCgoKCgoKB7fSwKPiAroKCgoKCgoH07Cj4goAo+IC1y
ZXRyeToKPiCgoKCgoKCgoHJlcyA9IHNjc2lfZXhlY19yZXEoKChzdHJ1Y3Qgc2NzaV9leGVjX2Fy
Z3MpIHsKPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoC5zZGV2ID0gc2RldiwKPiCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoC5jbWQgPSBjbWQsCj4gQEAgLTk0LDcgKzEw
MCw4IEBAIHN0YXRpYyBpbnQgaHBfc3dfdHVyKHN0cnVjdCBzY3NpX2RldmljZSAqc2RldiwKPiBz
dHJ1Y3QgaHBfc3dfZGhfZGF0YSAqaCkKPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oC5zc2hkciA9ICZzc2hkciwKPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoC50aW1l
b3V0ID0gSFBfU1dfVElNRU9VVCwKPiCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoC5y
ZXRyaWVzID0gSFBfU1dfUkVUUklFUywKPiAtoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oC5vcF9mbGFncyA9IHJlcV9mbGFncyB9KSk7Cj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKAub3BfZmxhZ3MgPSByZXFfZmxhZ3MsCj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKAuZmFpbHVyZXMgPSBmYWlsdXJlcyB9KSk7Cj4goKCgoKCgoKBpZiAocmVzKSB7Cj4goKCg
oKCgoKCgoKCgoKCgoGlmIChzY3NpX3NlbnNlX3ZhbGlkKCZzc2hkcikpCj4goKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgcmV0ID0gdHVyX2RvbmUoc2RldiwgaCwgJnNzaGRyKTsKPiBAQCAtMTA4LDgg
KzExNSw2IEBAIHN0YXRpYyBpbnQgaHBfc3dfdHVyKHN0cnVjdCBzY3NpX2RldmljZSAqc2RldiwK
PiBzdHJ1Y3QgaHBfc3dfZGhfZGF0YSAqaCkKPiCgoKCgoKCgoKCgoKCgoKCgaC0+cGF0aF9zdGF0
ZSA9IEhQX1NXX1BBVEhfQUNUSVZFOwo+IKCgoKCgoKCgoKCgoKCgoKByZXQgPSBTQ1NJX0RIX09L
Owo+IKCgoKCgoKCgfQo+IC2goKCgoKCgaWYgKHJldCA9PSBTQ1NJX0RIX0lNTV9SRVRSWSkKPiAt
oKCgoKCgoKCgoKCgoKCgZ290byByZXRyeTsKPiCgCj4goKCgoKCgoKByZXR1cm4gcmV0Owo+IKB9
Cj4gQEAgLTEyNiwxOSArMTMxLDMzIEBAIHN0YXRpYyBpbnQgaHBfc3dfc3RhcnRfc3RvcChzdHJ1
Y3QKPiBocF9zd19kaF9kYXRhICpoKQo+IKCgoKCgoKCgc3RydWN0IHNjc2lfc2Vuc2VfaGRyIHNz
aGRyOwo+IKCgoKCgoKCgc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2ID0gaC0+c2RldjsKPiCgoKCg
oKCgoGludCByZXMsIHJjID0gU0NTSV9ESF9PSzsKPiAtoKCgoKCgoGludCByZXRyeV9jbnQgPSBI
UF9TV19SRVRSSUVTOwo+IKCgoKCgoKCgYmxrX29wZl90IHJlcV9mbGFncyA9IFJFUV9GQUlMRkFT
VF9ERVYgfAo+IFJFUV9GQUlMRkFTVF9UUkFOU1BPUlQgfAo+IKCgoKCgoKCgoKCgoKCgoKBSRVFf
RkFJTEZBU1RfRFJJVkVSOwo+ICugoKCgoKCgc3RydWN0IHNjc2lfZmFpbHVyZSBmYWlsdXJlc1td
ID0gewo+ICugoKCgoKCgoKCgoKCgoKB7Cj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgLyoKPiAr
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgKiBMVU4gbm90IHJlYWR5IC0gbWFudWFsIGludGVydmVu
dGlvbgo+IHJlcXVpcmVkCj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgICoKPiAroKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKAgKiBTd2l0Y2gtb3ZlciBpbiBwcm9ncmVzcywgcmV0cnkuCj4gK6CgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgICovCj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgLnNlbnNlID0g
Tk9UX1JFQURZLAo+ICugoKCgoKCgoKCgoKCgoKCgoKCgoKCgoC5hc2MgPSAweDA0LAo+ICugoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoC5hc2NxID0gMHgwMywKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKAuYWxsb3dlZCA9IEhQX1NXX1JFVFJJRVMsCj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgLnJl
c3VsdCA9IFNBTV9TVEFUX0NIRUNLX0NPTkRJVElPTiwKPiAroKCgoKCgoKCgoKCgoKCgfSwKPiAr
oKCgoKCgoKCgoKCgoKCge30sCj4gK6CgoKCgoKB9Owo+IKAKPiAtcmV0cnk6Cj4goKCgoKCgoKBy
ZXMgPSBzY3NpX2V4ZWNfcmVxKCgoc3RydWN0IHNjc2lfZXhlY19hcmdzKSB7Cj4gLaCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAuc2RldiA9IHNkZXYsCj4gLaCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKAuY21kID0gY21kLAo+IC2goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgLmRhdGFfZGlyID0gRE1BX05PTkUsCj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKAuc3NoZHIgPSAmc3NoZHIsCj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAudGlt
ZW91dCA9IEhQX1NXX1RJTUVPVVQsCj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAu
cmV0cmllcyA9IEhQX1NXX1JFVFJJRVMsCj4gLaCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKAub3BfZmxhZ3MgPSByZXFfZmxhZ3MgfSkpOwo+ICugoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKAuc2RldiA9IHNkZXYsCj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoC5jbWQgPSBjbWQsCj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoC5kYXRhX2RpciA9IERNQV9OT05FLAo+ICugoKCgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKAuc3NoZHIgPSAmc3NoZHIsCj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoC50aW1lb3V0ID0gSFBfU1dfVElNRU9VVCwKPiAroKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgLnJldHJpZXMgPSBIUF9TV19SRVRSSUVTLAo+
ICugoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAub3BfZmxhZ3MgPSByZXFf
ZmxhZ3MsCj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoC5mYWlsdXJl
cyA9IGZhaWx1cmVzIH0pKTsKCk5pdHBpY2s6IHRoaXMgbG9va3MgYXMgaWYgeW91IGhhZG4ndCBn
b3QgdGhlIGluZGVudGF0aW9uIHJpZ2h0IGluCjA4LzM1LgoKTWFydGluCgo=

