From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [RFC] [PATCH 9/9] drivers/scsi/pcmcia/nsp_cs.h Removal of old
 scsi code
Date: Sat, 12 Aug 2006 23:03:19 +0200
Message-ID: <44DE4217.8060501@gmail.com>
References: <44DE3E5E.3020605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422701AbWHLVDI@vger.kernel.org>
In-Reply-To: <44DE3E5E.3020605@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, GOTO Masanori <gotom@debian.or.jp>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

diff -uprN -X linux-work/Documentation/dontdiff linux-work-clean/drivers/scsi/pcmcia/nsp_cs.h linux-work/drivers/scsi/pcmcia/nsp_cs.h
--- linux-work-clean/drivers/scsi/pcmcia/nsp_cs.h	2006-08-12 01:50:53.000000000 +0200
+++ linux-work/drivers/scsi/pcmcia/nsp_cs.h	2006-08-12 20:31:31.000000000 +0200
@@ -290,7 +290,6 @@ typedef struct _nsp_hw_data {
 #endif
 } nsp_hw_data;

-
 /****************************************************************************
  *
  */
@@ -302,22 +301,13 @@ static int        nsp_cs_config (struct

 /* Linux SCSI subsystem specific functions */
 static struct Scsi_Host *nsp_detect     (struct scsi_host_template *sht);
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static        int        nsp_detect_old (struct scsi_host_template *sht);
-static        int        nsp_release_old(struct Scsi_Host *shpnt);
-#endif
 static const  char      *nsp_info       (struct Scsi_Host *shpnt);
 static        int        nsp_proc_info  (
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	                                 struct Scsi_Host *host,
-#endif
 					 char   *buffer,
 					 char  **start,
 					 off_t   offset,
 					 int     length,
-#if !(LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-					 int     hostno,
-#endif
 					 int     inout);
 static        int        nsp_queuecommand(Scsi_Cmnd *SCpnt, void (* done)(Scsi_Cmnd *SCpnt));

@@ -352,7 +342,6 @@ static struct Scsi_Host *nsp_detect(stru
 static int  __init nsp_cs_init(void);
 static void __exit nsp_cs_exit(void);

-
 /* Debug */
 #ifdef NSP_DEBUG
 static void show_command (Scsi_Cmnd *SCpnt);
@@ -397,7 +386,6 @@ enum _burst_mode {
 	BURST_MEM32 = 2,
 };

-
 /**************************************************************************
  * SCSI messaage
  */
@@ -409,62 +397,8 @@ enum _burst_mode {

 #define MSG_EXT_SDTR         0x01

-
-/**************************************************************************
- * Compatibility functions
- */
-
-/* for Kernel 2.4 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
-#  define scsi_register_host(template)   scsi_register_module(MODULE_SCSI_HA, template)
-#  define scsi_unregister_host(template) scsi_unregister_module(MODULE_SCSI_HA, template)
-#  define scsi_host_put(host)            scsi_unregister(host)
-
-typedef void irqreturn_t;
-#  define IRQ_NONE      /* */
-#  define IRQ_HANDLED   /* */
-#  define IRQ_RETVAL(x) /* */
-
-/* This is ad-hoc version of scsi_host_get_next() */
-static inline struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *host)
-{
-	if (host == NULL) {
-		return scsi_hostlist;
-	} else {
-		return host->next;
-	}
-}
-
-/* This is ad-hoc version of scsi_host_hn_get() */
-static inline struct Scsi_Host *scsi_host_hn_get(unsigned short hostno)
-{
-	struct Scsi_Host *host;
-
-	for (host = scsi_host_get_next(NULL); host != NULL;
-	     host = scsi_host_get_next(host)) {
-		if (host->host_no == hostno) {
-			break;
-		}
-	}
-
-	return host;
-}
-
-static void cs_error(struct pcmcia_device *handle, int func, int ret)
-{
-	error_info_t err = { func, ret };
-	pcmcia_report_error(handle, &err);
-}
-
-/* scatter-gather table */
-#  define BUFFER_ADDR (SCpnt->SCp.buffer->address)
-#endif
-
-/* for Kernel 2.6 */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
 /* scatter-gather table */
 #  define BUFFER_ADDR ((char *)((unsigned int)(SCpnt->SCp.buffer->page) + SCpnt->SCp.buffer->offset))
-#endif

 #endif  /*__nsp_cs__*/
 /* end */
