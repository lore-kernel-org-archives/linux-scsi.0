Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47D933F5A9
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 02:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256110; cv=none; b=LnKBlxcyFHKEOwTO1p+GYIJroZafjVoqynZPly93VL54rxqnxk0ZLgaCcXDCcGYjs+daMqmefid6exQ3Nw/Ddie5Gpr7x1lToh9N/bGML1kWZwKAJP6FLOhkfMNbHESbClvO8DJyFtYSpfDud8D6j7cOPB7QhmW6d55LXBNGes0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256110; c=relaxed/simple;
	bh=84Dxy+IQXZ+Io/tsnEE56Nrw1ZiDroBdIIccATE0oog=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ogfLZGPzthhr69z3DAaRhasYip6kEd0yeH+THvhOTM4IYtB3p+H3832LpvDXbE/IpkOfsdbI61Q5/fs+A2nfulmbsb09Gtde66o7jO2huDliCTNNaLGcMe2P1+/vvJaxIAap5US9NSjg49CsIfwWNcN3ifwzOp6ensATNrmgVNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aV0NDUUa; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aV0NDUUa"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-47e81aca584so3792024f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 19:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784256106; x=1784860906; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v9ZzsR0v39hzEb6iXWVS0iiD5j1ThrMppOubfeQ9NoI=;
        b=aV0NDUUalJEVRuA4IO9jSbMXoB0AMDr5fprzU6ZVzx4b0dY+r1xs0R2RMJ3nK2BLYi
         /LNT3fkqTSK++WOOs1JSFn2RtDIq2rxcJDu+GJH0bfZTT/lBeaiCShtFuEKGKYLPhVkK
         mLeU+xBayM3jnah645b69Q1tO3LRPoCAY9UchHrPN8ZQWH7+uSj7+Mv7Jt4uSdZRzY9e
         k4lB3izQeu0KJ8QPRegQPmPvDN7AhSPzpZeiS84voDXN/PfS9SGu/vJ6eDc1hpHH3TGw
         l8vhDj+GzqJ1lWlj4GYjBPyT7IGP4Oi3FJ+CwMM1F5gMihaG+eUxF8nuzGKxTl1DeUR5
         IIWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784256106; x=1784860906;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v9ZzsR0v39hzEb6iXWVS0iiD5j1ThrMppOubfeQ9NoI=;
        b=jTizhqRMDJ3N5pnjBi6URNJ+zrG8Tg04UuFSQRofBjuCbakQevy3LYNyd7vXQdxqkL
         CL7ysmrK5WNgkDRCA/zzaMEjKK/YE/QWbfUBkWD5spvDm02L3JwVaj6JMGh2n+5EzY4c
         iLRA0for7+AcKh8K0uZShh1KJtXc3gJPqUN+66Mvw+M9o/XHaUltcwyWUt+SgRpIhMK/
         i5wGa9YF6UGvwhG9/0izYfdrbDG1mPCPBS8yaPqjqhGLO2yk1OksSMoABw8ndzlvvqqv
         oX6hXNueWV+CjAhOLna7dKM5gs4ZWden77KEeY/rx4umijE9DXvi20YHKothwxu/9Wj4
         CXyQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro3k9IMygVoqktMbic5hGaTAtFbMmYEcp+9FMUMY8MizVekp8zmwkQX3qp8r/xvHklHJ4TZLfpEC9lb@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+oL+3LmA0tV3tiM9e2lz4ca4lcNr7tkbNpMPw0MC/ihDuXg/E
	zjz6u+LCfceZ8WMjCZlcANv9zdfzEuyTsD3elW+E7jFGL+emBcmIS0tJqr6/dBB4ZKn1QHZ+5mZ
	xw+ONlmo2cMMMEkxxCw==
X-Received: from wrmh8.prod.google.com ([2002:adf:e988:0:b0:463:dd19:ae30])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5d12:0:b0:475:f0f0:9f04 with SMTP id ffacd0b85a97d-47f6235475bmr740733f8f.59.1784256105583;
 Thu, 16 Jul 2026 19:41:45 -0700 (PDT)
Date: Thu, 16 Jul 2026 23:04:07 +0000
In-Reply-To: <20260716230411.2767394-1-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260716230411.2767394-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260716230411.2767394-4-tarunsahu@google.com>
Subject: [PATCH v19 3/7] driver core: separate function to shutdown one device
From: Tarun Sahu <tarunsahu@google.com>
To: Shuah Khan <skhan@linuxfoundation.org>, Danilo Krummrich <dakr@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Rafael J. Wysocki" <rafael@kernel.org>
Cc: bvanassche@acm.org, john.g.garry@oracle.com, mlombard@redhat.com, 
	loberman@redhat.com, mclapinski@google.com, dmatlack@google.com, 
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, jordanrichards@google.com, souravsgl@google.com, 
	stuart.w.hayes@gmail.com, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, emilne@redhat.com, jmeneghi@redhat.com, 
	linux-scsi@vger.kernel.org, David Jeffery <djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"

From: David Jeffery <djeffery@redhat.com>

Make a separate function for the part of device_shutdown() that does the
shutown for a single device.  This is in preparation for making device
shutdown asynchronous.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 drivers/base/core.c | 71 +++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 78b90326addb..82a7af1f3ba2 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4898,12 +4898,48 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
 	return error;
 }
 
+static void shutdown_one_device(struct device *dev)
+{
+	struct device *parent = dev->parent;
+
+	/* hold lock to avoid race with probe/release */
+	if (parent)
+		device_lock(parent);
+	device_lock(dev);
+
+	/* Don't allow any more runtime suspends */
+	pm_runtime_get_noresume(dev);
+	pm_runtime_barrier(dev);
+
+	if (dev->class && dev->class->shutdown_pre) {
+		if (initcall_debug)
+			dev_info(dev, "shutdown_pre\n");
+		dev->class->shutdown_pre(dev);
+	}
+	if (dev->bus && dev->bus->shutdown) {
+		if (initcall_debug)
+			dev_info(dev, "shutdown\n");
+		dev->bus->shutdown(dev);
+	} else if (dev->driver && dev->driver->shutdown) {
+		if (initcall_debug)
+			dev_info(dev, "shutdown\n");
+		dev->driver->shutdown(dev);
+	}
+
+	device_unlock(dev);
+	if (parent)
+		device_unlock(parent);
+
+	put_device(parent);
+	put_device(dev);
+}
+
 /**
  * device_shutdown - call ->shutdown() on each device to shutdown.
  */
 void device_shutdown(void)
 {
-	struct device *dev, *parent;
+	struct device *dev;
 
 	wait_for_device_probe();
 	device_block_probing();
@@ -4925,7 +4961,7 @@ void device_shutdown(void)
 		 * prevent it from being freed because parent's
 		 * lock is to be held
 		 */
-		parent = get_device(dev->parent);
+		get_device(dev->parent);
 		get_device(dev);
 		/*
 		 * Make sure the device is off the kset list, in the
@@ -4934,36 +4970,7 @@ void device_shutdown(void)
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
 
-		/* hold lock to avoid race with probe/release */
-		if (parent)
-			device_lock(parent);
-		device_lock(dev);
-
-		/* Don't allow any more runtime suspends */
-		pm_runtime_get_noresume(dev);
-		pm_runtime_barrier(dev);
-
-		if (dev->class && dev->class->shutdown_pre) {
-			if (initcall_debug)
-				dev_info(dev, "shutdown_pre\n");
-			dev->class->shutdown_pre(dev);
-		}
-		if (dev->bus && dev->bus->shutdown) {
-			if (initcall_debug)
-				dev_info(dev, "shutdown\n");
-			dev->bus->shutdown(dev);
-		} else if (dev->driver && dev->driver->shutdown) {
-			if (initcall_debug)
-				dev_info(dev, "shutdown\n");
-			dev->driver->shutdown(dev);
-		}
-
-		device_unlock(dev);
-		if (parent)
-			device_unlock(parent);
-
-		put_device(dev);
-		put_device(parent);
+		shutdown_one_device(dev);
 
 		spin_lock(&devices_kset->list_lock);
 	}
-- 
2.55.0.229.g6434b31f56-goog

