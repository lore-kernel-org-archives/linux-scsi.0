Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0B92ECE86
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 20:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791490777; cv=none; b=EZ6rGprwUCh7CPzY2dLeglm7ofMwVE9Bq62awbkgQYkDz7MqNZv1JlWEc8ppz+P6s0E+SSMNnWKtw9xN7QLQxaycrhTrUa4b0lLl+CYqiZF5WxPTmIlD8CPqyLQCFYH0ueYjuPrUMlQJp2XdAM9QLoKXC8KeNltThlytbZYEE7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791490777; c=relaxed/simple;
	bh=V4nGewSKdUX/A09r8ENbXyQsI9uD5wAzJQm7heOTQ6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnpuAyte9vX58eR84Lwmr2xx43zt/gsB6a+2dUshlGDxtp/hfSsEYwoYI6PzQgZO2LtnzcZmLdiBJd3sxa31pVUWN3cxhMkloOv9ZAUahQ/BAHMknqF6XFwudqCKxX2Y8g3bK2KgLhUFWxL2mvR7p3csEQDS094kg01eKh+H0WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g7SO1PbT; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g7SO1PbT"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a02753c04fso19606585e9.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 13:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791490775; x=1792095575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V4nGewSKdUX/A09r8ENbXyQsI9uD5wAzJQm7heOTQ6w=;
        b=g7SO1PbTc44sStm/PmJeOrT3oEkBhNAchBDgP06iFthOpQyZWayzaMJuX8jeHXzw9L
         aZ2t/JMZGYre4G+BtBnF6Rc3zwl8L43hPn9QIAsw5FayI/+67s3wnJkUIE72W5NNJyXN
         sv827OlJFCvmcT2z5m83iju+OAg7tQDlql1Ri6Z4iokkzv4JjSUEwUk2q0SmpkpiLmCt
         iqTiiBXOoT04as47ExEIUKP0GDAVZXKBCEUvPJ0QVre9Yh8lEbijVVbN9gQz6254qIvu
         RHE+BuQlSnVxb8WMsWgjlveLJoXvT8fE5NAp+vJ2M9cKkog96QGPfDc7W81yUZ27mYXU
         ioDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791490775; x=1792095575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V4nGewSKdUX/A09r8ENbXyQsI9uD5wAzJQm7heOTQ6w=;
        b=Pha9fizGfFUtAAcP5O+TPpCh20Swg4DqWyzLFxTc2PyH9hQF4IawI1PY8FtzY9A9tt
         b5KNwK5SpIZuzVYRhnykR2wpTMvgd0ASON7oZTLdxxZFczZQckkLgkKUoh5kDxgBAC2x
         3Ck2ZX0Vm//XS76bfDmlDMHSIwHv/vjsA1rjV73nTC4Zvimd4Ip8HU38i2IUjgdAAR7P
         1d8DREkdLMmm+y8xz53DXaWdDsYxNRS/kUE/2+RXevFCvxgqzKxIpLnzUZZMvprMhqZg
         OCTZaeL0/HnJ0OqM4DHfaq8jJaYFT2Y2NeW4WTXuQBPgABzgzY9ov6CNnTcK7RixKdoU
         V/7A==
X-Forwarded-Encrypted: i=1; AKwUvBzrCzf47nc/PUggHeRrNUaAXWrUQcMGQY1iqG6ZTtsWbIljMdbnXc11eghOzNYC5DvL1dc61E7lEajY@vger.kernel.org
X-Gm-Message-State: AFuF++lmmPIwIlihSyZuJWP6pKsQIe43nMXXhkiG4+en1eKK0mpMGgh0
	f43Qatx1dGefeWt9Ogi8nHFZA4/EMFcY64ozKO1+6JHeliCGrFrleD4K
X-Gm-Gg: AYBFou1FR6toSHG0caiWS9E9HlCS4cs+u72dQzUE71XZ5uT4CisHRIuC88VflbgffGT
	V+vju6wtaQ2q8bc3EO4BgK3ovIRG4b91LFzcCrxEqI2GfsllP9byiw6Qe2UK0kr7VaWDFYc124j
	jCS/3YX/SmPCJIDRko2wDY5TEoJOlv7IW/ep1gMI+WA1yz3A3yqzLXuOQATDbgWI5HXEFXfoTYG
	a+gmPpdbHMMPY1aVxCK1nlTc/tK5hkWVVmGIpNXc2v9UQogqGgZBfHmpYz4JHp4jjP0LUqQ46Z9
	I9L6TIqd3mNeTnKJnSx5AuTq+GR9DutsTa8QxRZ1AgZphTw2syijg4s84lQ10Xntt6oIN6dd5A/
	o1n5nqiKi9Ia5BV2xRuB1SNcBIWfXKwhYziCSLOg3GOqWmy8K3CvOc/XTQJ/Au75kt1ZYPfT/EM
	7/vVEA8xQ0fMHXmCMrMjbFsEflXBR0AZxst9yVea55qx3K++wW4WBOxxPYqw/wPoD9D3N/z8RiL
	QeXw/3ivlHzsmuDGYOjApzdit8=
X-Received: by 2002:a05:600c:4688:b0:4a0:8b1:f5c with SMTP id 5b1f17b1804b1-4a18042a422mr121557365e9.22.1791490774492;
        Thu, 08 Oct 2026 13:19:34 -0700 (PDT)
Received: from darkstar.tail74c586.ts.net ([217.201.94.121])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf2343asm10384275e9.9.2026.10.08.13.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 13:19:34 -0700 (PDT)
From: Luca Cecchi <luca.cecchi.info@gmail.com>
To: oneukum@suse.com
Cc: linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	stern@rowland.harvard.edu,
	Luca Cecchi <luca.cecchi.info@gmail.com>
Subject: Re: [PATCH v2 1/2] usb: uas: implement .change_queue_depth to allow per-device queue depth override
Date: Thu,  8 Oct 2026 22:19:20 +0200
Message-ID: <20261008201920.40700-1-luca.cecchi.info@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <07d145c7-08a2-44ee-ac00-46535e0ca9e9@rowland.harvard.edu>
References: <20261008112645.1820678-1-luca.cecchi.info@gmail.com> <20261008122604.1862534-1-luca.cecchi.info@gmail.com> <07d145c7-08a2-44ee-ac00-46535e0ca9e9@rowland.harvard.edu>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Oliver, Alan,

(Resending in plain text - my previous reply went out as HTML and got bounced
by the list software. Apologies for the noise if it reaches you twice.)

Quick status update before sending v3. Both pending items are already fixed
locally: dropped the qdepth-guard per Oliver's note (that's a separate general
issue, not something this patch should carry a workaround for), and trimmed
the comment per Alan's feedback.

While re-validating today, something changed the picture: repeating our
original load test (the one that found the safe queue-depth threshold)
against the exact same Lexar ES3 unit, but now also on Windows with a
completely different driver stack (UASPStor, not Linux's uas), reproduces the
same command-timeout/reset behavior we'd previously only seen on Linux. Since
the physical drive/bridge is the only thing in common between the two
reproductions, this points to the test unit itself having degraded since our
first round of testing on Oct 4, rather than anything in the driver or the
patch.

We'd rather not send v3 until we can re-validate it properly, which isn't
meaningful right now if the hardware itself is behaving inconsistently. We'll
follow up once we've sorted out whether this drive is still usable for
testing - hopefully it hasn't given up on us for good.

Thanks again for the time and the careful feedback on this, it's genuinely
appreciated.

Luca
