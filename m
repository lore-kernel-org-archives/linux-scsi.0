Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63D034DCD2
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 09:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790586040; cv=none; b=opFZsP1Q4ATI8sQAztoXNP66g2HfZaLjF00ufjP4ld6DSkOiJsH7SqtCta+8BvVeba89iOveR/fkQS7VvqiR6nu0TQ2j23bLmymE9jCiwNsvaAClfXqLFYDoDAJF9yUbGhKU5iLrDEBS8C67v0YMYG06RPOLZGDr0MhIBqSERzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790586040; c=relaxed/simple;
	bh=Vwt5jRUFUNWUzFh6wGFDqhtk+9yWoFR7/PjgmMHhp9c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m/MyyPk+sgTB3FwJCpC5aO7yQAD881IYTzesswyM69NdsdHjpuU/DZUmBfVK8fn32y/VCgmUG18qyK+wyssXHPX8JVUMgERKFkYTs4Uw0B80lkKQAHD0V3lsIWvQib4oi+Tb/7EXi9xtF/2ubB/ZOtjhtHvAAVSu+5yFUCtqSoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZFAhpOc5; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZFAhpOc5"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-34182b58c7eso2390199eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 02:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790586037; x=1791190837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=peWtFw7a//NXoz+TblS/D+EGwqrleEVQ+goT3kgpwso=;
        b=ZFAhpOc5rD1XJSPl1v3i8pGMpdW2V3lbC8VUSl2u4vvF+pEvCnvcg+cHbvOBXDyMaq
         9e/1csHosxwKlVwUW6lJMX0VaLYOyuHgsSXWlO3d1zT3KquaC9pfnw42c+dPFj92434a
         jkpx+pTStBJfT3Fh3waZN54n2KOaHwc7I5fdhlYjwY1CF7SaKc34aszBLElKhzsU/w2L
         jNwpb2OGC3mwu8dLbUbViStt4EJ/n8bj4GBbuWdWM7pAdhPUPPltyx4ojYlBzj0jx9gi
         ZqwaFJvZEuKQ1Y+FkWU5Opu7jl6M3QA2jnCBGPRYoZ3LKJk4OJWDHjr5Ic3I1ydd1wkz
         2Zfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790586037; x=1791190837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=peWtFw7a//NXoz+TblS/D+EGwqrleEVQ+goT3kgpwso=;
        b=Hpkt2N89hitT4Y3ZHPM/Wh4J1ubAZtJ1kVV0okt1JOhxIdD93ZC8xPv4IgpOkbYbH5
         TPkTqknrqM0qjc8VfEJHT3YswyfMJSqjW7a/eD+9zTlkPjjqxAWbbac0WiVgdz3MIghG
         BxXB/Jtsznx+2cIXFh6zKrxH7RXHBPqjAbu8FqgCjwsC59r7utF4z4pPlM56nk54QsHi
         k/qco7auLq5Z09pFsD7TfJ9tode5vythWmGhij4omLz5MmBkoqIDl+2FTKjGaAQ5Bmf5
         ZpYniSXyc63ttdhHsQXQYt0Hh9E3zYipuIFTXbvfUQNW02XqY0L9PgwCEA7ctNa6+uTp
         23XA==
X-Gm-Message-State: AFq9FYJsKfZ95CmMtieOBR+rKJLm4cOESJngZ3yEac3IdwAejr9zvpzt
	MJm7jBh7WJsZy6lLTL9lrkC7qIcI57ETWNLlx31xIXMlTNaqh1KcOM2/
X-Gm-Gg: AYBFou0D5fukbigRaGocD0SNM5/WxWAPvtwUEPDs/SMRj+62gXB9oDxkQSqr7a9MUws
	RC4VnAityQPbbjNKirjLkhSA9nAzCtvM7k1y/hvlSBJyovvms2Ny/e1YS0nWQyxcuCKmz/1I4po
	165D5G4N0SI95coD3PfJbA+qjy7vwjHgdc0x5HEnN/OpQggo62eGGKutoV+QtKY43MvdJnHxWJZ
	Hc2TkwYmCp9Ss53QXrMg6XlcfTGNnY/AtyD/4bBD1N+AOsuBZoS8IRkAXU9TKQXhVtl0oaUX5x5
	Tl+aAGMWqzE66eMxejAk6MCMNDcgUhhMHmgSWUP4pvwg3Ea73bkV1FLc6WmRCiph1oe34ztnW1B
	36UFaBSfYNlhW1OxiHqOvZ5yRqaJ8Wc4WcZNTKD4RhO3g/5P4SwDic1eqVkvImeQIN8CiDOW5yL
	ET34hCXQi6fhw2stugCmjNQ2cuO0prrgYxseBvFw24P5/NATxlZP1CCp6osWCcNmDv/nh4hgiTq
	ge+P+HwB+rk7z+ZooZ9tr8AnULS
X-Received: by 2002:a05:693c:41ca:b0:33b:fc17:e691 with SMTP id 5a478bee46e88-34a63cad7d7mr375711eec.2.1790586035905;
        Mon, 28 Sep 2026 02:00:35 -0700 (PDT)
Received: from homik.search.charter.net ([2603:8002:ad40:56f0:3430:2ac1:d99f:94d7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34144172de6sm43351473eec.9.2026.09.28.02.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 02:00:35 -0700 (PDT)
From: Mariia Nikitash <nikitash.mariiaw@gmail.com>
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	morbo@google.com,
	kees@kernel.org,
	justinstitt@google.com,
	codemender-patching+linux@google.com,
	Mariia Nikitash <nikitash.mariiaw@gmail.com>
Subject: [PATCH v2 0/2] scsi: bfa: Replace strlcat() in symbolic name construction
Date: Mon, 28 Sep 2026 02:00:28 -0700
Message-ID: <20260928090031.712418-1-nikitash.mariiaw@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series replaces the strlcat() uses in BFA symbolic name
construction with snprintf().

Patch 1 converts bfa_fcs_fabric_nsymb_init().
Patch 2 converts bfa_fcs_fabric_psymb_init().

---

Changes since v1:
- Split the BFA changes out of the original cross-subsystem series.
- Patch 1: no code changes.
- Patch 2: use a single snprintf() call for both host_os_patch cases
  and drop the explicit final NUL assignment.

Original series:
https://lore.kernel.org/all/20260915081910.4142719-1-morbo@google.com/

Original bfa_fcs_fabric_psymb_init() patch:
https://lore.kernel.org/all/20260915081910.4142719-8-morbo@google.com/

Bill Wendling (2):
  scsi: bfa: Use snprintf() in bfa_fcs_fabric_nsymb_init()
  scsi: bfa: Use snprintf() in bfa_fcs_fabric_psymb_init()

 drivers/scsi/bfa/bfa_fcs.c | 88 ++++++++------------------------------
 1 file changed, 17 insertions(+), 71 deletions(-)

-- 
2.43.0
