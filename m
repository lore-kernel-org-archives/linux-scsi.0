From: Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 31/32] scsi: fnic: use current_kernel_time() for timestamp
Date: Fri, 30 May 2014 22:01:55 +0200
Message-ID: <1401480116-1973111-32-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The fnic driver currently uses the CURRENT_TIME macro to
generate a timestamp. Since this is otherwise used only in
file system code and we want to change the type, it's
better for this driver to use the equivalent function that
continues to return a struct timespec.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Hiral Patel <hiralpat@cisco.com>
Cc: Suma Ramars <sramars@cisco.com>
Cc: Brian Uchino <buchino@cisco.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/fnic/fnic_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index c772859..2659538 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -612,7 +612,7 @@ int fnic_fc_trace_set_data(u32 host_no, u8 frame_type,
 			fc_trace_entries.rd_idx = 0;
 	}
 
-	fc_buf->time_stamp = CURRENT_TIME;
+	fc_buf->time_stamp = current_kernel_time();
 	fc_buf->host_no = host_no;
 	fc_buf->frame_type = frame_type;
 
-- 
1.8.3.2

