Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D96400E1C
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779805090; cv=none; b=ZXwq02IJqfSpoR/uqeyaQ8bNzHyiX/GGfWst3f/fWTI2c/1sfw/EzkROcDgCDePWiv4l12bQUeo+DG/o761gr5GQKT6rf+QEN2aHGeBQ9s86mmrz/CAOw+R1N+buruVudgNtb8+O0aoFRHadcb9/lb4Fl3JdjMwa8uZp22o3bTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779805090; c=relaxed/simple;
	bh=A14j4ivDNBl2yGcg6n5ndH+ByZLqjyYb/4BbZyB+vg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V9w+74WTJ0QFVreP3G3+agtZ6qqavZWAgMoqtcJ9k8BeFxUgFtystB638XeQjJwbZQKGdLlYGpbCQvIESO0AI6ZwE1GFsw8H1BXviSkinIw0N1CpDkplRKH94thj+SRzcW+QmWdPA4k0YvGL9mOVlZiQLxofE6j8cBUiP4eJQ2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=Kr5CR1pu; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="Kr5CR1pu"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4904fd4f6aeso30332615e9.2
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 07:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1779805085; x=1780409885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWA1rx79U563LTGj65VSgfxyjti8CkpfF8kpzyqUrdk=;
        b=Kr5CR1puBNaF4clfOgdrSY811kH0XkJYaXu+tVuev20pRHeBFa6PmkgFfS7uPTR2Mj
         fccEIsQWEhUkWS/CT8WCi3/1a7oZuBvZ0BapIIz3Tp+MeoOcr1VGd0OfwtIMkjbrk1bb
         S51PVUaLe7Z2+cP8ML/eZy1CDRItho9DvS6wXJJhHCYPnaQRkpWofV8xMl3D+fAmy3L+
         e8z7ETF1JDJ+fKIfD9mFwX7Xn3lnn0nDGBAeeV/ZNq4TxDc3KDbcEEeWE8PRq1sgwGN/
         5b2esYUBdADisNNp39HkOaTwLPlCZEXJANrO0FuFsYBD8fAgQRjXET1mdfBqRTJMj+3X
         x24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779805085; x=1780409885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DWA1rx79U563LTGj65VSgfxyjti8CkpfF8kpzyqUrdk=;
        b=DjWIjgyQkd6UFLqEv66H1HXA+ya8KLAoQ0VRfZIjwqq28aEzvDsRIjtcdQE5JYb+KL
         p7j1B+8tA//m6bwPWHXud1X7EstrKaP6k0LL7yHJ2IanQgfcHjEILR+7+osbSwFWPDSw
         I6mfWYh4TyNg9M0WPHIbu4pNhM9GEVK8E3TL41MGt8T8ZyfrSbCEMU2/FQdIMVxpy3MR
         jqS+OxgnItlORyCfhRp6alDNb79Ni5AHbxvSAiu88WRpXHBNHtC6wksv3FONZJ6uduwp
         jjhMpok4ldFJJ6Xty9gbYVVs3mhG/iw4ZlKvdW+iDNGLiRu8axAB3PWgFp1cw9JO3kvr
         REKw==
X-Forwarded-Encrypted: i=1; AFNElJ/AroBbYypH4xqofqM5S8FUGBj+P7MiPjnGBLY00xypI8dx5acIhDtGDzvYSVYGAGwtEXcgjYnwkd5H@vger.kernel.org
X-Gm-Message-State: AOJu0YwnKC6Ht5CSvH3aaok+GvQcJdOxRHNl47459wgxcbgPyLujiXpi
	XcV+GVWYzdEUUPu1a+7gRzNsR0P52+XQ0BWoz+Y8IoFcSRtchy6untLFfQ4gwspaWvY=
X-Gm-Gg: Acq92OFJRaBwGOzIV+UsIpXC/oLxOwv0ruujLoC3n9DuqhA8qdEAcGuMZnO5CLG+bgi
	9ZQy02o1uURipi0vBv0Bm1siHzPJozZhxsmMLo0VCu1afN4DMDYmzg9HRbXgchEc3jtA/ZxqBAw
	wbQAMcvmQ4ILzxzwefzvO2RFBmfYH+i+F+XNzYFU6oVukdITShoWHuuiXJzELPFgM6b2Mcq5zUd
	14+EX/2BrgvHK7vin8bbIHvAtLHQr/MV3ScUiHzE/Ki4anx6U9PUW4Ddb26WTixpMYXbB52iFEf
	LID/rglNAQz7q3dIwa+8TtxD7u2XpxqnXKYaqmMS+HUzDQQC3ehF/goP6YzFTkXW3iYGlScRf7q
	B4NVkyo1VUKh1i0ar5i7gr44Ppq0IJWFbAAmC2Eq9zbwLg6CdOrkivxiA3BdLVTimwDwIgKrsGl
	TpZT/kf7Fn3zobdKpGPdrUNg+WVVjpJlNxGIC/mdI49m1emDUgSpRpZhLsjYW7d27hQL13aG2KX
	sPobt3Wy86HheVlLYHmhgj9Eg==
X-Received: by 2002:a05:600c:4592:b0:490:6237:5213 with SMTP id 5b1f17b1804b1-4906237537cmr145220735e9.23.1779805085104;
        Tue, 26 May 2026 07:18:05 -0700 (PDT)
Received: from localhost (p200300f65f47db04a716d2bdeddb4813.dip0.t-ipconnect.de. [2003:f6:5f47:db04:a716:d2bd:eddb:4813])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4904561a160sm379625175e9.9.2026.05.26.07.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 07:18:04 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Max Staudt <max@enpas.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Helge Deller <deller@gmx.de>
Cc: linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org,
	"Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH v1 6/8] zorro: Simplify storing pointers in device id struct
Date: Tue, 26 May 2026 16:17:32 +0200
Message-ID:  <49576a7501128c93ef318566ed7faefce163f1fd.1779803053.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1515; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=A14j4ivDNBl2yGcg6n5ndH+ByZLqjyYb/4BbZyB+vg8=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqFauEMCO+XO5wBiq0WLDW9CPIg9uJbXOSVo41d x54C4q2mLiJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCahWrhAAKCRCPgPtYfRL+ TjnnB/9l+SDbdriw4+P0R0QawXzQR6RNcTSEDOsG0Za0QxbkFa85XMb5sLwAO0owuw/Rowx6ky+ QMdsAXUgR3vwvQLdxYJlkEl/VA/XHq/xJJAuw+YZlvI7KLvHFN3YqbmJgo+fHO56QX05JkYBvJ2 Jk9WKvtvJ58lFHkr+5etBSYF3AixiJ+YBuoVcvjao9lM8EjUJ8SyDU/sXtdjUltWSXQmsKSN5Wa cffVeDubVIqpPQNOIDt4M8130VMFMoHEz1nySiOBmpolGD4C9tykhh7r5xGVttivy5+fc/p6kFl 64ZyNUXuXtZrf+NrGcA7ZEOvBZuObVE5B7q9XxMf4MX80c3s
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

Technically it is fine (on all current Linux architectures) to store a
pointer in an unsigned long variable. However this needs explicit
casting which is an easy source for type mismatches.

By replacing the plain unsigned long .driver_data in struct
zorro_device_id by an anonymous union, most of the casting can be
dropped. There is still some implicit casting involved (between a void *
and a driver specific pointer type), but that's better than the approach
to store a pointer in an unsigned long variable as this doesn't lose the
information that the data being pointed to is const.

All users of struct zorro_device_id are initialized in a way that is
compatible with the new definition, so no adaptions are needed there.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 include/linux/mod_devicetable.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 3b0c9a251a2e..2673a1bd82c4 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -640,7 +640,11 @@ struct mdio_device_id {
 
 struct zorro_device_id {
 	__u32 id;			/* Device ID or ZORRO_WILDCARD */
-	kernel_ulong_t driver_data;	/* Data private to the driver */
+	union {
+		/* Data private to the driver */
+		kernel_ulong_t driver_data;
+		const void *driver_data_ptr;
+	};
 };
 
 #define ZORRO_WILDCARD			(0xffffffff)	/* not official */
-- 
2.47.3

