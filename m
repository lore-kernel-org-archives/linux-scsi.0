Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952E91F8F1E
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 20:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728420790; cv=none; b=jRN7kZz2J/47t18mZgkkpPXQed2i7eTHTN0x6ffmZh2eUefPF0GTngTY9DMB95hGO7SM5D2nyaQ34SV9v/skFAY/3js+aD7d0sBqADU90erqzyuz5l/WwkCcYFiW1nGtUMdwFP/MEiSrk7KWhTTUQU9wwL7WYMuYyq+vvepGFC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728420790; c=relaxed/simple;
	bh=EYYQQNaJxOq2uSck0dQ1qIG3HkLIfGB1rzrNq6xH874=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAh1aDzsEkwC6XKFvSX5ry/WiPUvYTeITP+9era4HynaKNylc5zLzNZikDIxDaiifE1Vg4mj4CcOA+gtHKehL9mxbbWfhOLLI35cOhjrFn4B/gvzp8F3rj2vu3BOolVO8d8AYLgQYns51HM3BuvbuoYPhRyGDJeB6omgMdB+M5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1nVzNGEv; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1nVzNGEv"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XNSsJ2QFFzlgTWP;
	Tue,  8 Oct 2024 20:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1728420783; x=1731012784; bh=61VZ5
	p6HhJLCPTmVwfS8V1DKni+mGKHfNP1L2zR6+W8=; b=1nVzNGEvdTGkK6ihV2r89
	uLTGNt8zN1frJ4MrWW1w1xHNjHZiNZXQeIS5JTymIc/5I35JM9d8qo0zIA65I4dZ
	qcxoCn30N0/mPUvfSKSlEbJsZdtktLIUk9PK5f5TgCKDcdoDR3ZRv3EEeAF5zRTY
	ICJvXzgl3tgedaHSNETDc4WC5ijbXfnOgszF9o+JoJDxDDMFNKK55wN5kJ2rtq1T
	M+8DAvKAcziaQG3Nxu5Bwp3WwFepWij701iP80MQoD+aozKf0O4gE3Be5rJqFUHS
	ud5kriaV41KqmHRLnVauw7cL0NLPHe5EgjhDIfrQhMxdSvnXSJm+YjCBxYXvKSYz
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FxKE0dZvopU1; Tue,  8 Oct 2024 20:53:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XNSrw3sjCzlgMVL;
	Tue,  8 Oct 2024 20:52:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v3 6/6] scsi: core: Update .slave_configure() references in the documentation
Date: Tue,  8 Oct 2024 13:50:52 -0700
Message-ID: <20241008205139.3743722-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
In-Reply-To: <20241008205139.3743722-1-bvanassche@acm.org>
References: <20241008205139.3743722-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Now that .slave_configure() support has been removed, change all referenc=
es
to .slave_configure() into .sdev_configure() in the SCSI documentation.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/scsi_mid_low_api.rst | 30 ++++++++++++-------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi=
/scsi_mid_low_api.rst
index 1330cfb6eaaf..a93df7c3ae50 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -150,10 +150,10 @@ scsi devices of which only the first 2 respond::
     scsi_scan_host()  -------+
 			    |
 			sdev_init()
-			slave_configure() -->  scsi_change_queue_depth()
+			sdev_configure() -->  scsi_change_queue_depth()
 			    |
 			sdev_init()
-			slave_configure()
+			sdev_configure()
 			    |
 			sdev_init()   ***
 			sdev_destroy() ***
@@ -163,7 +163,7 @@ scsi devices of which only the first 2 respond::
 	respond, a sdev_init(), sdev_destroy() pair is called.
=20
 If the LLD wants to adjust the default queue settings, it can invoke
-scsi_change_queue_depth() in its slave_configure() routine.
+scsi_change_queue_depth() in its sdev_configure() routine.
=20
 When an HBA is being removed it could be as part of an orderly shutdown
 associated with the LLD module being unloaded (e.g. with the "rmmod"
@@ -203,7 +203,7 @@ An LLD can use this sequence to make the mid level aw=
are of a SCSI device::
     scsi_add_device()  ------+
 			    |
 			sdev_init()
-			slave_configure()   [--> scsi_change_queue_depth()]
+			sdev_configure()   [--> scsi_change_queue_depth()]
=20
 In a similar fashion, an LLD may become aware that a SCSI device has bee=
n
 removed (unplugged) or the connection to it has been interrupted. Some
@@ -222,7 +222,7 @@ upper layers with this sequence::
=20
 It may be useful for an LLD to keep track of struct scsi_device instance=
s
 (a pointer is passed as the parameter to sdev_init() and
-slave_configure() callbacks). Such instances are "owned" by the mid-leve=
l.
+sdev_configure() callbacks). Such instances are "owned" by the mid-level=
.
 struct scsi_device instances are freed after sdev_destroy().
=20
=20
@@ -331,7 +331,7 @@ Details::
     *      bus scan when an HBA is added (i.e. scsi_scan_host()). So it
     *      should only be called if the HBA becomes aware of a new scsi
     *      device (lu) after scsi_scan_host() has completed. If successf=
ul
-    *      this call can lead to sdev_init() and slave_configure() callb=
acks
+    *      this call can lead to sdev_init() and sdev_configure() callba=
cks
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
+    *      LLD. [Specifically during and after sdev_configure() and prio=
r to
     *      sdev_destroy().] Can safely be invoked from interrupt code.
     *
     *      Defined in: drivers/scsi/scsi.c [see source code for more not=
es]
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
@@ -658,7 +658,7 @@ Summary:
   - proc_info - supports /proc/scsi/{driver_name}/{host_no}
   - queuecommand - queue scsi command, invoke 'done' on completion
   - sdev_init - prior to any commands being sent to a new device
-  - slave_configure - driver fine tuning for given device after attach
+  - sdev_configure - driver fine tuning for given device after attach
   - sdev_destroy - given device is about to be shut down
=20
=20
@@ -975,7 +975,7 @@ Details::
     *      prior to its initial scan. The corresponding scsi device may =
not
     *      exist but the mid level is just about to scan for it (i.e. se=
nd
     *      and INQUIRY command plus ...). If a device is found then
-    *      slave_configure() will be called while if a device is not fou=
nd
+    *      sdev_configure() will be called while if a device is not foun=
d
     *      sdev_destroy() is called.
     *      For more details see the include/scsi/scsi_host.h file.
     *
@@ -985,7 +985,7 @@ Details::
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
@@ -1004,7 +1004,7 @@ Details::
     *
     *      Optionally defined in: LLD
     **/
-	int slave_configure(struct scsi_device *sdp)
+	int sdev_configure(struct scsi_device *sdp)
=20
=20
     /**
@@ -1024,7 +1024,7 @@ Details::
     *      commands will be sent for this sdp instance. [However the dev=
ice
     *      could be re-attached in the future in which case a new instan=
ce
     *      of struct scsi_device would be supplied by future sdev_init()
-    *      and slave_configure() calls.]
+    *      and sdev_configure() calls.]
     *
     *      Optionally defined in: LLD
     **/
