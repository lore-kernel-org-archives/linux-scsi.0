Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D72F33D503
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 02:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256110; cv=none; b=sjh9Zr1zIp7wW+KBeUynf63ibjganMWkwIHOq0C+90+HCGwP+6dmZqbhAwzIXIw1dZFaU4fuzG3IHopODPW/QV3Feu/6FfE0nreT+nzfiFb9icnBjMI3bzQUpJIVucSoBoMKTRnac3wJ7jLcMp9xwHcthEVv1JPmG3gRY3MjdgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256110; c=relaxed/simple;
	bh=KH/ARVjO6KZqlgIJZ1WbqwS9YnBGnwAD01sy0uaFPNc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EI0IM4WU2+Vf4zaHEzdir0xXaGkT4kj8MqZ9AbV+J3QYWWN8aqtCaMjobKbajFsKVXXpI35tVqc6hJ2wIG0Y0wyn/oavAEsNMoPQosuERR6MjfHKXb4sEi612LxOKPl17rJj2PHm0S+fjWepAgqMMhxS2j3okhlVvuF/uz73048=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DcJqkWZB; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DcJqkWZB"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c158b6e31aaso104532666b.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 19:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784256107; x=1784860907; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kNEDG9WfHYH4efBdhIMziRHnrMAb5uPezNVzt5EuvWI=;
        b=DcJqkWZBRf2GuSm85TbSk//3Q06uwxJu6aO496mHJV3VBZY3e66PiCZLTe7F+tP4vg
         Z2/Z/zWWZDKP9q+4ESQ9rPnfuxZJ6isaI10ZipudmIveNlnsn/U1io3D2+1cYeMSKtRA
         I3ZsviIBeeodUHfvwtvmbwyO+mz9P2gS98NyIoLfnzgjGs/uZwkNGhVP72iz6WNZaO14
         88ftNlOaXXFTrqrLO+MUBCrTcv6HDF3HlkelU+PTYEGpEoA+cFfOXBduG68X62V91hv0
         iULuKBlZ0QDi7oL5IxgQYiYAgJe2FsVplDoPwzxe2YJfbneQ9ARbFlsc0RNnObQa/Qkt
         PZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784256107; x=1784860907;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kNEDG9WfHYH4efBdhIMziRHnrMAb5uPezNVzt5EuvWI=;
        b=jZH2oDJesTVJTtBdfd2v0lK7ECg9nWu344qIiG8/5bLtqlbpApJfNG7AuoX99Bwue+
         VuQA3apBQEC87cGON5UwLGz70a9PtCRx3Mrg8mD0hK6HJKuZK/BD5RPMRF93gzfqn6Xs
         aQUr/4hDQEM39ymh/yYwI63C4THwBSIikeL73mbudLNQWiqVNsRLG283bFw9PfU6AvBF
         WHeIHmz+VhppzTfMkLOX+1gQJgAjBmVfWXkiYPR/m/OqfbbgK6+UtI9JytLxCPO7PRNY
         mTfScVGEhQRqZQc7IlBI1brJyiso/+yVCSJlTFjYfWMDQzcK55gQEqhpUJkwBcOMeeR2
         bZmA==
X-Forwarded-Encrypted: i=1; AHgh+Rp8a8ZEea61WfAwU2+G6vIx0/BBFl41GYCeI9TUu/TYMZx5JRBUCu/1PaCQNa+vmT9JI8kKeXlegBMb@vger.kernel.org
X-Gm-Message-State: AOJu0YyAyhSMdoXEPhdJTvMN8b3663U6AlgG3g9raOJK5rbvPLxr51xi
	MLXm7LKDFUdKYntqiM3iKD7f+hCZMRyVZ7S/8BCA9QFgg6WO1V36wGdMyiVfrxfJ2kue/8DKCS0
	Udh7riT0oC8a4eFJB1w==
X-Received: from ejbgg8.prod.google.com ([2002:a17:906:e288:b0:c12:6e0e:a4b6])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:abcc:b0:c17:1295:265c with SMTP id a640c23a62f3a-c1712952993mr6792166b.21.1784256106546;
 Thu, 16 Jul 2026 19:41:46 -0700 (PDT)
Date: Thu, 16 Jul 2026 23:04:08 +0000
In-Reply-To: <20260716230411.2767394-1-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260716230411.2767394-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260716230411.2767394-5-tarunsahu@google.com>
Subject: [PATCH v19 4/7] driver core: do not always lock parent in shutdown
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
	linux-scsi@vger.kernel.org, David Jeffery <djeffery@redhat.com>, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Jeffery <djeffery@redhat.com>

Don't lock a parent device unless it is needed in device_shutdown. This
is in preparation for making device shutdown asynchronous, when it will
be needed to allow children of a common parent to shut down
simultaneously.

And only acquire a reference to the parent device if the parent is to be
locked.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/base/core.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 82a7af1f3ba2..31f95e86856e 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4898,14 +4898,10 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
 	return error;
 }
 
-static void shutdown_one_device(struct device *dev)
+static void __shutdown_one_device(struct device *dev)
 {
-	struct device *parent = dev->parent;
-
-	/* hold lock to avoid race with probe/release */
-	if (parent)
-		device_lock(parent);
-	device_lock(dev);
+	if (!dev->p || dev->p->dead)
+		return;
 
 	/* Don't allow any more runtime suspends */
 	pm_runtime_get_noresume(dev);
@@ -4925,12 +4921,32 @@ static void shutdown_one_device(struct device *dev)
 			dev_info(dev, "shutdown\n");
 		dev->driver->shutdown(dev);
 	}
+}
 
-	device_unlock(dev);
-	if (parent)
+static void shutdown_one_device(struct device *dev)
+{
+	struct device *parent;
+
+	device_lock(dev);
+
+	/* use parent lock if needed to avoid race with probe/release */
+	if (dev->bus && dev->bus->need_parent_lock && dev->p && !dev->p->dead &&
+	    (parent = get_device(dev->parent))) {
+		/* the parent lock needs to be acquired first, so re-lock */
+		device_unlock(dev);
+
+		device_lock(parent);
+		device_lock(dev);
+
+		__shutdown_one_device(dev);
+		device_unlock(dev);
 		device_unlock(parent);
+		put_device(parent);
+	} else {
+		__shutdown_one_device(dev);
+		device_unlock(dev);
+	}
 
-	put_device(parent);
 	put_device(dev);
 }
 
@@ -4956,12 +4972,6 @@ void device_shutdown(void)
 		dev = list_entry(devices_kset->list.prev, struct device,
 				kobj.entry);
 
-		/*
-		 * hold reference count of device's parent to
-		 * prevent it from being freed because parent's
-		 * lock is to be held
-		 */
-		get_device(dev->parent);
 		get_device(dev);
 		/*
 		 * Make sure the device is off the kset list, in the
-- 
2.55.0.229.g6434b31f56-goog

