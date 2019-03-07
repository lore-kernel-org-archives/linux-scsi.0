From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: gdth: Only call dma_free_coherent when buf is not NULL in ioc_general
Date: Thu,  7 Mar 2019 16:18:39 -0700
Message-ID: <20190307231839.3330-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Achim Leubner <achim_leubner@adaptec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

When building with -Wsometimes-uninitialized, Clang warns:

drivers/scsi/gdth.c:3662:6: warning: variable 'paddr' is used
uninitialized whenever 'if' condition is false
[-Wsometimes-uninitialized]

Don't attempt to call dma_free_coherent when buf is NULL (meaning that
we never called dma_alloc_coherent and initialized paddr), which avoids
this warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/402
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/gdth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index e7f1dd4f3b66..0ca9b4393770 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3697,8 +3697,9 @@ static int ioc_general(void __user *arg, char *cmnd)
 
 	rval = 0;
 out_free_buf:
-	dma_free_coherent(&ha->pdev->dev, gen.data_len + gen.sense_len, buf,
-			paddr);
+	if (buf)
+		dma_free_coherent(&ha->pdev->dev, gen.data_len + gen.sense_len,
+				  buf, paddr);
 	return rval;
 }
  
-- 
2.21.0
