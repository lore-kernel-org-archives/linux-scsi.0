From: Arjan van de Ven <arjan@infradead.org>
Subject: Mark some core scsi data structures const
Date: Mon, 28 Nov 2005 16:22:25 +0100
Message-ID: <1133191345.2824.34.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44004 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751274AbVK1PW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 10:22:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Hi,

patch below marks a few scsi core datastructures as const, so that they end up
in the .rodata section and don't cacheline share with things that get dirtied

Signed-off-by: Arjan van de Ven <arjan@infradead.org>

diff -purN linux-2.6.15-rc1/drivers/scsi/ch.c linux-2.6.15-rc1-const/drivers/scsi/ch.c
--- linux-2.6.15-rc1/drivers/scsi/ch.c	2005-11-17 09:45:28.000000000 +0100
+++ linux-2.6.15-rc1-const/drivers/scsi/ch.c	2005-11-28 09:54:04.000000000 +0100
@@ -75,7 +75,7 @@ static int vendor_counts[CH_TYPES-4];
 module_param_array(vendor_firsts, int, NULL, 0444);
 module_param_array(vendor_counts, int, NULL, 0444);
 
-static char *vendor_labels[CH_TYPES-4] = {
+static const char * vendor_labels[CH_TYPES-4] = {
 	"v0", "v1", "v2", "v3"
 };
 // module_param_string_array(vendor_labels, NULL, 0444);
@@ -140,7 +140,7 @@ static struct file_operations changer_fo
 #endif
 };
 
-static struct {
+static const struct {
 	unsigned char  sense;
 	unsigned char  asc;
 	unsigned char  ascq;
diff -purN linux-2.6.15-rc1/drivers/scsi/constants.c linux-2.6.15-rc1-const/drivers/scsi/constants.c
--- linux-2.6.15-rc1/drivers/scsi/constants.c	2005-11-17 09:45:28.000000000 +0100
+++ linux-2.6.15-rc1-const/drivers/scsi/constants.c	2005-11-28 09:42:57.000000000 +0100
@@ -1065,7 +1065,7 @@ struct error_info2 {
 	const char * fmt;
 };
 
-static struct error_info2 additional2[] =
+static const struct error_info2 additional2[] =
 {
 	{0x40,0x00,0x7f,"Ram failure (%x)"},
 	{0x40,0x80,0xff,"Diagnostic failure on component (%x)"},
@@ -1077,7 +1077,7 @@ static struct error_info2 additional2[] 
 };
 
 /* description of the sense key values */
-static const char *snstext[] = {
+static const char * const snstext[] = {
 	"No Sense",	    /* 0: There is no sense information */
 	"Recovered Error",  /* 1: The last command completed successfully
 				  but used error correction */
@@ -1279,7 +1279,7 @@ void scsi_print_req_sense(const char *de
 EXPORT_SYMBOL(scsi_print_req_sense);
 
 #ifdef CONFIG_SCSI_CONSTANTS
-static const char *one_byte_msgs[] = {
+static const char * const one_byte_msgs[] = {
 /* 0x00 */ "Command Complete", NULL, "Save Pointers",
 /* 0x03 */ "Restore Pointers", "Disconnect", "Initiator Error", 
 /* 0x06 */ "Abort", "Message Reject", "Nop", "Message Parity Error",
@@ -1289,13 +1289,13 @@ static const char *one_byte_msgs[] = {
 };
 #define NO_ONE_BYTE_MSGS (sizeof(one_byte_msgs)  / sizeof (const char *))
 
-static const char *two_byte_msgs[] = {
+static const char * const two_byte_msgs[] = {
 /* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag"
 /* 0x23 */ "Ignore Wide Residue"
 };
 #define NO_TWO_BYTE_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
 
-static const char *extended_msgs[] = {
+static const char * const extended_msgs[] = {
 /* 0x00 */ "Modify Data Pointer", "Synchronous Data Transfer Request",
 /* 0x02 */ "SCSI-I Extended Identify", "Wide Data Transfer Request"
 };
@@ -1397,7 +1397,7 @@ EXPORT_SYMBOL(scsi_print_command);
 
 #ifdef CONFIG_SCSI_CONSTANTS
 
-static const char * hostbyte_table[]={
+static const char * const hostbyte_table[]={
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET", 
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY"};
@@ -1422,12 +1422,12 @@ void scsi_print_hostbyte(int scsiresult)
 
 #ifdef CONFIG_SCSI_CONSTANTS
 
-static const char * driverbyte_table[]={
+static const char * const driverbyte_table[]={
 "DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR", 
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
 #define NUM_DRIVERBYTE_STRS (sizeof(driverbyte_table) / sizeof(const char *))
 
-static const char * driversuggest_table[]={"SUGGEST_OK",
+static const char * const driversuggest_table[]={"SUGGEST_OK",
 "SUGGEST_RETRY", "SUGGEST_ABORT", "SUGGEST_REMAP", "SUGGEST_DIE",
 "SUGGEST_5", "SUGGEST_6", "SUGGEST_7", "SUGGEST_SENSE"};
 #define NUM_SUGGEST_STRS (sizeof(driversuggest_table) / sizeof(const char *))
diff -purN linux-2.6.15-rc1/drivers/scsi/raid_class.c linux-2.6.15-rc1-const/drivers/scsi/raid_class.c
--- linux-2.6.15-rc1/drivers/scsi/raid_class.c	2005-11-17 09:45:28.000000000 +0100
+++ linux-2.6.15-rc1-const/drivers/scsi/raid_class.c	2005-11-28 09:57:50.000000000 +0100
@@ -115,7 +115,7 @@ static DECLARE_TRANSPORT_CLASS(raid_clas
 			       raid_remove,
 			       NULL);
 
-static struct {
+static const struct {
 	enum raid_state	value;
 	char		*name;
 } raid_states[] = {
diff -purN linux-2.6.15-rc1/drivers/scsi/scsi_scan.c linux-2.6.15-rc1-const/drivers/scsi/scsi_scan.c
--- linux-2.6.15-rc1/drivers/scsi/scsi_scan.c	2005-11-17 09:45:28.000000000 +0100
+++ linux-2.6.15-rc1-const/drivers/scsi/scsi_scan.c	2005-11-17 12:02:31.000000000 +0100
@@ -74,7 +74,7 @@
 #define SCSI_SCAN_TARGET_PRESENT	1
 #define SCSI_SCAN_LUN_PRESENT		2
 
-static char *scsi_null_device_strs = "nullnullnullnull";
+static const char *scsi_null_device_strs = "nullnullnullnull";
 
 #define MAX_SCSI_LUNS	512
 
diff -purN linux-2.6.15-rc1/drivers/scsi/scsi_sysfs.c linux-2.6.15-rc1-const/drivers/scsi/scsi_sysfs.c
--- linux-2.6.15-rc1/drivers/scsi/scsi_sysfs.c	2005-11-17 09:45:28.000000000 +0100
+++ linux-2.6.15-rc1-const/drivers/scsi/scsi_sysfs.c	2005-11-17 12:03:33.000000000 +0100
@@ -21,7 +21,7 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
-static struct {
+static const struct {
 	enum scsi_device_state	value;
 	char			*name;
 } sdev_states[] = {
@@ -48,7 +48,7 @@ const char *scsi_device_state_name(enum 
 	return name;
 }
 
-static struct {
+static const struct {
 	enum scsi_host_state	value;
 	char			*name;
 } shost_states[] = {
diff -purN linux-2.6.15-rc1/drivers/scsi/scsi_transport_fc.c linux-2.6.15-rc1-const/drivers/scsi/scsi_transport_fc.c
--- linux-2.6.15-rc1/drivers/scsi/scsi_transport_fc.c	2005-11-17 09:45:28.000000000 +0100
+++ linux-2.6.15-rc1-const/drivers/scsi/scsi_transport_fc.c	2005-11-17 12:05:32.000000000 +0100
@@ -111,7 +111,7 @@ fc_enum_name_search(port_state, fc_port_
 

 /* Convert fc_tgtid_binding_type values to ascii string name */
-static struct {
+static const struct {
 	enum fc_tgtid_binding_type	value;
 	char				*name;
 	int				matchlen;
@@ -149,7 +149,7 @@ get_fc_##title##_names(u32 table_key, ch
 

 /* Convert FC_COS bit values to ascii string name */
-static struct {
+static const struct {
 	u32 			value;
 	char			*name;
 } fc_cos_names[] = {
@@ -163,7 +163,7 @@ fc_bitfield_name_search(cos, fc_cos_name
 

 /* Convert FC_PORTSPEED bit values to ascii string name */
-static struct {
+static const struct {
 	u32 			value;
 	char			*name;
 } fc_port_speed_names[] = {
@@ -189,7 +189,7 @@ show_fc_fc4s (char *buf, u8 *fc4_list)
 

 /* Convert FC_RPORT_ROLE bit values to ascii string name */
-static struct {
+static const struct {
 	u32 			value;
 	char			*name;
 } fc_remote_port_role_names[] = {
diff -purN linux-2.6.15-rc1/drivers/scsi/sr.c linux-2.6.15-rc1-const/drivers/scsi/sr.c
--- linux-2.6.15-rc1/drivers/scsi/sr.c	2005-11-17 09:45:28.000000000 +0100
+++ linux-2.6.15-rc1-const/drivers/scsi/sr.c	2005-11-17 12:06:18.000000000 +0100
@@ -730,7 +730,7 @@ static void get_capabilities(struct scsi
 	unsigned int the_result;
 	int retries, rc, n;
 
-	static char *loadmech[] =
+	static const char *loadmech[] =
 	{
 		"caddy",
 		"tray",
diff -purN linux-2.6.15-rc1/drivers/scsi/st.c linux-2.6.15-rc1-const/drivers/scsi/st.c
--- linux-2.6.15-rc1/drivers/scsi/st.c	2005-11-17 09:45:28.000000000 +0100
+++ linux-2.6.15-rc1-const/drivers/scsi/st.c	2005-11-28 10:00:53.000000000 +0100
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20050830";
+static const char *verstr = "20050830";
 
 #include <linux/module.h>
 
@@ -134,7 +134,7 @@ static struct st_dev_parm {
 #endif
 /* Bit reversed order to get same names for same minors with all
    mode counts */
-static char *st_formats[] = {
+static const char *st_formats[] = {
 	"",  "r", "k", "s", "l", "t", "o", "u",
 	"m", "v", "p", "x", "a", "y", "q", "z"}; 
 


