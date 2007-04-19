From: Steven Hayter <steven@hayter.me.uk>
Subject: Re: [PATCH] add two SCSI command opcodes
Date: Thu, 19 Apr 2007 23:38:09 +0100
Message-ID: <4627EF51.7000603@hayter.me.uk>
References: <20070419151053.GA10199@localdomain> <20070419154743.GA18325@lug-owl.de> <20070419163959.GA25595@localdomain> <20070419164952.GA19438@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomb.org.uk ([85.189.5.98]:42848 "EHLO zombie.undead"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422709AbXDSXDF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Apr 2007 19:03:05 -0400
In-Reply-To: <20070419164952.GA19438@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Dan Aloni <da-x@monatomic.org>, Jan-Benedict Glaw <jbglaw@lug-owl.de>, Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
 > On Thu, Apr 19, 2007 at 07:39:59PM +0300, Dan Aloni wrote:
 >> On Thu, Apr 19, 2007 at 05:47:43PM +0200, Jan-Benedict Glaw wrote:
 >>> Where's the user?
 >> A privately maintained kernel driver.
 >>
 >> Do we _must_ have in-tree users? I'd consider the change for 
completion's
 >> sake.
 >
 > I agree with Dan -- if they're published in a SCSI spec, we should
 > include them in this header file.

That sounded like a challenge to me... it's not a serious suggestion 
it's included, but here's a patch against 2.6.20. for nearly all SCSI 
commands, bar a couple which are really redundant (eg SEND_MESSAGE_12).

There's quite a few in there people might also say are redundant, like 
the 3 diferent names for FORMAT... just there defined using diferent 
names for diferent device types, and all the ones for printer devices 
which as far as I'm aware there's no support on Linux for.

diff -urN a/include/scsi/scsi.h b/include/scsi/scsi.h
--- a/include/scsi/scsi.h	2007-04-19 22:31:57.000000000 +0100
+++ b/include/scsi/scsi.h	2007-04-19 23:30:03.000000000 +0100
@@ -35,37 +35,59 @@
   */

  #define TEST_UNIT_READY       0x00
+#define REWIND                0x01
  #define REZERO_UNIT           0x01
  #define REQUEST_SENSE         0x03
  #define FORMAT_UNIT           0x04
+#define FORMAT_MEDIUM         0x04
+#define FORMAT                0x04
  #define READ_BLOCK_LIMITS     0x05
  #define REASSIGN_BLOCKS       0x07
  #define INITIALIZE_ELEMENT_STATUS 0x07
  #define READ_6                0x08
+#define RECEIVE               0x08
  #define WRITE_6               0x0a
+#define SEND_6                0x0a
+#define PRINT                 0x0a
  #define SEEK_6                0x0b
+#define SET_CAPACITY          0x0b
+#define SLEW_AND_PRINT        0x0b
  #define READ_REVERSE          0x0f
  #define WRITE_FILEMARKS       0x10
+#define SYNCHRONIZE_BUFFER    0x10
  #define SPACE                 0x11
  #define INQUIRY               0x12
+#define VERIFY_6              0x13
  #define RECOVER_BUFFERED_DATA 0x14
  #define MODE_SELECT           0x15
  #define RESERVE               0x16
+#define RESERVE_ELEMENT_6     0x16
  #define RELEASE               0x17
+#define RELEASE_ELEMENT_6     0x17
  #define COPY                  0x18
  #define ERASE                 0x19
  #define MODE_SENSE            0x1a
  #define START_STOP            0x1b
+#define LOAD_UNLOAD           0x1b
+#define STOP_PRINT            0x1b
+#define OPEN_CLOSE_IMPORT_EXPORT_ELEMENT 0x1b
  #define RECEIVE_DIAGNOSTIC    0x1c
  #define SEND_DIAGNOSTIC       0x1d
  #define ALLOW_MEDIUM_REMOVAL  0x1e

+#define READ_FORMAT_CAPACITIES 0x23
  #define SET_WINDOW            0x24
+#define READ_CAPACITY_10      0x25
  #define READ_CAPACITY         0x25
+#define READ_CARD_CAPACITY    0x25
  #define READ_10               0x28
+#define READ_GENERATION       0x29
  #define WRITE_10              0x2a
  #define SEEK_10               0x2b
+#define LOCATE_10             0x2b
  #define POSITION_TO_ELEMENT   0x2b
+#define ERASE_10              0x2c
+#define READ_UPDATED_BLOCK    0x2d
  #define WRITE_VERIFY          0x2e
  #define VERIFY                0x2f
  #define SEARCH_HIGH           0x30
@@ -77,6 +99,7 @@
  #define SYNCHRONIZE_CACHE     0x35
  #define LOCK_UNLOCK_CACHE     0x36
  #define READ_DEFECT_DATA      0x37
+#define INITIALIZE_ELEMENT_STATUS_WITH_RANGE 0x37
  #define MEDIUM_SCAN           0x38
  #define COMPARE               0x39
  #define COPY_VERIFY           0x3a
@@ -87,32 +110,110 @@
  #define WRITE_LONG            0x3f
  #define CHANGE_DEFINITION     0x40
  #define WRITE_SAME            0x41
+#define READ_SUB_CHANNEL      0x42
  #define READ_TOC              0x43
+#define REPORT_DENSITY_SUPPORT 0x44
+#define PLAY_AUDIO_10         0x45
+#define GET_CONFIGURATION     0x46
+#define PLAY_AUDIO_MSF        0x47
+#define GET_EVENT_STATUS_NOTIFICATION 0x4a
+#define PAUSE_RESUME          0x4b
  #define LOG_SELECT            0x4c
  #define LOG_SENSE             0x4d
+#define STOP_PLAY_SCAN        0x4e
+#define XDWRITE_10            0x50
+#define XPWRITE_10            0x51
+#define READ_DISC_INFORMATION 0x51
+#define XDREAD_10             0x52
+#define READ_TRACK_INFORMATION 0x52
+#define RESERVE_TRACK         0x53
+#define SEND_OPC_INFORMATION  0x54
  #define MODE_SELECT_10        0x55
  #define RESERVE_10            0x56
+#define RESERVE_ELEMENT_10    0x56
  #define RELEASE_10            0x57
+#define RELEASE_ELEMENT_10    0x57
+#define REPAIR_TRACK          0x58
  #define MODE_SENSE_10         0x5a
+#define CLOSE_TRACK_SESSION   0x5b
+#define READ_BUFFER_CAPACITY  0x5c
+#define SEND_CUE_SHEET        0x5d
  #define PERSISTENT_RESERVE_IN 0x5e
  #define PERSISTENT_RESERVE_OUT 0x5f
+#define XDWRITE_EXTENDED_16   0x80
+#define WRITE_FILEMARKS_16    0x80
+#define REBUILD_16            0x81
+#define READ_REVERSE_16       0x81
+#define REGENERATE_16         0x82
+#define EXTENDED_COPY         0x83
+#define RECEIVE_COPY_RESULTS  0x84
+#define ACCESS_CONTROL_IN     0x86
+#define ACCESS_CONTROL_OUT    0x87
+#define READ_16               0x88
+#define WRITE_16              0x8a
+#define ORWRITE               0x8b
+#define READ_ATTRIBUTE        0x8c
+#define WRITE_ATTRIBUTE       0x8d
+#define WRITE_AND_VERIFY_16   0x8e
+#define VERIFY_16             0x8f
+#define PRE_FETCH_16          0x90
+#define SYNCHRONIZE_CACHE_16  0x91
+#define SPACE_16              0x91
+#define LOCK_UNLOCK_CACHE_16  0x92
+#define LOCATE_16             0x92
+#define WRITE_SAME_16         0x93
+#define ERASE_16              0x93
+#define SERVICE_ACTION_IN     0x9e
+#define SERVICE_ACTION_OUT    0x9f
  #define REPORT_LUNS           0xa0
+#define BLANK                 0xa1
+#define SECURITY_PROTOCOL_IN  0xa2
  #define MAINTENANCE_IN        0xa3
+#define SEND_KEY              0xa3
+#define MAINTENANCE_OUT       0xa4
+#define REPORT_KEY            0xa4
  #define MOVE_MEDIUM           0xa5
+#define PLAY_AUDIO_12         0xa5
  #define EXCHANGE_MEDIUM       0xa6
+#define LOAD_UNLOAD_CD_DVD    0xa6
+#define MOVE_MEDIUM_ATTACHED  0xa7
+#define SET_READ_AHEAD        0xa7
  #define READ_12               0xa8
+#define SERVICE_ACTION_OUT_12 0xa9
  #define WRITE_12              0xaa
+#define SERVICE_ACTION_IN_12  0xab
+#define ERASE_12              0xac
+#define GET_PERFORMANCE       0xac
+#define READ_DVD_STRUCTURE    0xad
  #define WRITE_VERIFY_12       0xae
+#define VERIFY_12             0xaf
  #define SEARCH_HIGH_12        0xb0
  #define SEARCH_EQUAL_12       0xb1
  #define SEARCH_LOW_12         0xb2
+#define SET_LIMITS_12         0xb3
+#define READ_ELEMENT_STATUS_ATTACHED 0xb4
+#define SECURITY_PROTOCOL_OUT 0xb5
+#define REQUEST_VOLUME_ELEMENT_ADDRESS 0xb5
  #define SEND_VOLUME_TAG       0xb6
+#define SET_STREAMING         0xb6
+#define READ_DEFECT_DATA_12   0xb7
  #define READ_ELEMENT_STATUS   0xb8
+#define READ_CD_MSF           0xb9
+#define REDUNDANCY_GROUP_IN   0xba
+#define SCAN                  0xba
+#define REDUNDANCY_GROUP_OUT  0xbb
+#define SET_CD_SPEED          0xbb
+#define SPARE_IN              0xbc
+#define SPARE_OUT             0xbd
+#define MECHANISM_STATUS      0xbd
+#define VOLUME_SET_IN         0xbe
+#define READ_CD               0xbe
+#define VOLUME_SET_OUT        0xbf
+#define SEND_DVD_STRUCTURE    0xbf
+
+/* Vendor specific opcodes */
  #define WRITE_LONG_2          0xea
-#define READ_16               0x88
-#define WRITE_16              0x8a
-#define VERIFY_16	      0x8f
-#define SERVICE_ACTION_IN     0x9e
+
  /* values for service action in */
  #define	SAI_READ_CAPACITY_16  0x10
  /* values for maintenance in */

