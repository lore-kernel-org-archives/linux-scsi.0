Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3D564
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 18:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776191276; cv=none; b=Ve4Fi/2IIbkUWTEFypi5tHulVAgSuJG/QZ9/QBuqO71Ytd6JfJyHwY+pv+Hzvb/Q5CbAsq/C6ib+OQfnlQBcgi74Ldp4FkceE9J6fZOBgEM3iX+exKsVRJHSp4il/vk+rcJKY3CoS16IB8TY2fAhmP3gF3p+abv5LFjpfGTDhKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776191276; c=relaxed/simple;
	bh=GBH9XKDPiCh46F8M2/HZODnwDQDwS2/ykoBsfui0D+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hXVfSQiwXPiUlJfC7lLfd5BU7XY+U2RwTGC6z4M6bSF7tXp0RlVrIQOYjF6PndocF7EDaFHgsrwN17QIS91yWweuMV+sQssoqG2xsIlC7va4acZ9gxpz9oUYFI3/OEVTl3HnPPb6FUQOct8hcpIbf9vNPZzv1K4UQCFBKEZIFSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=dJKH14Pu; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="dJKH14Pu"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2d96243c91fso4331167eec.1
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 11:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776191274; x=1776796074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=netVJOmyOdXKjOl0WnRqogzYsAyFf7P7QgQREMM3OAs=;
        b=dJKH14PuGbOt9eTFig9Fk8K/mAT1Bu6hUqZlqkpz2/snRUbmJO8cdaABc7cBjtgfYl
         7UIrAKp0F8kJMXvxVwcEkYmDYRPekagR+RxdbNUBI/QI5hON3oTH8gfApvvZhbkEZ3wf
         PtfJC5LE7QFh/bzmJAW+xLchGfsZhX6RG02bwwWtJvsxJttXB1hOrI0MM4MWKJNBk/+s
         W7E5eRw3SgeXWEsRqqq9ezCFaw/iA93TohAGwi+OSL1RNTW0rfNyL/x9+6Xlt0aldYNm
         9nNYG5GEXVRx9YAZuD6kZT8a0MZdmHDNDeJimYD2YHC0Ka04AbF4NNZSUcthrpcCyaRl
         JEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776191274; x=1776796074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=netVJOmyOdXKjOl0WnRqogzYsAyFf7P7QgQREMM3OAs=;
        b=fpt86zJ/KEmfn+vhnqDLSK9+aakAutdSVNex8hcV2tbT8N3OOhh2NhUVFbZqn5pZua
         zzmSZLl+6eSLuIKZXmFs/kPmFdaS1JFZSTiPmRbDhbSc5WrSz+9NMIVZK7nVCcGSbgAs
         lna1hNO0F0gNBSqK848Qk9dyq2/T3o/8seMKsTrJ+Zooj32mxtX2bq+w9bCBYIZbdFrJ
         DsrNsMxaPv+q2L9lXAnsp0dOTE20K0+apscOtpmohV4p5k5LvWPm48NYiw8NmqDDu6Bn
         LOQGrsBKJIKE1xfrGdbl2K9TyrvlXQ8m3tmhVUpA1O3yChKZw3m22m4q43v7pCZ+UeC2
         iW1w==
X-Forwarded-Encrypted: i=1; AFNElJ8CVKsEi+0pnnyfQIZteNeBg18q0xVC34bcEDXmH3GSIH4ws2NHcOuXQ+5xUlrsguibwnX/nyJ1sDSz@vger.kernel.org
X-Gm-Message-State: AOJu0YzvZQZmcIPwAStTcK5HwZ4KoaB9f6N3LQ12oRg7dTXa8IoOxBvW
	h/G47u5cnMjD+RBg4EkXnCE3m/l/hRq/WXLiIzl1S5LNw+IHofE7DhIRiIzzBS6QjIw=
X-Gm-Gg: AeBDiev7va0J8Nw3n1MMEwiRX9GCeEhDsP7izEGOYY3TpqygsP8uO4woj/I77WpLhoi
	59OGxlqkaSPRhbdDYAR8KK8iufBPcRZ7Ry1Ljg73b2vLjkYc23xhx9JKqR5ifCxAv3yDzkL/Pgk
	Ah1Yk+NqLqs6R90nV1xrPh4aYvwqukUER5tOBZolQQKyc/Ze8XzQUcHJmHq9ur762Cd0GJmNckT
	3MefUphqnNccUOeboXh0iiLHvA1a4SLdb/CZiD5dfxt+fgK6kKGNo1H3khoNOxEnudZIAUTAY/Z
	abPfoga/KANtmqyOKMH4k0CLsHrEcUPHHjJ9gcWP8v13WMkI3296fUXh+39ZhV8OGhWWjUT2OE5
	9aROytDcaPVA6JrjpeTCfUxhOBhjrWB0x8sGOUA7AJtaTBF8LYw/Dvt4WHSNwb2RkQ1urnlT6G1
	t4AEQed78uVBu2z2A3loyffVJ5fqBZgZ5foAc19ZGA9VWXrez/guIgyTObyaNUJc5kjZ3+J6xFF
	NW1Sk0tFY/kYpPuDqihKo/g926AzZkmtEU1/IE6az6yULZQT75wLt5473l0cqloKTdUFiYzcguX
	QroDpqOtVXzZMOElOedxKPOw7D2DbxzLFaA=
X-Received: by 2002:a05:7300:d4ce:b0:2dd:5641:ef2 with SMTP id 5a478bee46e88-2dd5641154bmr1611809eec.25.1776191274441;
        Tue, 14 Apr 2026 11:27:54 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.104])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561bde70csm25813550eec.15.2026.04.14.11.27.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Apr 2026 11:27:53 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: hare@suse.de,
	linux-scsi@vger.kernel.org
Cc: Brian Bunker <brian@purestorage.com>
Subject: [PATCH v3 0/1] scsi: scsi_dh_alua: increase default ALUA timeout to maximum spec value
Date: Tue, 14 Apr 2026 11:27:47 -0700
Message-ID: <20260414182748.39776-1-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ALUA handler already maps a 0 value (no implicit transition timeout
provided by the target) to the ALUA_FAILOVER_TIMEOUT constant. This
means the kernel is already saying it won't accept an infinite
transition time - it substitutes a finite default instead.

It has been suggested that some arrays may take tens of minutes to
complete transitions, but even today those would be broken by the
current 0-to-60-second translation. The kernel currently caps this.

The SCSI specification allows the implicit transition timeout to be
specified as a single byte, meaning the maximum explicit value is 255
seconds. This patch simply changes the default from an arbitrary 60
seconds to U8_MAX (255), the highest value that could be explicitly
provided by the target per the spec.

This is a minimal, safe change: we're not removing the cap, just
raising the default to match what the spec allows.

Brian Bunker (1):
  scsi: scsi_dh_alua: increase default ALUA timeout to maximum spec
    value

 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.50.1 (Apple Git-155)

