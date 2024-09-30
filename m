Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7B419882F
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 20:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727729; cv=none; b=YWZ2l/+0+/YFJ6RcR2Bs00kiF/YvFcytAM+UFD7GHSfLcbQN2L1u+LEpOy40+j8jFIoJqQeAUUc6VC3NTa8EGQOi1aust9TzZ7UJ68Eg9HVfYfPpbeD6I957smDUUMA0Zz16PIaMwQ8tAw1ywvXRvybSk/Cb5gHR+TmSt0bUKaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727729; c=relaxed/simple;
	bh=eJGS2yvMsnBP+meJId+lEaJ2YG786w9cnACvRadZ3ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJBGn9Y6TSY/fT3MdH+Aoy8bdL0nrOwd2Sy7ZtEMrV/td6V4CLy04EDBvdCB04O1hCk69syX5xwggUdnpAbwkYAppFvqprwkEzL5AxIohTbZ/gmeXewMCdL6rNLq9dtfg4nQxuqjQ12FqoZR2SyPztTL/9EmS2iZo2HzEVhAtys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FykeiS0H; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FykeiS0H"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XHXYC1sXVz6ClY9b;
	Mon, 30 Sep 2024 20:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1727727721; x=1730319722; bh=0n58H
	+y/iSJLf/sPPt/9kbMzNFx9UeTCbAE4TMsiU4s=; b=FykeiS0HfRvcFgsoIP44J
	F4NiJJAOUL5HPj7Zj8FPf+LGGKQvTidKyK5GI8hMKOx9mi5PYAKqol4z1RWhbL4c
	pSuunlrz8LEXeuyjD6jPT4OBByr6ck0/f2+mOQ5C4TyhStYhjzV55UXMGXndv3eW
	bjjeFbDsjof7YKI3y6vVPkJIk2HHpOugWJG8GF/Ei9RxeS9Rrg98dORYEM2D4ZwM
	IuBWz5qrBEhmKF+zF+UqLH5kYBxC9zZ0JUiD3ZjbBS8ekn5LhMaw3GrvyQim0oKR
	AMY7ZXrqlnjRjo3nTPLNgskUiitfzhL7RIHtpott5NFD5m5sNN7AXBK7F9R+zlDZ
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wTQu0jhWeqtd; Mon, 30 Sep 2024 20:22:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XHXWw4L4cz6ClY9c;
	Mon, 30 Sep 2024 20:21:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 4/4] scsi: core: Update .slave_configure() references in the documentation
Date: Mon, 30 Sep 2024 13:18:50 -0700
Message-ID: <20240930201937.2020129-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
In-Reply-To: <20240930201937.2020129-1-bvanassche@acm.org>
References: <20240930201937.2020129-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Now that .slave_configure() support has been removed, change all referenc=
es to
.slave_configure() into .device_configure() in the SCSI documentation.

Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/scsi_mid_low_api.rst | 31 +++++++++++++------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi=
/scsi_mid_low_api.rst
index 3507c10164b4..12c00e91cc0f 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -150,10 +150,10 @@ scsi devices of which only the first 2 respond::
     scsi_scan_host()  -------+
 			    |
 			device_alloc()
-			slave_configure() -->  scsi_change_queue_depth()
+			device_configure() -->  scsi_change_queue_depth()
 			    |
 			device_alloc()
-			slave_configure()
+			device_configure()
 			    |
 			device_alloc()   ***
 			device_destroy() ***
@@ -163,7 +163,7 @@ scsi devices of which only the first 2 respond::
 	respond, a device_alloc(), device_destroy() pair is called.
=20
 If the LLD wants to adjust the default queue settings, it can invoke
-scsi_change_queue_depth() in its slave_configure() routine.
+scsi_change_queue_depth() in its device_configure() routine.
=20
 When an HBA is being removed it could be as part of an orderly shutdown
 associated with the LLD module being unloaded (e.g. with the "rmmod"
@@ -203,7 +203,7 @@ An LLD can use this sequence to make the mid level aw=
are of a SCSI device::
     scsi_add_device()  ------+
 			    |
 			device_alloc()
-			slave_configure()   [--> scsi_change_queue_depth()]
+			device_configure()   [--> scsi_change_queue_depth()]
=20
 In a similar fashion, an LLD may become aware that a SCSI device has bee=
n
 removed (unplugged) or the connection to it has been interrupted. Some
@@ -222,7 +222,7 @@ upper layers with this sequence::
=20
 It may be useful for an LLD to keep track of struct scsi_device instance=
s
 (a pointer is passed as the parameter to device_alloc() and
-slave_configure() callbacks). Such instances are "owned" by the mid-leve=
l.
+device_configure() callbacks). Such instances are "owned" by the mid-lev=
el.
 struct scsi_device instances are freed after device_destroy().
=20
=20
@@ -331,7 +331,7 @@ Details::
     *      bus scan when an HBA is added (i.e. scsi_scan_host()). So it
     *      should only be called if the HBA becomes aware of a new scsi
     *      device (lu) after scsi_scan_host() has completed. If successf=
ul
-    *      this call can lead to device_alloc() and slave_configure() ca=
llbacks
+    *      this call can lead to device_alloc() and device_configure() c=
allbacks
     *      into the LLD.
     *
     *      Defined in: drivers/scsi/scsi_scan.c
@@ -374,7 +374,7 @@ Details::
     *      Might block: no
     *
     *      Notes: Can be invoked any time on a SCSI device controlled by=
 this
-    *      LLD. [Specifically during and after slave_configure() and pri=
or to
+    *      LLD. [Specifically during and after device_configure() and pr=
ior to
     *      device_destroy().] Can safely be invoked from interrupt code.
     *
     *      Defined in: drivers/scsi/scsi.c [see source code for more not=
es]
@@ -627,14 +627,15 @@ Interface functions are supplied (defined) by LLDs =
and their function
 pointers are placed in an instance of struct scsi_host_template which
 is passed to scsi_host_alloc() [or scsi_register() / init_this_scsi_driv=
er()].
 Some are mandatory. Interface functions should be declared static. The
-accepted convention is that driver "xyz" will declare its slave_configur=
e()
+accepted convention is that driver "xyz" will declare its device_configu=
re()
 function as::
=20
-    static int xyz_slave_configure(struct scsi_device * sdev);
+    static int xyz_device_configure(struct scsi_device * sdev,
+                                    struct queue_limits *lim);
=20
 and so forth for all interface functions listed below.
=20
-A pointer to this function should be placed in the 'slave_configure' mem=
ber
+A pointer to this function should be placed in the 'device_configure' me=
mber
 of a "struct scsi_host_template" instance. A pointer to such an instance
 should be passed to the mid level's scsi_host_alloc() [or scsi_register(=
) /
 init_this_scsi_driver()].
@@ -658,7 +659,7 @@ Summary:
   - proc_info - supports /proc/scsi/{driver_name}/{host_no}
   - queuecommand - queue scsi command, invoke 'done' on completion
   - device_alloc - prior to any commands being sent to a new device
-  - slave_configure - driver fine tuning for given device after attach
+  - device_configure - driver fine tuning for given device after attach
   - device_destroy - given device is about to be shut down
=20
=20
@@ -975,7 +976,7 @@ Details::
     *      prior to its initial scan. The corresponding scsi device may =
not
     *      exist but the mid level is just about to scan for it (i.e. se=
nd
     *      and INQUIRY command plus ...). If a device is found then
-    *      slave_configure() will be called while if a device is not fou=
nd
+    *      device_configure() will be called while if a device is not fo=
und
     *      device_destroy() is called.
     *      For more details see the include/scsi/scsi_host.h file.
     *
@@ -985,7 +986,7 @@ Details::
=20
=20
     /**
-    *      slave_configure - driver fine tuning for given device just af=
ter it
+    *      device_configure - driver fine tuning for given device just a=
fter it
     *                     has been first scanned (i.e. it responded to a=
n
     *                     INQUIRY)
     *      @sdp: device that has just been attached
@@ -1004,7 +1005,7 @@ Details::
     *
     *      Optionally defined in: LLD
     **/
-	int slave_configure(struct scsi_device *sdp)
+	int device_configure(struct scsi_device *sdp, struct queue_limits *lim)
=20
=20
     /**
@@ -1024,7 +1025,7 @@ Details::
     *      commands will be sent for this sdp instance. [However the dev=
ice
     *      could be re-attached in the future in which case a new instan=
ce
     *      of struct scsi_device would be supplied by future device_allo=
c()
-    *      and slave_configure() calls.]
+    *      and device_configure() calls.]
     *
     *      Optionally defined in: LLD
     **/
