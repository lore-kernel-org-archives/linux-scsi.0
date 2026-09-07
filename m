Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F49E362152
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 04:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788755066; cv=none; b=IvD0kvJGrkwPYLOLdYgQK/L1i35Bf0m2Ggo8/XXDF6gri0Gor0sUbxCN0WoiuWZjdY5P0EjuslfOo/gKeABz54V0exHh514bflFfj72sGwX6klQaH4hj7Y7aQSsosaZ1vEmqF9jREF9g02zJaVyt2xpBsAe0jH6cYbr5S3306UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788755066; c=relaxed/simple;
	bh=b8397s6rxrFw8Jh0i+WpcqO3/9x3XxXO+xcruOWEfqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3kLGAFI+c2kaVG/s56qHtmdkmSVC0BP5hj89Wx1Vhemt7ZSZTh+7WZtq+6QGUN1Dc37ZW6/yTDJXslRQLjxxTJekbI+wO9WvmYn87YH2lDskOaGTVBuZTSL1euGZkPajsiLQqK4Y18im45vm/9ArfKT1lDZkYwce8b3NHMGWTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TKWMMp1Q; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TKWMMp1Q"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ceab75934dso29488965ad.2
        for <linux-scsi@vger.kernel.org>; Sun, 06 Sep 2026 21:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788755064; x=1789359864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9gOfzXZ7OX3db6K93hBUSUQSq3Ddcb5aXbz13zQbpzY=;
        b=TKWMMp1Q9eWMUT3S15TdGyFylUmmq6TtWeL0F8OyVzTAt+EpsGBINcyy0FDN4TIZef
         Whe1O2RhPwMzw9kFu+m8hKvJkAh22Y9BuoH21kcxBozVO45ftw2pTInwWWCOtntpumU8
         CRKB3y5VuO6Y/i7yOwmxkPe5yAjv94+t8pfqPrNq4JJRjMBDP+gZJXmp4FuAToa4xX32
         526uvbbhs+baYS2Biu1HyzwDHutJxAsIYE6dcBjI4z9cp3ZTtOw56x+A160c52k5kBiZ
         3yFX6KObrN+8GUZ15wxktTUnzYeXNAtyRThEpW968/2CdNC+lD4mkMDnuF9aPhYxKBXC
         eYoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788755064; x=1789359864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9gOfzXZ7OX3db6K93hBUSUQSq3Ddcb5aXbz13zQbpzY=;
        b=EpmacX5/M0tulpsjRI0hmaXn4Jm/SO3EBa+H/LVD6WNfaGnMs2ABEQxf+7PNL8BNmQ
         qIvyYzEkGd0w5tDPdCKMg49ikc1+W7dQmdWrNIrd/n9ZHLIDq087C1n/cV5cdYMTGHE2
         hgcJNbb2AJuXIN/E8hkv7daCThlfVU9LeuOWKMapuEixhBvS/iopvYn6GSv3HPyHkow/
         NOX9qt9H3W9Zw9tNK8Zq/aLOAcYla3G7WeIftP3bDfM1avUDqeKa3pOlML8MHp3nBnrL
         7yUE85I1rxnY3liymR9pJQwk9WaI80jP0ExKiomcb/uMpNAeog/X3uXM4efWmqwOTYRx
         BweA==
X-Forwarded-Encrypted: i=1; AKwUvBxh8gfZ4/+2J91fwaQgS36B6KEyrhskYeqjiNkS5LkfBlJlBP+4kWtE2ABDyf0EiJzNqcmSKZnAyTTi@vger.kernel.org
X-Gm-Message-State: AFuF++kC/XXBU5aIwRLon9GZadcLYjDm82SWKYlU1VcToypcLbI+WNxO
	s6MChL6VLcmx/HIIAG4iGo/J2XyocOpx489Sytbg1eUCBPgquN6biLPH
X-Gm-Gg: AYBFou1xPeI6CgxL+u3h22xLQSx0Qy+jXDdrpD0JGDRRum2WHOo12erQiLBC0hixOwJ
	+fRk9KCqzEu6xe5GNCP5IQGC9FwSVPPaWsN5XqtgYSaU+L1fr+GPiwqgN+5Kf55NrTzXLX0cZU5
	oXO3JGGed1/gDbev5988fyKoJeMACAcFXqL/nUl30sHLuzykmm+VJ/KsYoW9DF49XAHPI2/5B+4
	ih0e5vlJAaDb7WIhS+veNNdZw1FM5GcIyQTPMh3iKolx+sKZymPBblzJi5oPGt0pebVfXMK6yLS
	MlvGMhvyX20xGHghxwoXQJ83wQ+S+HPZXAivIXLrzWiOnDC0uXI4lsFPC9pwFOwUnz9YecgFfln
	vBLpHJfsZYbvlKK3Fya428kLiA/EFLdQ4ZZPFlDo0FpBneixLYaSG4X/TRtKg4dzNwWhG/59si+
	7UY7hsliMfPH0waTJ41ch5qbtfgSfBRf8xzRDkROVOGp17OrrwOeNQZJqQ3bEJ6s5nVKOwLXemB
	5LzlyD4Iu9W1Q==
X-Received: by 2002:a17:90b:3b46:b0:398:dcfe:967a with SMTP id 98e67ed59e1d1-39b2620a2ecmr30060909a91.17.1788755063559;
        Sun, 06 Sep 2026 21:24:23 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3342af0bc08sm22629643eec.17.2026.09.06.21.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 21:24:23 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	Oliver Neukum <oliver@neukum.org>,
	Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	Hannes Reinecke <hare@suse.de>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Don Brace <don.brace@microchip.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Doug Gilbert <dgilbert@interlog.com>,
	Narsimhulu Musini <nmusini@cisco.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	storagedev@microchip.com,
	megaraidlinux.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH 2/2] scsi: fix repeated words in comments
Date: Mon,  7 Sep 2026 09:54:01 +0530
Message-ID: <20260907042402.12893-5-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904121449.24178-3-hemanth.selam@gmail.com>
References: <20260904121449.24178-3-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please drop this patch.  Three of the changes in it are wrong, and I only
found that out after posting.

  drivers/scsi/dc395x.c
    "but we'll fill them in in case something else needs them"
    "fill them in" and "in case" are separate; the sentence is correct as
    it stands.

  drivers/scsi/aic94xx/aic94xx_scb.c
    "if no device is connected to the LED, is is dimmed (off)"
    This is not a doubled "is", it is a misspelt "it is".  Deleting one
    word leaves "is dimmed" with no subject.

  drivers/scsi/sg.c
    "but is is possible that the app intended SG_DXFER_TO_DEV"
    Same thing: it should read "but it is possible".

I was matching doubled words mechanically without reading the sentence
around them.  Sorry for the noise.

If a corrected patch for the aic94xx and sg wording would be welcome I am
happy to send one, but I will not resend unless you ask for it.
