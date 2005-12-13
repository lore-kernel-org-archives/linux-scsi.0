From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Correct NO_EXTENDED_MSGS definition
Date: Tue, 13 Dec 2005 06:30:24 -0700
Message-ID: <20051213133024.GL9286@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35530 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932175AbVLMNaY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2005 08:30:24 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Use the ARRAY_SIZE macro.  Also fixes the definition of NO_EXTENDED_MSGS
(I diagnose excessive cut-and-paste-itis).

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: drivers/scsi/constants.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/constants.c,v
retrieving revision 1.12
retrieving revision 1.13
diff -u -p -r1.12 -r1.13
--- a/drivers/scsi/constants.c	12 Nov 2005 04:08:09 -0000	1.12
+++ b/drivers/scsi/constants.c	13 Dec 2005 00:01:16 -0000	1.13
@@ -114,8 +114,7 @@ static const struct value_name_pair main
 	{0xd, "Report supported task management functions"},
 	{0xe, "Report priority"},
 };
-#define MAINT_IN_SZ \
-        (int)(sizeof(maint_in_arr) / sizeof(maint_in_arr[0]))
+#define MAINT_IN_SZ (int)ARRAY_SIZE(maint_in_arr)
 
 static const struct value_name_pair maint_out_arr[] = {
 	{0x6, "Set device identifier"},
@@ -123,34 +122,29 @@ static const struct value_name_pair main
 	{0xb, "Change aliases"},
 	{0xe, "Set priority"},
 };
-#define MAINT_OUT_SZ \
-        (int)(sizeof(maint_out_arr) / sizeof(maint_out_arr[0]))
+#define MAINT_OUT_SZ (int)ARRAY_SIZE(maint_out_arr)
 
 static const struct value_name_pair serv_in12_arr[] = {
 	{0x1, "Read media serial number"},
 };
-#define SERV_IN12_SZ  \
-        (int)(sizeof(serv_in12_arr) / sizeof(serv_in12_arr[0]))
+#define SERV_IN12_SZ (int)ARRAY_SIZE(serv_in12_arr)
 
 static const struct value_name_pair serv_out12_arr[] = {
 	{-1, "dummy entry"},
 };
-#define SERV_OUT12_SZ \
-        (int)(sizeof(serv_out12_arr) / sizeof(serv_in12_arr[0]))
+#define SERV_OUT12_SZ (int)ARRAY_SIZE(serv_out12_arr)
 
 static const struct value_name_pair serv_in16_arr[] = {
 	{0x10, "Read capacity(16)"},
 	{0x11, "Read long(16)"},
 };
-#define SERV_IN16_SZ  \
-        (int)(sizeof(serv_in16_arr) / sizeof(serv_in16_arr[0]))
+#define SERV_IN16_SZ (int)ARRAY_SIZE(serv_in16_arr)
 
 static const struct value_name_pair serv_out16_arr[] = {
 	{0x11, "Write long(16)"},
 	{0x1f, "Notify data transfer device(16)"},
 };
-#define SERV_OUT16_SZ \
-        (int)(sizeof(serv_out16_arr) / sizeof(serv_in16_arr[0]))
+#define SERV_OUT16_SZ (int)ARRAY_SIZE(serv_out16_arr)
 
 static const struct value_name_pair variable_length_arr[] = {
 	{0x1, "Rebuild(32)"},
@@ -190,8 +184,7 @@ static const struct value_name_pair vari
 	{0x8f7e, "Perform SCSI command (osd)"},
 	{0x8f7f, "Perform task management function (osd)"},
 };
-#define VARIABLE_LENGTH_SZ \
-        (int)(sizeof(variable_length_arr) / sizeof(variable_length_arr[0]))
+#define VARIABLE_LENGTH_SZ (int)ARRAY_SIZE(variable_length_arr)
 
 static const char * get_sa_name(const struct value_name_pair * arr,
 			        int arr_sz, int service_action)
@@ -1287,19 +1280,19 @@ static const char *one_byte_msgs[] = {
 /* 0x0c */ "Bus device reset", "Abort Tag", "Clear Queue", 
 /* 0x0f */ "Initiate Recovery", "Release Recovery"
 };
-#define NO_ONE_BYTE_MSGS (sizeof(one_byte_msgs)  / sizeof (const char *))
+#define NO_ONE_BYTE_MSGS ARRAY_SIZE(one_byte_msgs)
 
 static const char *two_byte_msgs[] = {
 /* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag",
 /* 0x23 */ "Ignore Wide Residue"
 };
-#define NO_TWO_BYTE_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
+#define NO_TWO_BYTE_MSGS ARRAY_SIZE(two_byte_msgs)
 
 static const char *extended_msgs[] = {
 /* 0x00 */ "Modify Data Pointer", "Synchronous Data Transfer Request",
 /* 0x02 */ "SCSI-I Extended Identify", "Wide Data Transfer Request"
 };
-#define NO_EXTENDED_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
+#define NO_EXTENDED_MSGS ARRAY_SIZE(extended_msgs)
 
 
 int scsi_print_msg (const unsigned char *msg)
@@ -1401,7 +1399,7 @@ static const char * hostbyte_table[]={
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET", 
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY"};
-#define NUM_HOSTBYTE_STRS (sizeof(hostbyte_table) / sizeof(const char *))
+#define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
 void scsi_print_hostbyte(int scsiresult)
 {
@@ -1425,12 +1423,12 @@ void scsi_print_hostbyte(int scsiresult)
 static const char * driverbyte_table[]={
 "DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR", 
 "DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD", "DRIVER_SENSE"};
-#define NUM_DRIVERBYTE_STRS (sizeof(driverbyte_table) / sizeof(const char *))
+#define NUM_DRIVERBYTE_STRS ARRAY_SIZE(driverbyte_table)
 
 static const char * driversuggest_table[]={"SUGGEST_OK",
 "SUGGEST_RETRY", "SUGGEST_ABORT", "SUGGEST_REMAP", "SUGGEST_DIE",
 "SUGGEST_5", "SUGGEST_6", "SUGGEST_7", "SUGGEST_SENSE"};
-#define NUM_SUGGEST_STRS (sizeof(driversuggest_table) / sizeof(const char *))
+#define NUM_SUGGEST_STRS ARRAY_SIZE(driversuggest_table)
 
 void scsi_print_driverbyte(int scsiresult)
 {
