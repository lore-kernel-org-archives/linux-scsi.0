From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 1/3] scsi/trace: Use macros for getting driver byte,
 host byte, msg byte, and status byte
Date: Mon, 01 Sep 2014 12:33:28 +0000
Message-ID: <20140901123327.597.39622.stgit@yuno-kbuild.novalocal>
References: <20140901123325.597.47231.stgit@yuno-kbuild.novalocal>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140901123325.597.47231.stgit@yuno-kbuild.novalocal>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, "Ewan D. Milne" <emilne@redhat.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

For getting driver byte, host byte, msg byte, and status byte, macros are
implemented in scsi/scsi.h, so we use it.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Robert Elliott <Elliott@hp.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 include/trace/events/scsi.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index db6c935..8aecdc2 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -328,10 +328,10 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		  show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
-		  show_driverbyte_name(((__entry->result) >> 24) & 0xff),
-		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
-		  show_msgbyte_name(((__entry->result) >> 8) & 0xff),
-		  show_statusbyte_name(__entry->result & 0xff))
+		  show_driverbyte_name(driver_byte(__entry->result)),
+		  show_hostbyte_name(host_byte(__entry->result)),
+		  show_msgbyte_name(msg_byte(__entry->result)),
+		  show_statusbyte_name(status_byte(__entry->result)))
 );
 
 DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
