Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773E42264A9
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776802835; cv=none; b=eQ4I+/MuLJjS9votAlsJSwpY+yMAHxPzPhZ0cuzUqfRaW6Nzc97/fNfmWLL4XD3lUn/nkS6hBtVYAmzB6GhhS9IpXyU2t9719ZCqGKtP/wDHIHJdVw6IQHyhS4PsxfEn4Fz8FBh/hiNQHxh+aH9OaE9xP5wSnRM1ou6rgxzbmlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776802835; c=relaxed/simple;
	bh=XDVPBTdCs3OUX362+JD01VeIENTWj2pufietE4OlKTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k2s6Sva9M9nc4FRqucAYlg4QuKWMNVpradeg9obIk7HAMFaSgKbWySxyacFhES5YdoK7JDdzk0aWqB/zlmhQuT/CnqcvAxSJVNvV4dM2jWy5/8xsykl9WHqjXhpha+3xuksW9leBGbK3wSIiy2owOqtIPcCqEG15M8UUdpYLWoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Tvy5lTjQ; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Tvy5lTjQ"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488af96f6b2so59744595e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 13:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776802833; x=1777407633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4InyHXPJBPo6rmqToNaN50jvmsKveAu/nD+dC1zAHOk=;
        b=Tvy5lTjQbw2dGu3bcPL0bU5azEV9T0jEi+3duBhaUXA2bpNZ/I8B0fbYSsiQVnuNcX
         xAW3aA4Nr67V95BRGK2/DMcF6BUB8/lktKsvj2Ew0cYHb8KwyxAx55oWpjSKCnAErFs3
         zNuKJbBsKHG/ZKDrS9sZ/9cTWG7jQpQQQ+TJEMFL9Y/raXuiMZfdjR9ZHjm8IORHLHNF
         eYs3RZD9shbzsJ7S+Dn/wTIcBwHexN3Qe6jrhIQgpdSM5etic58IJmON+g2ZQ8Dl0INd
         RHOE5BOubp89Zse64VA7PHQCoXf5/EeynCq7n1z9KPczyeamjcyIYhl+GdeUuzQaddBM
         CSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776802833; x=1777407633;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4InyHXPJBPo6rmqToNaN50jvmsKveAu/nD+dC1zAHOk=;
        b=qAiJcY64K1pp5wIJLYqwncrrrNDGTPMk/dEkwmSt4cCAM7e2UFZTC5XPyT4Dqu2jT0
         /+lsIBJZgpuNV9Vt1+24+HUwF0PtdJFuKGyhtHHdYHiUxppuLIVToJgjMvxg9ixkjGNo
         /UcAXeFTMuckSkaIG1GivSMXmlLyOKLvG+DphpRXGGLt7cA4W7BikQdRd96NvFB1Bp+f
         JNbuDUHTeqzxCxPGt4K6ehJXko6SM4onJQdhGUo/V4Q4hqFZ7BOi8tV5enPxD9I58F9e
         F8h4ksAUGD1mQWA9G+XnXsouhvaXvyQ8bRpPRjYkpeVA0tMsF4KgbIt7iyqJ+qZf+Ca+
         tsjw==
X-Gm-Message-State: AOJu0YwwJWwQ8pE9qmp2jEF8FDxPU3ZqeFjPooFGJXLw62exWO62daFj
	vYDF2aGykFNaCltY/+ePysRO92JMRFwnzz+9fRdpgr/1DzfxnIEk9fsRY2QjqyfMGWQ=
X-Gm-Gg: AeBDieuXpfFsj1OOBU7JKOz0P7DRjL1cqLZbpS0gVDDIo93Wti/ogFx9viRRjI32ZrQ
	jg5IH3XM+yQZfDlFxWOiC1CtOLvxYmtPJuvH+qQ/wG5m/iyWFh8w4BvjQQgGDtGDx9DAIGUZ9t7
	HD0H4irY+v83yhn51KNC1ZfSxMq/yaPiT5wmUquSwPWMvj70CfeHWy5jSamgl75qYM2M5igPkEn
	AUwmOecrLaTfETfpu+dkv34a0IIejjz5dbh2SXz+QdxANCJ7ZDti3jjRUxj17jx+sOMYVY1firv
	06o/FFnLaE4rdGF6z60BNrVGGU4UoJYf0+4DvJ6d14iD7pTmK1N+G083LqlBNEoRddZkjHQcW8G
	qQpL+s7qXqK5mlOrR7yTAQLW9bzSxtlRNWbvv8SoibsAe0z3o+S6nRk4w0DS8kbsrf0bX38h9Kw
	YWwmI8uDvr7UyYB+axy+F6Xum06gYpbG+5sfUeY8cjLlhcPZZ9BwohFMYK620TOq7LnnszgHeY/
	WNX0YiF7txBfcxvLCqXVwLT
X-Received: by 2002:a05:600c:4ec6:b0:489:1f98:71e3 with SMTP id 5b1f17b1804b1-4891f987487mr128372835e9.28.1776802832699;
        Tue, 21 Apr 2026 13:20:32 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4891bb3d121sm306442795e9.14.2026.04.21.13.20.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 13:20:32 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Don Brace <don.brace@microchip.com>
Cc: linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/2] Fix SAS wildcard scan on smartpqi and other controllers
Date: Tue, 21 Apr 2026 22:20:16 +0200
Message-ID: <20260421202018.511388-1-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and
multi-channel scans") modified the way SAS drivers handle the common way of
rescanning SCSI devices using "echo - - - >/sys/class/scsi_host/host$N/scan".
Before this patch, SAS drivers would only scan channel 0 for this "wildcard
scan" scenario; after this patch, it would scan all channels up to
shost->max_channel.

This can cause massive resource usage for some drivers, as the driver needs to
send an INQUIRY to LUN 0 to every supported ID and e.g. smartpqi sets
shost->max_id to 0xffffffff. These INQUIRYs mostly fail, but the kernel needs
to set up queues, tag sets, etc. before sending the INQUIRY. Also, some SAS
drivers assign special meaning to SCSI channels such as channel 0 for physical
and channel 1 for logical devices, and thus don't support "normal" SCSI
scanning of these channels anyway.

With smartpqi and hisi_sas, actual kernel crashes due to resource exhaustion
have been observed.

A lot of SAS drivers, including the affected ones, provide scan_start() and
scan_finished() functions that offer custom, firmware-assisted scanning
functionality specific for the driver in question. The idea of this patch set
is to map the "wildcard scan" to this driver-specific scanning procedure if
the driver provides one.

The first patch is a minor fix for smartpqi to make pqi_scan_finished() work.

Changes v1 -> v2:

- export and call do_scsi_scan_host() instead of duplicating its code
  (Hannes Reinecke)

Martin Wilck (2):
  scsi: smartpqi: use shost_to_hba() in pqi_scan_finished()
  scsi: sas_user_scan: use scan_start if available

 drivers/scsi/scsi_scan.c              |  3 ++-
 drivers/scsi/scsi_transport_sas.c     | 19 +++++++++++++++++++
 drivers/scsi/smartpqi/smartpqi_init.c |  2 +-
 include/scsi/scsi_host.h              |  1 +
 4 files changed, 23 insertions(+), 2 deletions(-)

-- 
2.53.0

