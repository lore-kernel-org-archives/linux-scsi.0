From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] qla1280: driver_setup not __initdata
Date: Tue, 19 Oct 2004 21:28:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4175E95A.9090107@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090009020406020908040207"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:39602 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S268092AbUJTEcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 00:32:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jes@trained-monkey.org

This is a multi-part message in MIME format.
--------------090009020406020908040207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


-- 
~Randy

--------------090009020406020908040207
Content-Type: text/x-patch;
 name="qla1280_init.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="qla1280_init.patch"


'driver_setup' cannot be __initdata if slave_configure() can be called
after driver-init:
Error: ./drivers/scsi/qla1280.o .text refers to 0000000000000fbf R_X86_64_PC32     .init.data+0x000000000000007b
Error: ./drivers/scsi/qla1280.o .text refers to 0000000000000fc9 R_X86_64_PC32     .init.data+0x000000000000007e
Error: ./drivers/scsi/qla1280.o .text refers to 0000000000000fea R_X86_64_PC32     .init.data+0x000000000000007b
Error: ./drivers/scsi/qla1280.o .text refers to 0000000000000ff4 R_X86_64_PC32     .init.data+0x0000000000000080
Error: ./drivers/scsi/qla1280.o .text refers to 0000000000001039 R_X86_64_PC32     .init.data+0x000000000000007b
Error: ./drivers/scsi/qla1280.o .text refers to 0000000000001043 R_X86_64_PC32     .init.data+0x0000000000000082

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>

diffstat:=
 drivers/scsi/qla1280.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -Naurp ./drivers/scsi/qla1280.c~qla1280_init ./drivers/scsi/qla1280.c
--- ./drivers/scsi/qla1280.c~qla1280_init	2004-10-18 14:55:35.000000000 -0700
+++ ./drivers/scsi/qla1280.c	2004-10-19 21:01:59.414022600 -0700
@@ -549,7 +549,7 @@ static void qla1280_get_target_parameter
 static int qla1280_set_target_parameters(struct scsi_qla_host *, int, int);
 
 
-static struct qla_driver_setup driver_setup __initdata;
+static struct qla_driver_setup driver_setup;
 
 /*
  * convert scsi data direction to request_t control flags

--------------090009020406020908040207--
