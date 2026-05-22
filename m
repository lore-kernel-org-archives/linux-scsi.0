Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1250B3CBE7A
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 10:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779446270; cv=none; b=MASHJh32WmOsGAoWgKHA+iptDfRAitBXG+lfMwSKHMeqsmDk3E4NkglEyQAlGR5+plCsAA1za8ktd28LNsIG+wMmfHw7N6SVNqMLltHqXjQoekoS+YqelLHcK9PGeVcj1hRyhWlUsTb5xadVsTU+3vngiN+Tlg1v14SnL8oF5Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779446270; c=relaxed/simple;
	bh=Ac4xnvnmTYeA2XO6wouWeRbpqTgtkLKatItCecIHYT4=;
	h=Message-ID:Date:Content-Type:MIME-Version:From:To:Cc:Subject:
	 In-Reply-To:References; b=CltLr4csn+yRCu/Q+9TmLc3n1+jTQJ32oqkXh6AchFRHU1V5hnwq3PGQUT2eJhcVa2gy2uXv9hfDVnI4JobHECpjmCti5HkKLgfWubgUXb8BXfl21dXH4ufPeWvdcYIZQWgi4Vui3J2Kt/FGcjxseXtGBCASqMZsUjkpo0GbGRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WeCtiRxA; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WeCtiRxA"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-67c1e0229acso11863665a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2026 03:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779446263; x=1780051063; darn=vger.kernel.org;
        h=references:in-reply-to:subject:cc:to:from:content-transfer-encoding
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ac4xnvnmTYeA2XO6wouWeRbpqTgtkLKatItCecIHYT4=;
        b=WeCtiRxAUjVZYBIekn+j1tAurP+BrWtiwvGaNBZipS8+QFOssLnwSqA7dp4ORSHLaI
         qp/Itfe2Ykr209UNxoaofgWMsaoQ3ovf6ffaOjf1jcUZKU23jrEcIo9MP/1TBhOmxFSB
         dG15VTtVs9hCTwfouO2YGZEES9Y5x44IyaUXl7ZAIQD4cZi3uYLtrRlCEc/5HIz9tihk
         VqJTq7UW02McmuadUmWBY7l/YUCy0zsj4PP1EQP3Dbfly/p7kqUR2U+LykQfDBR0Eltt
         /iCQsavaBMSTpqPyQe98sRjsoSfAiCaPNmDXPOHpev8lQzDu9vfXRJzEpdVnwJb8bh2h
         PUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779446263; x=1780051063;
        h=references:in-reply-to:subject:cc:to:from:content-transfer-encoding
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ac4xnvnmTYeA2XO6wouWeRbpqTgtkLKatItCecIHYT4=;
        b=cPKfgrmPJj21g/71ZrEhBz8jc9np6jQ6DjGpMy7OkEC5rRwAzkGl9o2E7pMWn2lmZN
         ruD82DIRLN3Wu6unocQY3QLOb1S96MPHtBD1hgWLacNVWovvXkLbr81FhnGNA7pkdjRy
         SOKKw+pAYcuf77jy/F30JjoC3s7AWrdED7jdIJLfgCfrNqLuZGIkj5XcO0hozJIGwU0e
         JvMXODhRxbt4KSgZpPf9UrznQjDE6F90g4no410KA/iD80xgo4GuwBO+hj5ombV3w9fZ
         OxatBs3++WBzMdTYsjlHNnek41oTLZTcfuWKKA3Y2pJFR4L9Fc9O5t/eMTRe8cbtFwhd
         MX6A==
X-Forwarded-Encrypted: i=1; AFNElJ+M2dhYjO2SNi0xgwmfJ9iyxXZKrJ+GXIb94NHTLSAx7GlVN7scPJIk8cvWCycu8Kg6ZtEMiNnk29JA@vger.kernel.org
X-Gm-Message-State: AOJu0YyRmQp0LrsDqJuzMqOES7LcjD20xvfBUrQcO1ckPL7DTnXwHSnv
	LHaCsUECgpQqTYLtCOdkqPtowpr6kcJmS5vEUuoCtIrZQJRg40FFKKfD
X-Gm-Gg: Acq92OFCATFbh2XU6Sv8JljHK2MX07+6qnIr1H9W8Zrb1g5OkOuRYC8IiSz97/HhTnc
	10UjtTJUp9jiRJ0Mw+VRkW24kLq7ugmQeyoJiHVI1C1RseaH4siitAauR98LsN2pySjzUHIjD3H
	Ylb3sSJaxlBWzIzvTx/Ev9VxnGV1qFO5dsDeSVTEjjMKD7gyzl6PpxMBqHeS6fn0kGiaSQHM16K
	6v73mw4j+uOrZlu313vcYBQR/2+9i57oaf20jZxPKbWVvftBJmipuwSe6E0iVz4fOypkdBg5FXy
	oOFq4YCvsD6Ymb2LQHFjlHpvvR8djvUhcgPlUMzZvTUuGF7fMXTeDHXZy74hq7KsfybdofMhHmC
	e5Jlj4b4Be4cVIXJWTogLz/FFaRp4Hq+fooNWoKFY2rXwmYpIVpLz+DqKhWzyT+YqRtiqt33Qht
	SQEvZ3DVVUc7cLv7P+BIRMnL3qXdIMTXteMJcIaK3IORipk8qqyLE+ih8U4QD+3dPfQiyM7ZwJw
	lEeCBbZn9ET+hkiyeRl2Is1kKvD0sxu+zdT91Jwd5njtkh2/xYtflAXdDoAxGpKHbmIH10L60G2
	OzEbw6iWuBxQuPFnl2TNEN3X7O1J
X-Received: by 2002:a05:6402:1cc9:b0:676:d8df:f8c1 with SMTP id 4fb4d7f45d1cf-6889cc544b4mr1427718a12.22.1779446262781;
        Fri, 22 May 2026 03:37:42 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-688bb62b6dfsm513385a12.30.2026.05.22.03.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 03:37:41 -0700 (PDT)
Message-ID: <6a1031f5.e5f1cd4d.398bf4.edc9@mx.google.com>
Date: Fri, 22 May 2026 03:37:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: Hannes Reinecke <hare@suse.com>
Cc: David Disseldorp <ddiss@suse.de>, martin.petersen@oracle.com,
 bvanassche@acm.org, mlombard@arkamax.eu, target-devel@vger.kernel.org,
 linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
In-Reply-To: <430612f0-53f6-49bc-acd5-e69df3b330da@suse.com>
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
 <20260520165259.272808-1-hossu.alexandru@gmail.com>
 <20260522003800.2323e11a.ddiss@suse.de>
 <430612f0-53f6-49bc-acd5-e69df3b330da@suse.com>

T24gRnJpLCBNYXkgMjIsIDIwMjYsIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPiBUaGUgbGVuZ3Ro
IGNoZWNrIHNob3VsZCBiZSBwYXJ0IG9mIHRoZSBjaGFwX2Jhc2U2NF9kZWNvZGUoKSBmdW5jdGlv
biwKPiB3aGljaCBzaG91bGQgcmVqZWN0IGlucHV0cyB3aXRoIHRoZSB3cm9uZyBsZW5ndGguIF9B
bmRfIHlvdSBuZWVkCj4gdG8gYWRkIGEgJ2xlbmd0aCcgYXJndW1lbnQgZm9yICdjbGllbnRfZGln
ZXN0JyBzdWNoIHRoYXQgdGhlIGZ1bmN0aW9uCj4ga25vd3MgdGhlIHNpemUgb2YgdGhlIG91dHB1
dCBidWZmZXIgYW5kIGNhbiBhdm9pZCBwcmVjaXNlbHkgdGhlc2UKPiBpc3N1ZXMuCgpUaGFuayB5
b3UgZm9yIHRoZSBmZWVkYmFjay4gQWRkaW5nIGEgZHN0X2xlbiBwYXJhbWV0ZXIgdG8KY2hhcF9i
YXNlNjRfZGVjb2RlKCkgYW5kIG1vdmluZyB0aGUgb3ZlcmZsb3cgY2hlY2sgaW5zaWRlIHRoZSBk
ZWNvZGVyCmlzIGEgY2xlYW5lciBhcHByb2FjaCBhbmQgSSBhZ3JlZSBpdCBpcyB0aGUgcmlnaHQg
ZGlyZWN0aW9uLgoKdjQgY2FycmllcyBEYXZpZCdzIFJldmlld2VkLWJ5IGFuZCBmaXhlcyB0aGUg
aW1tZWRpYXRlIG92ZXJmbG93IHdpdGggYQptaW5pbWFsIGRpZmYuIFdvdWxkIGl0IGJlIGFjY2Vw
dGFibGUgdG8gbWVyZ2UgdjQgYXMgYSBxdWljayBmaXggZm9yIHRoZQpvdmVyZmxvdywgd2l0aCBh
IGZvbGxvdy11cCBwYXRjaCB0aGF0IGFkZHMgdGhlIGRzdF9sZW4gcGFyYW1ldGVyIHRvCmNoYXBf
YmFzZTY0X2RlY29kZSgpIGFuZCByZW1vdmVzIHRoZSBwcmUtY2hlY2s/CgpBbGV4YW5kcnU=

