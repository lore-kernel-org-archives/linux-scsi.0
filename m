Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDC948BD3C
	for <linux-scsi@vger.kernel.org>; Tue,  5 May 2026 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778001215; cv=none; b=PN2FYfFl/rp8ADal/7P6RbNLCblGs+jUOyenNc9fL11a0Y6RB38dhYbgbb45oGQYHFsXIdF330pCLyPiPAsxQ8dasIbA+o5ystrPYLxPnOlrirRxNgfEOxKjBMTXRpbCbG1pP5mrbitqFNyi4WAqgHoNNkKpFMHyVzkX7fB+GKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778001215; c=relaxed/simple;
	bh=YdOAIcJ4Kse8SW0OAWGxljzBJZxhvEAckeGCvrbu6uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUSy3BCwxSr+lC+e9qOi3u+2wZo9tvISBPBbQQ7SC/8yUtRVFzed5kubT5FRPdGt6Kqx5UKJtMkFLuqVv/V9z/xnVJSpfps+j1V3Q8KsCQndPsMrO3vFN9IHP0LOobiYttSRZFmumdMUq3UDJhoB6Ek49wN2bNSHHKEo42+UOIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=BKeh+oDz; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="BKeh+oDz"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-130c653cce4so1731490c88.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 May 2026 10:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1778001213; x=1778606013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iKY4lJyd+21P0kyrpn5OPmCHqZTY1mw5LGnxBMKlyXY=;
        b=BKeh+oDzezdVAS99nm/2mS6qLMaVdui6nbW3Sqmk0bHejKoMOm5bcMGHHHtsX1noYr
         MzAr7QJsdSR2YnvDv8tuwyPzFzG9D7Gpku4Amq1h5BUNLwsKmAYHSih5eBPblNHol3Kw
         7LV392Mi4L4ismq2g93Qt0mcl2dS1MEpTLkrBo9MwWRaDxC1NJhYF/o0bprdYKVeUpAS
         K2WltXww+gNB0HaKb6C1Kt93grlLydG5mLiAzibef3IfOwzZSXnD9895i9rN1R7yrL1U
         WNxWH3BjOLeXJiI60GRXLQDdbSaD3f/KTYDBWjnbylYcNRGLs6uXBYkVUL/NB4CqapHg
         5nJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778001213; x=1778606013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iKY4lJyd+21P0kyrpn5OPmCHqZTY1mw5LGnxBMKlyXY=;
        b=gxKvJOr3owaJHykkJBgua/6avgMjEbRv1X46Nh67+O7J3qeBYBwRqCKLM2tQP7b9Js
         ypJ7IuDWK3UjqBZLtt/yRCFOSpNxpbYic0BgDtXUk452HUeWtJfDiZ/AuI1A1mi0/RPm
         HlDZEGFhaaerUeF+03PKLIfeeQXqD1Vv6pUJ6jB7bo9l2t0SCl6MKHfH/fbhEjK3TLJm
         x7a8e4Vk6GtNg76u4S44aZufUe6ECozFmMAGtYBa+4cQL9FXcjqBU1z7QsrMtxM3UJsv
         c8290BdZ5Km8uCWXfocNCMB0ewcM87Udof4hmkcipEesRknk0zEfj6xCTruRY4B4ovRn
         eMgw==
X-Forwarded-Encrypted: i=1; AFNElJ8TqJVXdNZQmMajQTF123KmFMRTQp6+Ceyd+IOZfHSH7fg7bXfUjD9BiimqwnuktMewCmyreyKASURb@vger.kernel.org
X-Gm-Message-State: AOJu0YyEZZSzje1hv/rrhVlZKvqFGxeVuzKqKFBYfzZ+AfvPF0/tXQvY
	PJHlQA+9lDOuWMsX2EVAc+vvix6ruOYMd8yYMfQ6SlXcGrMxuNUuOn/SlbHMMhrxrRs=
X-Gm-Gg: AeBDiesFA3IhB2xjoA1CpbLudEj3XbNTWKUZ2YkpE/+DWVM24xl2O3gdoeFFgRzHB+J
	omLBLzHgKx2vM04QFBYUe9EiwOtyzMLzGCRzl3Qb9t2bkNMYO+rGKG0m2f2KheFOpTFekypUx82
	840alWKetFMkRrGs0o6ZdhrHFOcnehVpvQIynzr2kfklS0FUhnD6TOuQYeTPVrPsHMmvdpEnJot
	nDpsL/GSWkVq/clU9o1zFdGzev/g+7NzlN2Q83NsaSQHqRBspaMdqFyIgK4MSLx++3LOvgtwyr2
	Uiy/kD+QfCqeTFi4zBxW2vNtkbdnmHODQIhOMpFq7oYArCOVVGUtPCkMX5WIqlNYh1zUSoPGAq1
	e3WGychgpl55u/5Ad6nyoYpFIQg/cM05jn9G5iwYusREtdIR1XakAnnl3/riFk6eZI0/ze5Oouz
	5N8Yd35+PHUR7rq7/eVPanpKqKMIpjBR634CYzKT1j61Aps6zYr182ro7SiwhUAIJM68GBuA0Wc
	6GDUwpb/2MFHJpC5GLAoQgHR++hBJQmYx7zk/xH15+DSnR2G4TeAIz5Q8FTFrDvzzBz8sesO52R
	QQK3Q6cjnAD4Ma0cqzUIG6Gtkah75Sn3mA==
X-Received: by 2002:a05:7022:221d:b0:130:9f2d:ff99 with SMTP id a92af1059eb24-1319cd26692mr10718c88.20.1778001213132;
        Tue, 05 May 2026 10:13:33 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12df81ec067sm22200018c88.0.2026.05.05.10.13.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 May 2026 10:13:32 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: bvanassche@acm.org
Cc: hare@suse.de,
	linux-scsi@vger.kernel.org,
	krishna.kant@purestorage.com
Subject: Re: [PATCH v3 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
Date: Tue,  5 May 2026 10:13:15 -0700
Message-ID: <20260505171315.10851-1-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <1c517f94-d03b-44d1-8f3f-327be5362199@acm.org>
References: <1c517f94-d03b-44d1-8f3f-327be5362199@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 5/5/26 1:24 AM, Bart Van Assche wrote:
>> This changes the sysfs ABI for /sys/.../vendor, /sys/.../model and
>> /sys/.../rev.
>
> Not necessarily. If the format specifiers %-8s / %-16s / %-4s are used
> for reporting these member variables via sysfs, the sysfs output should
> remain the same.

Agreed - left-justified width specifiers would re-pad on the way out
and keep the byte-for-byte sysfs output. The current diff uses plain
%s for the sysfs attributes:

  -sdev_rd_attr (vendor, "%.8s\n");
  -sdev_rd_attr (model,  "%.16s\n");
  -sdev_rd_attr (rev,    "%.4s\n");
  +sdev_rd_attr (vendor, "%s\n");
  +sdev_rd_attr (model,  "%s\n");
  +sdev_rd_attr (rev,    "%s\n");

so as posted "PURE    \n" still shrinks to "PURE\n". If those become
%-8s / %-16s / %-4s in the next revision the ABI concern goes away.

Thanks,
Brian
