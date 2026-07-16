Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23D2342539
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 02:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256113; cv=none; b=WdzDT3Vida6ceD3H34b6b0jQPV4mnG1napmTvG8W6UVwAp4ze4gugmzZCHDArVSEvsOK/7AdW1gzTJHn/WN7I0+GC7dM1wBCUOoF31X20ah5frAcCVsoE0N3F2sj2g9iU0uRCH3xPpWIB0I7hEM5PVyHaHErOOqYpVACbzGsbr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256113; c=relaxed/simple;
	bh=DDh2GgbdI5RQMq7gxZncAkacOeotdu9Fzy33SzeLtQY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j/wVkDVFVelU39olWG4bER+RQiB9x/+lnwCSbVFJZDRgMQ5tHkG81rawEYZd++kBgGWe9fbknNzACg3w+ZTql/iPdWTUtyCJAom0Wot/On9Anmf3KzoafFxAzkTVFI58muAukdAa7Y6XooJWIztDb7ouMj3e7Bpwugfb7J6yMK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=orv+ecfv; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="orv+ecfv"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c15d84e3572so360137366b.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 19:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784256109; x=1784860909; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j3nhX204PbzOZptNzEwfrJ1tihihmuj8AGndCLVcQhw=;
        b=orv+ecfvKYOj/yUJ9oD4U8h51O7yL9kYoEFD77GjnYHcrC7r1TX+pEyEgIjl/W1uc8
         ypb7qUSt3+iIF3/wK7fNZnYYyhJH8i6q+LtNOx5XnM3RGFbWPdwlSZmaO7bJx3QJY5yz
         wsMW3wukE8obNz901dtKRSneP+3WIsg6OtooP9O0Dxru+VfNgu5tERuzWp+bRVjNl2eN
         7aoepUmCqPU6qUNXGZIrup5xpUyWsqMYEvcd++EkZRwxSb7sAhyLcx801cRrRzhf+KLI
         H6UG7CR8j+raBCBpuuylPQTpZebyvbXQ40JUSFzPgG4iuw1e4XNdnl3OQScgIR/xikKU
         nWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784256109; x=1784860909;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j3nhX204PbzOZptNzEwfrJ1tihihmuj8AGndCLVcQhw=;
        b=Sd25+S0oJHLV0Azk03EFOUul+zqyz4DrZfkBZO1AlkBOEFtonqGmkAe4o7oK6W9zPb
         bvWmpuSzn5uLHez3tit2yEFieNO6dDUOF/YvthZKBmwZ45fkpdBhzDSMwCkj9sP7mJfx
         oQh1qL0aHsQcXOt5wge8LOvxJQP4lJJoX0vupTuuekdTXaeuTUuvBRWiViIcNl/OdFne
         YAyJGJMnCxU8W+qKvYqOx7FVvqOsM6qiATAd4qcxh+EtmaYWeCcIW5eTOiJxvfYDAPVY
         mbcbFFMn3Vp25mm2EgUItyNdqaCu2AvQnKKqdSw/0UCY6AEJkAf5/luXkzolP39w/eh6
         IMtA==
X-Forwarded-Encrypted: i=1; AHgh+RqNH+jUBFackWMVIPnBokV2TNXu7VUj1DEYTPyMAmlIJeQY9Fzn8Rqa6pbWmWTt2jkcYDWhPeBHciOV@vger.kernel.org
X-Gm-Message-State: AOJu0YyNgdaH/2M5/2941UsZlItdCUgMZeFRpAVzr6wL0fpU9Rk6A0s1
	aiAA8NvBRpr9RCXdu2Re0S43LeiCU3rQAg4XpeDG3hME6DV7JAHeirTAPgB9gJL1IFSXNJMytYC
	nmrKYyxGNyvcnsy9HLg==
X-Received: from ejfr10.prod.google.com ([2002:a17:906:3d6a:b0:c12:5875:9cda])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7203:b0:bed:19af:f89a with SMTP id a640c23a62f3a-c16b46caa65mr21546866b.7.1784256108367;
 Thu, 16 Jul 2026 19:41:48 -0700 (PDT)
Date: Thu, 16 Jul 2026 23:04:10 +0000
In-Reply-To: <20260716230411.2767394-1-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260716230411.2767394-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260716230411.2767394-7-tarunsahu@google.com>
Subject: [PATCH v19 6/7] PCI: Enable async shutdown support
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

Like its async suspend support, allow PCI device shutdown to be performed
asynchronously to reduce shutdown time.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dd0abbc63e18..af2381446406 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1046,6 +1046,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 
 	bus->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(bus->bridge);
+	dev_set_async_shutdown(bus->bridge);
 	pci_set_bus_of_node(bus);
 	pci_set_bus_msi_domain(bus);
 	if (bridge->msi_domain && !dev_get_msi_domain(&bus->dev) &&
@@ -2748,6 +2749,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	pci_reassigndev_resource_alignment(dev);
 
 	pci_init_capabilities(dev);
+	dev_set_async_shutdown(&dev->dev);
 
 	/*
 	 * Add the device to our list of discovered devices
-- 
2.55.0.229.g6434b31f56-goog

