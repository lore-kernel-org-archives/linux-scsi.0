Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD3A15B0EC
	for <linux-scsi@vger.kernel.org>; Sat,  9 May 2026 17:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778346795; cv=none; b=t/1tEi1F1X7oDuXa+XAvUycsHeoV9QjLE+NLPfCZlb1ZukvA+vK6mQykZOgLDWVZMcC4SNIUPjgpq+Lz1l+ZZU4dOpmnxYl7RdqMAfqKoO+cLpGZkGzFK9nJDS5Id5eDW8Cf3lDsxz6WEoLHepzEEFVD+PSPoK0wLzwpeEZHSKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778346795; c=relaxed/simple;
	bh=cz6JrxY2mZcv/ckGZwKXhcfoUtZlEKu6bqMhp7dd/qY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g3BiFMAfc6vawsvQWyaXJ0lBr1TwPZPxI/IfINyFZ4wKhVubZsCNY9PNqnapP1DkRou4q21iqupjByKvPdh/BzZbpbn9kDUUtmA2A2pb1foOMvUl/OAnlwu+JD+9WzlXpGteugp4ikHCQmWsLr/zc5q4oRPXDDhqeR1fo0ni4zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z2boJGRR; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z2boJGRR"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48e72b02bf6so616805e9.3
        for <linux-scsi@vger.kernel.org>; Sat, 09 May 2026 10:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778346792; x=1778951592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QhpVd7na12hAnyObot7grd9UEomYtJgCFXH+/TjsYW0=;
        b=Z2boJGRRVSl3WUhmblMlqmYUpvbsdlEac3SdkojXUu+lsE3Gz1GDCKq/Z7f+LAkYX0
         HjCLI2zTDi0gjjrby7lFyOORebiOwHLC83lrpLMZSjwT6eLe+lfi38cWdqCP8+EItYbu
         MWDUA2hrkFL9rF4KL9UqsBXQiMEdQWsdYB3Rsf9LNQn/257Y5YnK5241cxpiVSaepKUH
         YAwlDFf8nrXF779dxXZFZbxuaWnMZZ5bM+fuGRQoVCAVB2c0jKJYVIJbxrNWNl7u9jLW
         00lo//VARe7WKjjN82KziQ7HtRxsZVNSJTzeknlrFWeYksZ598oeybwVveWovrighv+1
         NbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778346792; x=1778951592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhpVd7na12hAnyObot7grd9UEomYtJgCFXH+/TjsYW0=;
        b=cVOL0fjoupv5j89DR8zrEis/BAs8FPJSzyaipKA/7NYTV6omWcP3AgeCpPnoGXP1Hr
         5fdq9fKxvaMgPI5gMczvHlSPLDBBhV9KywvaXiSAdtxqI1vU+BIuRsbuYSXgt/Wa8RPI
         gNY66GkJm/+dYJWIA3QpFPr69tFyaT1nBiguO3PRrutpYW98ADzorbV7N8S41uY26W5i
         k1hOAZWxDMtzsntxwBDxDqssdLXsGtrz13ZyEb6AniSHXUolOF8/2oQKvfa15G6QHor1
         W33EYr1UCR0Ze3SA4umsF7jwgCHPReLXFiHeRB2/fl4kgoAq+ydlb1EaiMBcXwpkSTjV
         x4fA==
X-Forwarded-Encrypted: i=1; AFNElJ8k+sB4EY673oS63cEjYEHNURDzjns+UmMrX2W7Elnk1m+ZEJ6Cl+d29kMEa5TlpOfaoHlmg7P31TOc@vger.kernel.org
X-Gm-Message-State: AOJu0Yz03epa+6em+3mmFgiN7jPJLIz4LEM19thiSIOYYzeQ+rWrrO+w
	9LidihMJ0s+3qolqwavg6mgctnYAYM0r4Q7pEf9wam2nhjV+BQVN4m/P
X-Gm-Gg: Acq92OHENebUb9H0q5lMXIUv69J/+je9DAeRL2rzFXqgCRoNBYsCWkdrV15ON846uxd
	EYT0QnFhrryghP2tfqUlGv4NMtc24b0a2pXWRo8j0ig/q+CJhh0F5C1KftcwbemabsOnIY5jigZ
	of3ixTHba2HS5Ceof60WHFCNgIxfkKzls1iVY4WqTKcpDmxLOoytQx8Y9kHl3O5F/v1B1Xn0wun
	KxbntOZ+UvNR1rWVYXxffirN+SgyogMsfPqyUtEFXGfScN51P4X8Qhzj2O6rfdsAR6tFQjKOwy0
	0xWf5Vqty+rH5uxraLpgL5+BPZxoMTOUBDwRpXr6ZovBriO+L2skofVTfvJI91dgo/e2pQ+qMlA
	wYmzxWOHlxdTzc6FqlusTD89Gi8XUVSBYiiHGdvQwMquCt9JSfn3GqzpaFxohtCueKuZG2uZJwc
	Xwh+Wi5kk6VXW1zopsgbOdOgWwEkkbtWxCX9HYvsMu2edG
X-Received: by 2002:a05:600c:198c:b0:48a:58e1:6cf7 with SMTP id 5b1f17b1804b1-48e530bf915mr122535745e9.4.1778346792363;
        Sat, 09 May 2026 10:13:12 -0700 (PDT)
Received: from localhost.localdomain ([82.215.118.79])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702e715dsm115329635e9.8.2026.05.09.10.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 10:13:11 -0700 (PDT)
From: Stepan Ionichev <sozdayvek@gmail.com>
To: hare@suse.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stepan Ionichev <sozdayvek@gmail.com>
Subject: [PATCH] scsi: aic7xxx: avoid NULL deref of cur_column in ahc_print_register()
Date: Sat,  9 May 2026 14:56:56 +0500
Message-Id: <20260509095656.7143-1-sozdayvek@gmail.com>
X-Mailer: git-send-email 2.33.0.windows.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ahc_print_register() takes an optional 'cur_column' pointer that may
be NULL.  The function already guards two of its three accesses:

	if (cur_column != NULL && *cur_column >= wrap_point) {
		printk("\n");
		*cur_column = 0;
	}
	...
	if (cur_column != NULL)
		*cur_column += printed;
	return (printed);

The early-return path taken when 'table' is NULL forgot the guard:

	if (table == NULL) {
		printed += printk(" ");
		*cur_column += printed;     /* unconditional deref */
		return (printed);
	}

If a caller passes (cur_column == NULL, table == NULL) the kernel
NULL-derefs in the early-return path while otherwise doing the right
thing in the rest of the function.

smatch flags the inconsistency:

  drivers/scsi/aic7xxx/aic7xxx_core.c:7067 ahc_print_register() error:
  we previously assumed 'cur_column' could be null (see line 7060)

Mirror the existing NULL check used at the function's tail before
updating *cur_column on the early-return path.

No functional change for callers that pass a non-NULL cur_column.

Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index b9761f9f0..82eb84afb 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -7064,7 +7064,8 @@ ahc_print_register(const ahc_reg_parse_entry_t *table, u_int num_entries,
 	printed  = printk("%s[0x%x]", name, value);
 	if (table == NULL) {
 		printed += printk(" ");
-		*cur_column += printed;
+		if (cur_column != NULL)
+			*cur_column += printed;
 		return (printed);
 	}
 	printed_mask = 0;
-- 
2.43.0

