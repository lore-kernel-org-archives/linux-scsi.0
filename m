Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D6A179A3;
	Thu,  5 Dec 2024 04:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733372323; cv=none; b=gvMdo0O7cuJh27lo0wG14NX8g2HVmMT+oGYHnSjJaoWezKd75cyf+PyQSEOjriJCjPYBeYgD6XlkGA92fRg0FUm5ar2TiBs+NDQAXoNxDu3CJ5kUVyt+Vqy4AK6NwbqTbJF5MIwuomoHJwolJcYAZpkz3hQIsTHRkaEld3ONzP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733372323; c=relaxed/simple;
	bh=Hc/ogtOEmF7D8YkqBuvJxto0GqNinnc67Jn22EMh1H8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hCnkHA62MSZYJ+rhHUYIjMNcy+gQIP9dy6qMxi3YtOAbJevHt+4XHZD1yeFn8ahPY+BR7Pb9oZhMBOaNOwqOrHpSHJE/D2KY3woUnDLO7udsPWOj9hf5Dkj0ZPkrFWkiyhBWQv3WXfyv5NFNXry0TPbeZMTFAG9SOjmb25Nq3tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ICjwFIZ3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ICjwFIZ3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=B82C/LcfsYccXrpe7bgH64JBTZbfnHFuNDau8+XaZWI=; b=ICjwFIZ3u/hnsihrH9JZZaBj8y
	M8w6OC+RqBpWHfXa5lJ8x0QQ/SJdeDxngScJsmjik9eoY3vYoAeB/mdH8uWDuyCia4Kni73JTtohz
	FXfHYUK5GfDxDbbMLzdgK9GvHbmquz5QQOnyMV07QULJR1c3CZs0uC3hmz55KNM2Pt+ygjAVdgJTt
	eoP6F/JPWM6y/j5YRAgJLhRgXvyiI5DUMSWVE0oqak9o3p6ILFR2/Og5OLeSp0cvuH3JAPGzT8D0X
	bTtLCDtyTwh2Ng3MIgJmoygnv5Efw+HbiNCp4+vKOqyEVWG3vuXo8ZeyFRC5k/8i51BIRHRQtDVK7
	qQf3AdLQ==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tJ3K4-0000000Eiuw-1Lt5;
	Thu, 05 Dec 2024 04:18:40 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	megaraidlinux.pdl@broadcom.com
Subject: [PATCH] scsi: eliminate scsi_register() and scsi_unregister() usage & docs.
Date: Wed,  4 Dec 2024 20:18:39 -0800
Message-ID: <20241205041839.164404-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scsi_mid_low_api.rst refers to scsi_register() and scsi_unregister()
but these functions (or macros) don't exist. They have been replaced
by more meaningful names.

Update one driver (megaraid_mbox.c) that uses "scsi_unregister" in a
warning message. Update scsi_mid_low_api.rst to eliminate references to
scsi_register() and scsi_unregister().

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: megaraidlinux.pdl@broadcom.com
---
Please note: This patch should follow the previous patch:
  scsi: Docs: remove init_this_scsi_driver()

 Documentation/scsi/scsi_mid_low_api.rst |   55 ++--------------------
 drivers/scsi/megaraid/megaraid_mbox.c   |    2 
 include/scsi/scsi_host.h                |    2 
 3 files changed, 7 insertions(+), 52 deletions(-)

--- linux-next-20241204.orig/drivers/scsi/megaraid/megaraid_mbox.c
+++ linux-next-20241204/drivers/scsi/megaraid/megaraid_mbox.c
@@ -621,7 +621,7 @@ megaraid_io_attach(adapter_t *adapter)
 	host = scsi_host_alloc(&megaraid_template_g, 8);
 	if (!host) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid mbox: scsi_register failed\n"));
+			"megaraid mbox: scsi_host_alloc failed\n"));
 
 		return -1;
 	}
--- linux-next-20241204.orig/include/scsi/scsi_host.h
+++ linux-next-20241204/include/scsi/scsi_host.h
@@ -595,7 +595,7 @@ struct Scsi_Host {
 	 * have some way of identifying each detected host adapter properly
 	 * and uniquely.  For hosts that do not support more than one card
 	 * in the system at one time, this does not need to be set.  It is
-	 * initialized to 0 in scsi_register.
+	 * initialized to 0 in scsi_host_alloc.
 	 */
 	unsigned int unique_id;
 
--- linux-next-20241204.orig/Documentation/scsi/scsi_mid_low_api.rst
+++ linux-next-20241204/Documentation/scsi/scsi_mid_low_api.rst
@@ -101,7 +101,7 @@ supplied functions" below.
 Those functions in group b) are listed in a section entitled "Interface
 functions" below. Their function pointers are placed in the members of
 "struct scsi_host_template", an instance of which is passed to
-scsi_host_alloc() [#]_.  Those interface functions that the LLD does not
+scsi_host_alloc().  Those interface functions that the LLD does not
 wish to supply should have NULL placed in the corresponding member of
 struct scsi_host_template.  Defining an instance of struct
 scsi_host_template at file scope will cause NULL to be  placed in function
@@ -116,9 +116,6 @@ should be static. For example the sdev_i
 called "xxx" could be defined as
 ``static int xxx_sdev_init(struct scsi_device * sdev) { /* code */ }``
 
-.. [#] the scsi_host_alloc() function is a replacement for the rather vaguely
-       named scsi_register() function in most situations.
-
 
 Hotplug initialization model
 ============================
@@ -302,14 +299,12 @@ Summary:
   - scsi_host_alloc - return a new scsi_host instance whose refcount==1
   - scsi_host_get - increments Scsi_Host instance's refcount
   - scsi_host_put - decrements Scsi_Host instance's refcount (free if 0)
-  - scsi_register - create and register a scsi host adapter instance.
   - scsi_remove_device - detach and remove a SCSI device
   - scsi_remove_host - detach and remove all SCSI devices owned by host
   - scsi_report_bus_reset - report scsi _bus_ reset observed
   - scsi_scan_host - scan SCSI bus
   - scsi_track_queue_full - track successive QUEUE_FULL events
   - scsi_unblock_requests - allow further commands to be queued to given host
-  - scsi_unregister - [calls scsi_host_put()]
 
 
 Details::
@@ -475,27 +470,6 @@ Details::
 
 
     /**
-    * scsi_register - create and register a scsi host adapter instance.
-    * @sht:        pointer to scsi host template
-    * @privsize:   extra bytes to allocate in hostdata array (which is the
-    *              last member of the returned Scsi_Host instance)
-    *
-    *      Returns pointer to new Scsi_Host instance or NULL on failure
-    *
-    *      Might block: yes
-    *
-    *      Notes: When this call returns to the LLD, the SCSI bus scan on
-    *      this host has _not_ yet been done.
-    *      The hostdata array (by default zero length) is a per host scratch
-    *      area for the LLD.
-    *
-    *      Defined in: drivers/scsi/hosts.c .
-    **/
-    struct Scsi_Host * scsi_register(struct scsi_host_template * sht,
-				    int privsize)
-
-
-    /**
     * scsi_remove_device - detach and remove a SCSI device
     * @sdev:      a pointer to a scsi device instance
     *
@@ -524,7 +498,7 @@ Details::
     *
     *      Notes: Should only be invoked if the "hotplug initialization
     *      model" is being used. It should be called _prior_ to
-    *      scsi_unregister().
+    *      calling scsi_host_put().
     *
     *      Defined in: drivers/scsi/hosts.c .
     **/
@@ -601,31 +575,12 @@ Details::
     void scsi_unblock_requests(struct Scsi_Host * shost)
 
 
-    /**
-    * scsi_unregister - unregister and free memory used by host instance
-    * @shp:        pointer to scsi host instance to unregister.
-    *
-    *      Returns nothing
-    *
-    *      Might block: no
-    *
-    *      Notes: Should not be invoked if the "hotplug initialization
-    *      model" is being used. Called internally by exit_this_scsi_driver()
-    *      in the "passive initialization model". Hence a LLD has no need to
-    *      call this function directly.
-    *
-    *      Defined in: drivers/scsi/hosts.c .
-    **/
-    void scsi_unregister(struct Scsi_Host * shp)
-
-
-
 
 Interface Functions
 ===================
 Interface functions are supplied (defined) by LLDs and their function
 pointers are placed in an instance of struct scsi_host_template which
-is passed to scsi_host_alloc() or scsi_register().
+is passed to scsi_host_alloc().
 Some are mandatory. Interface functions should be declared static. The
 accepted convention is that driver "xyz" will declare its sdev_configure()
 function as::
@@ -636,7 +591,7 @@ and so forth for all interface functions
 
 A pointer to this function should be placed in the 'sdev_configure' member
 of a "struct scsi_host_template" instance. A pointer to such an instance
-should be passed to the mid level's scsi_host_alloc() or scsi_register().
+should be passed to the mid level's scsi_host_alloc().
 .
 
 The interface functions are also described in the include/scsi/scsi_host.h
@@ -1111,7 +1066,7 @@ of interest:
     hostdata[0]
 		 - area reserved for LLD at end of struct Scsi_Host. Size
                    is set by the second argument (named 'xtr_bytes') to
-                   scsi_host_alloc() or scsi_register().
+                   scsi_host_alloc().
     vendor_id
 		 - a unique value that identifies the vendor supplying
                    the LLD for the Scsi_Host.  Used most often in validating
