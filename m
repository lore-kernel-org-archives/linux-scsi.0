From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: scsi_transport_spi:  make const arrays static to shink object code size
Date: Sat, 16 Sep 2017 16:44:59 +0100
Message-ID: <20170916154459.28614-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate const arrays on the stack, instead make them static.
Makes the object code smaller by over 530 bytes:

Before:
  37010	  14144	    128	  51282	   c852	drivers/scsi/scsi_transport_spi.o

After:
   text	   data	    bss	    dec	    hex	filename
  36312	  14304	    128	  50744	   c638	drivers/scsi/scsi_transport_spi.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/scsi_transport_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index d0219e36080c..3f7ad400fb8d 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -819,11 +819,11 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 	 * fails, the device won't let us write to the echo buffer
 	 * so just return failure */
 	
-	const char spi_test_unit_ready[] = {
+	static const char spi_test_unit_ready[] = {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0
 	};
 
-	const char spi_read_buffer_descriptor[] = {
+	static const char spi_read_buffer_descriptor[] = {
 		READ_BUFFER, 0x0b, 0, 0, 0, 0, 0, 0, 4, 0
 	};
 
-- 
2.14.1
