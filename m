Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451B31D278D
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 20:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727901449; cv=none; b=c1TWdaTGWpeUjdWP8gF7VLsTEDFNvizIjEWqA++5filuZHeel80MN/pRBQ9rQOcJfD3rGcSHSafjLjwGuadrxKtisXK2Qt6G0gV2z6IKNQn3CntSncIfarDSTQ/ZYZk1vCV/ZvuxldaNpAyMAWPWQyV4lKb+vywH/pMGEkUe6lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727901449; c=relaxed/simple;
	bh=CCL/v6kRU4w83CeAI1pZGW0tbAcxsAtne08MF3AfO3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHGzyNEw3M4Fk6ATx8g9ZQxNNbWmGL4UInIBYF1Y87WceDUoI5vQvxF3Qi4HGf3A37gAx1FuTz1lF+x1yH+vPUY3ImrM5F0OdNLuWO3dAJx1OSOcRUGLx+kwloliU5BVzJZuNv7GchJ4gVTdPKkzchnEVFEZf5nxdpBiAo4BqRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=X5HJ5DBV; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="X5HJ5DBV"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJmp008CyzlgMWH;
	Wed,  2 Oct 2024 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1727901442; x=1730493443; bh=NxLgy
	kgem6v0qTdUsDCHC/2cdg3o/9EA4n3IQelwP/Y=; b=X5HJ5DBViqUhou0kTRvAu
	BmHKyyWW8MQCRnZV3+4Ot65u0H+q3ofMdicoouYFD1QFWtNo9dj78IMDT8i8QauD
	yv5P/vWPHtIot5nFI15VLMSMcs2tY25TxZvJkJHRJ45BPph9p0wuZFK4glNNo4ZH
	gznTblJD88qPtXVI5qWZ7w0BeNFH5GI46IEa6yGUPl9HATfJcQhG79gIYTqFcBIi
	VwqUdSIfJHiJUzjyb+2MpS/gvFi/pra4ls5ZQ1hL8trI/iaAlsXVJ2Bcs39n4JuI
	KW24B077T4A3wvOJrcmH/umBVEtL0lLKhy8MRO1JgGRHM978j+5ccS0wpNL2/JeC
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id juxMYdvVCwYv; Wed,  2 Oct 2024 20:37:22 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJmn34GFnzlgMWB;
	Wed,  2 Oct 2024 20:36:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2 07/11] scsi: core: Rename .slave_alloc() and .slave_destroy() in the documentation
Date: Wed,  2 Oct 2024 13:33:59 -0700
Message-ID: <20241002203528.4104996-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
In-Reply-To: <20241002203528.4104996-1-bvanassche@acm.org>
References: <20241002203528.4104996-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Update the SCSI documentation such that it uses the new names for these
methods.

Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/scsi_mid_low_api.rst | 50 ++++++++++++-------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi=
/scsi_mid_low_api.rst
index 2df29b92e196..aba832d590eb 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -112,9 +112,9 @@ Those usages in group c) should be handled with care,=
 especially in a
 that are shared with the mid level and other layers.
=20
 All functions defined within an LLD and all data defined at file scope
-should be static. For example the slave_alloc() function in an LLD
+should be static. For example the sdev_prep() function in an LLD
 called "xxx" could be defined as
-``static int xxx_slave_alloc(struct scsi_device * sdev) { /* code */ }``
+``static int xxx_sdev_prep(struct scsi_device * sdev) { /* code */ }``
=20
 .. [#] the scsi_host_alloc() function is a replacement for the rather va=
guely
        named scsi_register() function in most situations.
@@ -149,18 +149,18 @@ scsi devices of which only the first 2 respond::
     scsi_add_host()  ---->
     scsi_scan_host()  -------+
 			    |
-			slave_alloc()
+			sdev_prep()
 			slave_configure() -->  scsi_change_queue_depth()
 			    |
-			slave_alloc()
+			sdev_prep()
 			slave_configure()
 			    |
-			slave_alloc()   ***
-			slave_destroy() ***
+			sdev_prep()   ***
+			sdev_destroy() ***
=20
=20
     *** For scsi devices that the mid level tries to scan but do not
-	respond, a slave_alloc(), slave_destroy() pair is called.
+	respond, a sdev_prep(), sdev_destroy() pair is called.
=20
 If the LLD wants to adjust the default queue settings, it can invoke
 scsi_change_queue_depth() in its slave_configure() routine.
@@ -176,8 +176,8 @@ same::
     =3D=3D=3D----------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D----------=
-------=3D=3D=3D------
     scsi_remove_host() ---------+
 				|
-			slave_destroy()
-			slave_destroy()
+			sdev_destroy()
+			sdev_destroy()
     scsi_host_put()
=20
 It may be useful for a LLD to keep track of struct Scsi_Host instances
@@ -202,7 +202,7 @@ An LLD can use this sequence to make the mid level aw=
are of a SCSI device::
     =3D=3D=3D-------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D-------------=
-------=3D=3D=3D------
     scsi_add_device()  ------+
 			    |
-			slave_alloc()
+			sdev_prep()
 			slave_configure()   [--> scsi_change_queue_depth()]
=20
 In a similar fashion, an LLD may become aware that a SCSI device has bee=
n
@@ -218,12 +218,12 @@ upper layers with this sequence::
     =3D=3D=3D----------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D----------=
-------=3D=3D=3D------
     scsi_remove_device() -------+
 				|
-			slave_destroy()
+			sdev_destroy()
=20
 It may be useful for an LLD to keep track of struct scsi_device instance=
s
-(a pointer is passed as the parameter to slave_alloc() and
+(a pointer is passed as the parameter to sdev_prep() and
 slave_configure() callbacks). Such instances are "owned" by the mid-leve=
l.
-struct scsi_device instances are freed after slave_destroy().
+struct scsi_device instances are freed after sdev_destroy().
=20
=20
 Reference Counting
@@ -331,7 +331,7 @@ Details::
     *      bus scan when an HBA is added (i.e. scsi_scan_host()). So it
     *      should only be called if the HBA becomes aware of a new scsi
     *      device (lu) after scsi_scan_host() has completed. If successf=
ul
-    *      this call can lead to slave_alloc() and slave_configure() cal=
lbacks
+    *      this call can lead to sdev_prep() and slave_configure() callb=
acks
     *      into the LLD.
     *
     *      Defined in: drivers/scsi/scsi_scan.c
@@ -375,7 +375,7 @@ Details::
     *
     *      Notes: Can be invoked any time on a SCSI device controlled by=
 this
     *      LLD. [Specifically during and after slave_configure() and pri=
or to
-    *      slave_destroy().] Can safely be invoked from interrupt code.
+    *      sdev_destroy().] Can safely be invoked from interrupt code.
     *
     *      Defined in: drivers/scsi/scsi.c [see source code for more not=
es]
     *
@@ -506,7 +506,7 @@ Details::
     *      Notes: If an LLD becomes aware that a scsi device (lu) has
     *      been removed but its host is still present then it can reques=
t
     *      the removal of that scsi device. If successful this call will
-    *      lead to the slave_destroy() callback being invoked. sdev is a=
n
+    *      lead to the sdev_destroy() callback being invoked. sdev is an
     *      invalid pointer after this call.
     *
     *      Defined in: drivers/scsi/scsi_sysfs.c .
@@ -657,9 +657,9 @@ Summary:
   - ioctl - driver can respond to ioctls
   - proc_info - supports /proc/scsi/{driver_name}/{host_no}
   - queuecommand - queue scsi command, invoke 'done' on completion
-  - slave_alloc - prior to any commands being sent to a new device
+  - sdev_prep - prior to any commands being sent to a new device
   - slave_configure - driver fine tuning for given device after attach
-  - slave_destroy - given device is about to be shut down
+  - sdev_destroy - given device is about to be shut down
=20
=20
 Details::
@@ -960,7 +960,7 @@ Details::
=20
=20
     /**
-    *      slave_alloc -   prior to any commands being sent to a new dev=
ice
+    *      sdev_prep -   prior to any commands being sent to a new devic=
e
     *                      (i.e. just prior to scan) this call is made
     *      @sdp: pointer to new device (about to be scanned)
     *
@@ -976,12 +976,12 @@ Details::
     *      exist but the mid level is just about to scan for it (i.e. se=
nd
     *      and INQUIRY command plus ...). If a device is found then
     *      slave_configure() will be called while if a device is not fou=
nd
-    *      slave_destroy() is called.
+    *      sdev_destroy() is called.
     *      For more details see the include/scsi/scsi_host.h file.
     *
     *      Optionally defined in: LLD
     **/
-	int slave_alloc(struct scsi_device *sdp)
+	int sdev_prep(struct scsi_device *sdp)
=20
=20
     /**
@@ -992,7 +992,7 @@ Details::
     *
     *      Returns 0 if ok. Any other return is assumed to be an error a=
nd
     *      the device is taken offline. [offline devices will _not_ have
-    *      slave_destroy() called on them so clean up resources.]
+    *      sdev_destroy() called on them so clean up resources.]
     *
     *      Locks: none
     *
@@ -1008,7 +1008,7 @@ Details::
=20
=20
     /**
-    *      slave_destroy - given device is about to be shut down. All
+    *      sdev_destroy - given device is about to be shut down. All
     *                      activity has ceased on this device.
     *      @sdp: device that is about to be shut down
     *
@@ -1023,12 +1023,12 @@ Details::
     *      by this driver for given device should be freed now. No furth=
er
     *      commands will be sent for this sdp instance. [However the dev=
ice
     *      could be re-attached in the future in which case a new instan=
ce
-    *      of struct scsi_device would be supplied by future slave_alloc=
()
+    *      of struct scsi_device would be supplied by future sdev_prep()
     *      and slave_configure() calls.]
     *
     *      Optionally defined in: LLD
     **/
-	void slave_destroy(struct scsi_device *sdp)
+	void sdev_destroy(struct scsi_device *sdp)
=20
=20
=20
