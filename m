Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84091E894
	for <linux-scsi@vger.kernel.org>; Mon, 26 Feb 2024 23:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708991635; cv=none; b=MF33puVBoPEhUsG5Ywik6nWdsgSlihnfQ0+322EfTN65FLurnazUbEXxBKjGh3RKDSQkU9TmPJetbd34XlqYGaJ+ObIcdyKq/1yUaAwCaxO7cXkKEf9ahBUZi+d4F3E91yLA6946otHjsMZ5ZYaGcFjWek3pTA+oJRsjfqhPxq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708991635; c=relaxed/simple;
	bh=JeCxx3c4ppdgFDh3lp6P1rqNUJwDxT9JEo9Mm+GfI38=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MgoKSpblfoUJbm1UO+LsSExxBkBpCMkEUR6Eab+Y7tiJxv6841Uz9Jrr5iBY9r3exUH9Xw1FQhlmxcKRcwCcK8QS9WO8/2m6U50GGpgd0I1XFeQaMj7vdxecMubh10ssmDZ/nP8262H/YiTPl+zMLg5J8QYmAUZZpmHIC2n9opo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fy1d2mYM; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--justinstitt.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fy1d2mYM"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26845cdso5010573276.3
        for <linux-scsi@vger.kernel.org>; Mon, 26 Feb 2024 15:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708991632; x=1709596432; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S39j559seDHpHoyUT6gNBve2pYTlYnQB3wRYpD7F2CQ=;
        b=Fy1d2mYM9bV1lszCzKF98Q2nCdK/94vBoLQjkpBqgs7WL0pb83HxuWjXTTz6vxRp6E
         NQYYO4PIfEeSJ8bfzWG5u/Yc/Wtqix4gYedQOzAEp+0Yj1/YIuDKrrHNimbIPid9DVJi
         zJw6/pPPofKVeRvZYOFIgLIfuZBI1d1k479azNx3HBndxJi1DH+AituoPfikWgMdWAfY
         Xsb0S3EdK+OZjOrIesBv0/3QIV15xaY6wA/hPeTsm31ylWbuLvkGFi3ThEtXchmXwxjD
         /PrAoR9j+KlwSPC90FU5IDCD8sctiVJOzS/SHtnPp8FGyrj+rZSdx6rqB74WiOCYlbmG
         A4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708991632; x=1709596432;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S39j559seDHpHoyUT6gNBve2pYTlYnQB3wRYpD7F2CQ=;
        b=M+17S31c96ikMndXMDiU+9JEgmIzQH/0jIP0lhr+2qkveNB8M5UWosYtO3Vw3B9+tW
         FQw5S71TIw5N92ij17HI0TwaQK5zzxEBRKpeE1DpxCv3nFbux08MO0Cjn+YndlzZACjR
         LKO/D+cdeB2cdWlyXFqwJiOnozyNGKr75v44vOGI0vH0LQYlx3MtNelU6EO9ZFNpsHCv
         kI64irJxeDMoUGow5HEXS3HHGOFrsIPGQ8rbDm4AeODSa9CT76dehqMT7GKXS4ueZaPQ
         ZaHcI7hQ7zVcYdW22JksWbcCwl3LAiN9931BG8FZxUHi2a26hhhk5TG4QVa641sc3WnS
         0FPg==
X-Gm-Message-State: AOJu0Ywm10gRIrkXUD15uB3CnkYHApPrApnNYTPybaAvQvXzoObaV+Po
	LfgkvpPQw/c3+nHtxmMB6EsA5e2jjNRhbGoizVChq1GnxWwDpP+UlWPaVwsrKDvgeMifUnTJAiG
	vf5ZhpuDw8S5v7G5mvAKSxw==
X-Google-Smtp-Source: AGHT+IH54DJnpJg9iPluQxwsW66Wg0QACJLoVbFpM8JyEIz57ZeMOw8tfs/bwhBt9SCw4HWibOH+XXlMWWCOk7NznQ==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6902:1887:b0:dcc:e1a6:aca9 with
 SMTP id cj7-20020a056902188700b00dcce1a6aca9mr189067ybb.9.1708991631843; Mon,
 26 Feb 2024 15:53:51 -0800 (PST)
Date: Mon, 26 Feb 2024 23:53:44 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAIck3WUC/42NQQqDMBBFryJZd4qG1GpXvUeRYsaJDlgjGQkV8
 e5Nhe67+fD+4r1NCQUmUbdsU4EiC/spgT5lCod26gm4S6x0rk2utQZZwoTzCl3gSEFAUBjG2eE
 xT1wAwV2MLa9EZMtKJdMcyPH7qDyaxAPL4sN6RGPxfX/+8i9/LKCAyhpTt1Q7h3jvve9HOqN/q Wbf9w8CtWNb1wAAAA==
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1708991630; l=2521;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=JeCxx3c4ppdgFDh3lp6P1rqNUJwDxT9JEo9Mm+GfI38=; b=aI8lYYQTCTWr5poJcPKK8qGIaYaUXNNsUPhPuHz8s+B2GXWwyabkAt5Y93G5bTZHu1TS6wyRB
 e1Z6lu+bX0RDep2Xlb7/pIjK9b5aqj9hCE2PQ1b3XxtRQKpfxD3hgt3
X-Mailer: b4 0.12.3
Message-ID: <20240226-strncpy-drivers-scsi-lpfc-lpfc_ct-c-v2-1-2df2e46569b9@google.com>
Subject: [PATCH v2] scsi: lpfc: replace deprecated strncpy with strscpy
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

Considering the above, a suitable replacement is `strscpy` [2].

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
Changes in v2:
- keep strnlen (thanks Kees)
- Link to v1: https://lore.kernel.org/all/20240222-strncpy-drivers-scsi-lpfc-lpfc_ct-c-v1-1-20c685bd1b43@google.com/
---
 drivers/scsi/lpfc/lpfc_ct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index baae1f8279e0..296d2d4796cb 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2569,9 +2569,9 @@ lpfc_fdmi_set_attr_string(void *attr, uint16_t attrtype, char *attrstring)
 	 * 64 bytes or less.
 	 */
 
-	strncpy(ae->value_string, attrstring, sizeof(ae->value_string));
+	strscpy(ae->value_string, attrstring, sizeof(ae->value_string));
 	len = strnlen(ae->value_string, sizeof(ae->value_string));
-	/* round string length to a 32bit boundary. Ensure there's a NULL */
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

