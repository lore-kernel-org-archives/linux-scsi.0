From: Dmitry Voytik <voytikd@gmail.com>
Subject: [PATCH v2] scsi: be2iscsi: fix potential NULL pointer dereference
Date: Wed, 16 Jan 2019 23:47:35 +0100
Message-ID: <20190116224735.13061-1-voytikd@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dmitry Voytik <voytikd@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Fix potential NULL pointer dereference wich might happen in
beiscsi_alloc_mem(). If kmalloc_array() fails and mem_descr->mem_array
is set to NULL, then its dereferencing happens when passing
mem_descr->mem_array[] to dma_free_coherent().

Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
---

Changes since v1:
 - prevent double free by setting mem_arr_orig to NULL

 drivers/scsi/be2iscsi/be_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 74e260027c7d..7b8c80318c38 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2527,8 +2527,11 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 		mem_descr->size_in_bytes = phba->mem_req[i];
 		mem_descr->mem_array = kmalloc_array(j, sizeof(*mem_arr),
 						     GFP_KERNEL);
-		if (!mem_descr->mem_array)
+		if (!mem_descr->mem_array) {
+			mem_descr->mem_array = mem_arr_orig;
+			mem_arr_orig = NULL;
 			goto free_mem;
+		}
 
 		memcpy(mem_descr->mem_array, mem_arr_orig,
 		       sizeof(struct mem_array) * j);
-- 
2.20.1
