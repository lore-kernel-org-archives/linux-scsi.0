From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm64/crct10dif - preparatory refactor for 8x8 PMULL version
Date: Mon, 27 Aug 2018 17:38:11 +0200
Message-ID: <20180827153812.6763-2-ard.biesheuvel@linaro.org>
References: <20180827153812.6763-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180827153812.6763-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jeff.lien@wdc.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-scsi@vger.kernel.org

Reorganize the CRC-T10DIF asm routine so we can easily instantiate an
alternative version based on 8x8 polynomial multiplication in a
subsequent patch.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crct10dif-ce-core.S | 160 +++++++++++---------
 arch/arm64/crypto/crct10dif-ce-glue.c |   6 +-
 2 files changed, 90 insertions(+), 76 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index 663ea71cdb38..a39951015e86 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -80,7 +80,46 @@
 
 	vzr		.req	v13
 
-ENTRY(crc_t10dif_pmull)
+	.macro		fold64, p, reg1, reg2
+	ldp		q11, q12, [arg2], #0x20
+
+	__pmull_\p	v8, \reg1, v10, 2
+	__pmull_\p	\reg1, \reg1, v10
+
+CPU_LE(	rev64		v11.16b, v11.16b		)
+CPU_LE(	rev64		v12.16b, v12.16b		)
+
+	__pmull_\p	v9, \reg2, v10, 2
+	__pmull_\p	\reg2, \reg2, v10
+
+CPU_LE(	ext		v11.16b, v11.16b, v11.16b, #8	)
+CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
+
+	eor		\reg1\().16b, \reg1\().16b, v8.16b
+	eor		\reg2\().16b, \reg2\().16b, v9.16b
+	eor		\reg1\().16b, \reg1\().16b, v11.16b
+	eor		\reg2\().16b, \reg2\().16b, v12.16b
+	.endm
+
+	.macro		fold16, p, reg, rk
+	__pmull_\p	v8, \reg, v10
+	__pmull_\p	\reg, \reg, v10, 2
+	.ifnb		\rk
+	ldr_l		q10, \rk, x8
+	.endif
+	eor		v7.16b, v7.16b, v8.16b
+	eor		v7.16b, v7.16b, \reg\().16b
+	.endm
+
+	.macro		__pmull_p64, rd, rn, rm, n
+	.ifb		\n
+	pmull		\rd\().1q, \rn\().1d, \rm\().1d
+	.else
+	pmull2		\rd\().1q, \rn\().2d, \rm\().2d
+	.endif
+	.endm
+
+	.macro		crc_t10dif_pmull, p
 	frame_push	3, 128
 
 	mov		arg1_low32, w0
@@ -96,7 +135,7 @@ ENTRY(crc_t10dif_pmull)
 	cmp		arg3, #256
 
 	// for sizes less than 128, we can't fold 64B at a time...
-	b.lt		_less_than_128
+	b.lt		.L_less_than_128_\@
 
 	// load the initial crc value
 	// crc value does not need to be byte-reflected, but it needs
@@ -147,41 +186,19 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	// buffer. The _fold_64_B_loop will fold 64B at a time
 	// until we have 64+y Bytes of buffer
 
-
 	// fold 64B at a time. This section of the code folds 4 vector
 	// registers in parallel
-_fold_64_B_loop:
-
-	.macro		fold64, reg1, reg2
-	ldp		q11, q12, [arg2], #0x20
-
-	pmull2		v8.1q, \reg1\().2d, v10.2d
-	pmull		\reg1\().1q, \reg1\().1d, v10.1d
-
-CPU_LE(	rev64		v11.16b, v11.16b		)
-CPU_LE(	rev64		v12.16b, v12.16b		)
-
-	pmull2		v9.1q, \reg2\().2d, v10.2d
-	pmull		\reg2\().1q, \reg2\().1d, v10.1d
-
-CPU_LE(	ext		v11.16b, v11.16b, v11.16b, #8	)
-CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
-
-	eor		\reg1\().16b, \reg1\().16b, v8.16b
-	eor		\reg2\().16b, \reg2\().16b, v9.16b
-	eor		\reg1\().16b, \reg1\().16b, v11.16b
-	eor		\reg2\().16b, \reg2\().16b, v12.16b
-	.endm
+.L_fold_64_B_loop_\@:
 
-	fold64		v0, v1
-	fold64		v2, v3
-	fold64		v4, v5
-	fold64		v6, v7
+	fold64		\p, v0, v1
+	fold64		\p, v2, v3
+	fold64		\p, v4, v5
+	fold64		\p, v6, v7
 
 	subs		arg3, arg3, #128
 
 	// check if there is another 64B in the buffer to be able to fold
-	b.lt		_fold_64_B_end
+	b.lt		.L_fold_64_B_end_\@
 
 	if_will_cond_yield_neon
 	stp		q0, q1, [sp, #.Lframe_local_offset]
@@ -197,9 +214,9 @@ CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
 	movi		vzr.16b, #0		// init zero register
 	endif_yield_neon
 
-	b		_fold_64_B_loop
+	b		.L_fold_64_B_loop_\@
 
-_fold_64_B_end:
+.L_fold_64_B_end_\@:
 	// at this point, the buffer pointer is pointing at the last y Bytes
 	// of the buffer the 64B of folded data is in 4 of the vector
 	// registers: v0, v1, v2, v3
@@ -209,37 +226,27 @@ _fold_64_B_end:
 
 	ldr_l		q10, rk9, x8
 
-	.macro		fold16, reg, rk
-	pmull		v8.1q, \reg\().1d, v10.1d
-	pmull2		\reg\().1q, \reg\().2d, v10.2d
-	.ifnb		\rk
-	ldr_l		q10, \rk, x8
-	.endif
-	eor		v7.16b, v7.16b, v8.16b
-	eor		v7.16b, v7.16b, \reg\().16b
-	.endm
-
-	fold16		v0, rk11
-	fold16		v1, rk13
-	fold16		v2, rk15
-	fold16		v3, rk17
-	fold16		v4, rk19
-	fold16		v5, rk1
-	fold16		v6
+	fold16		\p, v0, rk11
+	fold16		\p, v1, rk13
+	fold16		\p, v2, rk15
+	fold16		\p, v3, rk17
+	fold16		\p, v4, rk19
+	fold16		\p, v5, rk1
+	fold16		\p, v6
 
 	// instead of 64, we add 48 to the loop counter to save 1 instruction
 	// from the loop instead of a cmp instruction, we use the negative
 	// flag with the jl instruction
 	adds		arg3, arg3, #(128-16)
-	b.lt		_final_reduction_for_128
+	b.lt		.L_final_reduction_for_128_\@
 
 	// now we have 16+y bytes left to reduce. 16 Bytes is in register v7
 	// and the rest is in memory. We can fold 16 bytes at a time if y>=16
 	// continue folding 16B at a time
 
-_16B_reduction_loop:
-	pmull		v8.1q, v7.1d, v10.1d
-	pmull2		v7.1q, v7.2d, v10.2d
+.L_16B_reduction_loop_\@:
+	__pmull_\p	v8, v7, v10
+	__pmull_\p	v7, v7, v10, 2
 	eor		v7.16b, v7.16b, v8.16b
 
 	ldr		q0, [arg2], #16
@@ -251,22 +258,22 @@ CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
 	// instead of a cmp instruction, we utilize the flags with the
 	// jge instruction equivalent of: cmp arg3, 16-16
 	// check if there is any more 16B in the buffer to be able to fold
-	b.ge		_16B_reduction_loop
+	b.ge		.L_16B_reduction_loop_\@
 
 	// now we have 16+z bytes left to reduce, where 0<= z < 16.
 	// first, we reduce the data in the xmm7 register
 
-_final_reduction_for_128:
+.L_final_reduction_for_128_\@:
 	// check if any more data to fold. If not, compute the CRC of
 	// the final 128 bits
 	adds		arg3, arg3, #16
-	b.eq		_128_done
+	b.eq		.L_128_done_\@
 
 	// here we are getting data that is less than 16 bytes.
 	// since we know that there was data before the pointer, we can
 	// offset the input pointer before the actual point, to receive
 	// exactly 16 bytes. after that the registers need to be adjusted.
-_get_last_two_regs:
+.L_get_last_two_regs_\@:
 	add		arg2, arg2, arg3
 	ldr		q1, [arg2, #-16]
 CPU_LE(	rev64		v1.16b, v1.16b			)
@@ -291,47 +298,46 @@ CPU_LE(	ext		v1.16b, v1.16b, v1.16b, #8	)
 	bsl		v0.16b, v2.16b, v1.16b
 
 	// fold 16 Bytes
-	pmull		v8.1q, v7.1d, v10.1d
-	pmull2		v7.1q, v7.2d, v10.2d
+	__pmull_\p	v8, v7, v10
+	__pmull_\p	v7, v7, v10, 2
 	eor		v7.16b, v7.16b, v8.16b
 	eor		v7.16b, v7.16b, v0.16b
 
-_128_done:
+.L_128_done_\@:
 	// compute crc of a 128-bit value
 	ldr_l		q10, rk5, x8		// rk5 and rk6 in xmm10
 
 	// 64b fold
 	ext		v0.16b, vzr.16b, v7.16b, #8
 	mov		v7.d[0], v7.d[1]
-	pmull		v7.1q, v7.1d, v10.1d
+	__pmull_\p	v7, v7, v10
 	eor		v7.16b, v7.16b, v0.16b
 
 	// 32b fold
 	ext		v0.16b, v7.16b, vzr.16b, #4
 	mov		v7.s[3], vzr.s[0]
-	pmull2		v0.1q, v0.2d, v10.2d
+	__pmull_\p	v0, v0, v10, 2
 	eor		v7.16b, v7.16b, v0.16b
 
 	// barrett reduction
-_barrett:
 	ldr_l		q10, rk7, x8
 	mov		v0.d[0], v7.d[1]
 
-	pmull		v0.1q, v0.1d, v10.1d
+	__pmull_\p	v0, v0, v10
 	ext		v0.16b, vzr.16b, v0.16b, #12
-	pmull2		v0.1q, v0.2d, v10.2d
+	__pmull_\p	v0, v0, v10, 2
 	ext		v0.16b, vzr.16b, v0.16b, #12
 	eor		v7.16b, v7.16b, v0.16b
 	mov		w0, v7.s[1]
 
-_cleanup:
+.L_cleanup_\@:
 	// scale the result back to 16 bits
 	lsr		x0, x0, #16
 	frame_pop
 	ret
 
-_less_than_128:
-	cbz		arg3, _cleanup
+.L_less_than_128_\@:
+	cbz		arg3, .L_cleanup_\@
 
 	movi		v0.16b, #0
 	mov		v0.s[3], arg1_low32	// get the initial crc value
@@ -342,20 +348,20 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	eor		v7.16b, v7.16b, v0.16b	// xor the initial crc value
 
 	cmp		arg3, #16
-	b.eq		_128_done		// exactly 16 left
-	b.lt		_less_than_16_left
+	b.eq		.L_128_done_\@		// exactly 16 left
+	b.lt		.L_less_than_16_left_\@
 
 	ldr_l		q10, rk1, x8		// rk1 and rk2 in xmm10
 
 	// update the counter. subtract 32 instead of 16 to save one
 	// instruction from the loop
 	subs		arg3, arg3, #32
-	b.ge		_16B_reduction_loop
+	b.ge		.L_16B_reduction_loop_\@
 
 	add		arg3, arg3, #16
-	b		_get_last_two_regs
+	b		.L_get_last_two_regs_\@
 
-_less_than_16_left:
+.L_less_than_16_left_\@:
 	// shl r9, 4
 	adr_l		x0, tbl_shf_table + 16
 	sub		x0, x0, arg3
@@ -363,8 +369,12 @@ _less_than_16_left:
 	movi		v9.16b, #0x80
 	eor		v0.16b, v0.16b, v9.16b
 	tbl		v7.16b, {v7.16b}, v0.16b
-	b		_128_done
-ENDPROC(crc_t10dif_pmull)
+	b		.L_128_done_\@
+	.endm
+
+ENTRY(crc_t10dif_pmull_p64)
+	crc_t10dif_pmull	p64
+ENDPROC(crc_t10dif_pmull_p64)
 
 // precomputed constants
 // these constants are precomputed from the poly:
diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index 96f0cae4a022..343a1e95b11a 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -22,7 +22,9 @@
 
 #define CRC_T10DIF_PMULL_CHUNK_SIZE	16U
 
-asmlinkage u16 crc_t10dif_pmull(u16 init_crc, const u8 buf[], u64 len);
+asmlinkage u16 crc_t10dif_pmull_p64(u16 init_crc, const u8 buf[], u64 len);
+
+static u16 (*crc_t10dif_pmull)(u16 init_crc, const u8 buf[], u64 len);
 
 static int crct10dif_init(struct shash_desc *desc)
 {
@@ -85,6 +87,8 @@ static struct shash_alg crc_t10dif_alg = {
 
 static int __init crc_t10dif_mod_init(void)
 {
+	crc_t10dif_pmull = crc_t10dif_pmull_p64;
+
 	return crypto_register_shash(&crc_t10dif_alg);
 }
 
-- 
2.18.0
