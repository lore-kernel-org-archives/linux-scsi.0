Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D723234
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730218282; cv=none; b=U+SmOM178rVmo23vhqJwyAN5Ecm0cXkNcHyfbGx59NkyWXHvsltffq28snRC5PunM1JxSre6XuctdsTgW7YrB9/OnXDevw6RTemzodizwjZclVFoTL9hH9OU9u1bdbzY65Th6asTWS4u0lclp0P7FyuXoSZzg59UL3C2kuvBsYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730218282; c=relaxed/simple;
	bh=srjNy+TVZKAgFFLz9s1dBvaSr3T1Nyiwu6ZcjFX7ZFU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J6KQdcHxqXdIzSrvM5BwWehikUv6diCPUTdaODIUoHcNIdROldwGuUQttuBtuCQonEmL2xqD6huzz+QLM1k7aZ4DUhFiRXFO/ph7flS6bo+lSbdxZm4f3Go8euqr+zu6FRounSD3Wdr92B9qhl99y1ZsGfHPJt/bFbbBTAscEC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fTN4Bj88; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTN4Bj88"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539fe02c386so6065702e87.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 09:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730218278; x=1730823078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J22/KDQPC3YJgGycC6+5gOjxNCYYORK65McdetT5T74=;
        b=fTN4Bj885Xv2IHXEddaRyLtU5aoE6dPIlQkvoT6vYnv3s1hXEisocxHNIs01W/CiE7
         qVjZ0paac70gDgdPrASjzYw2aoT/vUAkk0WawO5AtUOCqLpuiJ/AH8UB4I04RgP4+dX1
         BJic9eLc/Q0EAysGJeJ9PY9OuP9ydmps+rYzGZC8/nMq+ruNYa/3qqEG6BoyPiPqvJrC
         hTCRhCXGN9UrfMrkbKaE3Rng1woWnkrn9C+NsC8xf1kP3yZVxy9euO30VxzlTIVk+xJQ
         vg1SPUSI8ZYcSffVbof+Pi+BB9UGFDi2PzzIBVu9XrGpRBEkyEljiiL5eIKGPzT1DNfG
         eYjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730218278; x=1730823078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J22/KDQPC3YJgGycC6+5gOjxNCYYORK65McdetT5T74=;
        b=eqcAaDe89DkDL64he1VWSAp03koxvqQ2EBIyYVebNQabpycWRFBTMkJoAUY3L/Tv/9
         PJOQzqSSPrdVhrPtbFspex/PFcEUTNx+uVNxPRwoSdAekkb8W0BuWUR4faMwFRPPosbZ
         K+JJqGz0fyJMF0tTPbdn4qoWW8bL99RP72kEWVW0qZ3OL30UA/DMHxjVoshb0dl3YYVR
         XQ+gjT9oVRbP/Kz4Y7pfqIRtyfAjt2w/u2zpN5KXX9Mj94nSAugZMzrWL9LKzzYF+/V5
         8JBNk6Dt/qVnoJqVOzQFD5+Bs3WXmQpJ9XwrpIETJHWWL4FBHciuxZF0NMNLkYJSCQQZ
         BH2A==
X-Gm-Message-State: AOJu0YwhNQk3pVoLoYLKG1roN1Aycyl3DXKEkpgc+pYiyOjhLlNq3MEb
	s9iSU1PW43edt3fhKP7qpdD3OITxC7Mc6ohT5TWc69lNR1rSzbDr/yHZ7g==
X-Google-Smtp-Source: AGHT+IEu1gpE0FQ/wjP87yZ8Qbwukfd23WIJRcRUveODamm1KOMlKLTodmmGFFmkMA6ajtHEaDLMQw==
X-Received: by 2002:a05:6512:a93:b0:539:eec0:20de with SMTP id 2adb3069b0e04-53b492168c3mr934229e87.10.1730218278388;
        Tue, 29 Oct 2024 09:11:18 -0700 (PDT)
Received: from es40.darklands.se (h-94-254-104-176.A469.priv.bahnhof.se. [94.254.104.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b2e1272bdsm1391301e87.88.2024.10.29.09.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 09:11:18 -0700 (PDT)
From: Magnus Lindholm <linmag7@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: linmag7@gmail.com
Subject: [PATCH 0/1] scsi: qla1280.c
Date: Tue, 29 Oct 2024 17:08:44 +0100
Message-ID: <20241029161049.2133-1-linmag7@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prevent file system corruption on 32-bit ISP10x0 cards in 64-bit enabled systems
while maintaing the possibility to run other qlogic cards in 64-bit mode:

 - Explicitly set enable_64bit_addressing flag if QLA_64BIT_PTR is
   defined and card is in a 64-bit slot.
 - Add information about chip hardware revision and pci-slot width to
   driver information string
 - For QLA1040, limit DMA_BIT_MASK to 32 bits for 32-bit cards

