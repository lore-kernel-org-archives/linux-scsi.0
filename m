From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/ALUA]: Add initial support for EVPD 0x83
	Target port group and Logical Unit Group identifiers
Date: Mon, 02 Feb 2009 19:05:57 -0800
Message-ID: <1233630357.12375.101.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:26168 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751247AbZBCDHG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2009 22:07:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ming Zhang <blackmagic02881@gmail.com>, "Ross S. W. Walker" <rswwalker@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Rafiu Fakunle <rafiu@openfiler.com>

Greetings all,

This patch adds basic hardcoded support for EVPD 0x83 Target port group identifier (0x5) and
Logical Unit Group (0x6) identifiers.  These values will eventually be used by
Target_Core_Mod/ConfigFS for implict ALUA configuration.

Here is what it looks like with LIO-Target v3.0:

initiator# sg_inq -v -l 16384 -p 0x83 /dev/sdh
VPD INQUIRY: Device Identification page
    inquiry cdb: 12 01 83 00 fc 00
  Designation descriptor number 1, descriptor length: 58
    id_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: LIO-ORG
      vendor specific: IBLOCK:eEaqKo-gYF8-vnDA-jJhf-Xqzy-pjGF-G6Y50v
  Designation descriptor number 2, descriptor length: 8
    transport: Internet SCSI (iSCSI)
    id_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x1
  Designation descriptor number 3, descriptor length: 8
    transport: Internet SCSI (iSCSI)
    id_type: Target port group,  code_set: Binary
    associated with the target port
      Target port group: 0x0
  Designation descriptor number 4, descriptor length: 8
    id_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
      Logical unit group: 0x0
  Designation descriptor number 5, descriptor length: 72
    transport: Internet SCSI (iSCSI)
    id_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd,t,0x0001

This patch is made against lio-core-2.6.git/master
and tested on v2.6.29-rc2 x86 32-bit HVM.  The lio-core-2.6.git tree can be
found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_transport.c |   38 ++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 19c5100..ae51b5f 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -4168,6 +4168,8 @@ extern int transport_generic_emulate_inquiry (
 		if ((port = lun->lun_sep)) {	
 			se_portal_group_t *tpg = port->sep_tpg;
 			u32 padding, scsi_name_len;
+			u16 lun_gp = 0;	// Set to zero for implict ALUA
+			u16 tg_pg_i = 0; // Set to zero for implict ALUA
 			u16 tpgt;
 			/*
 			 * Relative target port identifer, see spc4r17 section 7.7.3.7 
@@ -4191,6 +4193,42 @@ extern int transport_generic_emulate_inquiry (
 			buf[off++] = (port->sep_rtpi & 0xff);
 			len += 8; // Header size + Designation descriptor 
 			/*
+			 * Target port group identifier, see spc4r17 section 7.7.3.8
+			 *
+			 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
+			 * section 7.5.1 Table 362 
+			 */
+			if (((len + 4) + 8) > cmd->data_length) {
+				len += 8; // Make check: below fail
+				goto check;
+			}
+			buf[off] = (TPG_TFO(tpg)->get_fabric_proto_ident() << 4);
+			buf[off++] |= 0x1; // CODE SET == Binary
+			buf[off] = 0x80; // Set PIV=1
+			buf[off] |= 0x10; // Set ASSOICATION == target port: 01b 
+			buf[off++] |= 0x5; // DESIGNATOR TYPE == Target port group identifier
+			off++; // Skip over Reserved
+			buf[off++] = 4; /* DESIGNATOR LENGTH */
+			off += 2; // Skip over Reserved Field
+			buf[off++] = ((tg_pg_i >> 8) & 0xff);
+			buf[off++] = (tg_pg_i & 0xff);
+			len += 8; // Header size + Designation descriptor
+			/*
+			 * Logical Unit Group identifier, see spc4r17 section 7.7.3.8
+			 */	
+			if (((len + 4) + 8) > cmd->data_length) {
+				len += 8; // Make check: below fail
+				goto check;
+			}
+			buf[off++] |= 0x1; // CODE SET == Binary
+			buf[off++] |= 0x6; // DESIGNATOR TYPE == Logical Unit Group identifier
+			off++; // Skip over Reserved
+			buf[off++] = 4; /* DESIGNATOR LENGTH */
+			off += 2; // Skip over Reserved Field
+			buf[off++] = ((lun_gp >> 8) & 0xff);
+			buf[off++] = (lun_gp & 0xff);
+			len += 8; // Header size + Designation descriptor
+			/*
 			 * SCSI name string designator, see spc4r17 section 7.7.3.11
 			 *
 			 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
-- 
1.5.4.1



