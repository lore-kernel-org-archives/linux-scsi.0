From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] correct attribute_container list usage
Date: Mon, 22 Aug 2005 18:26:25 -0500
Message-ID: <1124753185.5211.50.camel@mulgrave>
References: <1124723180.5211.25.camel@mulgrave>
	 <20050822214617.GA26441@us.ibm.com> <1124747956.5211.38.camel@mulgrave>
	 <20050822221427.GA26767@us.ibm.com>  <1124750826.5211.46.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:30901 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751009AbVHVX0n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 19:26:43 -0400
In-Reply-To: <1124750826.5211.46.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Mon, 2005-08-22 at 17:47 -0500, James Bottomley wrote:
> One apparent, but rather nasty, solution would be to embed object get
> and put into the klist head as functions that take the node, so
> klist_next would take the object reference as well as the list kref,
> then drop it on klist_release.

Well, I'm not enormously fond of this, but it's not as downright nasty
as I thought.  Patrick, could you try this (assuming you have a fast
machine ... I'll be done with the complete kernel rebuild that touching
klist.h requires eventually) you'll have to encode klist to device get
and put functions and feed them to klist_init_embedded().

James

diff --git a/include/linux/klist.h b/include/linux/klist.h
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -14,14 +14,24 @@
 #include <linux/kref.h>
 #include <linux/list.h>
 
-
+struct klist_node;
 struct klist {
 	spinlock_t		k_lock;
 	struct list_head	k_list;
+	void			(*get)(struct klist_node *);
+	void			(*put)(struct klist_node *);
 };
 
 
-extern void klist_init(struct klist * k);
+extern void klist_init_embedded(struct klist * k,
+				void (*get)(struct klist_node *),
+				void (*put)(struct klist_node *));
+
+static inline void klist_init(struct klist * k)
+{
+	klist_init_embedded(k, NULL, NULL);
+}
+
 
 
 struct klist_node {
diff --git a/lib/klist.c b/lib/klist.c
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -42,15 +42,26 @@
 /**
  *	klist_init - Initialize a klist structure. 
  *	@k:	The klist we're initializing.
+ *	@get:	The get function for the embedding object (NULL if none)
+ *	@put:	The put function for the embedding object (NULL if none)
+ *
+ * Initialises the klist structure.  If the klist_node structures are
+ * going to be embedded in refcounted objects (necessary for safe
+ * deletion) then the get/put arguments are used to initialise
+ * functions that take and release references on the embedding
+ * objects.
  */
 
-void klist_init(struct klist * k)
+void klist_init_embedded(struct klist * k, void (*get)(struct klist_node *),
+			 void (*put)(struct klist_node *))
 {
 	INIT_LIST_HEAD(&k->k_list);
 	spin_lock_init(&k->k_lock);
+	k->get = get;
+	k->put = put;
 }
 
-EXPORT_SYMBOL_GPL(klist_init);
+EXPORT_SYMBOL_GPL(klist_init_embedded);
 
 
 static void add_head(struct klist * k, struct klist_node * n)
@@ -74,6 +85,8 @@ static void klist_node_init(struct klist
 	init_completion(&n->n_removed);
 	kref_init(&n->n_ref);
 	n->n_klist = k;
+	if (k->get)
+		k->get(n);
 }
 
 
@@ -110,9 +123,12 @@ EXPORT_SYMBOL_GPL(klist_add_tail);
 static void klist_release(struct kref * kref)
 {
 	struct klist_node * n = container_of(kref, struct klist_node, n_ref);
+	void (*put)(struct klist_node *) = n->n_klist->put;
 	list_del(&n->n_node);
 	complete(&n->n_removed);
 	n->n_klist = NULL;
+	if (put)
+		put(n);
 }
 
 static int klist_dec_and_del(struct klist_node * n)


