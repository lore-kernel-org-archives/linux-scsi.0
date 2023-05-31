Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229E9C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 31 May 2023 16:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjEaQrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 12:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjEaQrT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 12:47:19 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0A198
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 09:47:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 853B92186B;
        Wed, 31 May 2023 16:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1685551636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lyWjfQNkfbbLc3J/O9ZZkR0+Z0HSNTwcpWLe6vt8SdY=;
        b=dGAnsIzUPut2bncMLeIsyKZVmRojCKuibrjne8Mkmt2bnaJQLkEXkuKVV/RkkBITVriZoD
        ia/aJOSh8mQStlNPCRbVMRz09iUXj4GQ99pMX7hxbKry27+fM65ZogxNiSOW3qc4h4WMmx
        i9PueMSxBYWQNLJ7eg7+guYdzcruVF4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5A076138E8;
        Wed, 31 May 2023 16:47:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ayx6FBR6d2QhcQAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 31 May 2023 16:47:16 +0000
Message-ID: <a75ece3d35f6d313823dbfcc62bb76e047278afd.camel@suse.com>
Subject: Re: [PATCH 3/9] lpfc: Account for fabric domain ctlr device loss
 recovery
From:   Martin Wilck <mwilck@suse.com>
To:     Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com
Date:   Wed, 31 May 2023 18:47:15 +0200
In-Reply-To: <20230523183206.7728-4-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
         <20230523183206.7728-4-justintee8345@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDIzLTA1LTIzIGF0IDExOjMyIC0wNzAwLCBKdXN0aW4gVGVlIHdyb3RlOgo+IFBy
ZS1leGlzdGluZyBkZXZpY2UgbG9zcyByZWNvdmVyeSBsb2dpYyB2aWEgdGhlCj4gTkxQX0lOX1JF
Q09WX1BPU1RfREVWX0xPU1MKPiBmbGFnIG9ubHkgaGFuZGxlZCBGYWJyaWMgUG9ydCBMb2dpbiwg
RmFicmljIENvbnRyb2xsZXIsIE1hbmFnZW1lbnQsCj4gYW5kCj4gTmFtZSBTZXJ2ZXIgYWRkcmVz
c2VzLgo+IAo+IEZhYnJpYyBkb21haW4gY29udHJvbGxlcnMgZmFsbCB1bmRlciB0aGUgc2FtZSBj
YXRlZ29yeSBmb3IgdXNhZ2Ugb2YKPiB0aGUKPiBOTFBfSU5fUkVDT1ZfUE9TVF9ERVZfTE9TUyBm
bGFnLqAgQWRkIGEgZGVmYXVsdCBjYXNlIHN0YXRlbWVudCB0bwo+IG1hcmsKPiBhbiBuZGxwIGZv
ciBkZXZpY2UgbG9zcyByZWNvdmVyeS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBKdXN0aW4gVGVlIDxq
dXN0aW4udGVlQGJyb2FkY29tLmNvbT4KClRoaXMgcGF0Y2ggZml4ZWQgYSBjdXN0b21lciBpc3N1
ZSBmb3IgdXMuCgpBY2tlZC1ieTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+CgoKPiAt
LS0KPiCgZHJpdmVycy9zY3NpL2xwZmMvbHBmY19oYmFkaXNjLmMgfCAxOSArKysrKysrKysrKysr
Ky0tLS0tCj4goDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygt
KQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvbHBmYy9scGZjX2hiYWRpc2MuYwo+IGIv
ZHJpdmVycy9zY3NpL2xwZmMvbHBmY19oYmFkaXNjLmMKPiBpbmRleCBmOTliNWMyMDZjZGIuLmE1
YzY5ZDRiZjJlMCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL3Njc2kvbHBmYy9scGZjX2hiYWRpc2Mu
Ywo+ICsrKyBiL2RyaXZlcnMvc2NzaS9scGZjL2xwZmNfaGJhZGlzYy5jCj4gQEAgLTQ1OCwxMSAr
NDU4LDkgQEAgbHBmY19kZXZfbG9zc190bW9faGFuZGxlcihzdHJ1Y3QgbHBmY19ub2RlbGlzdAo+
ICpuZGxwKQo+IKCgoKCgoKCgaWYgKG5kbHAtPm5scF90eXBlICYgTkxQX0ZBQlJJQykgewo+IKCg
oKCgoKCgoKCgoKCgoKBzcGluX2xvY2tfaXJxc2F2ZSgmbmRscC0+bG9jaywgaWZsYWdzKTsKPiCg
Cj4gLaCgoKCgoKCgoKCgoKCgoC8qIEluIG1hc3NpdmUgdnBvcnQgY29uZmlndXJhdGlvbiBzZXR0
aW5ncyBvciB3aGVuCj4gdGhlIEZMT0dJCj4gLaCgoKCgoKCgoKCgoKCgoCAqIGNvbXBsZXRlcyB3
aXRoIGEgc2VxdWVuY2UgdGltZW91dCwgaXQncyBwb3NzaWJsZQo+IC2goKCgoKCgoKCgoKCgoKAg
KiBkZXZfbG9zc190bW8gZmlyZWQgZHVyaW5nIG5vZGUgcmVjb3ZlcnkuoCBUaGUKPiBkcml2ZXIg
aGFzIHRvCj4gLaCgoKCgoKCgoKCgoKCgoCAqIGFjY291bnQgZm9yIHRoaXMgcmFjZSB0byBhbGxv
dyBmb3IgcmVjb3ZlcnkgYW5kCj4ga2VlcFRoaXMgcGF0Y2ggZml4ZWQgYSBjdXN0b21lciBpc3N1
ZSBmb3IgdXMuCgpBY2tlZC1ieTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+Cgo+IC2g
oKCgoKCgoKCgoKCgoKAgKiB0aGUgcmVmZXJlbmNlIGNvdW50aW5nIGNvcnJlY3QuCj4gK6CgoKCg
oKCgoKCgoKCgoC8qIFRoZSBkcml2ZXIgaGFzIHRvIGFjY291bnQgZm9yIGEgcmFjZSBiZXR3ZWVu
IGFueQo+IGZhYnJpYwo+ICugoKCgoKCgoKCgoKCgoKAgKiBub2RlIHRoYXQncyBpbiByZWNvdmVy
eSB3aGVuIGRldl9sb3NzX3RtbyBleHBpcmVzLgo+IFdoZW4gdGhpcwo+ICugoKCgoKCgoKCgoKCg
oKAgKiBoYXBwZW5zLCB0aGUgZHJpdmVyIGhhcyB0byBhbGxvdyBub2RlIHJlY292ZXJ5Lgo+IKCg
oKCgoKCgoKCgoKCgoKAgKi8KPiCgoKCgoKCgoKCgoKCgoKCgc3dpdGNoIChuZGxwLT5ubHBfRElE
KSB7Cj4goKCgoKCgoKCgoKCgoKCgoGNhc2UgRmFicmljX0RJRDoKPiBAQCAtNDg5LDYgKzQ4Nywx
NyBAQCBscGZjX2Rldl9sb3NzX3Rtb19oYW5kbGVyKHN0cnVjdCBscGZjX25vZGVsaXN0Cj4gKm5k
bHApCj4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgIG5kbHAtPm5scF9zdGF0ZSA8PQo+IE5M
UF9TVEVfUkVHX0xPR0lOX0lTU1VFKQo+IKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCg
cmVjb3ZlcmluZyA9IHRydWU7Cj4goKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgYnJlYWs7Cj4gK6Cg
oKCgoKCgoKCgoKCgoGRlZmF1bHQ6Cj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgLyogRW5zdXJl
IHRoZSBubHBfRElEIGF0IGxlYXN0IGhhcyB0aGUKPiBjb3JyZWN0IHByZWZpeC4KPiAroKCgoKCg
oKCgoKCgoKCgoKCgoKCgoKAgKiBUaGUgZmFicmljIGRvbWFpbiBjb250cm9sbGVyJ3MgbGFzdCB0
aHJlZQo+IG5pYmJsZXMKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKAgKiB2YXJ5IHNvIHdlIGhh
bmRsZSBpdCBpbiB0aGUgZGVmYXVsdCBjYXNlLgo+ICugoKCgoKCgoKCgoKCgoKCgoKCgoKCgoCAq
Lwo+ICugoKCgoKCgoKCgoKCgoKCgoKCgoKCgoGlmIChuZGxwLT5ubHBfRElEICYgRmFicmljX0RJ
RF9NQVNLKSB7Cj4gK6CgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKBpZiAobmRscC0+bmxw
X3N0YXRlID49Cj4gTkxQX1NURV9QTE9HSV9JU1NVRSAmJgo+ICugoKCgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgoKCgoKCgoKCgIG5kbHAtPm5scF9zdGF0ZSA8PQo+IE5MUF9TVEVfUkVHX0xPR0lOX0lT
U1VFKQo+ICugoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKByZWNvdmVyaW5n
ID0gdHJ1ZTsKPiAroKCgoKCgoKCgoKCgoKCgoKCgoKCgoKB9Cj4gK6CgoKCgoKCgoKCgoKCgoKCg
oKCgoKCgYnJlYWs7Cj4goKCgoKCgoKCgoKCgoKCgoH0KPiCgoKCgoKCgoKCgoKCgoKCgc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmbmRscC0+bG9jaywgaWZsYWdzKTsKPiCgCgo=

