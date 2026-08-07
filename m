Received: from mail-wm2-f9.google.com (mail-wm2-f9.google.com [74.125.225.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C3735C6BA
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 08:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786089840; cv=none; b=tcV3GLftm6E8Ro+XKJYbIO67c7k+q9zR2b+NhmFAe08Y/HDCrKmVVUtVTT4TruRXrGpY1sIU0I8Mh/oXYMMafIsU8fLEE+bEj1IDis3YilWtDyU3dwPm/1DBag3ewgWG/RZYrYbAHy5rScznkK8SuEtrKNjOEhLSd7gCUDV1SgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786089840; c=relaxed/simple;
	bh=wpA4wGKdfEQsAb+ErKq9hRB41Ak0nTG/7HtyFUq9sbs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Od8MsaNow9vbeSvLl/DpfHIE10ha6nqj5Nr+YYY5qEVwAk4hC+5GjPGZSieUVfwzuT0XbfCNhvpv86dNFyMLUTHLkhsB/Xeeg+SMQqSvtSfwJD4HCj5FZxcLnqqMiTbbpDUGJeUXPD7/uH1OrYDZ2vyRoeyLn0U/PHT1rpKi34Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WWJuHt3G; arc=none smtp.client-ip=74.125.225.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WWJuHt3G"
Received: by mail-wm2-f9.google.com with SMTP id 5b1f17b1804b1-49553b57612so6494785e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2026 01:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786089837; x=1786694637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2Os9gmZ7ykjaOOgcnZPDqpq/qN85Sh8iZbFNg2fS1NY=;
        b=WWJuHt3GPF5QCjBrirxD0tZ0heE7PAobjsEfhCIXIZjS4VoyNoq9gEt4v9R688GbPI
         QnrEZjk3wnvQT9ubtmgug9H571oBVr6mkXQz54rUXt0KWF9Hv2vOfdrAMOHLN/2yYGpx
         MIUMydBSPASA5BiCeDRCOl+t6MKIYeCj5c/6/QJIzGrK4tejFtuwW2yg51C4PiIS7shU
         KnqxATigi4ZGuPNvZYROlmY22JGkHfvf/rQZ07P8KQbvrAIfW6zjeCiIX4Uiaq85TFbk
         FqS2qYSLRzXbHVg1YZV8LduHyF6j0M/PpBcocNeexAjPT/++7JwPMtsWwbhhE9uid+lR
         GLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786089837; x=1786694637;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2Os9gmZ7ykjaOOgcnZPDqpq/qN85Sh8iZbFNg2fS1NY=;
        b=Olk2VjcrjkH1Pog/PbnYH756lZXzgv4xDAWIuLjjtgVovd81RphAVOYognj5/o8Wbu
         7d2SIJyown/irN5WLb8rumaUUAQVupthcs2a/i2NVibdA+rxmPRPo+NoGsMdZttveIeH
         5tysi+sEQIZ6J1gpxVJd/rHOSm4Q6DqPc+73V5av878GfrslTTG6i//m62vZy32N0QkW
         mRcqX005hvt1GgmjHVvJPGFTugmxaz5Zg7AXz3bkb4tcx5E0nT7iIqPflpXlubkHx5+Z
         RwmxSGDIXCcA+o5JXLPpz0LxK4lyWD9i4YB04lJkhhOZ8C1x85qnDtuLiruYkc9DL1wr
         aZjg==
X-Forwarded-Encrypted: i=1; AHgh+RqJZvvHWlUcs8MiIPF2vfaQBPVdwCjluFae9YZcOHZkU6u0IoFSZPIISkmNMe/pkuLjPUtpRNglPiB8@vger.kernel.org
X-Gm-Message-State: AOJu0YzsdAp5XezOT0h7mXPIafyuMIYXiJJ3Xh9FtN/EXsQyoqmFgdnS
	o1FQfuzueqh2mmv1Mly3jPmePufi1cQZuUNYcv7i3L5v8axv7XG6LtWy
X-Gm-Gg: AR+sD11b3LP84aYJjp/uqfVJ54DoeHXD19/u1H3m0Gijx7Dpw/V7dmPtex/HrnfGC4+
	H3KECFp7iNnzaLeE98j14k5ixNUBf07Kv52THw+KzIR0bDLqayK78oALrsPAjl+Q7yNNavqIYrE
	dRWUDV+LpVGXGnw9Z5tZ2xmkdWqZf6SJUgVnew6dzlfuA4U1vXJmInYZQweq0bPm5io6xchM434
	MhCsi+NL3nABL/95YR8COXDOp699+STBFMnzQFn+llNGHu2vUgKvjUckmQehUC3tbVRABYt+SaE
	QLSH4g8PEeiwcpXbpmYyAcfW5XgqlAq4jXNSPGJPxAK3SRNHT3oYmHfv4xcueyLtGQbhExpQMoF
	HkqvTNCP3KkTnBBBiWyMWA/K0YvoqnEQ82HcKi0LITGkoW/WaXaBRwQNzoL6O7YQTpR7bB93PUn
	3wjxezFKBECGmC2ufzWLabfKxAE3IJ5wTEB69S3C0R1ienfs7zF3iGd0TNW/2ZQZfpoFtPFB7/w
	B4CgQ==
X-Received: by 2002:a05:600c:3422:b0:496:c18c:f9a1 with SMTP id 5b1f17b1804b1-4994e7cb6abmr216202005e9.14.1786089835700;
        Fri, 07 Aug 2026 01:03:55 -0700 (PDT)
Received: from localhost.localdomain ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995d85b96csm13881625e9.2.2026.08.07.01.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 01:03:55 -0700 (PDT)
From: Roman Demidov <roman.demidov.nn@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Roman Demidov <roman.demidov.nn@gmail.com>,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] scsi: advansys: Fix invalid comparison in AdvBuildCarrierFreelist
Date: Fri,  7 Aug 2026 11:03:37 +0300
Message-ID: <20260807080339.9365-1-roman.demidov.nn@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The loop index i takes values from 0 to carr_num - 1 therefore
the comparison i == carr_num is always false. The assignment
next_offset = ~0 must occur for the last element of the list,
its index is carr_num - 1.

In the adv_get_next_carrier() function, the last element of the
list is determined by the value next_vpa = ~0 or next_vpa = 0.
If adv_get_next_carrier() is called with the last element of the
list as an argument, instead of returning NULL, adv_get_carrier()
will be called with an invalid offset. The resulting address is
outside the bounds of the allocated memory, after which
carrp->next_vpa is written, leading to memory corruption.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 98b96a7d99c8 ("advansys: Use DMA-API for carrier buffer")
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
---
 drivers/scsi/advansys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 5cdbf2bdb13d..95a227420b28 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4169,7 +4169,7 @@ static void AdvBuildCarrierFreelist(struct adv_dvc_var *adv_dvc)
 		adv_dvc->carrier[i].carr_va = cpu_to_le32(carr_offset);
 		adv_dvc->carrier[i].areq_vpa = 0;
 		next_offset = carr_offset + sizeof(ADV_CARR_T);
-		if (i == carr_num)
+		if (i == carr_num - 1)
 			next_offset = ~0;
 		adv_dvc->carrier[i].next_vpa = cpu_to_le32(next_offset);
 	}
-- 
2.53.0

