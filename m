Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373F6EAE7
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 00:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708562515; cv=none; b=GOdKn+rW/ReDIa1yrpCRQEHe151hZhbh/VfbWlgSoR5vWrBX+159WZYSraFf1Ivik7TMKqK1k3+3zHy7fSsslPXg+CoBMS8J2bcGkCr8SL8fPtBE0j8s9Pvjgbt80BGGawqwqfPvgeyozd8p1CWAgnLcsuOrjBcrw83w165HmbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708562515; c=relaxed/simple;
	bh=OTTeh2V6QDGWlxJqsDj3XrQmqyt1AJR5mKB7r3e/JNI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IRB4JBnHyNOliJLYN+f5LHczT1wgo3PeGYhCB2liXH949Mch9vqvk/j0rwc7su44xdIEEv9QuE79DmxoXmR0BrrQIo0YBcvn54ujkAAanJwQY/vFlR3SV1d9aD/P0NRrUW8BF1meySr+xCeR0jcTO8LkWIPjcvUn5Ww0OdeTVeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tk75PSBw; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tk75PSBw"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b267bf11so7291325276.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2024 16:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708562513; x=1709167313; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G583JTbO9RH5e4qatRoF50zt3H5aOXeubyono7wZgbU=;
        b=Tk75PSBwIRulegjD4wXVI1LoeKNytzxPNKGF4r7J5YViBQNmAULy2k/fqEPqOxoeD2
         zixpnd7HmSHoVdtIaGmE40ejGYb3MduYVIVSXlkrUzje0S0c1eB5APUQ9pWYMd87glFC
         fGFEoJS/WLc+Uwo8L1TowBnpXCxdaEQXCmtIxwOSKACuzriFetajC0psuuFdcopskDFp
         3u4eSuBVwLAeDykDPx5ZkMscJhz9HplfH1TWN77M6W36VxkNZ8mlJYHyGGaJ0CEsOAWO
         XHJEGOUVVO2rreQRe7HNKGUtqO1inIqTss1JInnIwUGV0u8rU0p9VcDxiJfPndObQZIw
         869w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708562513; x=1709167313;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G583JTbO9RH5e4qatRoF50zt3H5aOXeubyono7wZgbU=;
        b=fjeZagkVSwkaCJ/P/S3+puBhHfK+x5QSrQ8bsoqf+zaJSdnP1IylJ0un0MT5ARfATf
         cGBfieH0bE0Bbx16KrGv0C60jWaO30Z+3ugGg5TkSq6NSRxjsSoBDrDM+Qk0dIIHUSn1
         DfPDwGIFzYzIRrEJyxtBWAfrBkd0xy8qKhmk7wyvMNKKQEMudxWqc0jRsCivKxVpSlZa
         teblKt54KjIEFQZKLIU3om/qhEh+8NOg36TTy8+XUzktZjn7U1DbiP2ENL0tQWQ6+uke
         eHrM0X058aKtWzaGbjTemTDEN5fquGoJy4+G0xXni2Ggz2aPEx+67lnMIbxoqLh7tldm
         Mi4Q==
X-Gm-Message-State: AOJu0YyVvVO6SBJqxOhRi/V4RdFRmHIeyF9miC9ApSVa/RoL5+HlNImn
	wU989xiUC6TPmjVouE3CShQMeuD4n/BYSM6BOWyKFBVU3O4J4BiCdomHI6FaHTmjiCCvrfWgGxx
	ve4/uXJinK8Bb4HUS+/aLfA==
X-Google-Smtp-Source: AGHT+IGiyZ42qLqEd5VQhwppGk37FON0JE3UDwx/pyMP6iMh4zKRGnb0Q2Uu5IjrwRjQyoA/k3ecbiXnP1KcI9kYAg==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6902:1008:b0:dbe:387d:a8ef with
 SMTP id w8-20020a056902100800b00dbe387da8efmr33807ybt.1.1708562513250; Wed,
 21 Feb 2024 16:41:53 -0800 (PST)
Date: Thu, 22 Feb 2024 00:41:52 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAE+Y1mUC/x2NwQrCQAwFf6XkbKCGWsVfESk2fasBWZekFKX03
 116GZjLzEoBNwRdm5Uci4V9cpXjoSF9PfITbFN1kla6VkQ4Zs9afjy5LfDg0DB+l6Q7Bp1ZOZ2 6sT8DGPsL1VJxJPvul9t92/4hgrO3dQAAAA==
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1708562512; l=2488;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=OTTeh2V6QDGWlxJqsDj3XrQmqyt1AJR5mKB7r3e/JNI=; b=A2o2fiTjLDUmZ9F3wqmvRRVWLzoT82nVkkZDj98Xnn0hewgY8d0BMBO+anxo+q5J1CvgVNGan
 ecX1M9fbJJPB0fqNn0QDDpCEd/lQOrqsnM7HQ5lW5sI5e2Ioaybsh6P
X-Mailer: b4 0.12.3
Message-ID: <20240222-strncpy-drivers-scsi-lpfc-lpfc_ct-c-v1-1-20c685bd1b43@google.com>
Subject: [PATCH] scsi: lpfc: replace deprecated strncpy with strscpy
From: Justin Stitt <justinstitt@google.com>
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"

strncpy() is deprecated for use on NUL-terminated destination strings
[1] and as such we should prefer more robust and less ambiguous string
interfaces.

We expect ae->value_string to be NUL-terminated because there's a
comment that says as much; these attr strings are also used with other
string APIs, further cementing the fact.

Now, the question of whether or not to NUL-pad the destination buffer:
lpfc_fdmi_rprt_defer() initializes vports (all zero-initialized), then
we call lpfc_fdmi_cmd() with each vport and a mask. Then, inside of
lpfc_fdmi_cmd() we check each bit in the mask to invoke the proper
callback. Importantly, the zero-initialized vport is passed in as the
"attr" parameter. Seeing this:
|	struct lpfc_fdmi_attr_string *ae = attr;
... we can tell that ae->value_string is entirely zero-initialized. Due
to this, NUL-padding is _not_ required as it would be redundant.

Conveniently, strscpy also returns the number of bytes copied into the
destination buffer, eliminating the need for strnlen!

Considering the above, a suitable replacement is `strscpy` [2].

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index baae1f8279e0..42594ec87290 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2569,9 +2569,8 @@ lpfc_fdmi_set_attr_string(void *attr, uint16_t attrtype, char *attrstring)
 	 * 64 bytes or less.
 	 */
 
-	strncpy(ae->value_string, attrstring, sizeof(ae->value_string));
-	len = strnlen(ae->value_string, sizeof(ae->value_string));
-	/* round string length to a 32bit boundary. Ensure there's a NULL */
+	len = strscpy(ae->value_string, attrstring, sizeof(ae->value_string));
+	/* round string length to a 32bit boundary */
 	len += (len & 3) ? (4 - (len & 3)) : 4;
 	/* size is Type/Len (4 bytes) plus string length */
 	size = FOURBYTES + len;

---
base-commit: 39133352cbed6626956d38ed72012f49b0421e7b
change-id: 20240222-strncpy-drivers-scsi-lpfc-lpfc_ct-c-f54b67eeeb68

Best regards,
--
Justin Stitt <justinstitt@google.com>

