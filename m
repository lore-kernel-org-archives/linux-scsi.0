Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA2F1C9B8C
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 18:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729620712; cv=none; b=tavdXnL9J8sjO9E9/MzjLbl2F3I0jYgI/SaoNOX3DTSm4FPUP6MJYnlACwkfoW6JoUKBDl3JT+KtbdoEitntW437aBIleONKvF7v6PWkQEwKKe96a52mke0lR/VSIq+20Hii8RaRC4IB1JZhbw7fL+jpbwWf5gBN0ky3ZCJsqJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729620712; c=relaxed/simple;
	bh=7VPNvGFhJp4QFrXR/lsrYEfnRhyoTBneSnbVwl0krNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDZj17aVYe7pcFb4ruUTpBPF9HTtDjNDm6D4Ncb88USkLir67DeHwvLX4EbdJ4sBgSz13kONL+XP2VNWwVJbQ1FVBHHSIQS3Ko5DvHqeMxVOJJm0eJ0+nL5NvYH2f7x3Yh0I57Nc20CEDRddlrjWiHDu7vi1+qfsgmiIUcJiPYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yVbWZanh; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yVbWZanh"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XY0ck546szlgTWK;
	Tue, 22 Oct 2024 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729620703; x=1732212704; bh=VmXSj
	wm1/G2iyuIg9LEpmbam/HI4IRDdHemQBX7feCk=; b=yVbWZanhFN5/+zTdis6GH
	0UHPCGwEz8aZCaHDFte8og58KUrR7dmAwM8vkobZ5l5OHvrKdLgmfJTIQAAWtJTg
	BOdNgrT8BjLXtUn/5XscDvEL+ojxdmOZJtG2t7oPHfLkEmj1nXbVJTFJe91GsSDd
	EOXOW0WhrOdAKez6o7K/3PF87hJ/HNKcel3z8+hvldqiwIu0ZGCtVTy/9/62bMbF
	AcgTAhGS3wpZR9AHzV56lbPBUOkY/svqU8Y1kF5UeVaRsupAOInqtnsMlzL7P1tz
	zgFipHF/ZxmJ7HML7+k+6elNfSixLwUlDqUs3zt3jO/crcHkGydcL+qsROUZG4ha
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EkKLVIr7YLqW; Tue, 22 Oct 2024 18:11:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XY0ZR3hmszlgMVh;
	Tue, 22 Oct 2024 18:09:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v4 5/5] scsi: core: Update API documentation
Date: Tue, 22 Oct 2024 11:07:57 -0700
Message-ID: <20241022180839.2712439-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
In-Reply-To: <20241022180839.2712439-1-bvanassche@acm.org>
References: <20241022180839.2712439-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Since the .slave_alloc(), .slave_destroy() and .slave_configure() methods
have been renamed in struct scsi_host_template, also rename these in the
API documentation.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/scsi_mid_low_api.rst | 78 ++++++++++++-------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi=
/scsi_mid_low_api.rst
index 2df29b92e196..a93df7c3ae50 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -112,9 +112,9 @@ Those usages in group c) should be handled with care,=
 especially in a
 that are shared with the mid level and other layers.
=20
 All functions defined within an LLD and all data defined at file scope
-should be static. For example the slave_alloc() function in an LLD
+should be static. For example the sdev_init() function in an LLD
 called "xxx" could be defined as
-``static int xxx_slave_alloc(struct scsi_device * sdev) { /* code */ }``
+``static int xxx_sdev_init(struct scsi_device * sdev) { /* code */ }``
=20
 .. [#] the scsi_host_alloc() function is a replacement for the rather va=
guely
        named scsi_register() function in most situations.
@@ -149,21 +149,21 @@ scsi devices of which only the first 2 respond::
     scsi_add_host()  ---->
     scsi_scan_host()  -------+
 			    |
-			slave_alloc()
-			slave_configure() -->  scsi_change_queue_depth()
+			sdev_init()
+			sdev_configure() -->  scsi_change_queue_depth()
 			    |
-			slave_alloc()
-			slave_configure()
+			sdev_init()
+			sdev_configure()
 			    |
-			slave_alloc()   ***
-			slave_destroy() ***
+			sdev_init()   ***
+			sdev_destroy() ***
=20
=20
     *** For scsi devices that the mid level tries to scan but do not
-	respond, a slave_alloc(), slave_destroy() pair is called.
+	respond, a sdev_init(), sdev_destroy() pair is called.
=20
 If the LLD wants to adjust the default queue settings, it can invoke
-scsi_change_queue_depth() in its slave_configure() routine.
+scsi_change_queue_depth() in its sdev_configure() routine.
=20
 When an HBA is being removed it could be as part of an orderly shutdown
 associated with the LLD module being unloaded (e.g. with the "rmmod"
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
@@ -202,8 +202,8 @@ An LLD can use this sequence to make the mid level aw=
are of a SCSI device::
     =3D=3D=3D-------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D-------------=
-------=3D=3D=3D------
     scsi_add_device()  ------+
 			    |
-			slave_alloc()
-			slave_configure()   [--> scsi_change_queue_depth()]
+			sdev_init()
+			sdev_configure()   [--> scsi_change_queue_depth()]
=20
 In a similar fashion, an LLD may become aware that a SCSI device has bee=
n
 removed (unplugged) or the connection to it has been interrupted. Some
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
-slave_configure() callbacks). Such instances are "owned" by the mid-leve=
l.
-struct scsi_device instances are freed after slave_destroy().
+(a pointer is passed as the parameter to sdev_init() and
+sdev_configure() callbacks). Such instances are "owned" by the mid-level=
.
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
+    *      this call can lead to sdev_init() and sdev_configure() callba=
cks
     *      into the LLD.
     *
     *      Defined in: drivers/scsi/scsi_scan.c
@@ -374,8 +374,8 @@ Details::
     *      Might block: no
     *
     *      Notes: Can be invoked any time on a SCSI device controlled by=
 this
-    *      LLD. [Specifically during and after slave_configure() and pri=
or to
-    *      slave_destroy().] Can safely be invoked from interrupt code.
+    *      LLD. [Specifically during and after sdev_configure() and prio=
r to
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
@@ -627,14 +627,14 @@ Interface functions are supplied (defined) by LLDs =
and their function
 pointers are placed in an instance of struct scsi_host_template which
 is passed to scsi_host_alloc() [or scsi_register() / init_this_scsi_driv=
er()].
 Some are mandatory. Interface functions should be declared static. The
-accepted convention is that driver "xyz" will declare its slave_configur=
e()
+accepted convention is that driver "xyz" will declare its sdev_configure=
()
 function as::
=20
-    static int xyz_slave_configure(struct scsi_device * sdev);
+    static int xyz_sdev_configure(struct scsi_device * sdev);
=20
 and so forth for all interface functions listed below.
=20
-A pointer to this function should be placed in the 'slave_configure' mem=
ber
+A pointer to this function should be placed in the 'sdev_configure' memb=
er
 of a "struct scsi_host_template" instance. A pointer to such an instance
 should be passed to the mid level's scsi_host_alloc() [or scsi_register(=
) /
 init_this_scsi_driver()].
@@ -657,9 +657,9 @@ Summary:
   - ioctl - driver can respond to ioctls
   - proc_info - supports /proc/scsi/{driver_name}/{host_no}
   - queuecommand - queue scsi command, invoke 'done' on completion
-  - slave_alloc - prior to any commands being sent to a new device
-  - slave_configure - driver fine tuning for given device after attach
-  - slave_destroy - given device is about to be shut down
+  - sdev_init - prior to any commands being sent to a new device
+  - sdev_configure - driver fine tuning for given device after attach
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
+    *      sdev_init -   prior to any commands being sent to a new devic=
e
     *                      (i.e. just prior to scan) this call is made
     *      @sdp: pointer to new device (about to be scanned)
     *
@@ -975,24 +975,24 @@ Details::
     *      prior to its initial scan. The corresponding scsi device may =
not
     *      exist but the mid level is just about to scan for it (i.e. se=
nd
     *      and INQUIRY command plus ...). If a device is found then
-    *      slave_configure() will be called while if a device is not fou=
nd
-    *      slave_destroy() is called.
+    *      sdev_configure() will be called while if a device is not foun=
d
+    *      sdev_destroy() is called.
     *      For more details see the include/scsi/scsi_host.h file.
     *
     *      Optionally defined in: LLD
     **/
-	int slave_alloc(struct scsi_device *sdp)
+	int sdev_init(struct scsi_device *sdp)
=20
=20
     /**
-    *      slave_configure - driver fine tuning for given device just af=
ter it
+    *      sdev_configure - driver fine tuning for given device just aft=
er it
     *                     has been first scanned (i.e. it responded to a=
n
     *                     INQUIRY)
     *      @sdp: device that has just been attached
     *
     *      Returns 0 if ok. Any other return is assumed to be an error a=
nd
     *      the device is taken offline. [offline devices will _not_ have
-    *      slave_destroy() called on them so clean up resources.]
+    *      sdev_destroy() called on them so clean up resources.]
     *
     *      Locks: none
     *
@@ -1004,11 +1004,11 @@ Details::
     *
     *      Optionally defined in: LLD
     **/
-	int slave_configure(struct scsi_device *sdp)
+	int sdev_configure(struct scsi_device *sdp)
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
-    *      and slave_configure() calls.]
+    *      of struct scsi_device would be supplied by future sdev_init()
+    *      and sdev_configure() calls.]
     *
     *      Optionally defined in: LLD
     **/
-	void slave_destroy(struct scsi_device *sdp)
+	void sdev_destroy(struct scsi_device *sdp)
=20
=20
=20
