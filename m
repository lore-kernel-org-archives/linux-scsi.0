Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795857994;
	b=uPtev6JCUd5DnqSmZQLpjW6Y56Qu2hfbdNCc7wcRY98zWym7TtRQ4wnchD9uWxY8it1d
	 zZqEVfxLF9hY+mad2dpmf1hcL3IT1fnTrvO8l5MskG4Z6GSr/Ej3d2oPf1qJnIVCDObjw
	 SphhReWDn8XRPE71dXbrgc4S6fhkRSIZK0LfpEKLUfzwDLjQ1gBRu1KyRh60oQ28ZUKYl
	 r+e/YiKPoJnHG0Tmk1b1e6UxGe16xj7hbHCYKnzg7qAtozRXGOO+Fcl5vc8cTIIfGktou
	 2+gxFcgSmEcwBTXwsZCsTnosQmXhAN4DzjtKSxyzvMn90AayJb+FGYhnhcXQowvaA0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795857994;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:Message-ID:In-Reply-To:References:From:Subject:To:Cc:
	 MIME-Version:Content-Type:Content-Disposition:User-Agent;
	bh=OnOWml3mTVLZIAGAoGH3YhBUUwiS9xiwWGOu15WvauQ=;
	b=5AQlD20EJYhzn4TtWWCYPtOn0hl1YGhL+e4Ufv8Dgm8LF1IWVU2AQ0Gnxg3g1heu+OQ6
	 wHSVE80Ajp56vsWvfYgK13j2OU9Nu1oVLoCoOnSLk3fTZZX4IMiPBOIEWvwJlLurntRQ7
	 5zTuFEWcsqw5F8GScWsW1mqDObiAgcnfgwXViifEdLcEhc9lT+YdpeuSBlSf39yA+5ub0
	 a+E/HJRrQ+56mV97vQ5aiQBvvAzcDxcu+0nr4uDshJolHKi29xCfK4kKej0BaH1IcJWsW
	 J4a6pucR+8yDW8YKh6cWpRFa2yFo426Hg/WAAZTOtR6RpID7rjrlyyEjVtXQNUBaXGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=RenUamNs;
	arc=none smtp.remote-ip=74.125.224.43
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D30606A330
	for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 09:26:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2D30606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=RenUamNs
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-679a2b5fe87so8067227d50.3
        for <linux-scsi@vger.kernel.org>; Sat, 28 Nov 2026 01:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795857993; x=1796462793; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OnOWml3mTVLZIAGAoGH3YhBUUwiS9xiwWGOu15WvauQ=;
        b=RenUamNsZf0xZ6eO1WeyNy11Agw4rs/wJlNssAvZQda8EvImKO0psk1oR6MFuztTKT
         fFHZr+48kcr+/NDoo4WJsmi37/dKrYzsCrQdukW2rPE8x10PBn2nLB7aFOXbFI1QXWXm
         qL1KccP6c806B7SP3egqhmBTkxqjumJaJZYDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795857993; x=1796462793;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OnOWml3mTVLZIAGAoGH3YhBUUwiS9xiwWGOu15WvauQ=;
        b=L2FVoYlFsuTU9OeJ7ndZLw6K0HGFDnPmAvoLnm8Ghn1BlMxucUUx9yYRkX3t3NtTvJ
         2BD/DBYDZmamoUIdck8goyUT47aSp9yW2K1Ju/LT4ONqUT18OpBIhg0QpA/LR5aVq6Sq
         l7YzHLA2MgehWq0s1Ju/jqQDY/wC2M0iFWUT60q1B1ASazp6eVvbeCuNhAPbC33azoG7
         fX9VB7Zc/3lWHdjAfIl45itoy6yKAqCdG8vGPNr10af3Alrlh99Qd/07p3nucZj5b4/g
         RJWY5HKjOr5HRYXZ143BTdtb2gYI6kEAAnfSxoNsM5B+wTrUPuSLpjO2H2MSKGu7wrRz
         daUA==
X-Forwarded-Encrypted: i=1; AL+hErEIvM6xguQp5Ts9nehSjBAGQXlGrrMC8pvPx2hhgdXP4q8s2Ie9Vj797wkNPZt+Dp44EpiV1BJvjVJq@vger.kernel.org
X-Gm-Message-State: APuU4Z/bn4FdxZAuZ2s8myv3TZr3UtdydK2QOJT5FNH/O1O8KTzY/GdN
	1fBCpHzPP9hTwV6jbNQb5VAsCgEjnjWBffdpq1HY8Di98u5ArRNHcoF1Y2yEgPFIy+IsazNRmvS
	aLPDAeIC7l4FGBlo=
X-Gm-Gg: AZFdTZdwy2Oegsy2sYJ6ruybxoEPrx95MFI2kMKd8qHFoQOu0sm8Tl0kwxI4R4HAB58
	w3edriRjjmLrgCp729cxaTLcZe30XRxcW3lQ9bwNi3tG44qrpUg8E9NAhu82feGL2VP7AE2TBsd
	aybNAA5sSGZV9XBFAkQ+jWexZnoA7pmsH3cO2dfMf6rclAYGomHXA1eTbqtq1CELFuocfFGk4u1
	OAo4zuGhlCcMYIded7sg0sOSL0Hxa4MF+jzVVCEr8SoK7yjkZEvk3UbniusBTmw255LHdiFb2vV
	LO85YwCt82YlVhwJysfMemfPzCnZL0BI9Ayu0tKOwxzSl123sgtW9NlPqbBweAbSvqdxkRM5ETj
	FAmBjnPLm52FAOfwPIwwWw1tnIJBMrrubao24FXDIbjkhN2fjbuPhQvdpoM8cDGiAcJTrTgp9M5
	scsheVloQJbyBsacKDKOjGIX2YEqd3M69h70+bHJ3r45y1ZUXBj5aI/FBQg60Z/RLdHktRLg5hu
	pUtwj5orD1LpX/q6WHrb7ZB4xOOIKIDKlvcvKYpFUtj/96hi0aQ6VWiKpYi0/xmTmtbUpuWy8m9
	xpBwSY+P0y5J9QnLlx1pUVQhHyQPRH0A37+DHT7wcgGKNBsr/nilPhdunOTK437mJ2fFOILIpMD
	NdEW+8x65tQKrms06cY4kwULUFNi5o6v4cGe7RpirdlLF4f/XSobA20dL6VjdSHqEJ+AL7kFUiQ
	fCmAJUSwh/lWNlFDDnpbl2PICLeulV91nMC41aOF81Q9VoeE2PfupND1nR2IbV2nRgAkbmM4qAe
	wKl9q+0oDpu27AXohKX3Ik=
X-Received: by 2002:a05:690e:12c7:b0:679:2c7b:de5f with SMTP id 956f58d0204a3-67e314d4c18mr6074586d50.159.1795857993009;
        Sat, 28 Nov 2026 01:26:33 -0800 (PST)
Received: from [172.20.0.3] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67df33105fesm12336153d50.7.2026.11.28.01.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:26:32 -0800 (PST)
Date: Sat, 28 Nov 2026 01:26:31 -0800
Message-ID: <e8d703511f446b850bbdbc0e26ca5e53e6672b4c.1795842371.git.chris@chrisdown.name>
In-Reply-To: <cover.1795842371.git.chris@chrisdown.name>
References: <cover.1795842371.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v2 1/5] scsi: sd: Fix stale max_hw_wzeroes_unmap_sectors after
 a mode change
To: "Martin K. Petersen" <mkp@kernel.org>,
    "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>,
    linux-scsi@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

sd_config_write_same() sets max_hw_wzeroes_unmap_sectors when the
zeroing mode requires unmap. However, it does not clear it later. If
the mode changes to one that doesn't unmap, the old value stays, and
the queue still reports that write zeroes will unmap.

blk_validate_limits() also wants max_hw_wzeroes_unmap_sectors to be
either zero or equal to max_write_zeroes_sectors. This means that if
the write zeroes limit changes as well, the whole update is rejected
and none of the new limits are applied.

This can already be triggered from sysfs. On a disk that was in one of
the unmap modes, writing "write" to zeroing_mode and then 0 to
max_write_same_blocks makes that store fail with -EINVAL. From that
point forward, so does the limits update in each revalidate. The next
patch makes the zeroing mode depend on the capacity as well, and then
resizing a disk can trigger it too.

So, let's clear the limit when the mode doesn't unmap.

Fixes: 6dffe079fe36 ("scsi: sd: set max_hw_wzeroes_unmap_sectors if device supports SD_ZERO_*_UNMAP")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 drivers/scsi/sd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dc45df819c42..c7018a5de847 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1249,6 +1249,8 @@ out:
 	    sdkp->zeroing_mode == SD_ZERO_WS10_UNMAP)
 		lim->max_hw_wzeroes_unmap_sectors =
 				lim->max_write_zeroes_sectors;
+	else
+		lim->max_hw_wzeroes_unmap_sectors = 0;
 }
 
 static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
-- 
2.56.1

