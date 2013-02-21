From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH v2] [SCSI] aacraid: suppress two GCC warnings
Date: Thu, 21 Feb 2013 12:39:44 +0100
Message-ID: <1361446784.1341.41.camel@x61.thuisdomein>
References: <1360440561.1350.27.camel@x61.thuisdomein>
	 <1361356823.2581.43.camel@dabdike.int.hansenpartnership.com>
	 <1361358077.1341.14.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1361358077.1341.14.camel@x61.thuisdomein>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Building src.o for a 32 bit system triggers two GCC warnings:
    drivers/scsi/aacraid/src.c: In function =E2=80=98aac_src_deliver_me=
ssage=E2=80=99:
    drivers/scsi/aacraid/src.c:410:3: warning: right shift count >=3D w=
idth of type [enabled by default]
    drivers/scsi/aacraid/src.c:434:2: warning: right shift count >=3D w=
idth of type [enabled by default]

These warnings are caused by a right shift of 32. Use upper_32_bits() t=
o
suppress them.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Instead of a cast to u64, this version uses upper_32_bits() as James
suggested. I also stopped changing 0L to 0UL, because I keep having
doubts about the cargo cult.

1) Still compile tested only, but now on v3.8.

 drivers/scsi/aacraid/src.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 3b021ec..e2e3492 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -407,7 +407,7 @@ static int aac_src_deliver_message(struct fib *fib)
 		fib->hw_fib_va->header.StructType =3D FIB_MAGIC2;
 		fib->hw_fib_va->header.SenderFibAddress =3D (u32)address;
 		fib->hw_fib_va->header.u.TimeStamp =3D 0;
-		BUG_ON((u32)(address >> 32) !=3D 0L);
+		BUG_ON(upper_32_bits(address) !=3D 0L);
 		address |=3D fibsize;
 	} else {
 		/* Calculate the amount to the fibsize bits */
@@ -431,7 +431,7 @@ static int aac_src_deliver_message(struct fib *fib)
 		address |=3D fibsize;
 	}
=20
-	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
+	src_writel(dev, MUnit.IQ_H, upper_32_bits(address) & 0xffffffff);
 	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
=20
 	return 0;
--=20
1.8.1.2
