From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH v2 0/4] Patchset to use PCLMULQDQ to accelerate CRC-T10DIF checksum computation
Date: Wed, 17 Apr 2013 09:12:51 -0700
Message-ID: <cover.1366214842.git.tim.c.chen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Erdinc Ozturk <erdinc.ozturk@intel.com>, Vinodh Gopal <vinodh.gopal@intel.com>, James Guilford <james.guilford@intel.com>, Wajdi Feghali <wajdi.k.feghali@intel.com>, Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently the CRC-T10DIF checksum is computed using a generic table lookup
algorithm.  By switching the checksum to PCLMULQDQ based computation,
we can speedup the computation by 8x for checksumming 512 bytes and
even more for larger buffer size.  This will improve performance of SCSI
drivers turning on the CRC-T10IDF checksum.  In our SSD based experiments,
we have seen increase disk throughput by 3.5x with T10DIF for 512 byte
block size.

This patch set provides the x86_64 routine using PCLMULQDQ instruction
and switches the crc_t10dif library function to use the faster PCLMULQDQ
based routine when available.

Tim

v1->v2
1. Get rid of unnecessary xmm registers save and restore and fix ENDPROC
position in PCLMULQDQ version of crc t10dif computation.
2. Fix URL to paper reference of CRC computation with PCLMULQDQ. 
3. Add one additional tcrypt test case to exercise more code paths through 
crc t10dif computation.
4. Fix config dependencies of CRYPTO_CRCT10DIF.

Thanks to Matthew and Jussi who reviewed the patches and Keith
for testing version 1 of the patch set.  

Tim Chen (4):
  Wrap crc_t10dif function all to use crypto transform framework
  Accelerated CRC T10 DIF computation with PCLMULQDQ instruction
  Glue code to cast accelerated CRCT10DIF assembly as a crypto
    transform
  Simple correctness and speed test for CRCT10DIF hash

 arch/x86/crypto/Makefile                |   2 +
 arch/x86/crypto/crct10dif-pcl-asm_64.S  | 643 ++++++++++++++++++++++++++++++++
 arch/x86/crypto/crct10dif-pclmul_glue.c | 153 ++++++++
 crypto/Kconfig                          |  21 ++
 crypto/tcrypt.c                         |   8 +
 crypto/testmgr.c                        |  10 +
 crypto/testmgr.h                        |  33 ++
 include/linux/crc-t10dif.h              |  10 +
 lib/crc-t10dif.c                        |  96 +++++
 9 files changed, 976 insertions(+)
 create mode 100644 arch/x86/crypto/crct10dif-pcl-asm_64.S
 create mode 100644 arch/x86/crypto/crct10dif-pclmul_glue.c

-- 
1.7.11.7
