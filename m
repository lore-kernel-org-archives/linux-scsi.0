From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [patch, 2.5] scsi_ips.c: remove in favour of
Date: Fri, 08 Nov 2002 19:10:43 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108081529.CF1022C448@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, ipslinux@adaptec.com


[ check_region is deprecated because it is racy: request_region's
  return value should be used instead.  Please examine and forward to
  Linus if OK. ]

From:  Marcus Alanen <maalanen@ra.abo.fi>


--- trivial-2.5-bk/drivers/scsi/ips.c.orig	2002-11-08 18:46:55.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/ips.c	2002-11-08 18:46:55.000000000 +1100
@@ -856,7 +856,7 @@
                       ips_name, ips_next_controller, mem_addr, mem_len);
 
 #if LINUX_VERSION_CODE >= LinuxVersionCode(2,4,0)
-            if (check_mem_region(mem_addr, mem_len)) {
+            if (!request_mem_region(mem_addr, mem_len, "ips")) {
                /* Couldn't allocate io space */
                printk(KERN_WARNING "(%s%d) couldn't allocate IO space %x len %d.\n",
                       ips_name, ips_next_controller, io_addr, io_len);
@@ -866,7 +866,6 @@
                continue;
             }
 
-            request_mem_region(mem_addr, mem_len, "ips");
 #endif
 
             base = mem_addr & PAGE_MASK;
@@ -884,7 +883,7 @@
             DEBUG_VAR(1, "(%s%d) detect, IO region %x, size: %d",
                       ips_name, ips_next_controller, io_addr, io_len);
 
-            if (check_region(io_addr, io_len)) {
+            if (!request_region(io_addr, io_len, "ips")) {
                /* Couldn't allocate io space */
                printk(KERN_WARNING "(%s%d) couldn't allocate IO space %x len %d.\n",
                       ips_name, ips_next_controller, io_addr, io_len);
@@ -894,7 +893,6 @@
                continue;
             }
 
-            request_region(io_addr, io_len, "ips");
          }
 
          /* get planer status */
@@ -7329,12 +7327,11 @@
        uint32_t base;
        uint32_t offs;
 
-       if (check_mem_region(mem_addr, mem_len)) {
+       if (!request_mem_region(mem_addr, mem_len, "ips")) {
           printk(KERN_WARNING "Couldn't allocate IO Memory space %x len %d.\n", mem_addr, mem_len);
           return -1;
           }
 
-       request_mem_region(mem_addr, mem_len, "ips");
        base = mem_addr & PAGE_MASK;
        offs = mem_addr - base;
        ioremap_ptr = ioremap(base, PAGE_SIZE);
@@ -7346,11 +7343,10 @@
 
     /* setup I/O mapped area (if applicable) */
     if (io_addr) {
-       if (check_region(io_addr, io_len)) {
+       if (!request_region(io_addr, io_len, "ips")) {
           printk(KERN_WARNING "Couldn't allocate IO space %x len %d.\n", io_addr, io_len);
           return -1;
        }
-       request_region(io_addr, io_len, "ips");
     }
 
     /* get the revision ID */
-- 
  Don't blame me: the Monkey is driving
  File: Marcus Alanen <maalanen@ra.abo.fi>: [patch, 2.5] scsi_ips.c: remove check_*_region in favour of
