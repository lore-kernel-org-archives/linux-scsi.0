Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9471C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 21:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 325B920732
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 21:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503528AbgLNVYF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 16:24:05 -0500
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:56832 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727156AbgLNVX5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Dec 2020 16:23:57 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 1C222837F24C;
        Mon, 14 Dec 2020 21:23:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: salt69_10086c52741e
X-Filterd-Recvd-Size: 36863
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Mon, 14 Dec 2020 21:23:06 +0000 (UTC)
Message-ID: <f9017bc73dadfb84366734062d93722d8d7ecc59.camel@perches.com>
Subject: Re: [PATCH v3 1/6] scsi: ufs: Remove stringize operator '#'
 restriction
From:   Joe Perches <joe@perches.com>
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 14 Dec 2020 13:23:05 -0800
In-Reply-To: <20201214202014.13835-2-huobean@gmail.com>
References: <20201214202014.13835-1-huobean@gmail.com>
         <20201214202014.13835-2-huobean@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-14 at 21:20 +0100, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Current EM macro definition, we use stringize operator '#', which turns
> the argument it precedes into a quoted string. Thus requires the symbol
> of __print_symbolic() should be the string corresponding to the name of
> the enum.
> 
> However, we have other cases, the symbol and enum name are not the same,
> we can redefine EM/EMe, but there will introduce some redundant codes.
> This patch is to remove this restriction, let others reuse the current
> EM/EMe definition.

While this version doesn't have the copy/paste typo,
I fail to see value in defining EMe as a trailing comma
in an array declaration isn't meaningful and doesn't emit
any error or warning.

Maybe all the uses of EMe can be converted to EM and the
macro definitions removed.
---
 include/ras/ras_event.h            |  64 ++++++++---------
 include/trace/events/9p.h          | 142 ++++++++++++++++++-------------------
 include/trace/events/btrfs.h       |  66 ++++++++---------
 include/trace/events/huge_memory.h |  58 +++++++--------
 include/trace/events/migrate.h     |  26 +++----
 include/trace/events/mmflags.h     |  34 ++++-----
 include/trace/events/sock.h        |  56 +++++++--------
 include/trace/events/sunrpc.h      |  44 ++++++------
 include/trace/events/tlb.h         |  16 ++---
 include/trace/events/ufs.h         |  12 ++--
 include/trace/events/v4l2.h        |  54 +++++++-------
 include/trace/events/writeback.h   |  24 +++----
 12 files changed, 274 insertions(+), 322 deletions(-)

diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 0bdbc0d17d2f..32521a1066c7 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -348,56 +348,52 @@ TRACE_EVENT(aer_event,
 
 #ifdef CONFIG_MEMORY_FAILURE
 #define MF_ACTION_RESULT	\
-	EM ( MF_IGNORED, "Ignored" )	\
-	EM ( MF_FAILED,  "Failed" )	\
-	EM ( MF_DELAYED, "Delayed" )	\
-	EMe ( MF_RECOVERED, "Recovered" )
-
-#define MF_PAGE_TYPE		\
-	EM ( MF_MSG_KERNEL, "reserved kernel page" )			\
-	EM ( MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page" )	\
-	EM ( MF_MSG_SLAB, "kernel slab page" )				\
-	EM ( MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking" ) \
-	EM ( MF_MSG_POISONED_HUGE, "huge page already hardware poisoned" )	\
-	EM ( MF_MSG_HUGE, "huge page" )					\
-	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
-	EM ( MF_MSG_NON_PMD_HUGE, "non-pmd-sized huge page" )		\
-	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
-	EM ( MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page" )		\
-	EM ( MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page" )		\
-	EM ( MF_MSG_DIRTY_MLOCKED_LRU, "dirty mlocked LRU page" )	\
-	EM ( MF_MSG_CLEAN_MLOCKED_LRU, "clean mlocked LRU page" )	\
-	EM ( MF_MSG_DIRTY_UNEVICTABLE_LRU, "dirty unevictable LRU page" )	\
-	EM ( MF_MSG_CLEAN_UNEVICTABLE_LRU, "clean unevictable LRU page" )	\
-	EM ( MF_MSG_DIRTY_LRU, "dirty LRU page" )			\
-	EM ( MF_MSG_CLEAN_LRU, "clean LRU page" )			\
-	EM ( MF_MSG_TRUNCATED_LRU, "already truncated LRU page" )	\
-	EM ( MF_MSG_BUDDY, "free buddy page" )				\
-	EM ( MF_MSG_BUDDY_2ND, "free buddy page (2nd try)" )		\
-	EM ( MF_MSG_DAX, "dax page" )					\
-	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
-	EMe ( MF_MSG_UNKNOWN, "unknown page" )
+	EM(MF_IGNORED, "Ignored")	\
+	EM(MF_FAILED,  "Failed")	\
+	EM(MF_DELAYED, "Delayed")	\
+	EM(MF_RECOVERED, "Recovered")
+
+#define MF_PAGE_TYPE							\
+	EM(MF_MSG_KERNEL, "reserved kernel page")			\
+	EM(MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page")		\
+	EM(MF_MSG_SLAB, "kernel slab page")				\
+	EM(MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking") \
+	EM(MF_MSG_POISONED_HUGE, "huge page already hardware poisoned")	\
+	EM(MF_MSG_HUGE, "huge page")					\
+	EM(MF_MSG_FREE_HUGE, "free huge page")				\
+	EM(MF_MSG_NON_PMD_HUGE, "non-pmd-sized huge page")		\
+	EM(MF_MSG_UNMAP_FAILED, "unmapping failed page")		\
+	EM(MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page")		\
+	EM(MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page")		\
+	EM(MF_MSG_DIRTY_MLOCKED_LRU, "dirty mlocked LRU page")		\
+	EM(MF_MSG_CLEAN_MLOCKED_LRU, "clean mlocked LRU page")		\
+	EM(MF_MSG_DIRTY_UNEVICTABLE_LRU, "dirty unevictable LRU page")	\
+	EM(MF_MSG_CLEAN_UNEVICTABLE_LRU, "clean unevictable LRU page")	\
+	EM(MF_MSG_DIRTY_LRU, "dirty LRU page")				\
+	EM(MF_MSG_CLEAN_LRU, "clean LRU page")				\
+	EM(MF_MSG_TRUNCATED_LRU, "already truncated LRU page")		\
+	EM(MF_MSG_BUDDY, "free buddy page")				\
+	EM(MF_MSG_BUDDY_2ND, "free buddy page (2nd try)")		\
+	EM(MF_MSG_DAX, "dax page")					\
+	EM(MF_MSG_UNSPLIT_THP, "unsplit thp")				\
+	EM(MF_MSG_UNKNOWN, "unknown page")
 
 /*
  * First define the enums in MM_ACTION_RESULT to be exported to userspace
  * via TRACE_DEFINE_ENUM().
  */
 #undef EM
-#undef EMe
 #define EM(a, b) TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 MF_ACTION_RESULT
 MF_PAGE_TYPE
 
 /*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * Now redefine the EM() macro to map the enums to the strings
  * that will be printed in the output.
  */
 #undef EM
-#undef EMe
 #define EM(a, b)		{ a, b },
-#define EMe(a, b)	{ a, b }
 
 TRACE_EVENT(memory_failure_event,
 	TP_PROTO(unsigned long pfn,
diff --git a/include/trace/events/9p.h b/include/trace/events/9p.h
index 78c5608a1648..a7a965d95ad9 100644
--- a/include/trace/events/9p.h
+++ b/include/trace/events/9p.h
@@ -8,91 +8,87 @@
 #include <linux/tracepoint.h>
 
 #define P9_MSG_T							\
-		EM( P9_TLERROR,		"P9_TLERROR" )			\
-		EM( P9_RLERROR,		"P9_RLERROR" )			\
-		EM( P9_TSTATFS,		"P9_TSTATFS" )			\
-		EM( P9_RSTATFS,		"P9_RSTATFS" )			\
-		EM( P9_TLOPEN,		"P9_TLOPEN" )			\
-		EM( P9_RLOPEN,		"P9_RLOPEN" )			\
-		EM( P9_TLCREATE,	"P9_TLCREATE" )			\
-		EM( P9_RLCREATE,	"P9_RLCREATE" )			\
-		EM( P9_TSYMLINK,	"P9_TSYMLINK" )			\
-		EM( P9_RSYMLINK,	"P9_RSYMLINK" )			\
-		EM( P9_TMKNOD,		"P9_TMKNOD" )			\
-		EM( P9_RMKNOD,		"P9_RMKNOD" )			\
-		EM( P9_TRENAME,		"P9_TRENAME" )			\
-		EM( P9_RRENAME,		"P9_RRENAME" )			\
-		EM( P9_TREADLINK,	"P9_TREADLINK" )		\
-		EM( P9_RREADLINK,	"P9_RREADLINK" )		\
-		EM( P9_TGETATTR,	"P9_TGETATTR" )			\
-		EM( P9_RGETATTR,	"P9_RGETATTR" )			\
-		EM( P9_TSETATTR,	"P9_TSETATTR" )			\
-		EM( P9_RSETATTR,	"P9_RSETATTR" )			\
-		EM( P9_TXATTRWALK,	"P9_TXATTRWALK" )		\
-		EM( P9_RXATTRWALK,	"P9_RXATTRWALK" )		\
-		EM( P9_TXATTRCREATE,	"P9_TXATTRCREATE" )		\
-		EM( P9_RXATTRCREATE,	"P9_RXATTRCREATE" )		\
-		EM( P9_TREADDIR,	"P9_TREADDIR" )			\
-		EM( P9_RREADDIR,	"P9_RREADDIR" )			\
-		EM( P9_TFSYNC,		"P9_TFSYNC" )			\
-		EM( P9_RFSYNC,		"P9_RFSYNC" )			\
-		EM( P9_TLOCK,		"P9_TLOCK" )			\
-		EM( P9_RLOCK,		"P9_RLOCK" )			\
-		EM( P9_TGETLOCK,	"P9_TGETLOCK" )			\
-		EM( P9_RGETLOCK,	"P9_RGETLOCK" )			\
-		EM( P9_TLINK,		"P9_TLINK" )			\
-		EM( P9_RLINK,		"P9_RLINK" )			\
-		EM( P9_TMKDIR,		"P9_TMKDIR" )			\
-		EM( P9_RMKDIR,		"P9_RMKDIR" )			\
-		EM( P9_TRENAMEAT,	"P9_TRENAMEAT" )		\
-		EM( P9_RRENAMEAT,	"P9_RRENAMEAT" )		\
-		EM( P9_TUNLINKAT,	"P9_TUNLINKAT" )		\
-		EM( P9_RUNLINKAT,	"P9_RUNLINKAT" )		\
-		EM( P9_TVERSION,	"P9_TVERSION" )			\
-		EM( P9_RVERSION,	"P9_RVERSION" )			\
-		EM( P9_TAUTH,		"P9_TAUTH" )			\
-		EM( P9_RAUTH,		"P9_RAUTH" )			\
-		EM( P9_TATTACH,		"P9_TATTACH" )			\
-		EM( P9_RATTACH,		"P9_RATTACH" )			\
-		EM( P9_TERROR,		"P9_TERROR" )			\
-		EM( P9_RERROR,		"P9_RERROR" )			\
-		EM( P9_TFLUSH,		"P9_TFLUSH" )			\
-		EM( P9_RFLUSH,		"P9_RFLUSH" )			\
-		EM( P9_TWALK,		"P9_TWALK" )			\
-		EM( P9_RWALK,		"P9_RWALK" )			\
-		EM( P9_TOPEN,		"P9_TOPEN" )			\
-		EM( P9_ROPEN,		"P9_ROPEN" )			\
-		EM( P9_TCREATE,		"P9_TCREATE" )			\
-		EM( P9_RCREATE,		"P9_RCREATE" )			\
-		EM( P9_TREAD,		"P9_TREAD" )			\
-		EM( P9_RREAD,		"P9_RREAD" )			\
-		EM( P9_TWRITE,		"P9_TWRITE" )			\
-		EM( P9_RWRITE,		"P9_RWRITE" )			\
-		EM( P9_TCLUNK,		"P9_TCLUNK" )			\
-		EM( P9_RCLUNK,		"P9_RCLUNK" )			\
-		EM( P9_TREMOVE,		"P9_TREMOVE" )			\
-		EM( P9_RREMOVE,		"P9_RREMOVE" )			\
-		EM( P9_TSTAT,		"P9_TSTAT" )			\
-		EM( P9_RSTAT,		"P9_RSTAT" )			\
-		EM( P9_TWSTAT,		"P9_TWSTAT" )			\
-		EMe(P9_RWSTAT,		"P9_RWSTAT" )
+		EM(P9_TLERROR,		"P9_TLERROR")			\
+		EM(P9_RLERROR,		"P9_RLERROR")			\
+		EM(P9_TSTATFS,		"P9_TSTATFS")			\
+		EM(P9_RSTATFS,		"P9_RSTATFS")			\
+		EM(P9_TLOPEN,		"P9_TLOPEN")			\
+		EM(P9_RLOPEN,		"P9_RLOPEN")			\
+		EM(P9_TLCREATE,		"P9_TLCREATE")			\
+		EM(P9_RLCREATE,		"P9_RLCREATE")			\
+		EM(P9_TSYMLINK,		"P9_TSYMLINK")			\
+		EM(P9_RSYMLINK,		"P9_RSYMLINK")			\
+		EM(P9_TMKNOD,		"P9_TMKNOD")			\
+		EM(P9_RMKNOD,		"P9_RMKNOD")			\
+		EM(P9_TRENAME,		"P9_TRENAME")			\
+		EM(P9_RRENAME,		"P9_RRENAME")			\
+		EM(P9_TREADLINK,	"P9_TREADLINK")			\
+		EM(P9_RREADLINK,	"P9_RREADLINK")			\
+		EM(P9_TGETATTR,		"P9_TGETATTR")			\
+		EM(P9_RGETATTR,		"P9_RGETATTR")			\
+		EM(P9_TSETATTR,		"P9_TSETATTR")			\
+		EM(P9_RSETATTR,		"P9_RSETATTR")			\
+		EM(P9_TXATTRWALK,	"P9_TXATTRWALK")		\
+		EM(P9_RXATTRWALK,	"P9_RXATTRWALK")		\
+		EM(P9_TXATTRCREATE,	"P9_TXATTRCREATE")		\
+		EM(P9_RXATTRCREATE,	"P9_RXATTRCREATE")		\
+		EM(P9_TREADDIR,		"P9_TREADDIR")			\
+		EM(P9_RREADDIR,		"P9_RREADDIR")			\
+		EM(P9_TFSYNC,		"P9_TFSYNC")			\
+		EM(P9_RFSYNC,		"P9_RFSYNC")			\
+		EM(P9_TLOCK,		"P9_TLOCK")			\
+		EM(P9_RLOCK,		"P9_RLOCK")			\
+		EM(P9_TGETLOCK,		"P9_TGETLOCK")			\
+		EM(P9_RGETLOCK,		"P9_RGETLOCK")			\
+		EM(P9_TLINK,		"P9_TLINK")			\
+		EM(P9_RLINK,		"P9_RLINK")			\
+		EM(P9_TMKDIR,		"P9_TMKDIR")			\
+		EM(P9_RMKDIR,		"P9_RMKDIR")			\
+		EM(P9_TRENAMEAT,	"P9_TRENAMEAT")			\
+		EM(P9_RRENAMEAT,	"P9_RRENAMEAT")			\
+		EM(P9_TUNLINKAT,	"P9_TUNLINKAT")			\
+		EM(P9_RUNLINKAT,	"P9_RUNLINKAT")			\
+		EM(P9_TVERSION,		"P9_TVERSION")			\
+		EM(P9_RVERSION,		"P9_RVERSION")			\
+		EM(P9_TAUTH,		"P9_TAUTH")			\
+		EM(P9_RAUTH,		"P9_RAUTH")			\
+		EM(P9_TATTACH,		"P9_TATTACH")			\
+		EM(P9_RATTACH,		"P9_RATTACH")			\
+		EM(P9_TERROR,		"P9_TERROR")			\
+		EM(P9_RERROR,		"P9_RERROR")			\
+		EM(P9_TFLUSH,		"P9_TFLUSH")			\
+		EM(P9_RFLUSH,		"P9_RFLUSH")			\
+		EM(P9_TWALK,		"P9_TWALK")			\
+		EM(P9_RWALK,		"P9_RWALK")			\
+		EM(P9_TOPEN,		"P9_TOPEN")			\
+		EM(P9_ROPEN,		"P9_ROPEN")			\
+		EM(P9_TCREATE,		"P9_TCREATE")			\
+		EM(P9_RCREATE,		"P9_RCREATE")			\
+		EM(P9_TREAD,		"P9_TREAD")			\
+		EM(P9_RREAD,		"P9_RREAD")			\
+		EM(P9_TWRITE,		"P9_TWRITE")			\
+		EM(P9_RWRITE,		"P9_RWRITE")			\
+		EM(P9_TCLUNK,		"P9_TCLUNK")			\
+		EM(P9_RCLUNK,		"P9_RCLUNK")			\
+		EM(P9_TREMOVE,		"P9_TREMOVE")			\
+		EM(P9_RREMOVE,		"P9_RREMOVE")			\
+		EM(P9_TSTAT,		"P9_TSTAT")			\
+		EM(P9_RSTAT,		"P9_RSTAT")			\
+		EM(P9_TWSTAT,		"P9_TWSTAT")			\
+		EM(P9_RWSTAT,		"P9_RWSTAT")
 
 /* Define EM() to export the enums to userspace via TRACE_DEFINE_ENUM() */
 #undef EM
-#undef EMe
 #define EM(a, b)	TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 P9_MSG_T
 
 /*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * Now redefine the EM() macro to map the enums to the strings
  * that will be printed in the output.
  */
 #undef EM
-#undef EMe
 #define EM(a, b)	{ a, b },
-#define EMe(a, b)	{ a, b }
 
 #define show_9p_op(type)						\
 	__print_symbolic(type, P9_MSG_T)
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 74b466dc20ac..7fcdd8a3f22e 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -61,46 +61,46 @@ struct btrfs_space_info;
 	       obj <= BTRFS_QUOTA_TREE_OBJECTID)) ? __show_root_type(obj) : "-"
 
 #define FLUSH_ACTIONS								\
-	EM( BTRFS_RESERVE_NO_FLUSH,		"BTRFS_RESERVE_NO_FLUSH")	\
-	EM( BTRFS_RESERVE_FLUSH_LIMIT,		"BTRFS_RESERVE_FLUSH_LIMIT")	\
-	EM( BTRFS_RESERVE_FLUSH_ALL,		"BTRFS_RESERVE_FLUSH_ALL")	\
-	EMe(BTRFS_RESERVE_FLUSH_ALL_STEAL,	"BTRFS_RESERVE_FLUSH_ALL_STEAL")
+	EM(BTRFS_RESERVE_NO_FLUSH,		"BTRFS_RESERVE_NO_FLUSH")	\
+	EM(BTRFS_RESERVE_FLUSH_LIMIT,		"BTRFS_RESERVE_FLUSH_LIMIT")	\
+	EM(BTRFS_RESERVE_FLUSH_ALL,		"BTRFS_RESERVE_FLUSH_ALL")	\
+	EM(BTRFS_RESERVE_FLUSH_ALL_STEAL,	"BTRFS_RESERVE_FLUSH_ALL_STEAL")
 
 #define FI_TYPES							\
-	EM( BTRFS_FILE_EXTENT_INLINE,		"INLINE")		\
-	EM( BTRFS_FILE_EXTENT_REG,		"REG")			\
-	EMe(BTRFS_FILE_EXTENT_PREALLOC,		"PREALLOC")
+	EM(BTRFS_FILE_EXTENT_INLINE,		"INLINE")		\
+	EM(BTRFS_FILE_EXTENT_REG,		"REG")			\
+	EM(BTRFS_FILE_EXTENT_PREALLOC,		"PREALLOC")
 
 #define QGROUP_RSV_TYPES						\
-	EM( BTRFS_QGROUP_RSV_DATA,		"DATA")			\
-	EM( BTRFS_QGROUP_RSV_META_PERTRANS,	"META_PERTRANS")	\
-	EMe(BTRFS_QGROUP_RSV_META_PREALLOC,	"META_PREALLOC")
+	EM(BTRFS_QGROUP_RSV_DATA,		"DATA")			\
+	EM(BTRFS_QGROUP_RSV_META_PERTRANS,	"META_PERTRANS")	\
+	EM(BTRFS_QGROUP_RSV_META_PREALLOC,	"META_PREALLOC")
 
 #define IO_TREE_OWNER						    \
-	EM( IO_TREE_FS_PINNED_EXTENTS, 	  "PINNED_EXTENTS")	    \
-	EM( IO_TREE_FS_EXCLUDED_EXTENTS,  "EXCLUDED_EXTENTS")	    \
-	EM( IO_TREE_BTREE_INODE_IO,	  "BTREE_INODE_IO")	    \
-	EM( IO_TREE_INODE_IO,		  "INODE_IO")		    \
-	EM( IO_TREE_INODE_IO_FAILURE,	  "INODE_IO_FAILURE")	    \
-	EM( IO_TREE_RELOC_BLOCKS,	  "RELOC_BLOCKS")	    \
-	EM( IO_TREE_TRANS_DIRTY_PAGES,	  "TRANS_DIRTY_PAGES")      \
-	EM( IO_TREE_ROOT_DIRTY_LOG_PAGES, "ROOT_DIRTY_LOG_PAGES")   \
-	EM( IO_TREE_INODE_FILE_EXTENT,	  "INODE_FILE_EXTENT")      \
+	EM(IO_TREE_FS_PINNED_EXTENTS,	  "PINNED_EXTENTS")	    \
+	EM(IO_TREE_FS_EXCLUDED_EXTENTS,	  "EXCLUDED_EXTENTS")	    \
+	EM(IO_TREE_BTREE_INODE_IO,	  "BTREE_INODE_IO")	    \
+	EM(IO_TREE_INODE_IO,		  "INODE_IO")		    \
+	EM(IO_TREE_INODE_IO_FAILURE,	  "INODE_IO_FAILURE")	    \
+	EM(IO_TREE_RELOC_BLOCKS,	  "RELOC_BLOCKS")	    \
+	EM(IO_TREE_TRANS_DIRTY_PAGES,	  "TRANS_DIRTY_PAGES")      \
+	EM(IO_TREE_ROOT_DIRTY_LOG_PAGES,  "ROOT_DIRTY_LOG_PAGES")   \
+	EM(IO_TREE_INODE_FILE_EXTENT,	  "INODE_FILE_EXTENT")      \
 	EM( IO_TREE_LOG_CSUM_RANGE,	  "LOG_CSUM_RANGE")         \
-	EMe(IO_TREE_SELFTEST,		  "SELFTEST")
+	EM( IO_TREE_SELFTEST,		  "SELFTEST")
 
 #define FLUSH_STATES							\
-	EM( FLUSH_DELAYED_ITEMS_NR,	"FLUSH_DELAYED_ITEMS_NR")	\
-	EM( FLUSH_DELAYED_ITEMS,	"FLUSH_DELAYED_ITEMS")		\
-	EM( FLUSH_DELALLOC,		"FLUSH_DELALLOC")		\
-	EM( FLUSH_DELALLOC_WAIT,	"FLUSH_DELALLOC_WAIT")		\
-	EM( FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR")	\
-	EM( FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS")		\
-	EM( ALLOC_CHUNK,		"ALLOC_CHUNK")			\
-	EM( ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE")		\
-	EM( RUN_DELAYED_IPUTS,		"RUN_DELAYED_IPUTS")		\
+	EM(FLUSH_DELAYED_ITEMS_NR,	"FLUSH_DELAYED_ITEMS_NR")	\
+	EM(FLUSH_DELAYED_ITEMS,		"FLUSH_DELAYED_ITEMS")		\
+	EM(FLUSH_DELALLOC,		"FLUSH_DELALLOC")		\
+	EM(FLUSH_DELALLOC_WAIT,		"FLUSH_DELALLOC_WAIT")		\
+	EM(FLUSH_DELAYED_REFS_NR,	"FLUSH_DELAYED_REFS_NR")	\
+	EM(FLUSH_DELAYED_REFS,		"FLUSH_ELAYED_REFS")		\
+	EM(ALLOC_CHUNK,			"ALLOC_CHUNK")			\
+	EM(ALLOC_CHUNK_FORCE,		"ALLOC_CHUNK_FORCE")		\
+	EM(RUN_DELAYED_IPUTS,		"RUN_DELAYED_IPUTS")		\
 	EM(COMMIT_TRANS,		"COMMIT_TRANS")			\
-	EMe(FORCE_COMMIT_TRANS,		"FORCE_COMMIT_TRANS")
+	EM(FORCE_COMMIT_TRANS,		"FORCE_COMMIT_TRANS")
 
 /*
  * First define the enums in the above macros to be exported to userspace via
@@ -108,9 +108,7 @@ struct btrfs_space_info;
  */
 
 #undef EM
-#undef EMe
 #define EM(a, b)	TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 FLUSH_ACTIONS
 FI_TYPES
@@ -119,14 +117,12 @@ IO_TREE_OWNER
 FLUSH_STATES
 
 /*
- * Now redefine the EM and EMe macros to map the enums to the strings that will
+ * Now redefine the EM macro to map the enums to the strings that will
  * be printed in the output
  */
 
 #undef EM
-#undef EMe
 #define EM(a, b)        {a, b},
-#define EMe(a, b)       {a, b}
 
 
 #define BTRFS_GROUP_FLAGS	\
diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4fdb14a81108..ae98c5bc03c8 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -8,45 +8,41 @@
 #include  <linux/tracepoint.h>
 
 #define SCAN_STATUS							\
-	EM( SCAN_FAIL,			"failed")			\
-	EM( SCAN_SUCCEED,		"succeeded")			\
-	EM( SCAN_PMD_NULL,		"pmd_null")			\
-	EM( SCAN_EXCEED_NONE_PTE,	"exceed_none_pte")		\
-	EM( SCAN_EXCEED_SWAP_PTE,	"exceed_swap_pte")		\
-	EM( SCAN_EXCEED_SHARED_PTE,	"exceed_shared_pte")		\
-	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
-	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
-	EM( SCAN_PAGE_RO,		"no_writable_page")		\
-	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
-	EM( SCAN_PAGE_NULL,		"page_null")			\
-	EM( SCAN_SCAN_ABORT,		"scan_aborted")			\
-	EM( SCAN_PAGE_COUNT,		"not_suitable_page_count")	\
-	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
-	EM( SCAN_PAGE_LOCK,		"page_locked")			\
-	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
-	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
-	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
-	EM( SCAN_VMA_NULL,		"vma_null")			\
-	EM( SCAN_VMA_CHECK,		"vma_check_failed")		\
-	EM( SCAN_ADDRESS_RANGE,		"not_suitable_address_range")	\
-	EM( SCAN_SWAP_CACHE_PAGE,	"page_swap_cache")		\
-	EM( SCAN_DEL_PAGE_LRU,		"could_not_delete_page_from_lru")\
-	EM( SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
-	EM( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
-	EM( SCAN_TRUNCATED,		"truncated")			\
-	EMe(SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
+	EM(SCAN_FAIL,			"failed")			\
+	EM(SCAN_SUCCEED,		"succeeded")			\
+	EM(SCAN_PMD_NULL,		"pmd_null")			\
+	EM(SCAN_EXCEED_NONE_PTE,	"exceed_none_pte")		\
+	EM(SCAN_EXCEED_SWAP_PTE,	"exceed_swap_pte")		\
+	EM(SCAN_EXCEED_SHARED_PTE,	"exceed_shared_pte")		\
+	EM(SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
+	EM(SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
+	EM(SCAN_PAGE_RO,		"no_writable_page")		\
+	EM(SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
+	EM(SCAN_PAGE_NULL,		"page_null")			\
+	EM(SCAN_SCAN_ABORT,		"scan_aborted")			\
+	EM(SCAN_PAGE_COUNT,		"not_suitable_page_count")	\
+	EM(SCAN_PAGE_LRU,		"page_not_in_lru")		\
+	EM(SCAN_PAGE_LOCK,		"page_locked")			\
+	EM(SCAN_PAGE_ANON,		"page_not_anon")		\
+	EM(SCAN_PAGE_COMPOUND,		"page_compound")		\
+	EM(SCAN_ANY_PROCESS,		"no_process_for_page")		\
+	EM(SCAN_VMA_NULL,		"vma_null")			\
+	EM(SCAN_VMA_CHECK,		"vma_check_failed")		\
+	EM(SCAN_ADDRESS_RANGE,		"not_suitable_address_range")	\
+	EM(SCAN_SWAP_CACHE_PAGE,	"page_swap_cache")		\
+	EM(SCAN_DEL_PAGE_LRU,		"could_not_delete_page_from_lru")\
+	EM(SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
+	EM(SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
+	EM(SCAN_TRUNCATED,		"truncated")			\
+	EM(SCAN_PAGE_HAS_PRIVATE,	"page_has_private")		\
 
 #undef EM
-#undef EMe
 #define EM(a, b)	TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 SCAN_STATUS
 
 #undef EM
-#undef EMe
 #define EM(a, b)	{a, b},
-#define EMe(a, b)	{a, b}
 
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index 4d434398d64d..a0224212e261 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -8,40 +8,36 @@
 #include <linux/tracepoint.h>
 
 #define MIGRATE_MODE						\
-	EM( MIGRATE_ASYNC,	"MIGRATE_ASYNC")		\
-	EM( MIGRATE_SYNC_LIGHT,	"MIGRATE_SYNC_LIGHT")		\
-	EMe(MIGRATE_SYNC,	"MIGRATE_SYNC")
+	EM(MIGRATE_ASYNC,	"MIGRATE_ASYNC")		\
+	EM(MIGRATE_SYNC_LIGHT,	"MIGRATE_SYNC_LIGHT")		\
+	EM(MIGRATE_SYNC,	"MIGRATE_SYNC")
 
 
 #define MIGRATE_REASON						\
-	EM( MR_COMPACTION,	"compaction")			\
-	EM( MR_MEMORY_FAILURE,	"memory_failure")		\
-	EM( MR_MEMORY_HOTPLUG,	"memory_hotplug")		\
-	EM( MR_SYSCALL,		"syscall_or_cpuset")		\
-	EM( MR_MEMPOLICY_MBIND,	"mempolicy_mbind")		\
-	EM( MR_NUMA_MISPLACED,	"numa_misplaced")		\
-	EMe(MR_CONTIG_RANGE,	"contig_range")
+	EM(MR_COMPACTION,	"compaction")			\
+	EM(MR_MEMORY_FAILURE,	"memory_failure")		\
+	EM(MR_MEMORY_HOTPLUG,	"memory_hotplug")		\
+	EM(MR_SYSCALL,		"syscall_or_cpuset")		\
+	EM(MR_MEMPOLICY_MBIND,	"mempolicy_mbind")		\
+	EM(MR_NUMA_MISPLACED,	"numa_misplaced")		\
+	EM(MR_CONTIG_RANGE,	"contig_range")
 
 /*
  * First define the enums in the above macros to be exported to userspace
  * via TRACE_DEFINE_ENUM().
  */
 #undef EM
-#undef EMe
 #define EM(a, b)	TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 MIGRATE_MODE
 MIGRATE_REASON
 
 /*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * Now redefine the EM() macro to map the enums to the strings
  * that will be printed in the output.
  */
 #undef EM
-#undef EMe
 #define EM(a, b)	{a, b},
-#define EMe(a, b)	{a, b}
 
 TRACE_EVENT(mm_migrate_pages,
 
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 67018d367b9f..dfb625cedf32 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -178,15 +178,15 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 
 #ifdef CONFIG_COMPACTION
 #define COMPACTION_STATUS					\
-	EM( COMPACT_SKIPPED,		"skipped")		\
-	EM( COMPACT_DEFERRED,		"deferred")		\
-	EM( COMPACT_CONTINUE,		"continue")		\
-	EM( COMPACT_SUCCESS,		"success")		\
-	EM( COMPACT_PARTIAL_SKIPPED,	"partial_skipped")	\
-	EM( COMPACT_COMPLETE,		"complete")		\
-	EM( COMPACT_NO_SUITABLE_PAGE,	"no_suitable_page")	\
-	EM( COMPACT_NOT_SUITABLE_ZONE,	"not_suitable_zone")	\
-	EMe(COMPACT_CONTENDED,		"contended")
+	EM(COMPACT_SKIPPED,		"skipped")		\
+	EM(COMPACT_DEFERRED,		"deferred")		\
+	EM(COMPACT_CONTINUE,		"continue")		\
+	EM(COMPACT_SUCCESS,		"success")		\
+	EM(COMPACT_PARTIAL_SKIPPED,	"partial_skipped")	\
+	EM(COMPACT_COMPLETE,		"complete")		\
+	EM(COMPACT_NO_SUITABLE_PAGE,	"no_suitable_page")	\
+	EM(COMPACT_NOT_SUITABLE_ZONE,	"not_suitable_zone")	\
+	EM(COMPACT_CONTENDED,		"contended")
 
 /* High-level compaction status feedback */
 #define COMPACTION_FAILED	1
@@ -203,12 +203,12 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 #define COMPACTION_FEEDBACK		\
 	EM(COMPACTION_FAILED,		"failed")	\
 	EM(COMPACTION_WITHDRAWN,	"withdrawn")	\
-	EMe(COMPACTION_PROGRESS,	"progress")
+	EM(COMPACTION_PROGRESS,		"progress")
 
 #define COMPACTION_PRIORITY						\
 	EM(COMPACT_PRIO_SYNC_FULL,	"COMPACT_PRIO_SYNC_FULL")	\
 	EM(COMPACT_PRIO_SYNC_LIGHT,	"COMPACT_PRIO_SYNC_LIGHT")	\
-	EMe(COMPACT_PRIO_ASYNC,		"COMPACT_PRIO_ASYNC")
+	EM(COMPACT_PRIO_ASYNC,		"COMPACT_PRIO_ASYNC")
 #else
 #define COMPACTION_STATUS
 #define COMPACTION_PRIORITY
@@ -238,23 +238,21 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 	IFDEF_ZONE_DMA32(	EM (ZONE_DMA32,	 "DMA32"))	\
 				EM (ZONE_NORMAL, "Normal")	\
 	IFDEF_ZONE_HIGHMEM(	EM (ZONE_HIGHMEM,"HighMem"))	\
-				EMe(ZONE_MOVABLE,"Movable")
+				EM (ZONE_MOVABLE,"Movable")
 
 #define LRU_NAMES		\
 		EM (LRU_INACTIVE_ANON, "inactive_anon") \
 		EM (LRU_ACTIVE_ANON, "active_anon") \
 		EM (LRU_INACTIVE_FILE, "inactive_file") \
 		EM (LRU_ACTIVE_FILE, "active_file") \
-		EMe(LRU_UNEVICTABLE, "unevictable")
+		EM (LRU_UNEVICTABLE, "unevictable")
 
 /*
- * First define the enums in the above macros to be exported to userspace
+ * First define the enum in the EM macro to be exported to userspace
  * via TRACE_DEFINE_ENUM().
  */
 #undef EM
-#undef EMe
 #define EM(a, b)	TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 COMPACTION_STATUS
 COMPACTION_PRIORITY
@@ -263,10 +261,8 @@ ZONE_TYPE
 LRU_NAMES
 
 /*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * Now redefine the EM() macro to map the enums to the strings
  * that will be printed in the output.
  */
 #undef EM
-#undef EMe
 #define EM(a, b)	{a, b},
-#define EMe(a, b)	{a, b}
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index a966d4b5ab37..254ded9e13b2 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -11,40 +11,38 @@
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
 
-#define family_names			\
-		EM(AF_INET)				\
-		EMe(AF_INET6)
+#define family_names					\
+	EM(AF_INET)					\
+	EM(AF_INET6)
 
 /* The protocol traced by inet_sock_set_state */
-#define inet_protocol_names		\
-		EM(IPPROTO_TCP)			\
-		EM(IPPROTO_DCCP)		\
-		EM(IPPROTO_SCTP)		\
-		EMe(IPPROTO_MPTCP)
-
-#define tcp_state_names			\
-		EM(TCP_ESTABLISHED)		\
-		EM(TCP_SYN_SENT)		\
-		EM(TCP_SYN_RECV)		\
-		EM(TCP_FIN_WAIT1)		\
-		EM(TCP_FIN_WAIT2)		\
-		EM(TCP_TIME_WAIT)		\
-		EM(TCP_CLOSE)			\
-		EM(TCP_CLOSE_WAIT)		\
-		EM(TCP_LAST_ACK)		\
-		EM(TCP_LISTEN)			\
-		EM(TCP_CLOSING)			\
-		EMe(TCP_NEW_SYN_RECV)
-
-#define skmem_kind_names			\
-		EM(SK_MEM_SEND)			\
-		EMe(SK_MEM_RECV)
+#define inet_protocol_names				\
+	EM(IPPROTO_TCP)				\
+	EM(IPPROTO_DCCP)			\
+	EM(IPPROTO_SCTP)			\
+	EM(IPPROTO_MPTCP)
+
+#define tcp_state_names					\
+	EM(TCP_ESTABLISHED)				\
+	EM(TCP_SYN_SENT)				\
+	EM(TCP_SYN_RECV)				\
+	EM(TCP_FIN_WAIT1)				\
+	EM(TCP_FIN_WAIT2)				\
+	EM(TCP_TIME_WAIT)				\
+	EM(TCP_CLOSE)					\
+	EM(TCP_CLOSE_WAIT)				\
+	EM(TCP_LAST_ACK)				\
+	EM(TCP_LISTEN)					\
+	EM(TCP_CLOSING)					\
+	EM(TCP_NEW_SYN_RECV)
+
+#define skmem_kind_names				\
+	EM(SK_MEM_SEND)					\
+	EM(SK_MEM_RECV)
 
 /* enums need to be exported to user space */
 #undef EM
-#undef EMe
 #define EM(a)       TRACE_DEFINE_ENUM(a);
-#define EMe(a)      TRACE_DEFINE_ENUM(a);
 
 family_names
 inet_protocol_names
@@ -52,9 +50,7 @@ tcp_state_names
 skmem_kind_names
 
 #undef EM
-#undef EMe
 #define EM(a)       { a, #a },
-#define EMe(a)      { a, #a }
 
 #define show_family_name(val)			\
 	__print_symbolic(val, family_names)
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 58994e013022..2b3c47ba7ad3 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -762,38 +762,36 @@ TRACE_EVENT(rpc_xdr_alignment,
 );
 
 /*
- * First define the enums in the below macros to be exported to userspace
+ * First define the enum in the EM macro to be exported to userspace
  * via TRACE_DEFINE_ENUM().
  */
 #undef EM
-#undef EMe
 #define EM(a, b)	TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
-#define RPC_SHOW_SOCKET				\
-	EM( SS_FREE, "FREE" )			\
-	EM( SS_UNCONNECTED, "UNCONNECTED" )	\
-	EM( SS_CONNECTING, "CONNECTING" )	\
-	EM( SS_CONNECTED, "CONNECTED" )		\
-	EMe( SS_DISCONNECTING, "DISCONNECTING" )
+#define RPC_SHOW_SOCKET					\
+	EM(SS_FREE,	 	"FREE")			\
+	EM(SS_UNCONNECTED,	"UNCONNECTED")		\
+	EM(SS_CONNECTING,	"CONNECTING")		\
+	EM(SS_CONNECTED,	"CONNECTED")		\
+	EM(SS_DISCONNECTING,	"DISCONNECTING")
 
 #define rpc_show_socket_state(state) \
 	__print_symbolic(state, RPC_SHOW_SOCKET)
 
 RPC_SHOW_SOCKET
 
-#define RPC_SHOW_SOCK				\
-	EM( TCP_ESTABLISHED, "ESTABLISHED" )	\
-	EM( TCP_SYN_SENT, "SYN_SENT" )		\
-	EM( TCP_SYN_RECV, "SYN_RECV" )		\
-	EM( TCP_FIN_WAIT1, "FIN_WAIT1" )	\
-	EM( TCP_FIN_WAIT2, "FIN_WAIT2" )	\
-	EM( TCP_TIME_WAIT, "TIME_WAIT" )	\
-	EM( TCP_CLOSE, "CLOSE" )		\
-	EM( TCP_CLOSE_WAIT, "CLOSE_WAIT" )	\
-	EM( TCP_LAST_ACK, "LAST_ACK" )		\
-	EM( TCP_LISTEN, "LISTEN" )		\
-	EMe( TCP_CLOSING, "CLOSING" )
+#define RPC_SHOW_SOCK					\
+	EM(TCP_ESTABLISHED,	"ESTABLISHED")		\
+	EM(TCP_SYN_SENT,	"SYN_SENT")		\
+	EM(TCP_SYN_RECV,	"SYN_RECV")		\
+	EM(TCP_FIN_WAIT1,	"FIN_WAIT1")		\
+	EM(TCP_FIN_WAIT2,	"FIN_WAIT2")		\
+	EM(TCP_TIME_WAIT,	"TIME_WAIT")		\
+	EM(TCP_CLOSE,		"CLOSE")		\
+	EM(TCP_CLOSE_WAIT,	"CLOSE_WAIT")		\
+	EM(TCP_LAST_ACK,	"LAST_ACK")		\
+	EM(TCP_LISTEN,		"LISTEN")		\
+	EM(TCP_CLOSING,		"CLOSING")
 
 #define rpc_show_sock_state(state) \
 	__print_symbolic(state, RPC_SHOW_SOCK)
@@ -801,13 +799,11 @@ RPC_SHOW_SOCKET
 RPC_SHOW_SOCK
 
 /*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * Now redefine the EM() macro to map the enums to the strings
  * that will be printed in the output.
  */
 #undef EM
-#undef EMe
 #define EM(a, b)	{a, b},
-#define EMe(a, b)	{a, b}
 
 DECLARE_EVENT_CLASS(xs_socket_event,
 
diff --git a/include/trace/events/tlb.h b/include/trace/events/tlb.h
index b4d8e7dc38f8..9e5a3d66e36f 100644
--- a/include/trace/events/tlb.h
+++ b/include/trace/events/tlb.h
@@ -9,31 +9,27 @@
 #include <linux/tracepoint.h>
 
 #define TLB_FLUSH_REASON						\
-	EM(  TLB_FLUSH_ON_TASK_SWITCH,	"flush on task switch" )	\
-	EM(  TLB_REMOTE_SHOOTDOWN,	"remote shootdown" )		\
-	EM(  TLB_LOCAL_SHOOTDOWN,	"local shootdown" )		\
-	EM(  TLB_LOCAL_MM_SHOOTDOWN,	"local mm shootdown" )		\
-	EMe( TLB_REMOTE_SEND_IPI,	"remote ipi send" )
+	EM(TLB_FLUSH_ON_TASK_SWITCH,	"flush on task switch")		\
+	EM(TLB_REMOTE_SHOOTDOWN,	"remote shootdown")		\
+	EM(TLB_LOCAL_SHOOTDOWN,		"local shootdown")		\
+	EM(TLB_LOCAL_MM_SHOOTDOWN,	"local mm shootdown")		\
+	EM(TLB_REMOTE_SEND_IPI,		"remote ipi send")
 
 /*
  * First define the enums in TLB_FLUSH_REASON to be exported to userspace
  * via TRACE_DEFINE_ENUM().
  */
 #undef EM
-#undef EMe
 #define EM(a,b)		TRACE_DEFINE_ENUM(a);
-#define EMe(a,b)	TRACE_DEFINE_ENUM(a);
 
 TLB_FLUSH_REASON
 
 /*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * Now redefine the EM() macro to map the enums to the strings
  * that will be printed in the output.
  */
 #undef EM
-#undef EMe
 #define EM(a,b)		{ a, b },
-#define EMe(a,b)	{ a, b }
 
 TRACE_EVENT(tlb_flush,
 
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index 0bd54a184391..28e9ffe7f272 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -23,38 +23,34 @@
 #define UFS_LINK_STATES			\
 	EM(UIC_LINK_OFF_STATE)		\
 	EM(UIC_LINK_ACTIVE_STATE)	\
-	EMe(UIC_LINK_HIBERN8_STATE)
+	EM(UIC_LINK_HIBERN8_STATE)
 
 #define UFS_PWR_MODES			\
 	EM(UFS_ACTIVE_PWR_MODE)		\
 	EM(UFS_SLEEP_PWR_MODE)		\
 	EM(UFS_POWERDOWN_PWR_MODE)	\
-	EMe(UFS_DEEPSLEEP_PWR_MODE)
+	EM(UFS_DEEPSLEEP_PWR_MODE)
 
 #define UFSCHD_CLK_GATING_STATES	\
 	EM(CLKS_OFF)			\
 	EM(CLKS_ON)			\
 	EM(REQ_CLKS_OFF)		\
-	EMe(REQ_CLKS_ON)
+	EM(REQ_CLKS_ON)
 
 /* Enums require being exported to userspace, for user tool parsing */
 #undef EM
-#undef EMe
 #define EM(a)	TRACE_DEFINE_ENUM(a);
-#define EMe(a)	TRACE_DEFINE_ENUM(a);
 
 UFS_LINK_STATES;
 UFS_PWR_MODES;
 UFSCHD_CLK_GATING_STATES;
 
 /*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * Now redefine the EM() macro to map the enums to the strings
  * that will be printed in the output.
  */
 #undef EM
-#undef EMe
 #define EM(a)	{ a, #a },
-#define EMe(a)	{ a, #a }
 
 TRACE_EVENT(ufshcd_clk_gating,
 
diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index 248bc09bfc99..f918ddd1319f 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -10,28 +10,26 @@
 
 /* Enums require being exported to userspace, for user tool parsing */
 #undef EM
-#undef EMe
 #define EM(a, b)	TRACE_DEFINE_ENUM(a);
-#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
 
 #define show_type(type)							\
 	__print_symbolic(type, SHOW_TYPE)
 
 #define SHOW_TYPE							\
-	EM( V4L2_BUF_TYPE_VIDEO_CAPTURE,	"VIDEO_CAPTURE" )	\
-	EM( V4L2_BUF_TYPE_VIDEO_OUTPUT,		"VIDEO_OUTPUT" )	\
-	EM( V4L2_BUF_TYPE_VIDEO_OVERLAY,	"VIDEO_OVERLAY" )	\
-	EM( V4L2_BUF_TYPE_VBI_CAPTURE,		"VBI_CAPTURE" )		\
-	EM( V4L2_BUF_TYPE_VBI_OUTPUT,		"VBI_OUTPUT" )		\
-	EM( V4L2_BUF_TYPE_SLICED_VBI_CAPTURE,   "SLICED_VBI_CAPTURE" )	\
-	EM( V4L2_BUF_TYPE_SLICED_VBI_OUTPUT,    "SLICED_VBI_OUTPUT" )	\
-	EM( V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY, "VIDEO_OUTPUT_OVERLAY" ) \
-	EM( V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, "VIDEO_CAPTURE_MPLANE" ) \
-	EM( V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,  "VIDEO_OUTPUT_MPLANE" )	\
-	EM( V4L2_BUF_TYPE_SDR_CAPTURE,          "SDR_CAPTURE" )		\
-	EM( V4L2_BUF_TYPE_SDR_OUTPUT,           "SDR_OUTPUT" )		\
-	EM( V4L2_BUF_TYPE_META_CAPTURE,		"META_CAPTURE" )	\
-	EMe(V4L2_BUF_TYPE_PRIVATE,		"PRIVATE" )
+	EM(V4L2_BUF_TYPE_VIDEO_CAPTURE,		"VIDEO_CAPTURE")	\
+	EM(V4L2_BUF_TYPE_VIDEO_OUTPUT,		"VIDEO_OUTPUT")		\
+	EM(V4L2_BUF_TYPE_VIDEO_OVERLAY,		"VIDEO_OVERLAY")	\
+	EM(V4L2_BUF_TYPE_VBI_CAPTURE,		"VBI_CAPTURE")		\
+	EM(V4L2_BUF_TYPE_VBI_OUTPUT,		"VBI_OUTPUT")		\
+	EM(V4L2_BUF_TYPE_SLICED_VBI_CAPTURE,	"SLICED_VBI_CAPTURE")	\
+	EM(V4L2_BUF_TYPE_SLICED_VBI_OUTPUT,	"SLICED_VBI_OUTPUT")	\
+	EM(V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY,	"VIDEO_OUTPUT_OVERLAY") \
+	EM(V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,	"VIDEO_CAPTURE_MPLANE") \
+	EM(V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,	"VIDEO_OUTPUT_MPLANE")	\
+	EM(V4L2_BUF_TYPE_SDR_CAPTURE,		"SDR_CAPTURE")		\
+	EM(V4L2_BUF_TYPE_SDR_OUTPUT,		"SDR_OUTPUT")		\
+	EM(V4L2_BUF_TYPE_META_CAPTURE,		"META_CAPTURE")		\
+	EM(V4L2_BUF_TYPE_PRIVATE,		"PRIVATE")
 
 SHOW_TYPE
 
@@ -39,27 +37,25 @@ SHOW_TYPE
 	__print_symbolic(field, SHOW_FIELD)
 
 #define SHOW_FIELD							\
-	EM( V4L2_FIELD_ANY,		"ANY" )				\
-	EM( V4L2_FIELD_NONE,		"NONE" )			\
-	EM( V4L2_FIELD_TOP,		"TOP" )				\
-	EM( V4L2_FIELD_BOTTOM,		"BOTTOM" )			\
-	EM( V4L2_FIELD_INTERLACED,	"INTERLACED" )			\
-	EM( V4L2_FIELD_SEQ_TB,		"SEQ_TB" )			\
-	EM( V4L2_FIELD_SEQ_BT,		"SEQ_BT" )			\
-	EM( V4L2_FIELD_ALTERNATE,	"ALTERNATE" )			\
-	EM( V4L2_FIELD_INTERLACED_TB,	"INTERLACED_TB" )		\
-	EMe( V4L2_FIELD_INTERLACED_BT,	"INTERLACED_BT" )
+	EM(V4L2_FIELD_ANY,		"ANY")				\
+	EM(V4L2_FIELD_NONE,		"NONE")				\
+	EM(V4L2_FIELD_TOP,		"TOP")				\
+	EM(V4L2_FIELD_BOTTOM,		"BOTTOM")			\
+	EM(V4L2_FIELD_INTERLACED,	"INTERLACED")			\
+	EM(V4L2_FIELD_SEQ_TB,		"SEQ_TB")			\
+	EM(V4L2_FIELD_SEQ_BT,		"SEQ_BT")			\
+	EM(V4L2_FIELD_ALTERNATE,	"ALTERNATE")			\
+	EM(V4L2_FIELD_INTERLACED_TB,	"INTERLACED_TB")		\
+	EM(V4L2_FIELD_INTERLACED_BT,	"INTERLACED_BT")
 
 SHOW_FIELD
 
 /*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * Now redefine the EM() macro to map the enums to the strings
  * that will be printed in the output.
  */
 #undef EM
-#undef EMe
 #define EM(a, b)	{a, b},
-#define EMe(a, b)	{a, b}
 
 /* V4L2_TC_TYPE_* are macros, not defines, they do not need processing */
 
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 1efa463c4979..ca2840636600 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -25,29 +25,25 @@
 
 /* enums need to be exported to user space */
 #undef EM
-#undef EMe
-#define EM(a,b) 	TRACE_DEFINE_ENUM(a);
-#define EMe(a,b)	TRACE_DEFINE_ENUM(a);
+#define EM(a, b) 	TRACE_DEFINE_ENUM(a);
 
 #define WB_WORK_REASON							\
-	EM( WB_REASON_BACKGROUND,		"background")		\
-	EM( WB_REASON_VMSCAN,			"vmscan")		\
-	EM( WB_REASON_SYNC,			"sync")			\
-	EM( WB_REASON_PERIODIC,			"periodic")		\
-	EM( WB_REASON_LAPTOP_TIMER,		"laptop_timer")		\
-	EM( WB_REASON_FS_FREE_SPACE,		"fs_free_space")	\
-	EMe(WB_REASON_FORKER_THREAD,		"forker_thread")
+	EM(WB_REASON_BACKGROUND,		"background")		\
+	EM(WB_REASON_VMSCAN,			"vmscan")		\
+	EM(WB_REASON_SYNC,			"sync")			\
+	EM(WB_REASON_PERIODIC,			"periodic")		\
+	EM(WB_REASON_LAPTOP_TIMER,		"laptop_timer")		\
+	EM(WB_REASON_FS_FREE_SPACE,		"fs_free_space")	\
+	EM(WB_REASON_FORKER_THREAD,		"forker_thread")
 
 WB_WORK_REASON
 
 /*
- * Now redefine the EM() and EMe() macros to map the enums to the strings
+ * Now redefine the EM() macro to map the enums to the strings
  * that will be printed in the output.
  */
 #undef EM
-#undef EMe
-#define EM(a,b)		{ a, b },
-#define EMe(a,b)	{ a, b }
+#define EM(a, b)	{ a, b },
 
 struct wb_writeback_work;
 

