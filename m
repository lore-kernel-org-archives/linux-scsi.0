Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0629378818
	for <linux-scsi@vger.kernel.org>; Mon,  4 May 2026 18:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919816; cv=none; b=FjGQT2pOotbDhDjaVi2+TTtQiWDHaxG3i3mEikF2rsdlNLIh72c1nc5/VpqN2pNqQ2fiXJ5f7LkLxZTyDLnb7pKeF1dTPzlyBr2M9NunefSwdAN3VsdgGCbAwzcOrBerBmYG69wUXDOHVMN5yvZr/zHvSSLKTswuFuXiUgawWdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919816; c=relaxed/simple;
	bh=m0hURCnl7dh6sHTbn9ofu805tFDLDeedvot5DWWCuH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfM/yfo1HgFlxB48rqPLiFqkHr772kf8ymslhO3zp+0hEHqa6Y/CTc6FxfnxSrNjBVseZn3GWRL1WBqiIQyxUmqO1BFLmmmK2eC10Z9LmLPWWQ6FLvAzQouLWeSxzKg7V6dQhNCVYvMiWf5GEDvJd0YpXd5HdxZ4fya9w4nJTcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=d6ZdwgpF; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="d6ZdwgpF"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2ee990e8597so4212338eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 May 2026 11:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777919814; x=1778524614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQz605sV2Y3Q2IPOA1O3ZaSViszBtifDvXd7l1R0JDE=;
        b=d6ZdwgpFgR0eEHROngKBeMPUhKH8YfXR9NLNhzfmaHR14+6DlrH/B2r9/wrHT/PS5D
         4oogCx2v4mImw1EXfnkCKngCEI4S2/gG3ianYHAqPQhmDiTccYGY6xKUbCmf8/XUsBkE
         M4JVEeIn8h9icXJHAh0JmLNd80D+bSRhYNOcj+lZMWzrxml4iouRi8IbnclK/0V1yFDN
         JqRG5JCJBUy2A88C0+ZGa6n/IBGJueJxu0v48ti4jWJFh3MbN+MclApbUbSpsX1KoMSd
         w1jt/vjQcmTjgP7np+8uTfFzr9YI3G6be9nqBPBG+lQGC5XOTGmP4QylwHoUcW4imbyC
         ohBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777919814; x=1778524614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zQz605sV2Y3Q2IPOA1O3ZaSViszBtifDvXd7l1R0JDE=;
        b=RIbYuR5dUnWkOfoo+Mji0mOAprJGhlvtSBgXdOXDCCjdEkm50i6roP+LOBK/NDRA0v
         yCCcGUqtRyRbPKyar22wWpKd305YQzNka1NcMHlArdrvOZh1OlJkSsBiQmeKg5izy+qP
         n9NO6JzrmGCvN7fPDMf0Zo1QhwpuQa5YOcyAN6TnoCwgmN8EoSjxlJdedm/NzCsnOCYq
         K6elawoLOe1pXsbNrVzqqBGb3+N1D5G0SYNFPtDdP35kH+U7WgnJhJ2AjadN/FxxMbiL
         89mPeMkX9nSfNY8gdLJJ0V1p3iFza2IOB2/BsdOx95bFTv5tpStAyFrT8PPgtd7Ek9g1
         +9Rw==
X-Forwarded-Encrypted: i=1; AFNElJ+7NCqwi/+mZ68886NnQF49ajgUDhPz1pUOemvyuPP0+zJQfV7WhRNjkKNng1gaRv/SyD2GOYU5dRVQ@vger.kernel.org
X-Gm-Message-State: AOJu0YxQnfT8xj340+sj7OLyY9JN7JQOlBi+EzMcu2o/4zXpuNRz7Z10
	8TTZbNBqXyws8h0MWv84MYyAx9tOmAg1L0atu1SksYQzKJuGR5kD97LZE/IR3DsEu9A=
X-Gm-Gg: AeBDies45EjrwEQqL+wveu5DgmBDnA1eNYg61GuzAlBN2FByFNIwKml7I/WiER+f8lL
	y6Uoz7jNEMIz/bX8gsqK57J4CsmJEbhV82DbRxq+goGKxNpwZ/paAEpvObQIUmSK8SGAUxd9bb1
	tjL8LxTQ4+2/JmG20wLQ01T4Es6CAv0w64gzhIgLiI4XN/gYE8YiARb7JImjy9/2iFE4GIF8IOM
	xk8cCSowUQctzrwN3vdLs35xuO2vI858cvzQ/rnaCR7MnEDX+mawLoDtpDC3SKfLHOEIZzyehwz
	vip3JIHQzOvZu/CJ0ohomzA5kh0jdSe+lY6Nh0j/Bo7tYz2u6AGi71LN/8y7daA2FcdiwIEJE2S
	gozvo/spcIGIJ4ldZb3MQfSsKTXNy4k8aKIXyX6cPadGPXGFXotnV+zRWqpnSQMgQtby0Ut2PUT
	A/bqMBcPkhxtN5OYkXx4IGk9oaFiZo14EYy2Hi8k5xmEzSL7pbHlfOAiMrAFKgIbcafPKfpUWSm
	AZxcykvFrIO5suZnmYZ4lh5gqJ0wapsQH3Dwfvt03wjMIYy2F+ZR5PROWAIrkdZmP+HfWtL9gdL
	eIVLEOILeAOs4hPlQilT8qtDU5GKh7gtCA==
X-Received: by 2002:a05:7300:5b95:b0:2df:7fe3:96a with SMTP id 5a478bee46e88-2efb5212edfmr4632917eec.0.1777919813777;
        Mon, 04 May 2026 11:36:53 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.98])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ee3b781555sm17636837eec.21.2026.05.04.11.36.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 May 2026 11:36:52 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: bvanassche@acm.org
Cc: hare@suse.de,
	linux-scsi@vger.kernel.org,
	krishna.kant@purestorage.com
Subject: Re: [PATCH v3 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
Date: Mon,  4 May 2026 11:36:51 -0700
Message-ID: <20260504183651.81037-1-brian@purestorage.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b584f42f-534e-4204-9fa6-92ff93ab62ad@acm.org>
References: <b584f42f-534e-4204-9fa6-92ff93ab62ad@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 5/3/26 8:44 AM, Bart Van Assche wrote:
> scsi: core: Convert inquiry information
>
> Convert these fields to fixed-size character arrays within struct
> scsi_device and remove trailing white space at initialization time.
>
> This patch fixes a bug in the qla2xxx driver.

Thanks for the patch - picking up the qla2xxx fix as a side effect of
the conversion is a nice win, and the call-site cleanup (no more
%.Ns / strncmp) is genuinely more readable.

> +static void strip_trailing_spaces(char *s)
> +{
> +	size_t size;
> +	char *end;
> +
> +	size = strlen(s);
> +	if (!size)
> +		return;
> +
> +	end = s + size - 1;
> +	while (end >= s && isspace(*end))
> +		end--;
> +	*(end + 1) = '\0';
> +}

This changes the sysfs ABI for /sys/.../vendor, /sys/.../model and
/sys/.../rev. Today these files contain the raw 8/16/4 bytes from
the INQUIRY response, space-padded as the SCSI spec requires for
short identifiers, followed by a newline. For example, on a Pure
array today:

  $ od -x /sys/.../vendor
  0000000 5550 4552 2020 2020 000a
  0000011

i.e. "PURE    \n" - 9 bytes. After the patch the same file would
contain "PURE\n" - 5 bytes. That's spec-correct (per SPC, trailing
bytes ARE padding, not data) but it's a userspace-visible change
that's been stable for some time. The places I'd worry about are
udev rules using ATTRS{vendor}=="PURE    " (literal match, no
whitespace handling) and shell scripts comparing against the padded
form. None of those are in-tree.

> -	if ((type == TYPE_ROM) && (strncmp(sdev->vendor, "HP ", 3) == 0))
> +	if (type == TYPE_ROM && strcmp(sdev->vendor, "HP") == 0)

A few of the strncmp -> strcmp conversions narrow the match in ways
that are worth a second look even after the strip - this one matches
only literal "HP" post-strip, where the original would have matched
"HP COMPAQ" too.

> -	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
> -	const char * model;		/* ... after scan; point to static string */
> -	const char * rev;		/* ... "nullnullnullnull" before scan */
> +	char vendor[9];
> +	char model[17];
> +	char rev[5];

Going back to Hannes' original suggestion - dropping
sdev->vendor / sdev->model / sdev->rev from struct scsi_device
entirely - is another way to get the qla2xxx bug out of the tree
without touching the sysfs output. The shape I had in mind is small
helpers against the (still raw, still space-padded) inquiry buffer:

  bool   scsi_device_vendor_match(struct scsi_device *sdev,
                                  const char *prefix);
  bool   scsi_device_model_match(struct scsi_device *sdev,
                                 const char *prefix);
  bool   scsi_device_rev_match(struct scsi_device *sdev,
                               const char *prefix);

  size_t scsi_device_vendor(struct scsi_device *sdev,
                            char *buf, size_t len);
  size_t scsi_device_model(struct scsi_device *sdev,
                           char *buf, size_t len);
  size_t scsi_device_rev(struct scsi_device *sdev,
                         char *buf, size_t len);

Match helpers do a bounded comparison against the inquiry bytes
under inquiry_mutex; copy helpers copy and NUL-terminate into a
caller buffer. Sysfs reads stay byte-exact (no strip); qla2xxx
becomes a small stack buffer + scsi_device_vendor() and the
over-read goes away. Scope is comparable to your conversion -
~18 call sites across ~8 files, each migrating separately - but
no userspace ABI delta and no cached pointers left in
struct scsi_device.

Happy either way - just wanted to surface the ABI concern and
remind you of the other direction before you spend more time on the
conversion patch.

Thanks,
Brian
