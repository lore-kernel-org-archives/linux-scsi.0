Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF62E480321
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778076952; cv=none; b=m5p01SlZNjdpvkel0WhpWQaFUxKPIatdMLL4K/TUkYcNn2G6R6Bm/SaZ0hwojK2cxCFR97JQ8RWyGxf6zQMyoxGtGtmlwa/OIinYCCy3DJgG6iFRDYYYrxW/Hg1CBFPXiOnzuZrElRPm5r/BAZudR1F8x8Lo+7ODXmkBb4ryDME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778076952; c=relaxed/simple;
	bh=zZcagGFZAjrjlPTdskd9mqi0QrGre7yqU1eShhuplxw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Exk8VdJQNfcGC326XnLy4o5RAn83LwzDUGfnUo0w9OhpLMOqxzKTYlwhA/BZ4As3Buh3JUPoJ3Y565g1oxogvWj1Mx2tPoH0nlL0Lm8uMYLgDoL3Fvwact7xeH2mnKi8xbRyWKFwrSKx3QZldeH/Sov0rU+bwcvI4zhSuoHwA3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BJ9XhKk0; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BJ9XhKk0"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891cd5927dso8622855e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 May 2026 07:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778076949; x=1778681749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Io/N+hHnLMI/zVIF68lkuWkyC9l4bvcPQWSmOV0m6oQ=;
        b=BJ9XhKk0MrbDVLaIWxMT5d6zEFaVIIJWRlMtlXLgjDCsfaIL7Z8IJNXOxW5Z4ixUDa
         oF8it0AxhKV9+BapijXl4FQXvUb1AjQCz4aGwdIcJfbbYd+xmxOR7ACUq0nPR/T8RIrC
         Y6p6CA6k/j0YV8MzD1jdKNuS4u/D0gVtWsvYkOFhlX5+bEhRpdmLw0I7K/dVMHz02Yn2
         6vlis2G9tkVNhGRhWqP4minQrJKfhb+LHGSEzUHOVpbEiADOpLEwGtcBKIaaFvcOZeiS
         +HKCx0aMP38thLUd7G4q/5pt536KRrUXhVHktVAMWaKu7I8KG88AYNoKhnwyQ+e6vod3
         LOXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778076949; x=1778681749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Io/N+hHnLMI/zVIF68lkuWkyC9l4bvcPQWSmOV0m6oQ=;
        b=Qk4+DrE7KG3NyESxTaLp6+og74mTqcSFQzhfqUbS8UUF2+DDFoCU1xoJ9ZULnBeBlQ
         mmv2Jt5Obr5LphOdDiRbRrA0sYe6a6RKJib7kARWMZi1fOXi8bdpg7fnsXEb445MkneG
         brfmqpyjOpsTx7NynLm8ghb3lQNY+mIR+pB1jhZeCDI2S6Bngx2wfPISPt6cyW6Q35M0
         ZQuNWoM8zm2cMKzo1PcCn2hqdGpgnXJm6gFc2XybJGDGHV/2wR0LClkMGs/vjGETTaaK
         IRwIv6ZHPASVttH24dyvTRUHF0DAwsUu3hm36ZXEP98UeiiQzjmUpiAsHI5sbBsfAuEG
         84Ww==
X-Forwarded-Encrypted: i=1; AFNElJ+9uQVrVUC5dT6Tv3jA4kRuJkkWhjZY/bQL8AoN8eWYa/5hAWBUl5r3/6VvIbchuSU/JbA10rAc7xQW@vger.kernel.org
X-Gm-Message-State: AOJu0YyFql80i2g3snK5qZyAvQJhHOmKz5v5j+oHzM80TI/yLaMgb9vG
	ZW9pKO/awZq3FjmW1Tro1MfHUy18mDbrgEY/OblPrzc0QPqhlJWBK3Y=
X-Gm-Gg: AeBDiesPiBywqxzDxuLXW3tRxIkP6IvziS8H2R3fJu3+F2IWPiX9rc0Wq/pSBlZWUIV
	aBfX3jSUBIltW3v14E8Zy7aiFHiPsLmjBdFYrtDKg14JQ1ZZQd4OBlOan97KwXvHWG+QvqB8zEm
	4Dt95veF3CeTWgmzlJMAQzgz6dr5qwEBO+bp+6vfnVcDc9TXK4qBhkiN8b296RRz7IjPhXOYe6K
	qqIgyRxrDeW7PIW54u2qbCE02CY5ZhQHEmKaoTrimj4BjSw8ZyIufNfGr3gNpqg1V2dY3Ru3zv4
	+AJC5r/WCaP1QtP/982u5uHWW9zAku9KYTlJzGW+75tS9Xrr947TNchtoiYxfgTzmmtXXN3glwq
	x+Ke78h7+jOkGHR8Oyg6+yJsuCIwCP267Oot1uktH1Gp9867kUQA1AiJjayEjX9mWvmvkCfd99N
	9OuDmATjwRcD8NWaiqtt7paeVcFxEm87C4Jn7YQt7CHcN6gkaggepKCFV+Oqq9lEkBAqSfMwA/
X-Received: by 2002:a05:600c:1f95:b0:486:fc61:541d with SMTP id 5b1f17b1804b1-48e51e124b9mr32527385e9.2.1778076948868;
        Wed, 06 May 2026 07:15:48 -0700 (PDT)
Received: from localhost (8.red-80-39-165.dynamicip.rima-tde.net. [80.39.165.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4505558e213sm13671647f8f.25.2026.05.06.07.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 07:15:47 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Aviv Coro <aviv.coro@ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	Caleb Sander <csander@purestorage.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Chris Leech <cleech@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Christoph Hellwig <hch@lst.de>,
	Clayton Skaggs <claytons@netapp.com>,
	Constantine Gavrilov <cgavrilov@infinidat.com>,
	Daniel Wagner <wagi@kernel.org>,
	=?UTF-8?q?David=20Santamar=C3=ADa=20Rogado?= <howl.nsp@gmail.com>,
	"Dmitry V. Levin" <ldv@strace.io>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	James Smart <jsmart2021@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	John Meneghini <jmeneghi@redhat.com>,
	Jyoti Rani <jrani@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Li Xiaokeng <lixiaokeng@huawei.com>,
	Marco Patalano <mpatalan@redhat.com>,
	Martin Belanger <martin.belanger@dell.com>,
	Martin George <Martin.George@netapp.com>,
	Martin Wilck <mwilck@suse.com>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	Maurizio Lombardi <mlombard@arkamax.eu>,
	NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Randy Jennings <randyj@purestorage.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Simon Schricker <sschricker@suse.de>,
	Steven Schremmer <Steve.Schremmer@netapp.com>,
	Thomas Song <tsong@purestorage.com>,
	Uday Shankar <ushankar@purestorage.com>,
	Vasuki Manikarnike <vasuki.manikarnike@hpe.com>,
	Wayne Berthiaume <Wayne.Berthiaume@dell.com>,
	Zou Ming <zouming.zouming@huawei.com>,
	BLOCK-ML <linux-block@vger.kernel.org>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>,
	NVME-ML <linux-nvme@lists.infradead.org>,
	SCSI-ML <linux-scsi@vger.kernel.org>
Subject: [PATCH RFC] nvme-multipath: optimize path selection in queue-depth policy
Date: Wed,  6 May 2026 16:15:41 +0200
Message-ID: <20260506141544.125089-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Move the zero-depth check inside the optimized path case to enable early
exit. It avoids redundant condition checks for non-optimized paths, and
eliminates the per-iteration check at the end of the loop, improving the
performance.

Cc: Aviv Coro <aviv.coro@ibm.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Brian Bunker <brian@purestorage.com>
Cc: Caleb Sander <csander@purestorage.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Clayton Skaggs <claytons@netapp.com>
Cc: Constantine Gavrilov <cgavrilov@infinidat.com>
Cc: Daniel Wagner <wagi@kernel.org>
Cc: David Santamaría Rogado <howl.nsp@gmail.com>
Cc: Dmitry V. Levin <ldv@strace.io>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Ewan Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Smart <jsmart2021@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: John Meneghini <jmeneghi@redhat.com>
Cc: Jyoti Rani <jrani@purestorage.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Li Xiaokeng <lixiaokeng@huawei.com>
Cc: Marco Patalano <mpatalan@redhat.com>
Cc: Martin Belanger <martin.belanger@dell.com>
Cc: Martin George <Martin.George@netapp.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Maurizio Lombardi <mlombard@arkamax.eu>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Nilay Shroff <nilay@linux.ibm.com>
Cc: Randy Jennings <randyj@purestorage.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Simon Schricker <sschricker@suse.de>
Cc: Steven Schremmer <Steve.Schremmer@netapp.com>
Cc: Thomas Song <tsong@purestorage.com>
Cc: Uday Shankar <ushankar@purestorage.com>
Cc: Vasuki Manikarnike <vasuki.manikarnike@hpe.com>
Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: BLOCK-ML <linux-block@vger.kernel.org>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Cc: NVME-ML <linux-nvme@lists.infradead.org>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
Status: Compile-tested only. UNTESTED on real hardware.

[I do not have access to this kind of hardware]

Feedback and testing are highly welcome.
---
 drivers/nvme/host/multipath.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 263161cb8ac0..7d212f6e865d 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -409,6 +409,8 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 				min_depth_opt = depth;
 				best_opt = ns;
 			}
+			if (min_depth_opt == 0)
+				goto out;
 			break;
 		case NVME_ANA_NONOPTIMIZED:
 			if (depth < min_depth_nonopt) {
@@ -419,11 +421,8 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 		default:
 			break;
 		}
-
-		if (min_depth_opt == 0)
-			return best_opt;
 	}
-
+out:
 	return best_opt ? best_opt : best_nonopt;
 }
 
-- 
2.54.0

