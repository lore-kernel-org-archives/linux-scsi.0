Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C619B646;
	Sat, 21 Dec 2024 21:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734816350; cv=none; b=uiQ86+h+rN2awae8wpRSjEtFVHWvzAYLgkunhbOkFt4rUjLTxe6gLkQfx/Xi+stFhQbpgncXF+3/mDXfCwQ4vKLkWbY3SlGm7+BmiUrX27YwqipGWJ+KPCnxjGC7Nx9TNQ/6njuZVI132zDBayYTjzeuQstQRVZvZJmQZXwaov4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734816350; c=relaxed/simple;
	bh=d23nxBd6dWBcy6v+tcmTJckiaiP789qYyYm/i6gYSm0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TiOt2TnHfNEyUuI9NRnGqsW38LpjhI1vA+Cag4PxgkUCVWcjeE7X4b1IrwhmByN6EdIgkdekJOu8T2A+hJP7ZaIK4n+/oFW3KHEkOfk1kJbDrxmlcBhNJSessJNeE0Qa7wjAAIExiUZzrtFMpwmPK1O6f2DVLJoGhU1gouSoAsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GSMmwlzX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GSMmwlzX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=UJs+9Ou9Y1wiosHH1I4myIqmfORyEj7N5bZXSlz+aGc=; b=GSMmwlzXic54KCGQu3eo0H/EgC
	8yO9eqvIn3fzKGIy+XkDycZ1NlFBRBLf2HOHmJE42DM0NjcAJW3wEM3VluwINJ3jftTCJM3Z7W9AF
	XNOiGBvUMxBbgqjszq+4d9x0Wphjyb0eulFk/jkfWpoYc5QOWjrIB7r1h3wBLHZIppyjCjhSQXYnc
	d3QnWE/PdhnNifITOn2hTPX4GTy7UZWU6oOPk8SX4UNuHndnXgjB3sKgQVeCNYPQwnEchfvv9hiQs
	t/CSBvaPvYQDpLDLfi2P1R/eML09kF2DOQmv/bnw2+ezsbLRFYumx7nkwsmo/r1w+yGQ6NgNc5Swl
	yVSTyLdQ==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tP6yl-00000007RG5-22HH;
	Sat, 21 Dec 2024 21:25:43 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Subject: [PATCH] scsi: Documentation: corrections for struct updates
Date: Sat, 21 Dec 2024 13:25:39 -0800
Message-ID: <20241221212539.1314560-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update scsi_mid_low_api.rst for changes to struct scsi_host and
struct scsi_cmnd.

struct scsi_host:
. no_async_abort is gone
. drop sh_list w/ no replacement
. change my_devices to __devices

struct scsi_cmnd:
 . removed 'done' (now in struct scsi_driver);
   use scsi_done() or scsi_done_direct() callbacks
 . change previous request_bufflen to scsi_bufflen()
 . change previous use_sg field to scsi_dma_map() or scsi_sg_count()
 . change previous request_buffer field to reference to 'usg_sg' text

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/scsi/scsi_mid_low_api.rst |   66 ++++++++--------------
 1 file changed, 25 insertions(+), 41 deletions(-)

--- linux-next-20241219.orig/Documentation/scsi/scsi_mid_low_api.rst
+++ linux-next-20241219/Documentation/scsi/scsi_mid_low_api.rst
@@ -683,11 +683,7 @@ Details::
     *
     *      Calling context: kernel thread
     *
-    *      Notes: If 'no_async_abort' is defined this callback
-    *  	will be invoked from scsi_eh thread. No other commands
-    *	will then be queued on current host during eh.
-    *	Otherwise it will be called whenever scsi_timeout()
-    *      is called due to a command timeout.
+    *      Notes: This is called only for a command that has timed out.
     *
     *      Optionally defined in: LLD
     **/
@@ -1006,6 +1002,13 @@ Member of interest:
 		 - primary callback that the mid level uses to inject
                    SCSI commands into an LLD.
 
+    vendor_id
+		 - a unique value that identifies the vendor supplying
+                   the LLD for the Scsi_Host.  Used most often in validating
+                   vendor-specific message requests.  Value consists of an
+                   identifier type and a vendor-specific value.
+                   See scsi_netlink.h for a description of valid formats.
+
 The structure is defined and commented in include/scsi/scsi_host.h
 
 .. [#] In extreme situations a single driver may have several instances
@@ -1046,9 +1049,6 @@ of interest:
 		 - maximum number of commands that can be queued on devices
                    controlled by the host. Overridden by LLD calls to
                    scsi_change_queue_depth().
-    no_async_abort
-		 - 1=>Asynchronous aborts are not supported
-		 - 0=>Timed-out commands will be aborted asynchronously
     hostt
 		 - pointer to driver's struct scsi_host_template from which
                    this struct Scsi_Host instance was spawned
@@ -1057,22 +1057,13 @@ of interest:
     transportt
 		 - pointer to driver's struct scsi_transport_template instance
                    (if any). FC and SPI transports currently supported.
-    sh_list
-		 - a double linked list of pointers to all struct Scsi_Host
-                   instances (currently ordered by ascending host_no)
-    my_devices
+    __devices
 		 - a double linked list of pointers to struct scsi_device
                    instances that belong to this host.
     hostdata[0]
 		 - area reserved for LLD at end of struct Scsi_Host. Size
-                   is set by the second argument (named 'xtr_bytes') to
+                   is set by the second argument (named 'privsize') to
                    scsi_host_alloc().
-    vendor_id
-		 - a unique value that identifies the vendor supplying
-                   the LLD for the Scsi_Host.  Used most often in validating
-                   vendor-specific message requests.  Value consists of an
-                   identifier type and a vendor-specific value.
-                   See scsi_netlink.h for a description of valid formats.
 
 The scsi_host structure is defined in include/scsi/scsi_host.h
 
@@ -1094,30 +1085,23 @@ Members of interest:
 
     cmnd
 		 - array containing SCSI command
-    cmnd_len
+    cmd_len
 		 - length (in bytes) of SCSI command
     sc_data_direction
 		 - direction of data transfer in data phase. See
                    "enum dma_data_direction" in include/linux/dma-mapping.h
-    request_bufflen
+    request_bufflen (see sdb.length; access using scsi_bufflen(cmd))
 		 - number of data bytes to transfer (0 if no data phase)
-    use_sg
-		 - ==0 -> no scatter gather list, hence transfer data
-                          to/from request_buffer
-                 - >0 ->  scatter gather list (actually an array) in
-                          request_buffer with use_sg elements
-    request_buffer
+    use_sg         (use scsi_dma_map(cmnd) or scsi_sg_count(cmnd) instead)
+		 - 0 => no scatter gather list, hence transfer data
+                          to/from driver's request_buffer
+                 - >0 =>  scatter gather list (actually an array) in
+                          cmnd->sdb.table with use_sg elements
+    request_buffer (See use_sg above)
 		   - either contains data buffer or scatter gather list
                      depending on the setting of use_sg. Scatter gather
                      elements are defined by 'struct scatterlist' found
                      in include/linux/scatterlist.h .
-    done
-		 - function pointer that should be invoked by LLD when the
-                   SCSI command is completed (successfully or otherwise).
-                   Should only be called by an LLD if the LLD has accepted
-                   the command (i.e. queuecommand() returned or will return
-                   0). The LLD may invoke 'done'  prior to queuecommand()
-                   finishing.
     result
 		 - should be set by LLD prior to calling 'done'. A value
                    of 0 implies a successfully completed command (and all
@@ -1140,13 +1124,13 @@ Members of interest:
     device
 		 - pointer to scsi_device object that this command is
                    associated with.
-    resid
+    resid_len   (access by calling scsi_set_resid() / scsi_get_resid())
 		 - an LLD should set this unsigned integer to the requested
                    transfer length (i.e. 'request_bufflen') less the number
-                   of bytes that are actually transferred. 'resid' is
+                   of bytes that are actually transferred. 'resid_len' is
                    preset to 0 so an LLD can ignore it if it cannot detect
                    underruns (overruns should not be reported). An LLD
-                   should set 'resid' prior to invoking 'done'. The most
+                   should set 'resid_len' prior to invoking 'done'. The most
                    interesting case is data transfers from a SCSI target
                    device (e.g. READs) that underrun.
     underflow
@@ -1155,10 +1139,10 @@ Members of interest:
                    figure. Not many LLDs implement this check and some that
                    do just output an error message to the log rather than
                    report a DID_ERROR. Better for an LLD to implement
-                   'resid'.
+                   'resid_len'.
 
-It is recommended that a LLD set 'resid' on data transfers from a SCSI
-target device (e.g. READs). It is especially important that 'resid' is set
+It is recommended that a LLD set 'resid_len' on data transfers from a SCSI
+target device (e.g. READs). It is especially important that 'resid_len' is set
 when such data transfers have sense keys of MEDIUM ERROR and HARDWARE ERROR
 (and possibly RECOVERED ERROR). In these cases if a LLD is in doubt how much
 data has been received then the safest approach is to indicate no bytes have
@@ -1168,7 +1152,7 @@ a LLD might use these helpers::
     scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
 
 where 'SCpnt' is a pointer to a scsi_cmnd object. To indicate only three 512
-bytes blocks has been received 'resid' could be set like this::
+bytes blocks have been received 'resid_len' could be set like this::
 
     scsi_set_resid(SCpnt, scsi_bufflen(SCpnt) - (3 * 512));
 
