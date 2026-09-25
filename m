Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D594CE662
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790359764; cv=none; b=E/WYZ3cJuqz1hfhXoWwzjIEVL2ExBB5U3v4V1m13Gqda30RQFB8F+tQLsbN1R/li3Mo4xsUGu5IpTlkOkos+dAVq+N1IPXPypHNhw8fBUnBvenCMSqvYGRLVO9/vnmPpOqjNWZc0eUKrTJCn85QO2L6mnHY34tBuuyeiwP1fdIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790359764; c=relaxed/simple;
	bh=tRtd1uFFd4kUdV4m5rR2k0bHW/yymp/eFIk/mal9ok0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iZGM+w3MX0QPIazaicsiB5vg2IUHT66b20/JVlKck+daGSrkqrhilkqHiIHUMbcEc0EBjGVzQocSQuF0fmdv4/05Ct61LowJ2lOAYsR3yyjMXGTOmfO4AKBbq97jRci8Tz/M7XJM5/50l2hfnKTf4P1aGFv8W3pO5mZ0qW1zw4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XeUvIjps; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XeUvIjps"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzHQ2tQHz1XM4Tl;
	Fri, 25 Sep 2026 18:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1790359756; x=1792951757; bh=qc3fZlLt9oOCJJvzubC3i/jKoEKStRLQFZc
	gi3tNd8k=; b=XeUvIjpsE3hazzRCVmVb/HfazKBQe1dcjQmXfflGl51+7xb5+8G
	vEAPtFGAPoCHv0gMKH56i5N6JmXN+ZzbHVo4AD2tVkClfiEGLl0n//KnP/+tVzsa
	xz5dUeg5mtJ3Vf1QjGsPg8V/V1vPRC2H5Pac7oHSQUGFUUwRWr7c1hUdPSv/FTbO
	f/Kuzt6WU0410N/qHFNML66aZPU4U7DipIBP/Fi7vu6zlaL9eM8gcwdkeGXj6ibp
	rXKt0J7MEvwmOJLHT1BjHAwD1SGELemxxXrOAywiBGIVybK6Qez2Ie9GhrpgSk9T
	XPlhroYN8umAA8hQruUNNXxIzCiquIFWmuA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YPj3uodSLA8y; Fri, 25 Sep 2026 18:09:16 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzHF6sKrz1XM4Sx;
	Fri, 25 Sep 2026 18:09:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.garry@linux.dev>,
	Hannes Reinecke <hare@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] scsi: core: Fix scsi_done() documentation
Date: Fri, 25 Sep 2026 11:08:59 -0700
Message-ID: <9d10e1068d75c1a708b3a56e85782d651411fe06.1790359673.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Commit 11b68e36b167 ("scsi: core: Call scsi_done directly") changed
scsi_done from a function pointer member into a regular function.

Replace all references to the scsi_done function pointer member
with references to the scsi_done() function.

Cc: John Garry <john.garry@linux.dev>
Cc: Hannes Reinecke <hare@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/scsi_mid_low_api.rst | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi=
/scsi_mid_low_api.rst
index 5489e9d07ab7..84cf61b2d6ae 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -865,7 +865,7 @@ Details::
     *
     *      Other types of errors that are detected immediately may be
     *      flagged by setting scp->result to an appropriate value,
-    *      invoking the scp->scsi_done callback, and then returning 0
+    *      invoking the scsi_done() function, and then returning 0
     *      from this function. If the command is not performed
     *      immediately (and the LLD is starting (or will start) the give=
n
     *      command) then this function should place 0 in scp->result and
@@ -873,11 +873,11 @@ Details::
     *
     *      Command ownership.  If the driver returns zero, it owns the
     *      command and must take responsibility for ensuring the
-    *      scp->scsi_done callback is executed.  Note: the driver may
-    *      call scp->scsi_done before returning zero, but after it has
-    *      called scp->scsi_done, it may not return any value other than
+    *      scsi_done() function is called.  Note: the driver may
+    *      call scsi_done() before returning zero, but after it has
+    *      called scsi_done(), it may not return any value other than
     *      zero.  If the driver makes a non-zero return, it must not
-    *      execute the command's scsi_done callback at any time.
+    *      call scsi_done(scp) at any time.
     *
     *      Locks: up to and including 2.6.36, struct Scsi_Host::host_loc=
k
     *             held on entry (with "irqsave") and is expected to be
@@ -887,16 +887,16 @@ Details::
     *      Calling context: in interrupt (soft irq) or process context
     *
     *      Notes: This function should be relatively fast. Normally it
-    *      will not wait for IO to complete. Hence the scp->scsi_done
-    *      callback is invoked (often directly from an interrupt service
+    *      will not wait for IO to complete. Hence the scsi_done()
+    *      function is invoked (often directly from an interrupt service
     *      routine) some time after this function has returned. In some
     *      cases (e.g. pseudo adapter drivers that manufacture the
-    *      response to a SCSI INQUIRY) the scp->scsi_done callback may b=
e
-    *      invoked before this function returns.  If the scp->scsi_done
-    *      callback is not invoked within a certain period the SCSI mid
+    *      response to a SCSI INQUIRY) the scsi_done() function may be
+    *      invoked before this function returns.  If the scsi_done()
+    *      function is not invoked within a certain period the SCSI mid
     *      level will commence error processing.  If a status of CHECK
-    *      CONDITION is placed in "result" when the scp->scsi_done
-    *      callback is invoked, then the LLD driver should perform
+    *      CONDITION is placed in "result" when the scsi_done()
+    *      function is invoked, then the LLD driver should perform
     *      autosense and fill in the struct scsi_cmnd::sense_buffer
     *      array. The scsi_cmnd::sense_buffer array is zeroed prior to
     *      the mid level queuing a command to an LLD.
