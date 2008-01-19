From: Matthew Wilcox <matthew@wil.cx>
Subject: sym53c8xx ISTAT1 feature never set
Date: Sat, 19 Jan 2008 10:41:44 -0700
Message-ID: <20080119174144.GB25398@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36112 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbYASRlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Jan 2008 12:41:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I got an interesting mail from Mike Anderson yesterday detailing how he
managed to provoke an error recovery path that didn't work so well.

In sym_soft_reset(), we check to see if the chip has an ISTAT1
register, and if it does, and the scripts are running, we take
additional action to abort the running script before doing a full reset.
The comments for this function discuss a possible hang that can occur if
we don't do this.

The only problem is ... we never set the FE_ISTAT1 bit.  Mike tells me
that when he sets it, it makes his error recovery work.

I think we need a patch somewhat along these lines:

diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_
index 463f119..37575c1 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1226,61 +1226,61 @@ static struct sym_chip sym_dev_table[] = {
  ,
  {PCI_DEVICE_ID_NCR_53C875, 0x01, "875", 6, 16, 5, 2,
  FE_WIDE|FE_ULTRA|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
- FE_RAM|FE_DIFF|FE_VARCLK}
+ FE_RAM|FE_DIFF|FE_VARCLK|FE_ISTAT1}
  ,
  {PCI_DEVICE_ID_NCR_53C875, 0xff, "875", 6, 16, 5, 2,
  FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
- FE_RAM|FE_DIFF|FE_VARCLK}
+ FE_RAM|FE_DIFF|FE_VARCLK|FE_ISTAT1}
  ,
  {PCI_DEVICE_ID_NCR_53C875J, 0xff, "875J", 6, 16, 5, 2,
  FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
- FE_RAM|FE_DIFF|FE_VARCLK}
+ FE_RAM|FE_DIFF|FE_VARCLK|FE_ISTAT1}
  ,
  {PCI_DEVICE_ID_NCR_53C885, 0xff, "885", 6, 16, 5, 2,
  FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
- FE_RAM|FE_DIFF|FE_VARCLK}
+ FE_RAM|FE_DIFF|FE_VARCLK|FE_ISTAT1}
  ,
 #ifdef SYM_DEBUG_GENERIC_SUPPORT
  {PCI_DEVICE_ID_NCR_53C895, 0xff, "895", 6, 31, 7, 2,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|
- FE_RAM|FE_LCKFRQ}
+ FE_RAM|FE_LCKFRQ|FE_ISTAT1}
  ,
 #else
  {PCI_DEVICE_ID_NCR_53C895, 0xff, "895", 6, 31, 7, 2,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
- FE_RAM|FE_LCKFRQ}
+ FE_RAM|FE_LCKFRQ|FE_ISTAT1}
  ,
 #endif
  {PCI_DEVICE_ID_NCR_53C896, 0xff, "896", 6, 31, 7, 4,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
- FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_LCKFRQ}
+ FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_LCKFRQ|FE_ISTAT1}
  ,
  {PCI_DEVICE_ID_LSI_53C895A, 0xff, "895a", 6, 31, 7, 4,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
- FE_RAM|FE_RAM8K|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_LCKFRQ}
+ FE_RAM|FE_RAM8K|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_LCKFRQ|FE_ISTAT1}
  ,
  {PCI_DEVICE_ID_LSI_53C875A, 0xff, "875a", 6, 31, 7, 4,
  FE_WIDE|FE_ULTRA|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
- FE_RAM|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_LCKFRQ}
+ FE_RAM|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_LCKFRQ|FE_ISTAT1}
  ,
  {PCI_DEVICE_ID_LSI_53C1010_33, 0x00, "1010-33", 6, 31, 7, 8,
  FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_CRC|
- FE_C10}
+ FE_C10|FE_ISTAT1}
  ,
  {PCI_DEVICE_ID_LSI_53C1010_33, 0xff, "1010-33", 6, 31, 7, 8,
  FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_CRC|
- FE_C10|FE_U3EN}
+ FE_C10|FE_U3EN|FE_ISTAT1}
  ,
  {PCI_DEVICE_ID_LSI_53C1010_66, 0xff, "1010-66", 6, 31, 7, 8,
  FE_WIDE|FE_ULTRA3|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFBC|FE_LDSTR|FE_PFEN|
  FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_66MHZ|FE_CRC|
- FE_C10|FE_U3EN}
+ FE_C10|FE_U3EN|FE_ISTAT1}
  ,
  {PCI_DEVICE_ID_LSI_53C1510, 0xff, "1510d", 6, 31, 7, 4,
  FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|
- FE_RAM|FE_IO256|FE_LEDC}
+ FE_RAM|FE_IO256|FE_LEDC|FE_ISTAT1}
 };
 
 #define sym_num_devs (ARRAY_SIZE(sym_dev_table))

But I'd welcome advice from anyone who knows these chips better than I do
(ie Kai, James, etc).

Note that the only place we currently _check_ FE_ISTAT1 is in the
sym_soft_reset().  We do use nc_istat1 in a couple of other places,
but those places are guarded by FE_C10 (ie 53c1010 chips) which are a
superset of chips which implement ISTAT1.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
