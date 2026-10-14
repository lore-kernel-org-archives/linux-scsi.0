Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C56551986
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991463; cv=none; b=kLvUI5txNo8CgMtoGZJyBJMxHSCdr4/IFCz/5qP21+g6SuouEhVHCLKa71TINcM11Vm2H4o7PX23E+pZdAQPxvIRUQi78CwrrhOZztY627gwK9a0oDS3bPV/6h29qURYw98SqkfmgGUfktSPLYUkfuBvgG0q8/3ueYV6YsO+lIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991463; c=relaxed/simple;
	bh=AuomWEZX4AZzaXCJpww4x5u2oFWJ1CWj9oyE8+TmNiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o7/G7cXRlwJnRBE2H4IWz904cwL/MmXW+HN3BLOHJpXjTO++HDuWiJreU7Ml4ucV9+BkvMRTqpzoms+4wjAKRd5GHs4qVL8T/PElxYWvF4BPsEW7Bu5Cse/hor+KHBglAIIScALFbNlypOq3wBhcwzb5ut4GTLAhg5IpRqnmBSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=tim4LgQF; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="tim4LgQF"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e618db81c0so9715025ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 08:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791991461; x=1792596261; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Oe+0IhcD+dLnpRRZ2AO6uP7D6+WkqiUo4+grQwp5VRM=;
        b=tim4LgQFznfakpE7Q77lOgtffIurbEZsGhEFewaNF64KSC5GqyLjgjbO/XaX49kEpC
         06tvI1hVJrCeUJIgInYdmPDsvtcQavZkZujTr2lYOH7iOTrifuVFP3mM/25GKISS2Uei
         Dai+m8DxizKQh7uqa8qX4ph3W62gRn7K9CrEQlLkh3GMEJVdl6JuPIYaNHCrPLTQk+OD
         LaObQwB2CuhtdAkeoihpH2QrwLWvFPXfX42zBQeZRqLzdT2nhD68PoUlhBA6OzNxMWq6
         wIufLcNo3vHG4UQbWF0YTDQquqeF69nXx5TiXC5PVPzDs6DedGU8aMgsv6jGMWF1SVEc
         DWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991461; x=1792596261;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oe+0IhcD+dLnpRRZ2AO6uP7D6+WkqiUo4+grQwp5VRM=;
        b=dhR/pTIC1kJBtTMbDa1tA2LMXTNsAXw09+dPIL5KAT0gP8aql3qp6ZkYywYjZ/L21L
         xQ5PhV6dCjnzlrYdN0CShMLlL1S6nefxHxHQmuqdrc5TW2Pcosd7OmCr+pwMoYn5HHVx
         UBizARHgbdbAfeZvZVGc4N3J8G31Tk+rizsnSlqkkjXPvkMICS/5FYkLSI4cniGAcHoA
         UwfqqXJruCwcwbr8ypzJjT2KnGwkOokaHm14MldDqhmlm2ZKgLxIXSKR/mDGl27upIOh
         oRiz8LTYvV0jPbM8zchEA3vhEceuqf+803YkE3efJEtmn07EDbiA2wXspLmyyEUPiJrB
         C2gw==
X-Gm-Message-State: AFq9FYKkL6tork4779tA4ftuur9rwUAzJIjRTZMPnMgS+/P/iqGXjf1+
	G2YOGZ3QyRY8A97KGQTuR5atERu2dQu+0KkF4PsNqMZIK4V00t6SLoxs9vRJovO2l4k=
X-Gm-Gg: AYBFou0M7dHec99bEQdFiRJ+lEP3a8KLccYbJFf+x/7bmwhw+mxUjVCB2xNATgRUQmZ
	YQxWf0L+TdZvITmSYxLn5UcJYFlJnRh8EihYCtE9ToUI+O34eLH1Ww93MQfQzib8Gg30wApdp4W
	b+Gj0wbRZsSGoTWMplvPSwPeM0K0v4ZwOGTGepK7ou0viyeEaVjq011vC3FvLPOKC+XzLjB22Qc
	gxiGPHsegLPNPIj9tkUsY7y+Nc5vWyh6skHSwiGJhr/WtQ1sVeloefAaxaQK2yP7GV5jW7EqVZs
	SeZpcLcf3KAKkIuSiFf8+oc3KImQcy6qpjanJKym6SGTsJVp67OGy08jDSR8BtMwsPYNdUXvr3Z
	yr++m+fmIX5AM2zjtsWB7+5zZbTU46AunTHGPesWY173Do/HuthAnfmpXlALDeNi7lRDKsV30/a
	CKz9sM+mF+w8/BWPx6WETJxddLTHprW+pK86beLRdp18t7FTsdEyx+syDC99KEXQ9aKMJ3Dq4pL
	zyLr+QWsrDqxBxDRlYg
X-Received: by 2002:a17:902:c94b:b0:2e6:dcce:8222 with SMTP id d9443c01a7336-2e842f389cbmr147131975ad.57.1791991460638;
        Wed, 14 Oct 2026 08:24:20 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b298dsm69536815ad.33.2026.10.14.08.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:24:20 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v2 0/2] scsi: mvumi: bound two firmware-supplied lengths
Date: Thu, 15 Oct 2026 00:24:08 +0900
Message-ID: <20261014152408.3637388-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013173145.3412863-1-yhlee@isslab.korea.ac.kr>
References: <20261013173145.3412863-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Please drop this series.  It is superseded by

  [PATCH v5 0/6] scsi: mvumi: bound the values the firmware supplies
  <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
  https://lore.kernel.org/linux-scsi/20261014151914.3632701-1-yhlee@isslab.korea.ac.kr/

Both patches are 1/6 and 2/6 of that series, unchanged except for a
READ_ONCE() in 2/6.  The series also carries the handshake size patch I
posted separately and three more bounds that a full pass over the driver's
firmware-supplied values turned up.

Sorry for the two threads; one series is easier to review and easier to
pick up.
