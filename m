Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EB1CA52
	for <linux-scsi@vger.kernel.org>; Fri,  1 May 2026 22:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777673518; cv=none; b=dZ53wPawtJgAgw6YPTPojrVXobNrawKl7mBtnpw3+U0HTNur78VRxIz18OZPWq7FjM8edCVtKd/doI4RSVnhKpGhjjzWQwqau5GkL/g1BcWE/3PjO+cHp0kUqk6OCtLW/5scA9zr5+zGA/2eyB0Q1aPFJTwbxlpA+ZHKz1liBAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777673518; c=relaxed/simple;
	bh=+4ZlpgT8R20ijFAw1fzroBDxpBHdeNXJhrw1E2656Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcWFEXLaDwLxxSnmRUHq1JINOdPDK5w9oFJoG+irytSnEXMQjBYstDwr96kmyagoxJl+kEUcCQehy0YgaZ6rhuY4P4I3tV/TAmiCMchBwaiErw1/S9RLsKfgr3HXy/oioMZS9wU1PrPKij/ikQeo1n60bJbaJvWAZTewzjJPP1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=NFeHZ0qO; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NFeHZ0qO"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2ed0a45e970so2819948eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 May 2026 15:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777673516; x=1778278316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gXNaGtwFexhaykDXVu0PxSFbRsBy2jU/mOwMTjOwYeg=;
        b=NFeHZ0qOjlvr2naYivBSbG+D5j4ESXsjuzlKyrR9XOOAdHds/hbTKZoFOIReHmU2C3
         mNowBHhcu7a2sBnuFRY5zCs8MjMhWDQxK5Rcn/b4OYkAzCx+SX9ZOLG12DtVX8bEFlwX
         ORi2jgPh8xkDqw+QvSA5Gb8vxqWPnxZN0EIWHSK8tXXqmEggJ0iMkRnoQHvm25YN99MX
         oaaVummBobBk6+cn1tDdOk+wVk7ZAzqdLkZROUAqGq2mOK8kLczLk0iOmTGsCcPofOew
         uWf57OqNGZkA/u6W4cNLomE8SI5jZ81iFi71YgU1PpRb4ChYLgP0tgx+FWl+e6s6bHtk
         J3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777673516; x=1778278316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gXNaGtwFexhaykDXVu0PxSFbRsBy2jU/mOwMTjOwYeg=;
        b=YAfDe6n8iYKfC833hDiW3E4mEawYrzcgymKuwODUZi4vydhkkprFaKYrWVUEZRcJTd
         0P949GMVaLBkSH+of0dM7v6+8XCleYDB7MqWI8+VqU2OR7d31/ozY5E+IPreTiL0dG5n
         a9tXuYg/fwdiXDE3AHu5M7QcBsW6wxtkYXFulk5dYJb97x1APKjdFm1IinhUeg8FY+Ge
         D+/I7R/wk+aqxrg1s5RsWtntIkDsfaL6eNBcYX3pNwJDX6MSmDZDDHkEE35ZYJzx+eAc
         WzcCF0V7Vy5ldoq7SRgCZA7fRsirWEblbOU00Gazp4tBXJrX2exkGQlEVkteyHTtnaAV
         JYHw==
X-Forwarded-Encrypted: i=1; AFNElJ9G93P+YSPaGJXQ5EFBNwRT5oMU3WobmcO2x0qefet3y62oe2CveHorCZchPJnvr1pQs74woHKmKOGP@vger.kernel.org
X-Gm-Message-State: AOJu0YxpFuk2mSm44h+8TlUKv9FnbDPLvsAsOqZp20iE4yPPecRRp48w
	fAabVq3LW6MO6zyKdpH1TkKI/64wjVaUa+Yk19jMmnwLw7ffpdbeSvNGDVBWDaoj76E=
X-Gm-Gg: AeBDievjYA66EKOtxtRtpfU9+9fp4O5nfx1D/Qwc+ETL9IOc/DsTpNhme1nhT/tUcQj
	HCwSsZsV1+xH8iIwHZGxjVIz6uNFjT1jp7XM2CPrH16x8eUWYZLF0JracCney3Lngwa5m2Fk1bs
	bkJ1nxPDaBk/YlowB1Mu8LpheUs1ls+jVPXu3okgT2XLTiw1V2DvB55PieNpZpg2qTy7ewYMJDs
	CTu//+rstExNFoIGCM9m22/LPR7iXxO0oz+DeHDnwnpgJtrrupLkX5v3kPVAZcrXr8k2oP3WnpF
	570j/eCiR6wUjnqzp0hyXkgL/akBEqkxSd+H0Id+VNkW1eX0jCdYtSHrhjkcC8UQ3C2OysowoUj
	prUI/NmWOTQZ1LNXMDc4hqI4t+KdTHqMQOdKoLPzclOXWf/nO3ud5lEoSO0KIsHiPaIQjLkr6DU
	rBo3A68MzqMWELniVAVI1cvEPdN0rtYDrljwPnGqtnj61PLJT20HZyrsZUXMYU3PQGMJJWqdyiP
	ITNbtQlIo5D/ibQLXZAMNtCokDzSnbcVB/8u8jUySYlVDCCCaoX0XNsjtxI/8PkVVPWhfBnR3wM
	E3I5JCjUxWk+2OU53+XtB02n4kN557KhSg==
X-Received: by 2002:a05:7300:a494:b0:2ed:e12:3768 with SMTP id 5a478bee46e88-2efba4a84f7mr447727eec.30.1777673515765;
        Fri, 01 May 2026 15:11:55 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.98])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ee3889d611sm7729032eec.1.2026.05.01.15.11.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 01 May 2026 15:11:55 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: bvanassche@acm.org
Cc: hare@suse.de,
	linux-scsi@vger.kernel.org,
	krishna.kant@purestorage.com
Subject: Re: [PATCH v3 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
Date: Fri,  1 May 2026 15:11:26 -0700
Message-ID: <20260501221153.90440-1-brian@purestorage.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cc6d3238-5574-4a0a-ba3a-2660687ec292@acm.org>
References: <cc6d3238-5574-4a0a-ba3a-2660687ec292@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bart, Hannes,

Before I respin, I'd like to get your alignment on the API design.

Hannes, in your review of the earlier single-patch version of this
work last year, you wrote:

> +	sdev->vendor = (char *)(sdev->inquiry + 8);
> +	sdev->model = (char *)(sdev->inquiry + 16);
> +	sdev->rev = (char *)(sdev->inquiry + 32);
>
> I really hate these.
> Can't we replace them with accessor functions and drop the pointers?

That's the direction I want to take. Bart's feedback on v3 2/6 then
pushed back specifically on accessor functions that hand out pointers
to character data which is not '\0' terminated, and suggested that
sdev_show_##field() could take an offset and length instead.

Those two pieces of feedback converge: drop the cached pointers, but
don't replace them with anything that exposes a pointer to
non-NUL-terminated bytes. Before I respin around that, I want to make
sure I have the scope of Bart's objection right.

To help frame it, I audited every call site in the tree that touches
sdev->vendor, sdev->model, or sdev->rev - both the direct field name
and the alias forms callers actually use (cp->device->vendor,
cd->device->vendor, scsidp->vendor, ch->dt[elem]->vendor, SDp->vendor,
STp->device->..., etc.). For each hit I checked two failure modes:

  - bare "%s" in a format string (the qla2xxx pattern); and
  - NUL-assuming string functions (strlen, strcpy, strcat, strdup,
    strstr, strchr, strrchr, strcmp, strcasecmp, strscpy, strlcpy).

Result, across all three fields:

  Site                                              Field(s)   NUL-term?
  --------------------------------------------------  ---------  ----
  drivers/hwmon/drivetemp.c            (strncmp)       model       no
  drivers/scsi/aacraid/linit.c         (strncmp)       vendor      no
  drivers/scsi/advansys.c              (strncmp)       vendor      no
  drivers/scsi/scsi_dh.c               (strncmp)       v, m        no
  drivers/scsi/scsi_proc.c             (bounded loop)  v, m, r     no
  drivers/scsi/scsi_scan.c             (strncmp/%.Ns)  v, m, r     no
  drivers/scsi/sg.c                    (%8.8s)         v, m, r     no
  drivers/scsi/sr_vendor.c             (strncmp)       v, m        no
  drivers/scsi/scsi_sysfs.c            (%.Ns)          v, m, r     no
  drivers/scsi/st.c                    (strncmp)       v, m, r     no
  drivers/scsi/ch.c                    (%8.8s)         v, m, r     no
  drivers/scsi/storvsc_drv.c           (strncmp)       vendor      no
  drivers/target/target_core_pscsi.c   (snprintf %.Ns) v, m, r     no
  drivers/scsi/qla2xxx/qla_isr.c:3664  ("%s")          vendor      YES

Of 18 distinct call sites, 17 are bounded by either an explicit
length or a precision specifier. Exactly one - qla2xxx - passes
cp->device->vendor to a "%s" format, which walks past the 8-byte
vendor field into the model field until it finds a NUL byte. That's
a real over-read today.

I also checked every strlen/strcpy/strcat/etc. call site in the tree
and confirmed none of them runs on sdev->vendor / sdev->model /
sdev->rev directly. The two scsi_dh.c and st.c sites that look like
they might (strncmp(sdev->vendor, blacklist->vendor,
strlen(blacklist->vendor))) actually call strlen on the blacklist
entry, which is a NUL-terminated literal - the strncmp is bounded by
that length on the sdev side. Safe.

So there are no NUL-termination misuses on model or rev anywhere in
the tree, and exactly one on vendor (qla2xxx).

That means the work has two motivations that are worth separating:

  (a) qla2xxx is a bug today and worth fixing on its own with a
      Fixes: tag, independent of any larger refactoring.

  (b) The remaining 17 sites work today but only because each author
      knew the field is space-padded with no terminator. The
      conversion series doesn't fix bugs at those sites; it removes
      the opportunity for the next person to write "%s" somewhere and
      reintroduce a qla2xxx-class bug, and it's preparatory for
      INQUIRY refresh on rescan (where the buffer can be reallocated
      and a raw pointer into it becomes a UAF risk).

For (b), I had been heading toward an API built around copy-out and
match helpers - i.e. nothing in the public API hands back a pointer
to non-NUL-terminated bytes:

  size_t scsi_device_vendor(struct scsi_device *sdev,
                            char *buf, size_t len);
  size_t scsi_device_model(struct scsi_device *sdev,
                           char *buf, size_t len);
  size_t scsi_device_rev(struct scsi_device *sdev,
                         char *buf, size_t len);

  bool   scsi_device_vendor_match(struct scsi_device *sdev,
                                  const char *prefix);
  bool   scsi_device_model_match(struct scsi_device *sdev,
                                 const char *prefix);
  bool   scsi_device_rev_match(struct scsi_device *sdev,
                               const char *prefix);

The copy helpers take a caller buffer, copy the field, and
NUL-terminate. The match helpers take a NUL-terminated prefix string
from the caller and do a bounded comparison against the
(non-terminated) field bytes. The earlier scsi_inq_vendor() /
scsi_inq_product() / scsi_inq_revision() helpers that returned a
const char * into the inquiry buffer have been dropped.

A few questions before I respin:

  1. Bart, does the copy-out / match API above address the "no
     accessors for non-NUL-terminated data" concern, or is the
     objection broader?

  2. Hannes, would you prefer the conversion patches and the
     removal of sdev->vendor / sdev->model / sdev->rev to land as
     one series, or split into two - conversions first, removal as a
     follow-up once the conversions have settled?

I'd rather get your input on the API before sending another
12+ patch respin.

Thanks,
Brian
