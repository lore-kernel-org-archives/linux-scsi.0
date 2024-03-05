Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2345C1353EC
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 23:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709683126; cv=none; b=bTnALHZQG6CoLBwSnouNSoEy0Urh6iHKbeA3WLAAyiAOgcZVX6+e4RkNDr8zSdp5AeeL8x99Am46JQN7I+6hCr84aCeAFl7EdATkxgoIKCdIQ/iTsPuhYcSCEi7S5pqhRTex9ybabbxki3Q+P8EJ5oPkOCKkups5r1b77zsO2jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709683126; c=relaxed/simple;
	bh=ZQgGWVSWytcgK5MJZ6jggoBjQfFJugefhTJSzcVcgYk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rggp95OLKU35eSmIPD81X2UjMCAzMMddjEhPMivkhs8BJTRq2sgU1D2ZRL03O+5Y/Prjh5jXYmK3ePFYTBoFVm4lsxAVpM5t7xh+22aPbOtjr/dANodRjSzp4Vv7me4RCRAvmLA5GoTmiEdagK9+ADfzkiNfK4YSL95VvFBT54U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1FLFJf6l; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1FLFJf6l"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6ceade361so10457494276.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 15:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709683124; x=1710287924; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iW4+YjuNAKvAoJg+NmQ5C96xY/u5WzV8UruESW/Bs4M=;
        b=1FLFJf6lYz6MXkeWmkVOPVP/dTbCxipBlQKRRdIQQrIYT5xVRz2QD10+XwMkhELTOO
         A4bGpVLhcmi5j+DnbpFoSzd4qZy7nptJpe1yKBTq/h3HhcClu/RlxuWKpoH35rVoeUDN
         TEytp1a72dm/AWNBXa6KmfCNWxBk2r5PzZnEkgRNkWpbBygTujZQslKPMjWF4AwGSs6Y
         uhovgu9ZM/lL1czkaTMxO7dyD7W4XstRdBTElHPp7UafjG1xNJbmsc6XrgK6QNR93jZ4
         TrBbGjYn6qCWRNdf7Mcr9hTZiuPEU+DRpRD4KN8rWLyQg2u9P8lyCJgU/vuRphq/21lo
         w/IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709683124; x=1710287924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iW4+YjuNAKvAoJg+NmQ5C96xY/u5WzV8UruESW/Bs4M=;
        b=Sl3uJTMUk2fAfMpkzna+TY26zNyHVdrojtZyGgMecSFcYpzUPEGO6i7OjYPd11h38I
         PfTD4kP6hyGyHOlOMs6hPLPL2+VDT0Qu1nCF6yh9yFF7BeHi326bxIBx86h1BMK3xeRw
         fb+rHApYQ3jUa0zvaag1YtKuB/9CMjIMVwFZQuJrcj7omGFcf7Dpe9tK7CPD73mXxb5x
         iWEmxwa/nfAz7cl/tmzKibE5Xf25rrQRbk2B7jyyqD/SkIl/mnUAIeVbK/ifdN8H3tXs
         rHnH6wKCdVnj9PnTgKD9+oGuUxcf0FloGrG3zy/f3tj5EWFpQmavVDrGHp/kaIKkFk1o
         F/Kg==
X-Forwarded-Encrypted: i=1; AJvYcCXSQ+Rj9VFcKY2TKUkB9jHpySt1vpfYa7gQsrM6JvwL1PZNc+XSmDFz2dQFJ6jyjot0nnE8IGhhqNbAGb7G5ohsz/a2eYpcCTfjjw==
X-Gm-Message-State: AOJu0Yy6CBvzVuLIRpgRKnE8zLc0q04VlWofHViu0N3EFSDH4GEFPbIL
	Lhfc04tOKeP2ent+V3uemD2cAWmI8zjq9aIS/MAYl31UPcZ2m7lpW2hPzzb7UDEVIb4frljNhtN
	3CZat14b5Iw==
X-Google-Smtp-Source: AGHT+IHCo10p/LCIUXuR4X0ieD7GA4BMa+s0Kua3rnoaoX1L1KdO+HKSNyVkjWeL08MQ/A07Bzu15QUgFpNe/A==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:69ff:df2c:aa81:7b74])
 (user=ipylypiv job=sendgmr) by 2002:a05:6902:728:b0:dc2:1f34:fac4 with SMTP
 id l8-20020a056902072800b00dc21f34fac4mr3509623ybt.2.1709683124213; Tue, 05
 Mar 2024 15:58:44 -0800 (PST)
Date: Tue,  5 Mar 2024 15:58:22 -0800
In-Reply-To: <20240305235823.3308225-1-ipylypiv@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240305235823.3308225-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240305235823.3308225-8-ipylypiv@google.com>
Subject: [PATCH v6 7/7] scsi: isci: Add libsas SATA sysfs attributes group
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>, 
	Xiang Chen <chenxiang66@hisilicon.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"

The added sysfs attributes group enables the configuration of NCQ Priority
feature for HBAs that rely on libsas to manage SATA devices.

Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/isci/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 6277162a028b..8658dcd61b87 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -149,6 +149,11 @@ static struct attribute *isci_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(isci_host);
 
+static const struct attribute_group *isci_sdev_groups[] = {
+	&sas_ata_sdev_attr_group,
+	NULL
+};
+
 static const struct scsi_host_template isci_sht = {
 
 	.module				= THIS_MODULE,
@@ -176,6 +181,7 @@ static const struct scsi_host_template isci_sht = {
 	.compat_ioctl			= sas_ioctl,
 #endif
 	.shost_groups			= isci_host_groups,
+	.sdev_groups			= isci_sdev_groups,
 	.track_queue_depth		= 1,
 };
 
-- 
2.44.0.278.ge034bb2e1d-goog

