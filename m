From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: T10-PI: Getting failed tag info
Date: Thu, 11 Dec 2014 22:12:11 -0500
Message-ID: <yq1r3w5blys.fsf@sermon.lab.mkp.net>
References: <54892468.5060300@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43631 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933474AbaLLDMR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2014 22:12:17 -0500
In-Reply-To: <54892468.5060300@vlnb.net> (Vladislav Bolkhovitin's message of
	"Wed, 10 Dec 2014 20:58:16 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Vlad" == Vladislav Bolkhovitin <vst@vlnb.net> writes:

Vlad,

Vlad> We are currently developing a SCSI target system with T10-PI. We
Vlad> are using block integrity interface and found a problem that this
Vlad> interface fundamentally can not pass Oracle T10-PI certification
Vlad> tests. Those tests require to receive on the initiator side
Vlad> information about which particular tag failed the target checks,
Vlad> but the block integrity interface does not preserve this
Vlad> information, hence the target can not deliver it to the initiator
Vlad> => certification failure. The storage provides the right sense,
Vlad> but then in scsi_io_completion() it is dropped and replaced by a
Vlad> single EILSEQ.

Vlad> What would be the best way to fix that? By making a patch
Vlad> introducing new -EXXXXXX error codes for the PI errors?

I posted such a patch a while back. We use that in our qualification
tooling to ensure that the right things are reported when a PI error is
injected at various places in the stack.

One thing that needs to be done is to make returning these new errors to
userland conditional on !BIP_BLOCK_INTEGRITY. I'll put that on my list.

-- 
Martin K. Petersen	Oracle Linux Engineering


block: Add specific data integrity errors

Introduce a set of error codes that can be used by the block integrity
subsystem to signal which class of error was encountered by either the
I/O controller or the storage device.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
diff --git a/block/blk-core.c b/block/blk-core.c
index 6f8dba161bfe..bde1de440b03 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2442,6 +2442,18 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		case -ENODATA:
 			error_type = "critical medium";
 			break;
+		case -ECTRLGRD:
+		case -ECTRLAPP:
+		case -ECTRLREF:
+		case -EDISKGRD:
+		case -EDISKAPP:
+		case -EDISKREF:
+		case -EKERNGRD:
+		case -EKERNAPP:
+		case -EKERNREF:
+		case -EILSEQ:
+			error_type = "data integrity";
+			break;
 		case -EIO:
 		default:
 			error_type = "I/O";
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f4167b013d99..c05e86f4dded 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1210,6 +1210,15 @@ static int noretry_error(int error)
 	case -EOPNOTSUPP:
 	case -EREMOTEIO:
 	case -EILSEQ:
+	case -ECTRLGRD:
+	case -ECTRLAPP:
+	case -ECTRLREF:
+	case -EDISKGRD:
+	case -EDISKAPP:
+	case -EDISKREF:
+	case -EKERNGRD:
+	case -EKERNAPP:
+	case -EKERNREF:
 	case -ENODATA:
 	case -ENOSPC:
 		return 1;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 85cf0ef843f6..9f9e5770606b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -837,7 +837,20 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				action = ACTION_REPREP;
 			} else if (sshdr.asc == 0x10) /* DIX */ {
 				action = ACTION_FAIL;
-				error = -EILSEQ;
+				switch (sshdr.ascq) {
+				case 0x1:
+					error = -ECTRLGRD;
+					break;
+				case 0x2:
+					error = -ECTRLAPP;
+					break;
+				case 0x3:
+					error = -ECTRLREF;
+					break;
+				default:
+					error = -EILSEQ;
+					break;
+				}
 			/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
 			} else if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
 				action = ACTION_FAIL;
@@ -847,8 +860,22 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			break;
 		case ABORTED_COMMAND:
 			action = ACTION_FAIL;
-			if (sshdr.asc == 0x10) /* DIF */
-				error = -EILSEQ;
+			if (sshdr.asc == 0x10) { /* DIF */
+				switch (sshdr.ascq) {
+				case 0x1:
+					error = -EDISKGRD;
+					break;
+				case 0x2:
+					error = -EDISKAPP;
+					break;
+				case 0x3:
+					error = -EDISKREF;
+					break;
+				default:
+					error = -EILSEQ;
+					break;
+				}
+			}
 			break;
 		case NOT_READY:
 			/* If the device is in the process of becoming
diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
index 1e1ea6e6e7a5..d89af4ba1e04 100644
--- a/include/uapi/asm-generic/errno.h
+++ b/include/uapi/asm-generic/errno.h
@@ -110,4 +110,15 @@
 
 #define EHWPOISON	133	/* Memory page has hardware error */
 
+/* data integrity errors */
+#define ECTRLGRD	134	/* I/O controller detected guard tag error */
+#define ECTRLAPP	135	/* I/O controller detected app tag error */
+#define ECTRLREF	136	/* I/O controller detected ref tag error */
+#define EDISKGRD	137	/* Storage device detected guard tag error */
+#define EDISKAPP	138	/* Storage device detected app tag error */
+#define EDISKREF	139	/* Storage device detected ref tag error */
+#define EKERNGRD	140	/* Kernel detected guard tag error */
+#define EKERNAPP	141	/* Kernel detected app tag error */
+#define EKERNREF	142	/* Kernel detected ref tag error */
+
 #endif
