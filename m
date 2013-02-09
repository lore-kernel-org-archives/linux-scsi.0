From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] [SCSI] aacraid: silence two GCC warnings
Date: Sat, 09 Feb 2013 21:09:21 +0100
Message-ID: <1360440561.1350.27.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Compiling src.o for a 32 bit system triggers two GCC warnings:
    drivers/scsi/aacraid/src.c: In function =E2=80=98aac_src_deliver_me=
ssage=E2=80=99:
    drivers/scsi/aacraid/src.c:410:3: warning: right shift count >=3D w=
idth of type [enabled by default]
    drivers/scsi/aacraid/src.c:434:2: warning: right shift count >=3D w=
idth of type [enabled by default]

Silence these warnings by casting the 'address' variable (of type
dma_addr_t) to u64 on those two lines.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only.

1) Changing '0L' to 'OUL' might be a bit of cargo cult programming. I
doubt it's necessary. Members of that cult might also change
'0xffffffff' to '0xffffffffUL', but I didn't.

 drivers/scsi/aacraid/src.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 3b021ec..dfa8a37 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -407,7 +407,7 @@ static int aac_src_deliver_message(struct fib *fib)
 		fib->hw_fib_va->header.StructType =3D FIB_MAGIC2;
 		fib->hw_fib_va->header.SenderFibAddress =3D (u32)address;
 		fib->hw_fib_va->header.u.TimeStamp =3D 0;
-		BUG_ON((u32)(address >> 32) !=3D 0L);
+		BUG_ON(((u64)address >> 32) !=3D 0UL);
 		address |=3D fibsize;
 	} else {
 		/* Calculate the amount to the fibsize bits */
@@ -431,7 +431,7 @@ static int aac_src_deliver_message(struct fib *fib)
 		address |=3D fibsize;
 	}
=20
-	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
+	src_writel(dev, MUnit.IQ_H, ((u64)address >> 32) & 0xffffffff);
 	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
=20
 	return 0;
--=20
1.8.1.2
