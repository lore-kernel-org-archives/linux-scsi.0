Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAA431283E
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 14:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757944928; cv=none; b=ABt1M5xw1MritRgYzAYshIESstiHbjSlFOdehaJu+JslggDWQM27xAlsjQvWrqPaItk+JY08HMfmJmGlvfYxpTwgaUDZm9L9kV1mm9ctISwpYYiFHTD1udEHtW7oxNBRpwTySWkKB6ZjUO4trY3r6890TR8MIsxuTcT2zvwoMJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757944928; c=relaxed/simple;
	bh=+Q3O4y2WBPEBJ57wa/R6DL7ZmuMwhkbQ43LHQdgjuIs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PIpGNVqajngoP5H/06IxTUmXBzXZlDHFSP09gYUq2Ubw/6gfhinX9/DvKJ+jLOBawEhIgxEXTSVPn5J9cqpKuoB/PlTnDeJpx0PlbXGwAy0C5qOaEMyxGIy1w41Ax3yO0rC3PLNxko0gh0Ga+TtEmb/eERyXV8sgysD3EignTTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zo3fbmFc; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zo3fbmFc"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32df881dce2so2739816a91.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 07:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757944926; x=1758549726; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bb9kTddrcG1gYn0lmn1o+H87GYwOEccP+2QZchmvwOg=;
        b=zo3fbmFcf2efimSk7k2eDIAZ6dl+Xd59BakIzZidnjdGP/iEbq88Sh6tpWPH9TGPzL
         O6IlAehDkyQOPssxaSb5GlVpvwr/la3LW/rTEtwISE2T5T5qrpCUNOHX4DRWbmVW0wQV
         /DUusrqA0DLcwdrNV31CHObXFKpvjXoWtrpruSrUuXuliz/qU//ff5G+wzrjYCmYf1xx
         JrTuoO41BxxQobY3qhoo+MQG7yd0ZZuXbMN7g7iFTySoFVmWBSzjvUEmQzaKh1bokM3c
         iC89lMug8Dgae9dLxWAol008eoj/eTG7Lhvr6/aq+mumRAS4BCmrvXhkUX/9spCbjlWk
         CHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757944926; x=1758549726;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bb9kTddrcG1gYn0lmn1o+H87GYwOEccP+2QZchmvwOg=;
        b=W4E/iOcXZICJyIkxYs9T6FsHxDot/xmakBorACYkezZlqKZokOE2dIU3+S7C9S2+6y
         mj0xiDnDechVurynwGZ/HBg72U+bFheiHh+Ca03PbQ4NFjZK8U5jS0jdMqIc8HTaIlW9
         30fvi0Xo/iODBPR2MAQ9ilv1//4kjl4pN6HI7h/yLZjILH1ZDFkWIj7CR1ow1A69UYev
         FFwMMd6BC4caGzZXuMxdZg51sAWBJ3Nl9s3Dmol4Cj/9qHn4YBY8uO9qJGlZBu14tIGS
         dNz47VgJaPJaVxNiIVuy4tyTnhSin5AjsVN97Htikv0PjcYFWp1OFac6yXosaAUUgk9l
         OdKw==
X-Forwarded-Encrypted: i=1; AJvYcCX/U+91mI0iZ7v+cOF3XSOeef3cSbxg90vV1yB4yvSF7OVcUIoNTQdGFHlHhsjbTHd5viFJueB2fjbp@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3A3UvzRCERQ0SW6wyzzA6UOSdXP2+AkwX3j3gYZAQujIHEckq
	3t/35aTO3aWNps9kJed1dgD8p6jiprhLwBWfX3OOpbB9Nw0KZiPBi6vJfb2vU2H35ZNA9AOJCRa
	BMlazCw==
X-Google-Smtp-Source: AGHT+IF9VAl5yAYXme8hs+kHQJw7I6NLurDhLwOz+4NYmaOAMQ0rFyNNX/YVGnRr456xKTFFoiMubABtny4=
X-Received: from pjhu33.prod.google.com ([2002:a17:90a:51a4:b0:32e:7439:c086])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc4:b0:32d:f89f:9300
 with SMTP id 98e67ed59e1d1-32df89fb457mr10300075a91.8.1757944926072; Mon, 15
 Sep 2025 07:02:06 -0700 (PDT)
Date: Mon, 15 Sep 2025 07:02:04 -0700
In-Reply-To: <CAN53R8HxFvf9fAiF1vacCAdsx+m+Zcv1_vxEiq4CwoHLu17hNg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAN53R8HxFvf9fAiF1vacCAdsx+m+Zcv1_vxEiq4CwoHLu17hNg@mail.gmail.com>
Message-ID: <aMgcXJ3lbrTwOzzO@google.com>
Subject: Re: [RFC] Fix potential undefined behavior in __builtin_clz usage
 with GCC 11.1.0
From: Sean Christopherson <seanjc@google.com>
To: "=?utf-8?B?6ZmI5Y2O5pit?=" <lyican53@gmail.com>
Cc: linux-kernel@vger.kernel.org, idryomov@gmail.com, xiubli@redhat.com, 
	ceph-devel@vger.kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	mturquette@baylibre.com, sboyd@kernel.org, linux-clk@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

+Yuri

On Mon, Sep 15, 2025, =E9=99=88=E5=8D=8E=E6=98=AD wrote:
> Hi all,
>=20
> I've identified several instances in the Linux kernel where __builtin_clz=
()
> is used without proper zero-value checking, which may trigger undefined
> behavior when compiled with GCC 11.1.0 using -march=3Dx86-64-v3 -O1 optim=
ization.
>=20
> PROBLEM DESCRIPTION:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> GCC bug 101175 (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D101175) ca=
uses
> __builtin_clz() to generate BSR instructions without proper zero handling=
 when
> compiled with specific optimization flags. The BSR instruction has undefi=
ned
> behavior when the source operand is zero, potentially causing incorrect r=
esults.
>=20
> The issue manifests when:
> - GCC version: 11.1.0 (potentially other versions)
> - Compilation flags: -march=3Dx86-64-v3 -O1
> - Code pattern: __builtin_clz(value) where value might be 0
>=20
> AFFECTED LOCATIONS:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1. HIGH RISK: net/ceph/crush/mapper.c:265
> Problem: __builtin_clz(x & 0x1FFFF) when (x & 0x1FFFF) could be 0
> Impact: CRUSH hash algorithm corruption in Ceph storage
>=20
> 2. HIGH RISK: drivers/scsi/elx/libefc_sli/sli4.h:3796
> Problem: __builtin_clz(mask) in sli_convert_mask_to_count() with no zero =
check
> Impact: Incorrect count calculations in SCSI operations
>=20
> 3. HIGH RISK: tools/testing/selftests/kvm/dirty_log_test.c:314
> Problem: Two __builtin_clz() calls without zero validation
> Impact: KVM selftest framework reliability

In practice, neither pages nor test_dirty_ring_count can be zero.   Pages i=
s
guaranteed to be a large-ish value, as vm->page shift is guaranteed to be a=
t
most 16, DIRTY_MEM_BITS is 30, and the guest/host adjustments just do minor
tweaks.  Not to mention the test would fail miserably if pages were ever ze=
ro.

	pages =3D (1ul << (DIRTY_MEM_BITS - vm->page_shift)) + 3;
	pages =3D vm_adjust_num_guest_pages(vm->mode, pages);
	if (vm->page_size < getpagesize())
		pages =3D vm_num_host_pages(vm->mode, pages);

The user could deliberately set test_dirty_ring_count to zero, but the test=
 would
crash due to a divide-by-zero before reaching this point.

> 4. MEDIUM RISK: drivers/clk/clk-versaclock7.c:322
> Problem: __builtin_clzll(den) but prior checks likely prevent den=3D0
> Impact: Clock driver calculations (lower risk due to existing checks)
>=20
> COMPARISON WITH SAFE PATTERNS:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>=20
> The kernel already implements safe patterns in many places:
>=20
> // Safe pattern from include/asm-generic/bitops/builtin-fls.h
> return x ? sizeof(x) * 8 - __builtin_clz(x) : 0;
>=20
> // Safe pattern from arch/powerpc/lib/sstep.c
> op->val =3D (val ? __builtin_clz(val) : 32);
>=20
> PROPOSED FIXES:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1. net/ceph/crush/mapper.c:
> - int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
> + u32 masked =3D x & 0x1FFFF;
> + int bits =3D masked ? __builtin_clz(masked) - 16 : 16;
>=20
> 2. drivers/scsi/elx/libefc_sli/sli4.h:
> if (method) {
> - count =3D 1 << (31 - __builtin_clz(mask));
> + count =3D mask ? 1 << (31 - __builtin_clz(mask)) : 0;
> count *=3D 16;
>=20
> 3. tools/testing/selftests/kvm/dirty_log_test.c:
> - limit =3D 1 << (31 - __builtin_clz(pages));
> - test_dirty_ring_count =3D 1 << (31 - __builtin_clz(test_dirty_ring_coun=
t));
> + limit =3D pages ? 1 << (31 - __builtin_clz(pages)) : 1;
> + test_dirty_ring_count =3D test_dirty_ring_count ?
> + 1 << (31 - __builtin_clz(test_dirty_ring_count)) : 1;
>=20
> REPRODUCTION:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Based on the GCC bug report and analysis of the kernel code patterns, thi=
s
> issue can be reproduced by:
>=20
> 1. Compiling affected code with: gcc -march=3Dx86-64-v3 -O1
> 2. Examining generated assembly for BSR instructions
> 3. Triggering code paths where the __builtin_clz argument could be zero
>=20
> QUESTIONS:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1. Should I prepare formal patches for each affected subsystem?

Don't bother for the KVM selftest, it's not a problem in practice and check=
ing
for zero will only add confusion by incorrectly implying that pages and/or
test_dirty_ring_count can ever be zero.

> 2. Are there other instances I should investigate?
> 3. Would adding a kernel-wide safe wrapper for __builtin_clz be appropria=
te?

Maybe?  At a glance, several of the calls to __builtin_clz() could be repla=
ced
with fls() or fls64(), or a fls8() or fls16() (which don't exist, yet).  Th=
is is
probably a question for the bitops maintainer, Yuri, now Cc'd.

> 4. Would the maintainers like me to create a proof-of-concept test case?
>=20
> This analysis is based on static code review and comparison with the know=
n
> GCC bug behavior. Further testing by the respective subsystem maintainers
> would be valuable to confirm the impact.
>=20
> Best regards,
> Huazhao Chen
> lyican53@gmail.com
>=20
> ---
>=20
> This analysis affects multiple subsystems and should be addressed to ensu=
re
> deterministic behavior across different GCC versions and optimization lev=
els.
> I'm happy to assist with testing or patch development if the maintainers
> confirm this is indeed an issue worth addressing.
