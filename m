Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0FE41C8C
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqVp5I63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA2BC433C8;
	Thu,  7 Dec 2023 14:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701959300;
	bh=ZVLzNRalk/EBQP7fBKQQUpiBjDCywhTS+ujhMZKHZag=;
	h=From:To:Cc:Subject:Date:From;
	b=lqVp5I63et5bljSNokYmdBSuMMJegNZ3fS+vyMoz7z6FGjpPZAEEgPPkhmnB+23dI
	 iOITgbXqWJgtm9Z0cdHb2NGJ/EtdpNap3VBCdhLYx3RJuRZ0AnxvlI/mfskwMemqSM
	 pTYiCXXYkXxs3yTIhw1jYJs3QX9dXhzOq0b66YTljTKWTYD6qEVPVEVSQYVU3Ph0NS
	 6eWHkJKjI2TJGJ1pXXU/dAaXl2ZU8ErUkr1lDIF0/YD36eW0bsxhXd9wYXMVvlAABk
	 19jm6WRybPuP7n92iRjdcyy89tKKguVcD1IInxvJfR8XK/CO94Br5xRazz/Pj2D3sB
	 fQEylljkmBa4g==
From: Arnd Bergmann <arnd@kernel.org>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mpi3mr: fix printk() format strings
Date: Thu,  7 Dec 2023 15:28:06 +0100
Message-Id: <20231207142813.935717-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The newly introduced error messages get multiple format strings wrong: size_t must
be printed using the %z modifier rather than %l and dma_addr_t must be printed
by reference using the special %pad pointer type:

drivers/scsi/mpi3mr/mpi3mr_app.c: In function 'mpi3mr_build_nvme_prp':
include/linux/kern_levels.h:5:25: error: format '%llx' expects argument of type 'long long unsigned int', but argument 4 has type 'dma_addr_t' {aka 'unsigned int'} [-Werror=format=]
drivers/scsi/mpi3mr/mpi3mr_app.c:949:25: note: in expansion of macro 'dprint_bsg_err'
  949 |                         dprint_bsg_err(mrioc,
      |                         ^~~~~~~~~~~~~~
include/linux/kern_levels.h:5:25: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
drivers/scsi/mpi3mr/mpi3mr_app.c:1112:41: note: in expansion of macro 'dprint_bsg_err'
 1112 |                                         dprint_bsg_err(mrioc,
      |                                         ^~~~~~~~~~~~~~

Fixes: 9536af615dc9 ("scsi: mpi3mr: Support for preallocation of SGL BSG data buffers part-3")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 4b93b7440da6..0380996b5ad2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -947,8 +947,8 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 		dma_addr = drv_buf_iter->dma_desc[count].dma_addr;
 		if (dma_addr & page_mask) {
 			dprint_bsg_err(mrioc,
-				       "%s:dma_addr 0x%llx is not aligned with page size 0x%x\n",
-				       __func__,  dma_addr, dev_pgsz);
+				       "%s:dma_addr %pad is not aligned with page size 0x%x\n",
+				       __func__,  &dma_addr, dev_pgsz);
 			return -1;
 		}
 	}
@@ -1110,7 +1110,7 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 				if ((++desc_count) >=
 				   drv_buf_iter->num_dma_desc) {
 					dprint_bsg_err(mrioc,
-						       "%s: Invalid len %ld while building PRP\n",
+						       "%s: Invalid len %zd while building PRP\n",
 						       __func__, length);
 					goto err_out;
 				}
-- 
2.39.2

