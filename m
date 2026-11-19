Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795107916;
	b=gZM8dL8i1gWyI2DdDRke1mBFbdszZG3IyZj0tnr3iOrEI/4O8coc10n7JihSQuETH3B4
	 1KftKBgVBsQ7ZAOrAUNQ/GKGsOqf8E0IMJCvFwOdP8yW2Uj5ZHb8LFaxZ66UhMipGzkI0
	 tydhh/9B8Lxtz6e/p9Qkwc++GiPCIUNoU6mb+3P8/UsvZRKq0jPeC0FII34+XFscvU3rx
	 VAw8FQtV5hdDXZu4CQRV1yrFxJZ1LznkYln5XNW9yn9tID89+rn5/PhLJNtL7ll4I/kjq
	 FL/SAJ3vc9h2LM156pf8af8K2rxxijcaGxREFXA8pWrwHYgZIA5Gtae1L/V2RogYUGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107916;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=sqmCZzPodY7a2eZN9hiYKdyxOr9vBaN6CDvJ9v3zNlA=;
	b=bBycGi7113V/zeS+WDK4sq2eyZJ2J4L1d/eH40BsXrJBWjOcEVmcWKUI4WSMSctFjqEU
	 Dz7Nne6sVjN/CZH5vbI5wmmAdMF037DNVqys1wlTHwHkORtHCVw8rvzdQkNh73Sc9l55t
	 wgRFFczjLwXH4Ld/ftUmTdfp/GyQ+jE0x5CnaPqcmnuoiZwDdp9H7X5DhCRs8HpeFSbUk
	 //UomCTa12iFRnEyzqkXvUcdcpUTf/Gwdy6BGpWlMtABsMKvz+YwFuoGXTsSZUoQelRet
	 L60pQd1Xj8yGQNl6rtf8zuoCAkA0XbLTD7rd8dG68EHNjx3XQFudkT46OK5mva6ic7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=E5RmdONf;
	arc=none smtp.remote-ip=74.125.82.197
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AE0606A324
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 17:05:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6AE0606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=E5RmdONf
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-384c78aa0dbso766398eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 09:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795107915; x=1795712715; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sqmCZzPodY7a2eZN9hiYKdyxOr9vBaN6CDvJ9v3zNlA=;
        b=E5RmdONfYCJ299MPD3h2XC5pKfYyvH4ECAiLFxs2sQmHLP2dYrNORApVOAxHh5Y4/x
         w3ujwifVrtK3n+RsFDDcB0aTfaeY+WCYyttnfKGHavWgVRg3/EIF0QG8c7Hv6BkHTHjN
         VX7Z8ZG7G2Lf/rIDY95TQmYb4emV2pDkKTI3eCzQxPOzvarwOKuRQUl3u/N8nDeFDR2N
         kbecQvLqDLBMvbXSCpe9oCARgyfeoP5uJ8Eqbxct4aqLY1gYYpAvN9F3YRWWayP6sgzn
         1IG3XAFzfo4BdZfWLgEhC/5Bjht6QhuHqsF5xax/HaymN+YG4FJMY4ISIXrZUnVk1cgB
         p6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107915; x=1795712715;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sqmCZzPodY7a2eZN9hiYKdyxOr9vBaN6CDvJ9v3zNlA=;
        b=f7x3vaClxVFnhKvkXeJCZxJtkxJp0zd2n/JbFzJuIWmO7BIA+SWg01vX52MA7k/WkO
         XFb8VPQspawP69TeGEw1azQHkVQR+wtWGzeZ3r6enjjTSF8TA2UaEt2BlT22etR+8XfP
         UubVljfTUYiKWU27O/vGponmjY5WCq6bru+TACrNv/bqBHzY9UFWiyESM4YikPXIr5Ja
         Hkn7PXk06vgZ60fJLuipWxrSz7gEXYlO7HCjuR54R3nf91eWRD/XMw0Obmftzzvn2yFf
         VAfeoCpDLUqjuwmeJwDFaAJ4dau1R97Zi2YUE7l4cISKzl45hLSzFutKfXu0FrxdtMKa
         hh/g==
X-Gm-Message-State: APuU4Z8UXR6hUvX/1lpwEuxocpNsv8hhj2GXxMjakrVUrFBJgZIItUUN
	1reV3JkW+1sRt9ceLNqT/ybuxMo3oVfn/4GN25p4/RrWZbtBFrXtmT8oI4n1bV26d0AJq/zb+bQ
	1MvEYtl1TVw==
X-Received: from dybsl7.prod.google.com ([2002:a05:7301:7307:b0:359:a8c8:38e2])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:791:b0:384:e31e:3c39
 with SMTP id 5a478bee46e88-384e31e4317mr1074891eec.37.1795107914692; Thu, 19
 Nov 2026 09:05:14 -0800 (PST)
Date: Thu, 19 Nov 2026 09:05:11 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119170511.1515433-1-irogers@google.com>
Subject: [PATCH] scsi: qla2xxx: Format SFP EEPROM vendor strings with %.*s
From: Ian Rogers <irogers@google.com>
To: Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, Elkin Cruz <elkin@google.com>, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

In qla2xxx_print_sfp_info(), the verbose logging path passes the 16-byte
SFF-8472 transceiver EEPROM fields a0->vendor_name and a0->vendor_pn
directly as the format string argument to snprintf(). Per SFF-8472, these
ASCII fields are space-padded rather than NUL-terminated, and their bytes
originate from pluggable SFP optics over I2C; any '%' byte in EEPROM data
or a corrupted I2C read is interpreted as a printf format specifier with
no variadic arguments supplied.

Format a0->vendor_name and a0->vendor_pn directly in ql_dbg() using "%.*s"
bounded by sizeof(), matching the non-verbose ql_dbg() call immediately
above in the same function.

Found via an x86_64 LLVM=1 (Clang 21.1.8) allyesconfig audit with
-Wformat-security enabled; fix and changelog drafted with an AI coding
assistant. Build-tested under LLVM=1 W=1 and -Wformat-security; not tested
on QLogic Fibre Channel hardware.

Fixes: e4e3a2ce9556 ("scsi: qla2xxx: Add ability to autodetect SFP type")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ccb039d97353..77504cfc0741 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4126,15 +4126,13 @@ static void qla2xxx_print_sfp_info(struct scsi_qla_host *vha)
 	if (!(ql2xextended_error_logging & ql_dbg_verbose))
 		return;
 
-	memset(str, 0, STR_LEN);
-	snprintf(str, SFF_VEN_NAME_LEN+1, a0->vendor_name);
 	ql_dbg(ql_dbg_init, vha, 0x015a,
-	    "SFP MFG Name: %s\n", str);
+	    "SFP MFG Name: %.*s\n",
+	    (int)sizeof(a0->vendor_name), a0->vendor_name);
 
-	memset(str, 0, STR_LEN);
-	snprintf(str, SFF_PART_NAME_LEN+1, a0->vendor_pn);
 	ql_dbg(ql_dbg_init, vha, 0x015c,
-	    "SFP Part Name: %s\n", str);
+	    "SFP Part Name: %.*s\n",
+	    (int)sizeof(a0->vendor_pn), a0->vendor_pn);
 
 	/* media */
 	memset(str, 0, STR_LEN);
-- 
2.56.1.708.g77570a6a1d-goog

