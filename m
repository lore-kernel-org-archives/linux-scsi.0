From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 0/2] crypto: arm64/crct10dif - refactor and implement non-Crypto Extension version
Date: Mon, 27 Aug 2018 17:38:10 +0200
Message-ID: <20180827153812.6763-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jeff.lien@wdc.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-scsi@vger.kernel.org

The current arm64 CRC-T10DIF code only runs on cores that implement the
64x64 bit PMULL instructions that are part of the optional Crypto
Extensions, and falls back to the highly inefficient C code otherwise.

Let's provide a SIMD version that is twice as fast as the C code even on
a low end core like the Cortex-A53, and is time invariant and much easier
on the D-cache.

Some performance numbers at the bottom.

Ard Biesheuvel (2):
  crypto: arm64/crct10dif - preparatory refactor for 8x8 PMULL version
  crypto: arm64/crct10dif - implement non-Crypto Extensions alternative

 arch/arm64/crypto/crct10dif-ce-core.S | 314 +++++++++++++++-----
 arch/arm64/crypto/crct10dif-ce-glue.c |  14 +-
 2 files changed, 251 insertions(+), 77 deletions(-)

-- 
2.18.0

tcrypto speed tests on a 1 GHz Cortex-A53:

C version
=========
 0 (   16 byte blocks,   16 bytes x   1): 3302652 opers/sec,   52842432 Bps
 1 (   64 byte blocks,   16 bytes x   4):  612125 opers/sec,   39176000 Bps
 2 (   64 byte blocks,   64 bytes x   1): 1272473 opers/sec,   81438272 Bps
 3 (  256 byte blocks,   16 bytes x  16):  162127 opers/sec,   41504512 Bps
 4 (  256 byte blocks,   64 bytes x   4):  280237 opers/sec,   71740672 Bps
 5 (  256 byte blocks,  256 bytes x   1):  367349 opers/sec,   94041344 Bps
 6 ( 1024 byte blocks,   16 bytes x  64):   41142 opers/sec,   42129408 Bps
 7 ( 1024 byte blocks,  256 bytes x   4):   88099 opers/sec,   90213376 Bps
 8 ( 1024 byte blocks, 1024 bytes x   1):   95455 opers/sec,   97745920 Bps
 9 ( 2048 byte blocks,   16 bytes x 128):   20622 opers/sec,   42233856 Bps
10 ( 2048 byte blocks,  256 bytes x   8):   44421 opers/sec,   90974208 Bps
11 ( 2048 byte blocks, 1024 bytes x   2):   47158 opers/sec,   96579584 Bps
12 ( 2048 byte blocks, 2048 bytes x   1):   48095 opers/sec,   98498560 Bps
13 ( 4096 byte blocks,   16 bytes x 256):   10318 opers/sec,   42262528 Bps
14 ( 4096 byte blocks,  256 bytes x  16):   22265 opers/sec,   91197440 Bps
15 ( 4096 byte blocks, 1024 bytes x   4):   23639 opers/sec,   96825344 Bps
16 ( 4096 byte blocks, 4096 bytes x   1):   24032 opers/sec,   98435072 Bps
17 ( 8192 byte blocks,   16 bytes x 512):    5167 opers/sec,   42328064 Bps
18 ( 8192 byte blocks,  256 bytes x  32):   11152 opers/sec,   91357184 Bps
19 ( 8192 byte blocks, 1024 bytes x   8):   11836 opers/sec,   96960512 Bps
20 ( 8192 byte blocks, 4096 bytes x   2):   12006 opers/sec,   98353152 Bps
21 ( 8192 byte blocks, 8192 bytes x   1):   12031 opers/sec,   98557952 Bps

PMULL 64x64 version
====================
 0 (   16 byte blocks,   16 bytes x   1): 1663221 opers/sec,   26611536 Bps
 1 (   64 byte blocks,   16 bytes x   4):  496141 opers/sec,   31753024 Bps
 2 (   64 byte blocks,   64 bytes x   1): 1553169 opers/sec,   99402816 Bps
 3 (  256 byte blocks,   16 bytes x  16):  132224 opers/sec,   33849344 Bps
 4 (  256 byte blocks,   64 bytes x   4):  458027 opers/sec,  117254912 Bps
 5 (  256 byte blocks,  256 bytes x   1): 1353682 opers/sec,  346542592 Bps
 6 ( 1024 byte blocks,   16 bytes x  64):   33557 opers/sec,   34362368 Bps
 7 ( 1024 byte blocks,  256 bytes x   4):  390226 opers/sec,  399591424 Bps
 8 ( 1024 byte blocks, 1024 bytes x   1):  832879 opers/sec,  852868096 Bps
 9 ( 2048 byte blocks,   16 bytes x 128):   16853 opers/sec,   34514944 Bps
10 ( 2048 byte blocks,  256 bytes x   8):  201626 opers/sec,  412930048 Bps
11 ( 2048 byte blocks, 1024 bytes x   2):  437117 opers/sec,  895215616 Bps
12 ( 2048 byte blocks, 2048 bytes x   1):  553689 opers/sec, 1133955072 Bps
13 ( 4096 byte blocks,   16 bytes x 256):    8438 opers/sec,   34562048 Bps
14 ( 4096 byte blocks,  256 bytes x  16):  102551 opers/sec,  420048896 Bps
15 ( 4096 byte blocks, 1024 bytes x   4):  226754 opers/sec,  928784384 Bps
16 ( 4096 byte blocks, 4096 bytes x   1):  323362 opers/sec, 1324490752 Bps
17 ( 8192 byte blocks,   16 bytes x 512):    4222 opers/sec,   34586624 Bps
18 ( 8192 byte blocks,  256 bytes x  32):   51709 opers/sec,  423600128 Bps
19 ( 8192 byte blocks, 1024 bytes x   8):  115508 opers/sec,  946241536 Bps
20 ( 8192 byte blocks, 4096 bytes x   2):  169015 opers/sec, 1384570880 Bps
21 ( 8192 byte blocks, 8192 bytes x   1):  168734 opers/sec, 1382268928 Bps

PMULL 8x8 version
=================
testing speed of async crct10dif (crct10dif-arm64-ce)
 0 (   16 byte blocks,   16 bytes x   1): 1281627 opers/sec,   20506032 Bps
 1 (   64 byte blocks,   16 bytes x   4):  351733 opers/sec,   22510912 Bps
 2 (   64 byte blocks,   64 bytes x   1):  959314 opers/sec,   61396096 Bps
 3 (  256 byte blocks,   16 bytes x  16):   91002 opers/sec,   23296512 Bps
 4 (  256 byte blocks,   64 bytes x   4):  256833 opers/sec,   65749248 Bps
 5 (  256 byte blocks,  256 bytes x   1):  490696 opers/sec,  125618176 Bps
 6 ( 1024 byte blocks,   16 bytes x  64):   22952 opers/sec,   23502848 Bps
 7 ( 1024 byte blocks,  256 bytes x   4):  127006 opers/sec,  130054144 Bps
 8 ( 1024 byte blocks, 1024 bytes x   1):  168461 opers/sec,  172504064 Bps
 9 ( 2048 byte blocks,   16 bytes x 128):   11496 opers/sec,   23543808 Bps
10 ( 2048 byte blocks,  256 bytes x   8):   64000 opers/sec,  131072000 Bps
11 ( 2048 byte blocks, 1024 bytes x   2):   84752 opers/sec,  173572096 Bps
12 ( 2048 byte blocks, 2048 bytes x   1):   89919 opers/sec,  184154112 Bps
13 ( 4096 byte blocks,   16 bytes x 256):    5757 opers/sec,   23580672 Bps
14 ( 4096 byte blocks,  256 bytes x  16):   32129 opers/sec,  131600384 Bps
15 ( 4096 byte blocks, 1024 bytes x   4):   42608 opers/sec,  174522368 Bps
16 ( 4096 byte blocks, 4096 bytes x   1):   46351 opers/sec,  189853696 Bps
17 ( 8192 byte blocks,   16 bytes x 512):    2884 opers/sec,   23625728 Bps
18 ( 8192 byte blocks,  256 bytes x  32):   16105 opers/sec,  131932160 Bps
19 ( 8192 byte blocks, 1024 bytes x   8):   21364 opers/sec,  175013888 Bps
20 ( 8192 byte blocks, 4096 bytes x   2):   23299 opers/sec,  190865408 Bps
21 ( 8192 byte blocks, 8192 bytes x   1):   23292 opers/sec,  190808064 Bps
