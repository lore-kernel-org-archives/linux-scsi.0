Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8D63264D9
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 17:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778694186; cv=none; b=BQSt800YLmQumQc87nJ8Ii+F+3o8T9GR+cV5DCVxgl1EAE5gtpAY3l4tisV6QuoZWIW7QJbKcC1D775Lhmd9Tfwg0uKVE09gOKCGtCe0XuBB5QQY5uQl5AZadV74lr9q9x/SuFgRCrLm0Mu4Uxv+PmJEE4TIUL5EQN3OBUlGG7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778694186; c=relaxed/simple;
	bh=zbGuInjLrn7sNNtHp/Aqb5W6LbXk9dNsV+4Gb0q1vAc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ILhB8Le9KxgyeLE4LdzIOC5WuYAPGylojJ4uHEx97ilZMvaF4OB+1uci6KrLRLog/wcCL2e8N6n7Rv5ygQrhK3jY8x3E+4ID0VO4pr3Mt9yOpzGCqSrCRqmPBfKG9yLUvp43ZhmqskW2lkEdoV9tETiJeQtJRlWXVX227Kfzhmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QqGxSBQ0; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QqGxSBQ0"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488af96f6b2so84695435e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 10:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778694183; x=1779298983; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9mKf2vGe+YgF4AysgnStUnZi69Jvk/AIlQiBs2iLamM=;
        b=QqGxSBQ0TuDWtuMkJ9mnYPh74BOlFk0laHWRBx97pZCCqm/+rKgG7aZZ9KWeOdOi70
         MAvkk+Q2dK/TgBcAIFQdBK20r+f2G3JDz1inyw/x+/dH3ZMSPcimk+oASAim0xTdTJCP
         UVYA/qdVlKMWQ/PNOo5NdwX6eUNMFnhlsD4pmkC8IMsp8KTeZxqB4HG5IgfZ6HECCYxq
         HsQLtp1sUNgoj8jzVvaJYlKKeNUAtDB81mX0Jx/J/t2hOVZXXN2Bg9X1XspcMTgU71RY
         elm2I4dH2LkgVrZAd7zsZMoqt9LLkz9xlLhmKEJ4djcsefd4L0htlEFVf1eEu3AJvhCz
         hwng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778694183; x=1779298983;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9mKf2vGe+YgF4AysgnStUnZi69Jvk/AIlQiBs2iLamM=;
        b=lQVNnxDvsUEaliJaOWaGVOEslqbAFToHq/l0FafPfvMwcG+NBU+FLxY2dUkEXgjgJi
         OabpLZddmVXWLNT0nKpH6m2/tDE174kF02cg1YVjNsVhSNONBhmHeva8VzeXcwPDM3Xu
         P/PK2MBu/L2RojcNFaxbujFIKL8ay52hgcGCU9ueIs6trm1DlY4k02Flev6JiG6ZbrCT
         rQFXF6UXjI17hnktTZavipF/5zwZtVbx/qrdCr/XnVQX+o0qXZ+qaYlBaVlam2TMHHNG
         yZd3rBFXqeKyWcX+kvPbBEdcx16A7nKjWi/LoD7AO2l9KMuob6CtUVu53h8xZ61uFlFm
         sMlg==
X-Gm-Message-State: AOJu0YwhoZU+rV65ncXlQjrfmP+Bul9Wzqt39FwmEtrk+y+vsYAAzbnh
	RpRN6CGADw2P2+kFC4WW2rzDW4BFiw/JZX0ob71J5qIHAgob1WfyEpBnjw7mePkFYc0=
X-Gm-Gg: Acq92OH0p7lDF9mT9hmftzJHdH+5+3nqRUilcF8Kh6vgPQOsq4JfGMwxxEt3+m58GxR
	9DfCdSRPi74h+2KFsk9zypRNt4bZ0U8EFti0zNf8g/DUf/OVcd7ZWfePh8eK6UwzaGaNqkk1I8A
	B5V3CaVgbvyAs/wrf4m4auy4CUGFS5X7/U1eXvPgwqrpumv+HfKXVpweSRtWCRFGzkRrgzsrtKh
	PGP0kTAtWzYczXpx3pdtvUs5ptWxTMeC0EIOfk+8nmAhwKwMbF0iBAC5AzllUlj4zgxU0ficMyP
	Gqo4s7ra2x/jVveGJ+H9Hzwtx5AtWMdEjAkSqcHRiLLHvQw7vZgdzV+R48LMPMrR8i1luA9N6FJ
	kqmcakMcrb0DfjmpFK4Sau1888w+1eL114G6Jze1do6twpRMRUQ5qMpPG1ydprEE2AvLGLhRKlZ
	j5F6kPdFkvHzoqYhUVfFusyhRAUN1a4hcgl4lgY6Wm7gEvBJkU0HwobNgfo771oBBxtxILCL1mQ
	joB8fV7jDb3pw==
X-Received: by 2002:a05:600c:138e:b0:489:e126:b757 with SMTP id 5b1f17b1804b1-48fc9a51304mr66408585e9.25.1778694182769;
        Wed, 13 May 2026 10:43:02 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48fd64a0e38sm6229485e9.7.2026.05.13.10.43.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 10:43:02 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Don Brace <don.brace@microchip.com>,
	ranjan.kumar@broadcom.com
Cc: linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	Martin Wilck <mwilck@suse.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com
Subject: [PATCH v3 0/2] Fix SAS wildcard scan on smartpqi and other controllers
Date: Wed, 13 May 2026 19:42:34 +0200
Message-ID: <20260513174236.430465-1-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
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

v1 and v2 of this patch set proposed leveraging the functions scan_start() and
scan_finished() provided by some SAS drivers for fixing this issue. But the
review of the v2 series by Sashiko showed that this is a complex and
error-prone endeavor. Therefore I asked for some guidance on the ML [1].
I am now proposing a different, simpler solution to the issues we observed,
which is simply reverting commit 37c4e72b0651 ("scsi: Fix sas_user_scan() to
handle wildcard and multi-channel scans").

This revert will require a different solution for the wildcard scan with mpi3mr
and mpt3sas with "Tri-mode" enabled. But it seems wrong in the first place
that adding the support for this special mode of operation for some drivers
broke wildcard scan for other drivers.

The first patch is a minor fix for smartpqi.

[1] https://lore.kernel.org/linux-scsi/61b4da9dcbee8fd71d1ecb2cfdca5c2408528bd7.camel@suse.com/

----
Changes v2 -> v3:

- Removed patch 2 and replaced it by a revert of 37c4e72b0651

Changes v1 -> v2 (obsolete)

- export and call do_scsi_scan_host() instead of duplicating its code
  (Hannes Reinecke)

Martin Wilck (2):
  scsi: smartpqi: use shost_to_hba() in pqi_scan_finished()
  Revert "scsi: Fix sas_user_scan() to handle wildcard and multi-channel
    scans"

 drivers/scsi/scsi_scan.c              |  2 +-
 drivers/scsi/scsi_transport_sas.c     | 60 ++++++---------------------
 drivers/scsi/smartpqi/smartpqi_init.c |  2 +-
 3 files changed, 14 insertions(+), 50 deletions(-)

-- 
2.54.0

