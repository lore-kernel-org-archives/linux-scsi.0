Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CA712FF89
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 23:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709681689; cv=none; b=phzoJ7KIBoTSVT3jEVO7Tl15Wc7rp/2oquAJcVCRti3MCcDtMjnaHFrfhtQITwVmibJz6vbsh6CmcDsKO+gGB/akai6teTaBSbySS3cCzOvOaDg8R/07hHbMj8b6DGTZYeRf4VfZqQdLVfjMUzrU271u7PMKzGLhA+IYBbSmy9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709681689; c=relaxed/simple;
	bh=czOD/j/ywOqIqWqQCCJmduuSaKii8DftYSYMMRvzuOY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sp+dl3/aalPT1lIiLq/bHswTRAE2yiOpofMsJzALVqoK1YSbiXZj+w8pAowytjLF0Fk0+cPVT8gsHYQED5TqF/yO/F1re+H/ZR5a+YjUufTiCvJgoCJMg0fgi779CCuZSKMpcQm60sXfapXSx7hAQgX4nyQxqrlUzPnkxl2kPqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=atuqRhP8; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="atuqRhP8"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-7c83b5361feso292634939f.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 15:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709681687; x=1710286487; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r2W4dqEzBOijI8wbM/wyA2IQgHsKwReDWbrG7VxHa80=;
        b=atuqRhP8P/TfCwGQgNWKgapNSHdl5UkHCmHx425JwKp6B8Fe5+5fnqFvcjN2AL85zc
         OygZnvx09Y2IBmNcQStrBAZ+SyzwjnLaunxcP0YI0h93jUtEy/oK86UgOo6oIt5EdRgP
         Q3jayZlFB7drRgrv+8fncqp6haAiqpsuQTk79Dt5Q92IjVhD/0naz5+EWhSjOcO9p3Le
         gUfq0VS/3ju2UxQUant1r9mRXcG1S0XT5+cxFB+bP/LPByYn5wgJ1nsuXpanDV/X+aFc
         uudytaLSc+fF0pE5DDTR3y1o3AmyMOsAn2aZoAhtmHmr2VDLxIU1EpQ++5X8jQbAc4ob
         203Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709681687; x=1710286487;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r2W4dqEzBOijI8wbM/wyA2IQgHsKwReDWbrG7VxHa80=;
        b=ZJoWw3LqxAcCGmaJbvNwumCoHY8ZI93j8rBs21fgjaQUlKRP9NS5JC20g/7drrxKZv
         D20zhCFvorIya0TkQYKO/l84fU8VlGVZyYuj/tfmCwvcZgL0s1E6+f7Basjp/SBLzMHx
         MPBujwymSkI5lop77hzb9QWa9x1xQgqG+WqK1suLC6yC/zsNf/R7eO56DKiyQee1Bo7K
         f2oaAotpres7Mrb7Vh2rMC0wiXWGCxvrTT61TpL+fFi2YVbBgExF+ObgrDZCttCiLy3D
         Ce8CZ6QUmGvywpsMOhEL2a17kzmpI0lNFC6ie5ycw3PIf8zuZzp0S6fTuS1vsWKA8iMV
         +2lQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNvjJv7Vm82NhSFX4E7KPfTqWkwaXRS6oAng6ysX8GsNqxkTIWX2s4s6Zz+RYAabtwN7UDBjx34B5dTXl+F5lFX9+urRy/gLy+YA==
X-Gm-Message-State: AOJu0YxXnN0Fpc5nqF4WEWzoGHxpCVQMzhPCvG13SDPJY/nHBl+HJAx1
	nij+cxnjp5Tg+Pqv0FGnH57itt7JzkdSK8Nx1Bxp1ZtQ4dS2Q4hcaC6i1rdDUBPi3bYWvHdutRa
	mu/K2Gd5YtnK0VT5SdArzsg==
X-Google-Smtp-Source: AGHT+IFm3ISTtxwtmwSD9NEnQwVnyHnCYQ6FJqMFCjJEXEARRfVeZC5I1MMFbX1a4GaCMitdlTH/MvnY5lXWtY+oeQ==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6e02:20e8:b0:363:9d58:805b with
 SMTP id q8-20020a056e0220e800b003639d58805bmr867099ilv.3.1709681686790; Tue,
 05 Mar 2024 15:34:46 -0800 (PST)
Date: Tue, 05 Mar 2024 23:34:40 +0000
In-Reply-To: <20240305-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v3-0-5b78a13ff984@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v3-0-5b78a13ff984@google.com>
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1709681680; l=1883;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=czOD/j/ywOqIqWqQCCJmduuSaKii8DftYSYMMRvzuOY=; b=DYOpEnSj/Og/vqiokTExFjD71LvtbrcYqxy9v6/RMXqeXpYyUnnscjNm8adtp5Fg7YiqEAqDs
 7RiN0Ed55KvCUdUYEjrv8wbckJ6nPxFHt4TVloBv7kJZQ1muojOhUAG
X-Mailer: b4 0.12.3
Message-ID: <20240305-strncpy-drivers-scsi-mpi3mr-mpi3mr_fw-c-v3-5-5b78a13ff984@google.com>
Subject: [PATCH v3 5/7] scsi: devinfo: replace strncpy and manual pad
From: Justin Stitt <justinstitt@google.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Ariel Elior <aelior@marvell.com>, 
	Manish Chopra <manishc@marvell.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, Don Brace <don.brace@microchip.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kees Cook <keescook@chromium.org>, MPT-FusionLinux.pdl@broadcom.com, 
	netdev@vger.kernel.org, storagedev@microchip.com, 
	Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

Depending on the state of @compatible, we are going to do different
things with our @to buffer.

When @compatible is true we want a NUL-term'd and NUL-padded destination
buffer. Conversely, if @compatible is false we just want a space-padded
destination buffer (no NUL-term required).

As per:
/**
 * scsi_dev_info_list_add_keyed - add one dev_info list entry.
 * @compatible: if true, null terminate short strings.  Otherwise space pad.
...

Note that we can't easily use `strtomem_pad` here as the size of the @to
buffer is unknown to the compiler due to indirection layers.

Now, the intent of the code is more clear (I probably didn't even need
to add a comment -- that's how clear it is).

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 drivers/scsi/scsi_devinfo.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 3fcaf10a9dfe..2d3dbce25629 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -293,14 +293,16 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
 	size_t from_length;
 
 	from_length = strlen(from);
-	/* This zero-pads the destination */
-	strncpy(to, from, to_length);
-	if (from_length < to_length && !compatible) {
-		/*
-		 * space pad the string if it is short.
-		 */
-		memset(&to[from_length], ' ', to_length - from_length);
-	}
+
+	/*
+	 * null pad and null terminate if compatible
+	 * otherwise space pad
+	 */
+	if (compatible)
+		strscpy_pad(to, from, to_length);
+	else
+		memcpy_and_pad(to, to_length, from, from_length, ' ');
+
 	if (from_length > to_length)
 		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
 			__func__, name, from);

-- 
2.44.0.278.ge034bb2e1d-goog

