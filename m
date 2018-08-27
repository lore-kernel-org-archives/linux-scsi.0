From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: arm64/crct10dif - implement non-Crypto Extensions alternative
Date: Mon, 27 Aug 2018 17:38:12 +0200
Message-ID: <20180827153812.6763-3-ard.biesheuvel@linaro.org>
References: <20180827153812.6763-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827153812.6763-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jeff.lien@wdc.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-scsi@vger.kernel.org

The arm64 implementation of the CRC-T10DIF algorithm uses the 64x64 bit
polynomial multiplication instructions, which are optional in the
architecture, and if these instructions are not available, we fall back
to the C routine which is slow and inefficient.

So let's reuse the 64x64 bit PMULL alternative from the GHASH driver that
uses a sequence of ~40 instructions involving 8x8 bit PMULL and some
shifting and masking. This is a lot slower than the original, but it is
still twice as fast as the current [unoptimized] C code on Cortex-A53,
and it is time invariant and much easier on the D-cache.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crct10dif-ce-core.S | 154 ++++++++++++++++++++
 arch/arm64/crypto/crct10dif-ce-glue.c |  10 +-
 2 files changed, 162 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index a39951015e86..9e82e8e8ed05 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -80,6 +80,145 @@
 
 	vzr		.req	v13
 
+	ad		.req	v14
+	bd		.req	v10
+
+	k00_16		.req	v15
+	k32_48		.req	v16
+
+	t3		.req	v17
+	t4		.req	v18
+	t5		.req	v19
+	t6		.req	v20
+	t7		.req	v21
+	t8		.req	v22
+	t9		.req	v23
+
+	perm1		.req	v24
+	perm2		.req	v25
+	perm3		.req	v26
+	perm4		.req	v27
+
+	bd1		.req	v28
+	bd2		.req	v29
+	bd3		.req	v30
+	bd4		.req	v31
+
+	.macro		__pmull_init_p64
+	.endm
+
+	.macro		__pmull_pre_p64, bd
+	.endm
+
+	.macro		__pmull_init_p8
+	// k00_16 := 0x0000000000000000_000000000000ffff
+	// k32_48 := 0x00000000ffffffff_0000ffffffffffff
+	movi		k32_48.2d, #0xffffffff
+	mov		k32_48.h[2], k32_48.h[0]
+	ushr		k00_16.2d, k32_48.2d, #32
+
+	// prepare the permutation vectors
+	mov_q		x5, 0x080f0e0d0c0b0a09
+	movi		perm4.8b, #8
+	dup		perm1.2d, x5
+	eor		perm1.16b, perm1.16b, perm4.16b
+	ushr		perm2.2d, perm1.2d, #8
+	ushr		perm3.2d, perm1.2d, #16
+	ushr		perm4.2d, perm1.2d, #24
+	sli		perm2.2d, perm1.2d, #56
+	sli		perm3.2d, perm1.2d, #48
+	sli		perm4.2d, perm1.2d, #40
+	.endm
+
+	.macro		__pmull_pre_p8, bd
+	tbl		bd1.16b, {\bd\().16b}, perm1.16b
+	tbl		bd2.16b, {\bd\().16b}, perm2.16b
+	tbl		bd3.16b, {\bd\().16b}, perm3.16b
+	tbl		bd4.16b, {\bd\().16b}, perm4.16b
+	.endm
+
+__pmull_p8_core:
+.L__pmull_p8_core:
+	ext		t4.8b, ad.8b, ad.8b, #1			// A1
+	ext		t5.8b, ad.8b, ad.8b, #2			// A2
+	ext		t6.8b, ad.8b, ad.8b, #3			// A3
+
+	pmull		t4.8h, t4.8b, bd.8b			// F = A1*B
+	pmull		t8.8h, ad.8b, bd1.8b			// E = A*B1
+	pmull		t5.8h, t5.8b, bd.8b			// H = A2*B
+	pmull		t7.8h, ad.8b, bd2.8b			// G = A*B2
+	pmull		t6.8h, t6.8b, bd.8b			// J = A3*B
+	pmull		t9.8h, ad.8b, bd3.8b			// I = A*B3
+	pmull		t3.8h, ad.8b, bd4.8b			// K = A*B4
+	b		0f
+
+.L__pmull_p8_core2:
+	tbl		t4.16b, {ad.16b}, perm1.16b		// A1
+	tbl		t5.16b, {ad.16b}, perm2.16b		// A2
+	tbl		t6.16b, {ad.16b}, perm3.16b		// A3
+
+	pmull2		t4.8h, t4.16b, bd.16b			// F = A1*B
+	pmull2		t8.8h, ad.16b, bd1.16b			// E = A*B1
+	pmull2		t5.8h, t5.16b, bd.16b			// H = A2*B
+	pmull2		t7.8h, ad.16b, bd2.16b			// G = A*B2
+	pmull2		t6.8h, t6.16b, bd.16b			// J = A3*B
+	pmull2		t9.8h, ad.16b, bd3.16b			// I = A*B3
+	pmull2		t3.8h, ad.16b, bd4.16b			// K = A*B4
+
+0:	eor		t4.16b, t4.16b, t8.16b			// L = E + F
+	eor		t5.16b, t5.16b, t7.16b			// M = G + H
+	eor		t6.16b, t6.16b, t9.16b			// N = I + J
+
+	uzp1		t8.2d, t4.2d, t5.2d
+	uzp2		t4.2d, t4.2d, t5.2d
+	uzp1		t7.2d, t6.2d, t3.2d
+	uzp2		t6.2d, t6.2d, t3.2d
+
+	// t4 = (L) (P0 + P1) << 8
+	// t5 = (M) (P2 + P3) << 16
+	eor		t8.16b, t8.16b, t4.16b
+	and		t4.16b, t4.16b, k32_48.16b
+
+	// t6 = (N) (P4 + P5) << 24
+	// t7 = (K) (P6 + P7) << 32
+	eor		t7.16b, t7.16b, t6.16b
+	and		t6.16b, t6.16b, k00_16.16b
+
+	eor		t8.16b, t8.16b, t4.16b
+	eor		t7.16b, t7.16b, t6.16b
+
+	zip2		t5.2d, t8.2d, t4.2d
+	zip1		t4.2d, t8.2d, t4.2d
+	zip2		t3.2d, t7.2d, t6.2d
+	zip1		t6.2d, t7.2d, t6.2d
+
+	ext		t4.16b, t4.16b, t4.16b, #15
+	ext		t5.16b, t5.16b, t5.16b, #14
+	ext		t6.16b, t6.16b, t6.16b, #13
+	ext		t3.16b, t3.16b, t3.16b, #12
+
+	eor		t4.16b, t4.16b, t5.16b
+	eor		t6.16b, t6.16b, t3.16b
+	ret
+ENDPROC(__pmull_p8_core)
+
+	.macro		__pmull_p8, rq, ad, bd, i
+	.ifnc		\bd, v10
+	.err
+	.endif
+	mov		ad.16b, \ad\().16b
+	.ifb		\i
+	pmull		\rq\().8h, \ad\().8b, bd.8b		// D = A*B
+	.else
+	pmull2		\rq\().8h, \ad\().16b, bd.16b		// D = A*B
+	.endif
+
+	bl		.L__pmull_p8_core\i
+
+	eor		\rq\().16b, \rq\().16b, t4.16b
+	eor		\rq\().16b, \rq\().16b, t6.16b
+	.endm
+
 	.macro		fold64, p, reg1, reg2
 	ldp		q11, q12, [arg2], #0x20
 
@@ -106,6 +245,7 @@ CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
 	__pmull_\p	\reg, \reg, v10, 2
 	.ifnb		\rk
 	ldr_l		q10, \rk, x8
+	__pmull_pre_\p	v10
 	.endif
 	eor		v7.16b, v7.16b, v8.16b
 	eor		v7.16b, v7.16b, \reg\().16b
@@ -128,6 +268,8 @@ CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
 
 	movi		vzr.16b, #0		// init zero register
 
+	__pmull_init_\p
+
 	// adjust the 16-bit initial_crc value, scale it to 32 bits
 	lsl		arg1_low32, arg1_low32, #16
 
@@ -176,6 +318,7 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	ldr_l		q10, rk3, x8	// xmm10 has rk3 and rk4
 					// type of pmull instruction
 					// will determine which constant to use
+	__pmull_pre_\p	v10
 
 	//
 	// we subtract 256 instead of 128 to save one instruction from the loop
@@ -212,6 +355,8 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	ldp		q6, q7, [sp, #.Lframe_local_offset + 96]
 	ldr_l		q10, rk3, x8
 	movi		vzr.16b, #0		// init zero register
+	__pmull_init_\p
+	__pmull_pre_\p	v10
 	endif_yield_neon
 
 	b		.L_fold_64_B_loop_\@
@@ -225,6 +370,7 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	// constants
 
 	ldr_l		q10, rk9, x8
+	__pmull_pre_\p	v10
 
 	fold16		\p, v0, rk11
 	fold16		\p, v1, rk13
@@ -306,6 +452,7 @@ CPU_LE(	ext		v1.16b, v1.16b, v1.16b, #8	)
 .L_128_done_\@:
 	// compute crc of a 128-bit value
 	ldr_l		q10, rk5, x8		// rk5 and rk6 in xmm10
+	__pmull_pre_\p	v10
 
 	// 64b fold
 	ext		v0.16b, vzr.16b, v7.16b, #8
@@ -321,6 +468,7 @@ CPU_LE(	ext		v1.16b, v1.16b, v1.16b, #8	)
 
 	// barrett reduction
 	ldr_l		q10, rk7, x8
+	__pmull_pre_\p	v10
 	mov		v0.d[0], v7.d[1]
 
 	__pmull_\p	v0, v0, v10
@@ -352,6 +500,7 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	b.lt		.L_less_than_16_left_\@
 
 	ldr_l		q10, rk1, x8		// rk1 and rk2 in xmm10
+	__pmull_pre_\p	v10
 
 	// update the counter. subtract 32 instead of 16 to save one
 	// instruction from the loop
@@ -372,6 +521,11 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	b		.L_128_done_\@
 	.endm
 
+ENTRY(crc_t10dif_pmull_p8)
+	crc_t10dif_pmull	p8
+ENDPROC(crc_t10dif_pmull_p8)
+
+	.align		5
 ENTRY(crc_t10dif_pmull_p64)
 	crc_t10dif_pmull	p64
 ENDPROC(crc_t10dif_pmull_p64)
diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index 343a1e95b11a..b461d62023f2 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -23,6 +23,7 @@
 #define CRC_T10DIF_PMULL_CHUNK_SIZE	16U
 
 asmlinkage u16 crc_t10dif_pmull_p64(u16 init_crc, const u8 buf[], u64 len);
+asmlinkage u16 crc_t10dif_pmull_p8(u16 init_crc, const u8 buf[], u64 len);
 
 static u16 (*crc_t10dif_pmull)(u16 init_crc, const u8 buf[], u64 len);
 
@@ -87,7 +88,10 @@ static struct shash_alg crc_t10dif_alg = {
 
 static int __init crc_t10dif_mod_init(void)
 {
-	crc_t10dif_pmull = crc_t10dif_pmull_p64;
+	if (elf_hwcap & HWCAP_PMULL)
+		crc_t10dif_pmull = crc_t10dif_pmull_p64;
+	else
+		crc_t10dif_pmull = crc_t10dif_pmull_p8;
 
 	return crypto_register_shash(&crc_t10dif_alg);
 }
@@ -97,8 +101,10 @@ static void __exit crc_t10dif_mod_exit(void)
 	crypto_unregister_shash(&crc_t10dif_alg);
 }
 
-module_cpu_feature_match(PMULL, crc_t10dif_mod_init);
+module_cpu_feature_match(ASIMD, crc_t10dif_mod_init);
 module_exit(crc_t10dif_mod_exit);
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("crct10dif");
+MODULE_ALIAS_CRYPTO("crct10dif-arm64-ce");
-- 
2.18.0
