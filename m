From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: [PATCH] aacraid: prevent copy_from_user() BUG!
Date: Wed, 28 May 2008 15:32:55 -0400
Message-ID: <DF06F352-4C27-47D3-983A-FB2414C8D88E@adaptec.com>
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com> <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com> <86802c440804211742g1fe25aadjeaffce49722e7c46@mail.gmail.com> <BCC76E6D-9A0F-4DC1-822A-50EE44A52890@adaptec.com> <1E278B55-6C77-42FA-8B15-16A0939203FB@adaptec.com> <1FB85EE8-0F95-4CF8-AD36-9E0E6542BB59@adaptec.com> <7D06DAD1-983B-457F-8A9B-76C4FA95D57B@adaptec.com> <D25ECCDE-1A2B-4E11-BEF9-CAC0A9ABA0FE@adaptec.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-106--379742220
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:53360 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbYE1TdP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2008 15:33:15 -0400
In-Reply-To: <D25ECCDE-1A2B-4E11-BEF9-CAC0A9ABA0FE@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-Scsi <linux-scsi@vger.kernel.org>


--Apple-Mail-106--379742220
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Seen:

	kernel BUG at arch/i386/lib/usercopy.c:872

under a 2.6.18-8.el5 kernel. Traced it to a garbage-in/garbage-out  
ioctl condition in the aacraid driver.

Adaptec's special ioctl scb passthrough needs to check the validity of  
the individual scatter gather count fields to the maximum the adapter  
supports. Doing so will have the side effect of preventing  
copy_from_user() from bugging out while populating the dma buffers.  
This is a hardening effort, issue was triggered by an errant version  
of the management tools and thus the BUG should not be seen in the  
field.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's  
handling of patch attachments (inline gets damaged, please use  
attachment).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

  drivers/scsi/aacraid/commctrl.c |   32 ++++++++++++++++++++++++++++++ 
++
  1 file changed, 32 insertions(+)

diff -ru a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/ 
commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c	2008-05-28 15:13:39.505105412  
-0400
+++ b/drivers/scsi/aacraid/commctrl.c	2008-05-28 15:16:53.619280840  
-0400
@@ -581,6 +581,14 @@
  			for (i = 0; i < upsg->count; i++) {
  				u64 addr;
  				void* p;
+				if (upsg->sg[i].count >
+				    (dev->adapter_info.options &
+				     AAC_OPT_NEW_COMM) ?
+				      (dev->scsi_host_ptr->max_sectors << 9) :
+				      65536) {
+					rcode = -EINVAL;
+					goto cleanup;
+				}
  				/* Does this really need to be GFP_DMA? */
  				p = kmalloc(upsg->sg[i].count,GFP_KERNEL|__GFP_DMA);
  				if(!p) {
@@ -625,6 +633,14 @@
  			for (i = 0; i < usg->count; i++) {
  				u64 addr;
  				void* p;
+				if (usg->sg[i].count >
+				    (dev->adapter_info.options &
+				     AAC_OPT_NEW_COMM) ?
+				      (dev->scsi_host_ptr->max_sectors << 9) :
+				      65536) {
+					rcode = -EINVAL;
+					goto cleanup;
+				}
  				/* Does this really need to be GFP_DMA? */
  				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
  				if(!p) {
@@ -667,6 +683,14 @@
  			for (i = 0; i < upsg->count; i++) {
  				uintptr_t addr;
  				void* p;
+				if (usg->sg[i].count >
+				    (dev->adapter_info.options &
+				     AAC_OPT_NEW_COMM) ?
+				      (dev->scsi_host_ptr->max_sectors << 9) :
+				      65536) {
+					rcode = -EINVAL;
+					goto cleanup;
+				}
  				/* Does this really need to be GFP_DMA? */
  				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
  				if(!p) {
@@ -698,6 +722,14 @@
  			for (i = 0; i < upsg->count; i++) {
  				dma_addr_t addr;
  				void* p;
+				if (upsg->sg[i].count >
+				    (dev->adapter_info.options &
+				     AAC_OPT_NEW_COMM) ?
+				      (dev->scsi_host_ptr->max_sectors << 9) :
+				      65536) {
+					rcode = -EINVAL;
+					goto cleanup;
+				}
  				p = kmalloc(upsg->sg[i].count, GFP_KERNEL);
  				if (!p) {
  					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer -  
size = %d buffer number %d of %d\n",

Sincerely - Mark Salyzyn

--Apple-Mail-106--379742220
Content-Disposition: attachment;
	filename=aacraid_copy_from_user_BUG.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="aacraid_copy_from_user_BUG.patch"
Content-Transfer-Encoding: 7bit

diff -ru a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c	2008-05-28 15:13:39.505105412 -0400
+++ b/drivers/scsi/aacraid/commctrl.c	2008-05-28 15:16:53.619280840 -0400
@@ -581,6 +581,14 @@
 			for (i = 0; i < upsg->count; i++) {
 				u64 addr;
 				void* p;
+				if (upsg->sg[i].count >
+				    (dev->adapter_info.options &
+				     AAC_OPT_NEW_COMM) ?
+				      (dev->scsi_host_ptr->max_sectors << 9) :
+				      65536) {
+					rcode = -EINVAL;
+					goto cleanup;
+				}
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(upsg->sg[i].count,GFP_KERNEL|__GFP_DMA);
 				if(!p) {
@@ -625,6 +633,14 @@
 			for (i = 0; i < usg->count; i++) {
 				u64 addr;
 				void* p;
+				if (usg->sg[i].count >
+				    (dev->adapter_info.options &
+				     AAC_OPT_NEW_COMM) ?
+				      (dev->scsi_host_ptr->max_sectors << 9) :
+				      65536) {
+					rcode = -EINVAL;
+					goto cleanup;
+				}
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
 				if(!p) {
@@ -667,6 +683,14 @@
 			for (i = 0; i < upsg->count; i++) {
 				uintptr_t addr;
 				void* p;
+				if (usg->sg[i].count >
+				    (dev->adapter_info.options &
+				     AAC_OPT_NEW_COMM) ?
+				      (dev->scsi_host_ptr->max_sectors << 9) :
+				      65536) {
+					rcode = -EINVAL;
+					goto cleanup;
+				}
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
 				if(!p) {
@@ -698,6 +722,14 @@
 			for (i = 0; i < upsg->count; i++) {
 				dma_addr_t addr;
 				void* p;
+				if (upsg->sg[i].count >
+				    (dev->adapter_info.options &
+				     AAC_OPT_NEW_COMM) ?
+				      (dev->scsi_host_ptr->max_sectors << 9) :
+				      65536) {
+					rcode = -EINVAL;
+					goto cleanup;
+				}
 				p = kmalloc(upsg->sg[i].count, GFP_KERNEL);
 				if (!p) {
 					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",

--Apple-Mail-106--379742220
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



--Apple-Mail-106--379742220--
