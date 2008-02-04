From: "Nicholas A. Bellinger" <nab@kernel.org>
Subject: 2.6.24 kernel and LIO Target memory mapping
Date: Mon, 04 Feb 2008 05:27:20 -0800
Message-ID: <1202131640.11265.494.camel@haakon2.linux-iscsi.org>
References: <e2e108260802010609m12af3990k58a385b8f8598ec7@mail.gmail.com>
	 <1201877400.11265.311.camel@haakon2.linux-iscsi.org>
	 <1201958796.11265.415.camel@haakon2.linux-iscsi.org>
Reply-To: nab@kernel.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.re2.yahoo.com ([68.142.229.98]:37574 "HELO
	smtp107.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751637AbYBDNh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 08:37:56 -0500
In-Reply-To: <1201958796.11265.415.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, CBE-OSS-DEV <cbe-oss-dev@ozlabs.org>, Geoff Levand <geoffrey.le>
Cc: Bart Van Assche <bart.vanassche@gmail.com>

On Sat, 2008-02-02 at 05:26 -0800, Nicholas A. Bellinger wrote: 
> Hi Bart,
> 
> Ok, I have 2.6.24 running on ppc64 doing iSCSI/HD on PS3-Linux.  The
> changes for struct scatterlist->page moving to struct
> scatterlist->page_link where pretty straightforward, considering the LIO
> storage engine does not depend on struct scatterlist.  I am going to
> take another look at the diffs later today and make sure everything
> looks corerct, and will make the commits then.
> 
> If you could test these on your setup with 2.6.24 in the non IPoIB case
> (that from my previous emails I am guessing will be fine on your setup)
> I would really appreciate it.  I will put 2.6.24 in VM on the
> Linux-iSCSI.org fabric in the upcoming days, and do some additional
> testing.  Getting the CentOS v5u1 x86_64 builds release are a bit higher
> priority than 2.6.24, but I think that the 2.6.24 changes are reasonable
> and do not cause concern with the LIO v2.9 codebase.
> 
> Have you made any futher progress on debugging the issue LIO Target with
> IPoIB..?
> 
> Many thanks for your most valuable of time,
> 
> --nab
> 
> On Fri, 2008-02-01 at 06:50 -0800, Nicholas A. Bellinger wrote:
> > Hi There,
> > 
> > I will doing a 2.6.24 build for LIO on PS3-Linux this weekend now that
> > ps3rom.c is reporting the proper struct scsi_host_template->max_sectors.
> > Also in the queue are releasing updated builds for CentOS v5.1 x86_64.
> > I have recently upgraded one pair of core nodes on the Linux-iSCSI.org
> > fabric to the newest CentOS release, and minus a few minor issues with
> > the upgrade process, everything is looking very stable.  The few issues
> > that I had (an lvremove issue on v4.5, and qemu-dm performance with HVM
> > on v5.0) have been resolved and the fabric is running much smoother for
> > the VMs that are providing OCFS2 cluster storage to the LIO debian and
> > ubuntu repositories.  
> > 
> > I will let you know when I get 2.6.24 building.  Until then, feel free
> > to post the build failure log here.
> > 
> > Many thanks for your most valuable of time,
> > 
> > --nab
> > 
> > On Fri, 2008-02-01 at 15:09 +0100, Bart Van Assche wrote:
> > > Hello,
> > > 
> > > The Linux-iSCSI target (kernel module) does not compile on the 2.6.24
> > > kernel because of changes in the scatterlist API. Has a target date
> > > for a version that compiles with the 2.6.24 kernel headers already
> > > been set ?
> > > 
> > > Bart Van Assche.
> > > 
> 

Here are the changes to transport_memcpy_[write,read]_[contig,sg]()
respectively.  This functions are legacy within v2.9 LIO SE, and are
currently unused in kernel mode because the SE core does not rely on
struct scatterlist.

Index: target/iscsi_target_transport.c
===================================================================
--- target/iscsi_target_transport.c	(revision 205)
+++ target/iscsi_target_transport.c	(revision 206)
@@ -4181,7 +4181,7 @@
 		if (length > total_length)
 			length = total_length;
 
-		src = GET_ADDR_SG(sg_s, i);
+		src = GET_ADDR_SG(&sg_s[i]);
 
 		memcpy(dst, src, length);
 
@@ -4211,12 +4211,12 @@
 			if (length > total_length)
 				length = total_length;
 
-			dst = GET_ADDR_SG(sg_d, i) + dst_offset;
+			dst = GET_ADDR_SG(&sg_d[i]) + dst_offset;
 			if (!dst)
 				BUG();
 			i++;
 			
-			src = GET_ADDR_SG(sg_s, j) + src_offset;
+			src = GET_ADDR_SG(&sg_s[j]) + src_offset;
 			if (!src)
 				BUG();
 
@@ -4228,7 +4228,7 @@
 			if (length > total_length)
 				length = total_length;
 
-			dst = GET_ADDR_SG(sg_d, i) + dst_offset;
+			dst = GET_ADDR_SG(&sg_d[i]) + dst_offset;
 			if (!dst)
 				BUG();
 
@@ -4238,7 +4238,7 @@
 			} else
 				dst_offset = length;
 
-			src = GET_ADDR_SG(sg_s, j) + src_offset;
+			src = GET_ADDR_SG(&sg_s[j]) + src_offset;
 			if (!src)
 				BUG();
 			j++;
@@ -4269,7 +4269,7 @@
 		if (length > total_length)
 			length = total_length;
 
-		dst = GET_ADDR_SG(sg_d, i);
+		dst = GET_ADDR_SG(&sg_d[i]);
 
 		memcpy(dst, src, length);


These changes are followed up by transport_map_sg_to_mem()
and transport_map_mem_to_sg()..  The latter is the default path for
LIO SE v2.9 to v2.6 Linux storage subsystems along with the other completely
virtual subsystem drivers.  Note the former does reverse contigious
scatterlist array mapping to SE linked list memory which is then handed to
the SCSI transport, in the LIO case, traditional iSCSI.  This is currently
unused, but may be useful in some future cases.
 
@@ -4299,12 +4299,12 @@
 			if (length > total_length)
 				length = total_length;
 
-			src = GET_ADDR_SG(sg_s, i) + src_offset;
+			src = GET_ADDR_SG(&sg_s[i]) + src_offset;
 			if (!src)
 				BUG();
 			i++;
 
-			dst = GET_ADDR_SG(sg_d, j) + dst_offset;
+			dst = GET_ADDR_SG(&sg_d[j]) + dst_offset;
 			if (!dst)
 				BUG();
 
@@ -4316,7 +4316,7 @@
 			if (length > total_length)
 				length = total_length;
 
-			src = GET_ADDR_SG(sg_s, i) + src_offset;
+			src = GET_ADDR_SG(&sg_s[i]) + src_offset;
 			if (!src)
 				BUG();
 
@@ -4326,7 +4326,7 @@
 			} else
 				src_offset = length;
 
-			dst = GET_ADDR_SG(sg_d, j) + dst_offset;
+			dst = GET_ADDR_SG(&sg_d[j]) + dst_offset;
 			if (!dst)
 				BUG();
 			j++;
@@ -5191,7 +5191,7 @@
 		INIT_LIST_HEAD(&se_mem->se_list);
 
 		if (*task_offset == 0) {
-			se_mem->se_page = sg_s[j].page;
+			se_mem->se_page = GET_PAGE_SG(&sg_s[j]);
 			se_mem->se_off = sg_s[j].offset;
 
 			if (task_size >= sg_s[j].length)
@@ -5208,7 +5208,7 @@
 			if (saved_task_offset)
 				*task_offset = saved_task_offset;
 		} else {
-			se_mem->se_page = sg_s[j].page;
+			se_mem->se_page = GET_PAGE_SG(&sg_s[j]);
 			se_mem->se_off = (*task_offset + sg_s[j].offset);
 
 			if ((sg_s[j].length - *task_offset) > task_size) {
@@ -5348,7 +5348,7 @@
 
 	while (task_size) {
 		if (*task_offset == 0) {
-			sg[sg_no].page = se_mem->se_page;
+			SET_PAGE_SG(&sg[sg_no], se_mem->se_page);
 			sg[sg_no].offset = se_mem->se_off;
 
 			if (task_size >= se_mem->se_len) {
@@ -5375,7 +5375,7 @@
 			if (saved_task_offset)
 				*task_offset = saved_task_offset;
 		} else {
-			sg[sg_no].page = se_mem->se_page;
+			SET_PAGE_SG(&sg[sg_no], se_mem->se_page);
 			sg[sg_no].offset = (*task_offset + se_mem->se_off);
 
 			if ((se_mem->se_len - *task_offset) > task_size) {


The SE algoritims can also potentially accept preallocated memory for
RDMA operations and then map said memory to contiguous struct
scatterlist buffers that are then mapped to the SCSI, BIO, and
[read,write]v() for struct file.

Here are the macro changes for new and legacy operation:

Index: include/iscsi_linux_defs.h
===================================================================
--- include/iscsi_linux_defs.h (revision 207)
+++ include/iscsi_linux_defs.h (revision 208)
@@ -44,15 +44,29 @@
#define inline
#endif

-/* added to address 64bit addressing issues. */
+/*
+ * 2.6.24 provides an updated struct scatterlist API.  Use macros for
the new
+ * code, and use inline functions for legacy operation. 
+ */
#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)
# define GET_ADDR_SG(sg) sg_virt(sg)
# define GET_PAGE_SG(sg) sg_page(sg)
# define SET_PAGE_SG(sg, page) sg_assign_page(sg, page)
#else
-# define GET_ADDR_SG(sg) page_address(sg->page) + sg->offset
-# define GET_PAGE_SG(sg) sg->page
-# define SET_PAGE_SG(sg, page) sg->page = page
+#include <linux/scatterlist.h>
+static inline void *GET_ADDR_SG(struct scatterlist *sg)
+{
+ return(page_address(sg->page) + sg->offset);
+}
+static inline struct page *GET_PAGE_SG(struct scatterlist *sg)
+{
+ return(sg->page);
+}
+static inline void SET_PAGE_SG(struct scatterlist *sg, struct page
*page)
+{
+ sg->page = page;
+ return;
+}
#endif

/*

--nab

> 
> --~--~---------~--~----~------------~-------~--~----~
> You received this message because you are subscribed to the Google Groups "Linux-iSCSI.org Target Development" group.
> To post to this group, send email to linux-iscsi-target-dev@googlegroups.com
> To unsubscribe from this group, send email to linux-iscsi-target-dev-unsubscribe@googlegroups.com
> For more options, visit this group at http://groups.google.com/group/linux-iscsi-target-dev?hl=en
> -~----------~----~----~----~------~----~------~--~---
> 

