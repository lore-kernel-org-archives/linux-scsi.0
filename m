From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi: Kconfig option for debug prints.
Date: Mon, 12 Jan 2009 09:59:52 -0600
Message-ID: <496B68F8.3070103@cs.wisc.edu>
References: <496B62B8.3030402@panasas.com> <496B63DF.6010602@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000300020800050805040302"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59365 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbZALQAB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 11:00:01 -0500
In-Reply-To: <496B63DF.6010602@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000300020800050805040302
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Boaz Harrosh wrote:
> Boaz Harrosh wrote:
>> Remove the dark ages /* define debug_print */ in code, to use
>> a Kconfig option. With a system like Kconfig, in code, commented out,
>> configuration options are slavery and hard work.
>> (version control, manual edit ... need I say more)
>>
>> I've used an "int" config bit-mask so more areas of code can be
>> selected with one Koption, but mainly so that allmodconfig will
>> not turn it on.
>>
>> bit-1 - will turn on prints for libiscsi.
>> bit-2 - will turn on prints for libiscsi_tcp & iscsi_tcp.
>>
>> More iscsi drivers should use more bits.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/scsi/Kconfig        |   15 +++++++++++++++
>>  drivers/scsi/iscsi_tcp.c    |    7 -------
>>  drivers/scsi/iscsi_tcp.h    |    6 ++++++
>>  drivers/scsi/libiscsi_tcp.c |    7 -------
>>  include/scsi/libiscsi.h     |    3 +--
>>  5 files changed, 22 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> 
> Mike hi.
> 
> These are over latest Linus. Sorry I mixed up the branches.
> If they don't apply to your tree any more, I'll rebase.
> 

It applies ok.

> I'm sending these because for too many times I submit some code
> with iscsi sources edits, because I forget to remove the edits
> for enabling prints. Please consider for inclusion.
> 

What about compile time vs load time? Olaf had the attached patch which 
does it at module load time. It is nicer for users, but I was just 
worried about maybe there being a perf change with all the new ifs? I 
was waiting to do some testing to see if there was and change, but did 
not get around to it. Is that too paranoid (probably other factors like 
our crappy locking will slow us down more than some ifs for printks right)?

--------------000300020800050805040302
Content-Type: message/rfc822;
 name="[PATCH 04_21 - retry] Make iscsi debugging a module option.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="[PATCH 04_21 - retry] Make iscsi debugging a module option.e";
 filename*1="ml"

Return-Path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=michaelc=cs.wisc.edu@googlegroups.com>
Received: from shale.cs.wisc.edu (shale.cs.wisc.edu [128.105.6.25])
	by topaz.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id l5MHQO3S014345
	for <michaelc@topaz.cs.wisc.edu>; Fri, 22 Jun 2007 12:26:24 -0500
Received: from obsidian.cs.wisc.edu (obsidian.cs.wisc.edu [128.105.6.13])
	by shale.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id l5MHQO8O015509
	for <michaelc@cs.wisc.edu>; Fri, 22 Jun 2007 12:26:24 -0500
Received: from nz-out-0708.google.com (nz-out-0708.google.com [64.233.162.243])
	by obsidian.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id l5MHQ5Mh028506
	for <michaelc@cs.wisc.edu>; Fri, 22 Jun 2007 12:26:11 -0500
Received: by nz-out-0708.google.com with SMTP id v21so400324nzg
        for <michaelc@cs.wisc.edu>; Fri, 22 Jun 2007 10:26:05 -0700 (PDT)
Received: by 10.35.20.16 with SMTP id x16mr281718pyi.1182533160818;
        Fri, 22 Jun 2007 10:26:00 -0700 (PDT)
Received: by 10.44.241.69 with SMTP id o69gr8435hsh;
	Fri, 22 Jun 2007 10:25:46 -0700 (PDT)
X-Sender: okir@lst.de
X-Apparently-To: open-iscsi@googlegroups.com
Received: by 10.36.23.14 with SMTP id 14mr593024nzw.1182523326344; Fri, 22 Jun 2007 07:42:06 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210]) by mx.google.com with ESMTP id h71si850566nzf.2007.06.22.07.42.05; Fri, 22 Jun 2007 07:42:06 -0700 (PDT)
Received-SPF: pass (google.com: best guess record for domain of okir@lst.de designates 213.95.11.210 as permitted sender)
Received: from verein.lst.de (localhost [127.0.0.1]) by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l5MEg4o6025592 (version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO) for <open-iscsi@googlegroups.com>; Fri, 22 Jun 2007 16:42:05 +0200
Received: (from okir@localhost) by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l5MEg40x025590 for open-iscsi@googlegroups.com; Fri, 22 Jun 2007 16:42:04 +0200
Date: Fri, 22 Jun 2007 16:42:04 +0200
Message-Id: <200706221442.l5MEg40x025590@verein.lst.de>
Subject: [PATCH 04/21 - retry] Make iscsi debugging a module option
From: Olaf Kirch <olaf.kirch@oracle.com>
To: open-iscsi@googlegroups.com
In-reply-to: <submit-20070522.666-okir@lst.de>
X-Spam-Score: 0.286 () MAILTO_TO_SPAM_ADDR
X-Scanned-By: MIMEDefang 2.39
X-Google-Approved: michaelc@cs.wisc.edu via web at 2007-06-22 17:25:41
Reply-To: open-iscsi@googlegroups.com
Sender: open-iscsi@googlegroups.com
Precedence: bulk
X-Google-Loop: groups
Mailing-List: list open-iscsi@googlegroups.com;
	contact open-iscsi-owner@googlegroups.com
List-Id: <open-iscsi.googlegroups.com>
List-Post: <mailto:open-iscsi@googlegroups.com>
List-Help: <mailto:open-iscsi-help@googlegroups.com>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi-unsubscribe@googlegroups.com>
X-CSL-MailScanner-Information: Please contact lab@cs.wisc.edu for more information
X-CSL-MailScanner: Found to be clean


Make iscsi debugging a module option

This patch adds a debug module parameter to both
libiscsi and iscsi_tcp, allowing to toggle debug
at runtime via /sys/modules/$name/parameters/debug

Signed-off-by: olaf.kirch@oracle.com
---
 drivers/scsi/Kconfig     |    9 +++++++++
 drivers/scsi/iscsi_tcp.c |   13 +++++++++----
 drivers/scsi/libiscsi.c  |   10 ++++++++++
 include/scsi/libiscsi.h  |   11 +++++++----
 4 files changed, 35 insertions(+), 8 deletions(-)

Index: iscsi-2.6/drivers/scsi/iscsi_tcp.c
===================================================================
--- iscsi-2.6.orig/drivers/scsi/iscsi_tcp.c
+++ iscsi-2.6/drivers/scsi/iscsi_tcp.c
@@ -48,13 +48,18 @@ MODULE_AUTHOR("Dmitry Yusupov <dmitry_yu
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
-#undef DEBUG_TCP
 #define DEBUG_ASSERT
 
-#ifdef DEBUG_TCP
-#define debug_tcp(fmt...) printk(KERN_INFO "tcp: " fmt)
+#ifdef CONFIG_SCSI_ISCSI_DEBUG
+static int iscsi_tcp_debug = 0;
+#define debug_tcp(fmt...) do { \
+		if (unlikely(iscsi_tcp_debug)) \
+			printk(KERN_INFO "tcp: " fmt); \
+	} while (0)
+
+module_param_named(debug, iscsi_tcp_debug, int, S_IRUGO | S_IWUSR);
 #else
-#define debug_tcp(fmt...)
+#define debug_tcp(fmt...) do { } while (0)
 #endif
 
 #ifndef DEBUG_ASSERT
Index: iscsi-2.6/drivers/scsi/libiscsi.c
===================================================================
--- iscsi-2.6.orig/drivers/scsi/libiscsi.c
+++ iscsi-2.6/drivers/scsi/libiscsi.c
@@ -37,6 +37,16 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/libiscsi.h>
 
+/* Debug flag for libiscsi - needs to be
+ * exported so other iscsi modules can make use
+ * of the debug_scsi() macro */
+#ifdef CONFIG_SCSI_ISCSI_DEBUG
+int libiscsi_debug = 0;
+EXPORT_SYMBOL_GPL(libiscsi_debug);
+
+module_param_named(debug, libiscsi_debug, int, S_IRUGO | S_IWUSR);
+#endif
+
 struct iscsi_session *
 class_to_transport_session(struct iscsi_cls_session *cls_session)
 {
Index: iscsi-2.6/include/scsi/libiscsi.h
===================================================================
--- iscsi-2.6.orig/include/scsi/libiscsi.h
+++ iscsi-2.6/include/scsi/libiscsi.h
@@ -41,11 +41,14 @@ struct iscsi_cls_conn;
 struct iscsi_session;
 struct iscsi_nopin;
 
-/* #define DEBUG_SCSI */
-#ifdef DEBUG_SCSI
-#define debug_scsi(fmt...) printk(KERN_INFO "iscsi: " fmt)
+#ifdef CONFIG_SCSI_ISCSI_DEBUG
+extern int	libiscsi_debug;
+#define debug_scsi(fmt...) do { \
+		if (unlikely(libiscsi_debug)) \
+			printk(KERN_INFO "iscsi: " fmt); \
+	} while (0)
 #else
-#define debug_scsi(fmt...)
+#define debug_scsi(fmt...) do { } while (0)
 #endif
 
 #define ISCSI_DEF_XMIT_CMDS_MAX	128	/* must be power of 2 */
Index: iscsi-2.6/drivers/scsi/Kconfig
===================================================================
--- iscsi-2.6.orig/drivers/scsi/Kconfig
+++ iscsi-2.6/drivers/scsi/Kconfig
@@ -312,6 +312,15 @@ config ISCSI_TCP
 
 	 http://linux-iscsi.sf.net
 
+config SCSI_ISCSI_DEBUG
+	bool "Support iSCSI debugging"
+	depends on ISCSI_TCP
+	default n
+	help
+	 Say Y here to compile debugging support into libiscsi and
+	 iscsi_tcp. Debugging will not be enable by default, but
+	 can be switched on and off via module options.
+
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
 	depends on SGI_IP22 && SCSI

--~--~---------~--~----~------------~-------~--~----~
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi@googlegroups.com
To unsubscribe from this group, send email to open-iscsi-unsubscribe@googlegroups.com
For more options, visit this group at http://groups.google.com/group/open-iscsi
-~----------~----~----~----~------~----~------~--~---



--------------000300020800050805040302--
