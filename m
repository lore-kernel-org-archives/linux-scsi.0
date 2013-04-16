From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 0/4] Patchset to use PCLMULQDQ to accelerate CRC-T10DIF checksum computation
Date: Tue, 16 Apr 2013 09:20:47 -0700
Message-ID: <cover.1366120266.git.tim.c.chen@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7748 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965610Ab3DPXZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Apr 2013 19:25:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Jim Kukunas <james.t.kukunas@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Erdinc Ozturk <erdinc.ozturk@intel.com>, Vinodh Gopal <vinodh.gopal@intel.com>, James Guilford <james.guilford@intel.com>, Wajdi Feghali <wajdi.k.feghali@intel.com>, Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org

Herbert,

Currently the CRC-T10DIF checksum is computed using a generic table lookup
algorithm.  By switching the checksum to PCLMULQDQ based computation,
we can speedup the computation by 8x for checksumming 512 bytes and
even more for larger buffer size.  This will improve performance of SCSI
drivers turning on the CRC-T10IDF checksum.  In our SSD based experiments,
we have seen in disk throughput by 3.5x with T10DIF.

This patchset provide the x86_64 routine using PCLMULQDQ instruction
and switch the crc_t10dif library function to use the faster PCLMULQDQ
based routine when available.

Will appreciate if you can consider merging this for the 3.10 kernel.

Tim

Tim Chen (4):
  Wrap crc_t10dif function all to use crypto transform framework
  Accelerated CRC T10 DIF computation with PCLMULQDQ instruction
  Glue code to cast accelerated CRCT10DIF assembly as a crypto
    transform
  Simple correctness and speed test for CRCT10DIF hash

 arch/x86/crypto/Makefile                |   2 +
 arch/x86/crypto/crct10dif-pcl-asm_64.S  | 659 ++++++++++++++++++++++++++++++++
 arch/x86/crypto/crct10dif-pclmul_glue.c | 153 ++++++++
 crypto/Kconfig                          |  21 +
 crypto/tcrypt.c                         |   8 +
 crypto/testmgr.c                        |  10 +
 crypto/testmgr.h                        |  24 ++
 include/linux/crc-t10dif.h              |  10 +
 lib/crc-t10dif.c                        |  96 +++++
 9 files changed, 983 insertions(+)
 create mode 100644 arch/x86/crypto/crct10dif-pcl-asm_64.S
 create mode 100644 arch/x86/crypto/crct10dif-pclmul_glue.c

-- 
1.7.11.7

