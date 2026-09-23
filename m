Received: from mail-oo2-f39.google.com (mail-oo2-f39.google.com [74.125.231.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521E55304D1
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 13:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169204; cv=none; b=OW44CGaYypoLxFnvPj2Ywq2VkYEonL2pokBgDqNtXWCkPNxICkQUXN+ewOcAxTjPgrfodoDidD6Ew03D1HgQn6RH9mUB1GNE4j1QlyVf2EQ7UGuHJdjx/3Ru11Pc2Z2zxFlOW0ts+jesvWk9zLCsLKevGraIKdUnq9HGP0+kG6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169204; c=relaxed/simple;
	bh=GK5ecAyK3OXsUN1hxKCW7v5WXRm6BtLteeK8HP+W+Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AfIYuRSt5EHPTJl3+AGmcTAs4+8dUmnRWI6YwdoTpJwPn3NG4zZ9+8JQVeRXTaCKHXWkO0sobdxn7hWlenu5FFziumv94rkyxPzz2QrIVfD5UtObWNrXOAyj4kTlXjdfFuRezgCam1blXuwCUsvbrQxjuHYfzanB8PKyU1vVx+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gHtueHBR; arc=none smtp.client-ip=74.125.231.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gHtueHBR"
Received: by mail-oo2-f39.google.com with SMTP id 006d021491bc7-6c2613d80fbso538844eaf.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 06:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790169202; x=1790774002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nv6lEl/XuVHA69+WOwYewTTKvCN1uRHRSoP0EqmEiFU=;
        b=gHtueHBRlj/l+DD27c66zli3FQaMk6DAcAq+B4tzE4JT1ewaz2RasJOlMELzB3zNdA
         xe0EkABKvckfyAkle4Mb7EqFGn+Sb6XPoInc69+LhRU6LwyWTYuxJzR6r6E61s9ogBhs
         8PwShuXXD7mSlGfGlwfaMnCCwSow/9xRUil9FevH1UEgkj9tapKKJx2o/nOu/ooadLOA
         L02o6T6sliPhU+khVevLMG+k94zMxqTBgjV5GDvFPG3v+zJmh9IjYtjAsrJ5IzxQ+Aj3
         q58RU7eZHz32GjvQQTECfytl8EBs8Z0yOW/ArRbgYvHCTORNhRQLlfDFMrsTcujrdxpp
         BAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790169202; x=1790774002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nv6lEl/XuVHA69+WOwYewTTKvCN1uRHRSoP0EqmEiFU=;
        b=EBGH9siwCPLtaI7LjzvQ+x6tfvTdMrB01BIPkWoqOABse6fkvAwyZ7tstGzEZNVuUY
         +nhZTUHlft7pDe/O+ds/B4Pb84b7pJsWmVzy6uNCeQb0THNOWkyE77yh5yEgL1GtlzG4
         eBaRHQ12lr8qbqQ9TL7HvM87PvvTxDJY4iDOltDllMNKx5tcRWkMVZV74OR48FMNV3je
         jZ8Z3B5C+EIkz2Mut4vNlJi+lYCo0qKKRqx+5Vj5UNuOuHERLuwnAEkZcIYJTwXnOFAH
         V0M2HUa1HduTjSFkmA0lQ3ZscOSfImNqEHz2tqP0gWnKJgjmNmTggmoLM/OXtei4pEpz
         9ktg==
X-Gm-Message-State: AFuF++nK/3xobHc+o1DjYTZcxZw9jA5ZKK5EbpX6OlT4jUyd2Owxc5wL
	7+jZoOhB6pfzQ6LCF228FcwUGj7E597FJ8JNEc2IZM1PDxH8eD3YzZLS
X-Gm-Gg: AYBFou3UqzgUGsumJIRwNWjQZUw8abgBzR15hQehABbiSe1wDtMkSWQxJMsG4xYxY/g
	M9/b6MIzvli2gwqTatmAjGJHAzQQ0jexfEYXst6qYbP8VciBv6qSZ+9Y/S7uN8rAB3H0ZOFQheO
	7t3A+teYveFj23kXIiDLbP3nDVzlmOIDiDogSLv5uOXaZZItzDhocR001XW27y29v6BuTlhsMzD
	CJ09Voq1ZJh67uTVHjd6NCLHjCrMBPs61sklcyl91bad9XwQrkcM8fW2uKlMnH7ZqNlBvZy0vVV
	ImUkuKEPmrL+ai/AyD9DBcySheDW+FZzftK+U8z43mJhDwSx8s7OW7dnrN2Z0GwEKBqED6V2ZSr
	XvzxpIQqH6yo3RSMnvB64CeFX6nGGZ7lmg/1Ry/f8+6N3yfLBDln2Cy/O3UQu92WDB8mfa0MB3b
	sf/XM8DL346jJEcc/PtTB6ATCgOhVVpPeKWPs36uz4VzadopGzckVubtt79n/88GtKT9EJU+1vs
	IA8T33txBu7ThHLTvn5HLOwZbtfBvOuKxnABFJN
X-Received: by 2002:a05:6820:16a3:b0:6c0:1ab7:8883 with SMTP id 006d021491bc7-6d2cf84ab7dmr2261569eaf.13.1790169202135;
        Wed, 23 Sep 2026 06:13:22 -0700 (PDT)
Received: from archlinux.lan ([136.34.156.120])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4908e54f277sm1599838fac.7.2026.09.23.06.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 06:13:21 -0700 (PDT)
From: Danish Khateeb <danishkhateeb03@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Danish Khateeb <danishkhateeb03@gmail.com>
Subject: [PATCH 0/2] scsi: target: core: Fix and convert kmap_atomic() in SBC emulation
Date: Wed, 23 Sep 2026 08:13:17 -0500
Message-ID: <20260923131319.310123-1-danishkhateeb03@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 fixes the address sbc_dif_copy_prot() passes to kunmap_atomic(),
which has been off by one page since v4.2. It keeps kmap_atomic() so it
can be backported on its own, which is why checkpatch warns about the
deprecated call there. Patch 2 then converts the kmap_atomic() calls in
target_core_sbc.c to kmap_local_page().

The rd backend's protection pages are lowmem, so the bug only shows on
32-bit x86 with CONFIG_DEBUG_HIGHMEM, which gives lowmem pages a real
kmap slot too. I have not Cc'd stable for that reason.

Testing, in QEMU/KVM, with PREEMPT_LAZY and DEBUG_PREEMPT:

- i386 with HIGHMEM and DEBUG_HIGHMEM. On fe2ec83746e5 (v7.3-rc4+),
  kunmap_local_indexed() warns from sbc_dif_copy_prot(), the log has 103
  "DIFv1 checksum failed" errors, and 9 of the 23 checks fail with
  EILSEQ or EIO on the rd PI disk. With patch 1, and with both patches,
  all 23 pass with no warnings.
- x86-64 with KASAN. All 23 checks pass before and after the series,
  with no reports.

A static init sets up three rd_mcp devices through configfs and exports
them through tcm_loop: one with pi_prot_type=1, one without PI behind a
TPG with fabric_prot_type=1, and a plain one. It then runs O_DIRECT and
buffered writes and read-backs on the two PI disks, SG_IO WRITE(10) and
READ(10) without PI so the target inserts and strips it, and COMPARE AND
WRITE with a match and with a miscompare at byte 403. Kprobes show that
sbc_dif_generate(), sbc_dif_verify(), sbc_dif_copy_prot() and
compare_and_write_callback(), which inlines compare_and_write_do_cmp(),
all ran. W=1 and sparse are clean for target_core_sbc.c. I can post the
init program if it is useful.

Danish Khateeb (2):
  scsi: target: core: Fix kunmap_atomic() address in sbc_dif_copy_prot()
  scsi: target: core: Use kmap_local_page() in SBC emulation

 drivers/target/target_core_sbc.c | 58 ++++++++++++++++----------------
 1 file changed, 29 insertions(+), 29 deletions(-)


base-commit: fe2ec83746e501645709761605c2464a44fd2929
-- 
2.55.0

