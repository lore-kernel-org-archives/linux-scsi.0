From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 87/97] scsi: mpt3sas: fix memory ordering on 64bit writes
Date: Tue,  8 Jan 2019 14:29:36 -0500
Message-ID: <20190108192949.122407-87-sashal@kernel.org>
References: <20190108192949.122407-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190108192949.122407-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Stephan=20G=C3=BCnther?= <moepi@moepi.net>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephan Günther <moepi@moepi.net>

[ Upstream commit 23c3828aa2f84edec7020c7397a22931e7a879e1 ]

With commit 09c2f95ad404 ("scsi: mpt3sas: Swap I/O memory read value back
to cpu endianness"), 64bit writes in _base_writeq() were rewritten to use
__raw_writeq() instad of writeq().

This introduced a bug apparent on powerpc64 systems such as the Raptor
Talos II that causes the HBA to drop from the PCIe bus under heavy load and
being reinitialized after a couple of seconds.

It can easily be triggered on affacted systems by using something like

  fio --name=random-write --iodepth=4 --rw=randwrite --bs=4k --direct=0 \
    --size=128M --numjobs=64 --end_fsync=1
  fio --name=random-write --iodepth=4 --rw=randwrite --bs=64k --direct=0 \
    --size=128M --numjobs=64 --end_fsync=1

a couple of times. In my case I tested it on both a ZFS raidz2 and a btrfs
raid6 using LSI 9300-8i and 9400-8i controllers.

The fix consists in resembling the write ordering of writeq() by adding a
mandatory write memory barrier before device access and a compiler barrier
afterwards. The additional MMIO barrier is superfluous.

Signed-off-by: Stephan Günther <moepi@moepi.net>
Reported-by: Matt Corallo <linux@bluematt.me>
Acked-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 59d7844ee022..b59bba3e6516 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3344,8 +3344,9 @@ _base_mpi_ep_writeq(__u64 b, volatile void __iomem *addr,
 static inline void
 _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t *writeq_lock)
 {
+	wmb();
 	__raw_writeq(b, addr);
-	mmiowb();
+	barrier();
 }
 #else
 static inline void
-- 
2.19.1
