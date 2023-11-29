Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283E31D536
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2023 12:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G2fEAlaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC20C433C7;
	Wed, 29 Nov 2023 12:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701259592;
	bh=nq4//SqYMEHrYH9WAGI7RRiUbWslfN4uSXxCXgslX3I=;
	h=From:To:Cc:Subject:Date:From;
	b=G2fEAlaXY9tFxabavDUIrq3gW35B2D4E12tQ8ohrVLz5r1hW/SMZIAUGcmW8TD1RI
	 /2v5JjXFS/tq65TaNXp2VQEJ8rYsrj6ZJzprlHSXMKLfNLfJWEAcTDDzH5iTG4bO0T
	 3YW0+jUc4Ti0oz5/HOdBhwoxmbWOVKX32muHb1kzfi3bBjB8gy9+NCUx+fRLuMFRbl
	 VPoY1k0t705F8RggchuakSm+td9XflYIk/SRrKpWk0Ko9eHb0MRdU2cI5ZppGPTH8t
	 ugSZh5DXirVOD8ZZmxla1YqIuvNku48z3+6mqVzsKFKo1xkTTAn6qD+0uFe62W+t6/
	 CmB6CHLTLsKPw==
From: Arnd Bergmann <arnd@kernel.org>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Tomas Henzl <thenzl@redhat.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: reduce stack usage in mpi3mr_refresh_sas_ports()
Date: Wed, 29 Nov 2023 13:06:12 +0100
Message-Id: <20231129120626.4118089-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Toubling the number of PHYs also doubled the stack usage of this function,
exceeding the 32-bit limit of 1024 bytes:

drivers/scsi/mpi3mr/mpi3mr_transport.c: In function 'mpi3mr_refresh_sas_ports':
drivers/scsi/mpi3mr/mpi3mr_transport.c:1818:1: error: the frame size of 1636 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Since the sas_io_unit_pg0 structure is already allocated dynamically, use
the same method here. The size of the allocation can be smaller based on the
actual number of phys now, so use this as an upper bound.

Fixes: cb5b60894602 ("scsi: mpi3mr: Increase maximum number of PHYs to 64 from 32")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index c0c8ab586957..ab04596dbdf5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1671,7 +1671,7 @@ mpi3mr_update_mr_sas_port(struct mpi3mr_ioc *mrioc, struct host_port *h_port,
 void
 mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 {
-	struct host_port h_port[64];
+	struct host_port *h_port = NULL;
 	int i, j, found, host_port_count = 0, port_idx;
 	u16 sz, attached_handle, ioc_status;
 	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
@@ -1685,6 +1685,11 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
 	if (!sas_io_unit_pg0)
 		return;
+	h_port = kcalloc(mrioc->sas_hba.num_phys, sizeof(struct host_port),
+			 GFP_KERNEL);
+	if (!h_port)
+		goto out;
+
 	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
@@ -1814,6 +1819,7 @@ mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
 		}
 	}
 out:
+	kfree(h_port);
 	kfree(sas_io_unit_pg0);
 }
 
-- 
2.39.2

