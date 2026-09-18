Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406213B9DA7
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 13:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789737996; cv=none; b=BIWV5oIcya7Ky8H/QVoQTtRMRjTG0edLbTkoPGKFLApJZBFs2XUfssznPuZ1iPRvSGWiHSoRbEvRDNrM4MyKO7YEjAOPSXN2FAT+scMlkyA2soRrrsnKSAe8wmbSNTBi2KuRzO13Q21ed3i1wWC9Odf3o3bSrkEgQTMLTVT8BLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789737996; c=relaxed/simple;
	bh=MPIiOP8JjfTxn7ieweKgdc6dB45b+oMxnVdHZU8cI7g=;
	h=MIME-Version:In-Reply-To:References:Message-ID:Date:Subject:From:
	 To:Cc:Content-Type; b=Ev0mXQNk5Am7gvEZgn42ntC2QPinaei8uHrlvBB4upD276PYJEUXhbwH8SnAKEO+eK94Nxs1/dfM233vXHdPs6vCz4OaN488WKvTL5vfjsiIyPutMR9k8nUxOX9IBxQDGxoI29LT/q1trr7Tn7BtFQRYCA4hlKDgUPgqhF4cF24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P2LLuS2N; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P2LLuS2N"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so590817a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789737995; x=1790342795; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject:date
         :message-id:references:in-reply-to:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MPIiOP8JjfTxn7ieweKgdc6dB45b+oMxnVdHZU8cI7g=;
        b=P2LLuS2NgQtJFckk3JLFohWq+GEQeLYVBTwSSug6j+oFQ23sMEOUTlyeto1VIQveNj
         SIj8mhgWbsWvVg59p7+FTGZsFFw2/DMTb9afjOn8uS6HhHHW3+EoDpofGwcUVR5BqKdT
         KXQO6VlVwx5Q2ppsK/ahly2M8+EgsLL/oJbDNK9+K4G6asYZmE7yK0+vlxu4CbGJAUch
         RB37VwCNbJjERQN/dNAxGl8ouf9PPT1pxohbto0vdMsKKrENBEVqXmRVHtDiLqC+f5yw
         li3AL7o/lC64x8H5DbGMMjBXCVGneKuQXp3F+wPKufOmv19e+5rCePwcTWlzj+7Htmq+
         FqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789737995; x=1790342795;
        h=content-transfer-encoding:content-type:cc:to:from:subject:date
         :message-id:references:in-reply-to:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MPIiOP8JjfTxn7ieweKgdc6dB45b+oMxnVdHZU8cI7g=;
        b=Psa4a0zU53DoEONzWISsamt8GI78YsjNPttpDCJA1fwuUb3cMs+iiVQ+JEJhOMtVbC
         MMa5U9YgJKYsn+yqEvY7SeG+Hc0Ec2SKk5LpM6G/aKClWjiJy8EW9M4sxwXEEg3NQd/P
         BojkXq3awT42LssBAbUoVPqOu/5KXM9Uvkpdz3/NReXPebcPejgxY8v3ns3s2gF3jxCv
         7mjLatMz4FaDWARqBpfdCFhnybbki8BE9QJG3auzp0QtYyIqVF43Cs5/+8dtuL6nb6Hm
         42fmCBMHxmu8/guOfMqXVsBR4bDjRKB3z1TJsV+pyDyosTVexOUnhI232aL/H5+pJfPt
         oq7w==
X-Forwarded-Encrypted: i=1; AKwUvByfVowJZvWoc/LI4ErK+YKLH7gAxYJ5nv/kmXeMJ5ZLmISCVQXK7X4T8dtK6bruiAIZc4XQx/ZPwUZJ@vger.kernel.org
X-Gm-Message-State: AFuF++mbZJYMgrLm4fSB5y3yTZw6DmE/slJaIxl+IzHpTCDm5lmZnkcV
	R2+9NtV/On+DzzkpQ1RAVmA8UtVquUhe9AL65eSzMMVW2hg3d/+yG7Q7p4iJc+JyRlZgWDaFKCt
	YHZDH4yp9aiT1ADggazgZ2Q==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: from pgbcf5.prod.google.com ([2002:a05:6a02:845:b0:cc5:2af1:69a5])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:1f87:b0:3d3:ad3c:49a8 with SMTP id adf61e73a8af0-3dd8c515670mr7347239637.22.1789737994530;
 Fri, 18 Sep 2026 06:26:34 -0700 (PDT)
In-Reply-To: <20260903235308.1240963-1-stanleyjhu@google.com>
References: <20260903235308.1240963-1-stanleyjhu@google.com>
Message-ID: <18d66d39392b460c.3137322e31362e3131332e313435.2b1112.0000sendgmr@google.com>
Date: Fri, 18 Sep 2026 13:26:34 +0000
Subject: Re: [PATCH] scsi: ufs: core: Add fault injection for task abort failures
From: Stanley Jhu <stanleyjhu@google.com>
To: Peter Wang <peter.wang@mediatek.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, Hyeoncheol Jeong <hyenc.jeong@samsung.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Content-Transfer-Encoding: base64

T24gOS8xOC8yNiA2OjA4IFBNLCBQZXRlciBXYW5nICjnjovkv6Hlj4spIHdyb3RlOg0KPiBUaGUg
dGFzay1hYm9ydC1mYWlsIGluamVjdGlvbiBieXBhc3NlcyB1ZnNoY2RfaXNzdWVfdG1fY21kLg0K
PiBIb3dldmVyLCB1ZnNoY2RfaXNzdWVfdG1fY21kIGNhbiByZXR1cm4gZGlmZmVyZW50IHJlc3Vs
dHMgdGhhdA0KPiBpbnZvbHZlIHRoZSBkZXZpY2UgYW5kIHRoZSB1bmRlcmx5aW5nIGhhcmR3YXJl
LiBCZWNhdXNlIGVhY2ggcmVzdWx0DQo+IG1heSByZXF1aXJlIGEgZGlmZmVyZW50IGhhbmRsaW5n
IGZsb3csIGEgcHVyZSBpbmplY3Rpb24gY2Fubm90IGNvdmVyDQo+IGFsbCBvZiB0aGVzZSBlcnJv
ciBwYXRocz8NCg0KQWdyZWVkLiBTaG9ydC1jaXJjdWl0aW5nIHVmc2hjZF90cnlfdG9fYWJvcnRf
dGFzaygpIHdpdGggLUVJTyBieXBhc3Nlcw0KdWZzaGNkX2lzc3VlX3RtX2NtZCgpIGVudGlyZWx5
IGFuZCBkb2VzIG5vdCBleGVyY2lzZSB0aGUgZGlzdGluY3QgVE1SDQpyZXNwb25zZSBjb2RlcyBv
ciBoYXJkd2FyZSB0aW1lb3V0IHBhdGhzLg0KDQpXaGVuIHJlLWNoZWNraW5nIHRoZSBjYWxsIGdy
YXBoIG9uIGFuIHVubW9kaWZpZWQgdXBzdHJlYW0ga2VybmVsLCB0aGVyZQ0KaXMgYW4gZXZlbiBt
b3JlIGZ1bmRhbWVudGFsIHByb2JsZW0gd2l0aCBob29raW5nDQp1ZnNoY2RfdHJ5X3RvX2Fib3J0
X3Rhc2soKToNCi0gdWZzX2ZhaWxfY29tcGxldGlvbigpIGlzIG9ubHkgY2FsbGVkIGluIHVmc2hj
ZF90cmFuc2Zlcl9yZXFfY29tcGwoKQ0KICAgKHRoZSBsZWdhY3kgc2luZ2xlLWRvb3JiZWxsIGNv
bXBsZXRpb24gcGF0aCkgYW5kIG5ldmVyIGluIHRoZSBNQ1ENCiAgIGNvbXBsZXRpb24gcGF0aCAo
dWZzaGNkX21jcV9wb2xsX2NxZV9sb2NrKCkpLCBzbyB0aW1lb3V0X2luamVjdA0KICAgY2Fubm90
IHRyaWdnZXIgdWZzaGNkX21jcV9hYm9ydCgpIHVuZGVyIE1DUS4NCi0gVW5kZXIgc2luZ2xlLWRv
b3JiZWxsIG1vZGUsIHRoZSBjb250cm9sbGVyIGhhcyBhbHJlYWR5IGNsZWFyZWQgdGhlDQogICBk
b29yYmVsbCBiaXQgYnkgdGhlIHRpbWUgdGhlIGJsb2NrLWxheWVyIHRpbWVvdXQgZmlyZXMsIHNv
DQogICB1ZnNoY2RfYWJvcnQoKSBoaXRzICEocmVnICYgKDEgPDwgdGFnKSksIGNvbXBsZXRlcyB0
aGUgY29tbWFuZCwgYW5kDQogICByZXR1cm5zIGJlZm9yZSBldmVyIHJlYWNoaW5nIHVmc2hjZF90
cnlfdG9fYWJvcnRfdGFzaygpLg0KDQpUaGFua3MsDQpTdGFubGV5DQo=
