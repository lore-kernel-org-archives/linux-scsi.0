From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 4/8] aacraid: add name to driver template
Date: Mon, 12 Sep 2005 10:05:55 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919CB4@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:37783 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750920AbVILOGB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 10:06:01 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>

Mark Salyzyn writes:
>Christoph Hellwig writes:
>>> +	aac_driver_template.name = aac_drivers[index].name;
>>this is broken. it overwrites the name every time a host is allocated.
>Especially it does this on a live template.  Just implemented ->info
>
>->info() is not enough, there are places in the scsi subsystem which do
>not implement the info override over top the template name.
>
>I had discussed the possibility of submitting a patch to the scsi
subsystem to fix that brokenness, I am generally concerned with legacy
issues.

Looks like few remain. Could not figure a way to alter scsi_module.c
that made sense, doable but expensive, but hosts.c could be fixed up
with:

--- hosts.c     2005-09-07 12:17:18.000000000 -0400
+++ /tmp/hosts.c        2005-09-12 09:57:52.906881694 -0400
@@ -166,7 +166,7 @@

        if (!shost->can_queue) {
                printk(KERN_ERR "%s: can_queue = 0 no longer
supported\n",
-                               sht->name);
+                               sht->info ? sht->info(shost) :
sht->name);
                goto out;
        }

@@ -386,7 +386,8 @@

        if (!sht->detect) {
                printk(KERN_WARNING "scsi_register() called on new-style
"
-                                   "template for driver %s\n",
sht->name);
+                                   "template for driver %s\n",
+                                   sht->info ? sht->info(shost) :
sht->name);
                dump_stack();
        }

@@ -483,7 +484,8 @@
        if (unlikely(!shost->work_q)) {
                printk(KERN_ERR
                        "ERROR: Scsi host '%s' attempted to queue
scsi-work, "
-                       "when no workqueue created.\n",
shost->hostt->name);
+                       "when no workqueue created.\n",
+                       shost->hostt->info ? shost->hostt->info(shost) :
shost->
hostt->name);
                dump_stack();

                return -EINVAL;
@@ -502,7 +504,8 @@
        if (!shost->work_q) {
                printk(KERN_ERR
                        "ERROR: Scsi host '%s' attempted to flush
scsi-work, "
-                       "when no workqueue created.\n",
shost->hostt->name);
+                       "when no workqueue created.\n",
+                       shost->hostt->info ? shost->hostt->info(shost) :
shost->
hostt->name);
                dump_stack();
                return;

Sincerely -- Mark Salyzyn
