From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: Status of qlogic tcp/ip (fc0) support
Date: Mon, 15 Dec 2003 10:19:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031215181944.GB1259@praka.local.home>
References: <1071483139.1433.3.camel@cala> <3FDD9D52.2060405@cri74.org> <1071511696.1932.1.camel@cala>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls01.socal.rr.com ([66.75.160.16]:46770 "EHLO
	orngca-mls01.socal.rr.com") by vger.kernel.org with ESMTP
	id S263927AbTLOSZE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 13:25:04 -0500
Content-Disposition: inline
In-Reply-To: <1071511696.1932.1.camel@cala>
List-Id: linux-scsi@vger.kernel.org
To: Mario Giammarco <mgiammarco@virgilio.it>
Cc: Fabien Salvi <fabien@cri74.org>, linux-scsi@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, 15 Dec 2003, Mario Giammarco wrote:

> > You should send your compile errors...
> 
> I am getting crazy.
> 
> I have tried with 2.4.18 2.4.22 2.4.23 2.6.0-test11 and I was not able to compile it.
> 
> What am I doing wrong?
> 

Try the attached patch against 6.06.10 (available from the QLogic
website).

Regards,
Andrew Vasquez

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ip_fixes-v6.06.10.diff"

diff -Nurd 60610-dist/drv/qla2x00.c 60610-ip1/qla2x00.c
--- 60610-dist/drv/qla2x00.c	2003-09-15 19:24:24.000000000 -0700
+++ 60610-ip1/qla2x00.c	2003-12-15 09:53:43.250856304 -0800
@@ -11578,7 +11578,7 @@
 
 			case ET_IP_RECEIVE:
 				/* Handle IP receive packet */
-				qla2x00_ip_receive(ha, pkt);
+				qla2x00_ip_receive(ha, (response_t *)pkt);
 				break;
 
 			case ET_MAILBOX_COMMAND:
@@ -14637,8 +14637,8 @@
 
 	/* Prepare CT request */
 	ct_iu = (struct ct_sns_pkt *)ha->ct_iu;
-	ct_req = ct_iu->p.req;
-	ct_rsp = ct_iu->p.rsp;
+	ct_req = &ct_iu->p.req;
+	ct_rsp = &ct_iu->p.rsp;
 
 	/* Initialize Name Server CT-Command header */
 	qla2x00_prep_nsrv_ct_cmd_hdr(ct_req,RSNN_NN_CMD,RSNN_NN_RSP_SIZE);
@@ -16607,10 +16607,14 @@
 	for ( ; size >= sizeof(port_list_entry_t);
 			size -= sizeof(port_list_entry_t),
 			port_entry++) {
+#if defined(FC_IP_SUPPORT)
+		uint16_t list_entry_loop_id;
+#endif
 		device.loop_id = le16_to_cpu(port_entry->loop_id);
 
 #if defined(FC_IP_SUPPORT)
-		device.loop_id &= LOOP_ID_MASK; 
+		list_entry_loop_id = port_entry->loop_id;
+		port_entry->loop_id &= LOOP_ID_MASK; 
 #endif
 
 		/* Skip any non-local loop-ids - this includes 'known ports' */
diff -Nurd 60610-dist/drv/qla2x00.h 60610-ip1/qla2x00.h
--- 60610-dist/drv/qla2x00.h	2003-09-15 19:11:19.000000000 -0700
+++ 60610-ip1/qla2x00.h	2003-12-15 09:57:08.934587624 -0800
@@ -2954,7 +2954,6 @@
 
 #define PORT_SCAN_NEEDED      28      /* */
 #define IOCTL_ERROR_RECOVERY	29      
-#define FDMI_REGISTER_NEEDED	30
 
 
 /* macro for timer to start dpc for handling mailbox commands */

--qMm9M+Fa2AknHoGS--
