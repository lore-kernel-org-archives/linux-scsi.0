Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A31A202F71
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 02:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757904714; cv=none; b=htlrDF2eRMtaDtcJnQapwSCkv7MyKr61/nWlmExzC11FVpfE7vhU3QAYH2oCM8nTb2SGferlHjZB6pWJU5XJgGoqk4FvGTA+i9o+78lS6n3qqbSHwVN7q12Ef6q+5BvBf+N7kZ4YNRn+m0KXfbqjif5/zlv2ez+EczPziu0kCgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757904714; c=relaxed/simple;
	bh=EHCSfQ2XnebCHi96Y4dD+dNrHULC6WpUjEi9/5mfeAs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dankivrtt8crbfrVOrFmdW4yeneOk0bQOzkXHFIAin2qqxC/vTg+Q4+72xkx6rIUuq7i31+q+dXSuBbbIDI6hHWymNxubW982xISveD4aoY/P7UJBTQEabRlfsmb7diKDs1Le542pVQbSfuYHs/6uujVECx0Fvkpm80OWr0Cq/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QHLoIWMf; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHLoIWMf"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-770db3810a7so15822616d6.0
        for <linux-scsi@vger.kernel.org>; Sun, 14 Sep 2025 19:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757904712; x=1758509512; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EHCSfQ2XnebCHi96Y4dD+dNrHULC6WpUjEi9/5mfeAs=;
        b=QHLoIWMfVplcun/lEerfYdg/bUv0X5hCUd/1WvfoqWyjD+DD7EByyKr9BIgS2w3tLu
         cUa3eF/zO1fZQ45n4VsIojB9YAw0fnCzEtFaABgm1r5y2kDFy9VSe15779sgE3n4dj68
         KxErNSoCdCdNt+2WRZOmVXAGuog9F2z44HJEoKq/qcN5+IzlaN7QU0aVjEmUZNsU8TL8
         2F/P56uKAj/YcpNocJ8PYz2IjqVaNO5HXe5L1Mt9YB+GuBINAP6KV6UGpN1LhGG5QwkC
         lWrTgXFGLwbq8JQmyl/t7sHPqGjk0JK84OJq3b8uzWzkcN/lhc8eNONutc3Sc3Rp1/rn
         /HFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757904712; x=1758509512;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EHCSfQ2XnebCHi96Y4dD+dNrHULC6WpUjEi9/5mfeAs=;
        b=j1Qj6pNsC3M7sf6WgOjumfjvnAmQyjFjJot+ENUBtkCEDB1qlGivLjRZepQ+RQmGRi
         uQLf4Di5qsGpJ7qYCj+Crn+TVzyfa5Y7vzGu6qwiKqECmn5VMPprI0+K4TnXO7SJhBUn
         aLY/S6t7gREe0PfXL8ySANqoAFf3InwqQaDIGbUi3xp8bXujjMC2UAgrXFo4fWEeWNCB
         G/C6c55dtkdLoolqmf/bvKwQBna4fzTnnLWHQVkHV20BBJsaf+0WOBpzJpeRj+xu70Qt
         C6hf0V+iiRe8OzIQtwRAHVO7DudvrCMbPJ+by9smIpwoNGTIj/RY2BlIA5PzshYpxlG4
         rLnw==
X-Forwarded-Encrypted: i=1; AJvYcCV/kpRTFp28oDI5Z6iCU5xKb02rFf7NXlmD+CnZmwFXm8tG/575bOHv9iO//eeai3UQLzQWDnEtLpmR@vger.kernel.org
X-Gm-Message-State: AOJu0Yyue6q4Lfb9pl1+AjblGIEYZ3dwMvtMJwCyFZLgkgRv0hE/OE3C
	M9idPFbIl/gNJnTGmZyGn01auCaiWGUNT3HW7UqO511QeTQDYW1wCgx2cHLsKPicqzlyIpGE0ob
	Odxe8m9FqMKdNSrMaMnNRQwwQXgLNN3A=
X-Gm-Gg: ASbGnct5I4VrG8NvVarooZcjYMFiN/oL/1tO25mJ/n2AMU/hVitxQ238WqUOifBnmnz
	AtnYb+8qvZURW/pSSAUySXdXZEeWWjb0i4HIjZP8vW3lg6LcXsKg02mb8iWh01RwatGhdVLdqOW
	kL0OpvA1VMsU0Ch/hoG3pWi9urc5qHOXyGMcNsMB8t2s0dirqlJv4npOA1On1uDb+7kaGTbxNXQ
	rF/4n4kIAPZcpYK4xfz
X-Google-Smtp-Source: AGHT+IFP8eaILsH9go5zyLSWkPywDlTf0zFbEuxeMo96jyMKBC6y8FwuOWf/q4q8WZnK3lNGYAepz88m6iC+xXZJxTk=
X-Received: by 2002:a05:6214:5f81:b0:767:c73e:88d4 with SMTP id
 6a1803df08f44-767c73e8a77mr124152186d6.8.1757904711760; Sun, 14 Sep 2025
 19:51:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?6ZmI5Y2O5pit?= <lyican53@gmail.com>
Date: Mon, 15 Sep 2025 10:51:38 +0800
X-Gm-Features: AS18NWCYV1ejkfb-hhHGxKG9Jq-ZiN_AIhYVPE02h-fdGA1vS5JP9-9rQn3NWAQ
Message-ID: <CAN53R8HxFvf9fAiF1vacCAdsx+m+Zcv1_vxEiq4CwoHLu17hNg@mail.gmail.com>
Subject: [RFC] Fix potential undefined behavior in __builtin_clz usage with
 GCC 11.1.0
To: linux-kernel@vger.kernel.org
Cc: idryomov@gmail.com, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	mturquette@baylibre.com, sboyd@kernel.org, linux-clk@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

I've identified several instances in the Linux kernel where __builtin_clz()
is used without proper zero-value checking, which may trigger undefined
behavior when compiled with GCC 11.1.0 using -march=x86-64-v3 -O1 optimization.

PROBLEM DESCRIPTION:
===================

GCC bug 101175 (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101175) causes
__builtin_clz() to generate BSR instructions without proper zero handling when
compiled with specific optimization flags. The BSR instruction has undefined
behavior when the source operand is zero, potentially causing incorrect results.

The issue manifests when:
- GCC version: 11.1.0 (potentially other versions)
- Compilation flags: -march=x86-64-v3 -O1
- Code pattern: __builtin_clz(value) where value might be 0

AFFECTED LOCATIONS:
==================

1. HIGH RISK: net/ceph/crush/mapper.c:265
Problem: __builtin_clz(x & 0x1FFFF) when (x & 0x1FFFF) could be 0
Impact: CRUSH hash algorithm corruption in Ceph storage

2. HIGH RISK: drivers/scsi/elx/libefc_sli/sli4.h:3796
Problem: __builtin_clz(mask) in sli_convert_mask_to_count() with no zero check
Impact: Incorrect count calculations in SCSI operations

3. HIGH RISK: tools/testing/selftests/kvm/dirty_log_test.c:314
Problem: Two __builtin_clz() calls without zero validation
Impact: KVM selftest framework reliability

4. MEDIUM RISK: drivers/clk/clk-versaclock7.c:322
Problem: __builtin_clzll(den) but prior checks likely prevent den=0
Impact: Clock driver calculations (lower risk due to existing checks)

COMPARISON WITH SAFE PATTERNS:
=============================

The kernel already implements safe patterns in many places:

// Safe pattern from include/asm-generic/bitops/builtin-fls.h
return x ? sizeof(x) * 8 - __builtin_clz(x) : 0;

// Safe pattern from arch/powerpc/lib/sstep.c
op->val = (val ? __builtin_clz(val) : 32);

PROPOSED FIXES:
==============

1. net/ceph/crush/mapper.c:
- int bits = __builtin_clz(x & 0x1FFFF) - 16;
+ u32 masked = x & 0x1FFFF;
+ int bits = masked ? __builtin_clz(masked) - 16 : 16;

2. drivers/scsi/elx/libefc_sli/sli4.h:
if (method) {
- count = 1 << (31 - __builtin_clz(mask));
+ count = mask ? 1 << (31 - __builtin_clz(mask)) : 0;
count *= 16;

3. tools/testing/selftests/kvm/dirty_log_test.c:
- limit = 1 << (31 - __builtin_clz(pages));
- test_dirty_ring_count = 1 << (31 - __builtin_clz(test_dirty_ring_count));
+ limit = pages ? 1 << (31 - __builtin_clz(pages)) : 1;
+ test_dirty_ring_count = test_dirty_ring_count ?
+ 1 << (31 - __builtin_clz(test_dirty_ring_count)) : 1;

REPRODUCTION:
============

Based on the GCC bug report and analysis of the kernel code patterns, this
issue can be reproduced by:

1. Compiling affected code with: gcc -march=x86-64-v3 -O1
2. Examining generated assembly for BSR instructions
3. Triggering code paths where the __builtin_clz argument could be zero

QUESTIONS:
=========

1. Should I prepare formal patches for each affected subsystem?
2. Are there other instances I should investigate?
3. Would adding a kernel-wide safe wrapper for __builtin_clz be appropriate?
4. Would the maintainers like me to create a proof-of-concept test case?

This analysis is based on static code review and comparison with the known
GCC bug behavior. Further testing by the respective subsystem maintainers
would be valuable to confirm the impact.

Best regards,
Huazhao Chen
lyican53@gmail.com

---

This analysis affects multiple subsystems and should be addressed to ensure
deterministic behavior across different GCC versions and optimization levels.
I'm happy to assist with testing or patch development if the maintainers
confirm this is indeed an issue worth addressing.
