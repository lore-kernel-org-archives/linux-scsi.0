Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEDA143C67
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 06:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720161757; cv=none; b=rlNcle4e9Mxo0yZFcZ5xLrFM2LZBm9A0jb5MBqezdmx++qtSt97oAXyHAR8F0e2SwyW0AdgJXvhayU/LF+dV1ZqWm7YAdnFABN32JpxoB+feId6rFfQuC8nDRYiDMZqj3E6/A6CTfOdDMBKKjUo/y3NFRLmRALBgiJPsmistmpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720161757; c=relaxed/simple;
	bh=CWl72ReHjXCYWhKlNG9N2O+IUodhLDJfcgQMkeLW04c=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=n9jxkwYr85+f0RJdQLWuo7Ao/U+LmhTRsGIqjy3UloRPGJQYUcoE3iOjfTXhZ85YAhbhPYYbV3tz/Gfc4z2HGUTgHqcelq0Gwj0P/WhpP9LVxGhg9/p5N4n+ZlB/rJLWnhxuni4mlEtueMa1b28zE2SNvbcnLLnz35K6e/r5RT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1zLchmjJ; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1zLchmjJ"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52e98c72d2bso70375e87.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jul 2024 23:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720161753; x=1720766553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=waQspLv/Jp+UpTZ4iMwnmeyNv2/eDMBAOGCEYrIWEFg=;
        b=1zLchmjJBf4rhrrqUKAnuyIUjKpAy2torOuk1d9YY4v0EdgKMld4st8H0Hs0lAu1Ot
         5/MZImK54Z2Ig5l8funRpdV5NFWkk0QVpI6qWhI0h/SDZYRyDUx9+eIOqzfOrW4qZUel
         VNFZ6n5clWcrcZ2/J5iun91plfiHc4CG8KchoyiIJRLVH0jNJwsXN6ra/7M6EJPZcvc+
         Km1soitL1+S4pc1X11kG/uMrXKF7qHlkVU4d7C1Vs7aSn6Qu4H0gykmz7wPjX4o6Fi8c
         MlgCWpkmEpoDgX1C3oiLlj0HfaU6geBEJDc7wnUpPYty0gNkU+9JVUx5uOgWZT1nUvIo
         SJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720161753; x=1720766553;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=waQspLv/Jp+UpTZ4iMwnmeyNv2/eDMBAOGCEYrIWEFg=;
        b=cxTb1ihbjsVJUNQAezLatEjlcg0VFK883XPOe2fJx4tIwc53XhlFvf97pQEIkvPdST
         E1NGlF0VCEgtWxET/A5MKOAMWbEspUFZ0sqy7Niqeje12INod99QaWmPzYqzSe0Ue+Bu
         pTN0ibJRXrhYzTXWsg8L6FkZyPUDB2/kN2FFAjoF+q1oX6XZXkJMitJmucaL5vhTdqWW
         TurdxtIEEVpzYpa5Cbt960krjAbgsf9vtSwx56jth6MB8P7rlGhlBzipMqYMZCByABWr
         XG1Gx6aUMXOi+ExrbE4xrJxAIXBSs7hG61zQKZQzg2k+hqYSZfRfoAHmpxDjOWTYVx04
         vgEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvlJ950/nR2GzfL8+Ht2UCB1f31Ii2cDEc1Is/SUJDC0QFx/C6dhqad3N3Sxv41OnD9vNaPUTFOuwXnb5NTebqnbaEAqosIpdShA==
X-Gm-Message-State: AOJu0YyDOj2OAeJ+VCdv/CmZIjznFweK140h4rou0le2uCgAqlcyDvJZ
	4UHL7kWUlW6x8qFPLqwpv/dBhDM7OTtQ+tTjPMzIJiuGNktAKP/TKxmjw7617s7KHYdblrZAX06
	3Hm5vlJT1
X-Google-Smtp-Source: AGHT+IHQVZfmP8Kf7Vg7+YOar8W+pG2xnl2rTo85ayKWXNSneGGBg+vqVXwSHucIKC0g6Fn0qMkveA==
X-Received: by 2002:ac2:5a50:0:b0:52c:a7b6:bb11 with SMTP id 2adb3069b0e04-52ea0619e47mr2245356e87.1.1720161752595;
        Thu, 04 Jul 2024 23:42:32 -0700 (PDT)
Received: from [127.0.0.1] (87-52-80-167-dynamic.dk.customer.tdc.net. [87.52.80.167])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ea69513e4sm88226e87.289.2024.07.04.23.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 23:42:30 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
 linux-scsi@vger.kernel.org, 
 "Martin K . Petersen" <martin.petersen@oracle.com>, 
 Ming Lei <ming.lei@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, Christoph Hellwig <hch@lst.de>, 
 Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20240704052816.623865-1-dlemoal@kernel.org>
References: <20240704052816.623865-1-dlemoal@kernel.org>
Subject: Re: [PATCH v2 0/5] Remove zone reset all emulation
Message-Id: <172016175015.242380.5721463092175148141.b4-ty@kernel.dk>
Date: Fri, 05 Jul 2024 00:42:30 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0


On Thu, 04 Jul 2024 14:28:11 +0900, Damien Le Moal wrote:
> Jens, Mike,
> 
> Here is a set of patches based on block/for-next to remove the emulation
> for zone reset all from the block layer and move it to device mapper.
> This is done because device mapper is the only zoned device driver that
> does not natively support REQ_OP_ZONE_RESET_ALL. With this change, the
> emulation that may be required depending on a mapped device zone mapping
> is moved to device mapper and the reset all feature
> (BLK_FEAT_ZONE_RESETALL) can be deleted, as well as all the code
> handling this feature in blk-zoned.c. The DM-based handling of
> REQ_OP_ZONE_RESET_ALL can also be much faster than the block layer
> emulation as that operation can be forwarded as is to targets mapping
> all sequential write required zones.
> 
> [...]

Applied, thanks!

[1/5] null_blk: Introduce the zone_full parameter
      commit: f4d5dc33c823ef1d7ccbbd2d1e40b871fad0012b
[2/5] dm: Refactor is_abnormal_io()
      commit: ae7e965b36e3132238d16b4ccd223f65162397b5
[3/5] dm: handle REQ_OP_ZONE_RESET_ALL
      commit: 81e7706345f06e1e97a092f59697b7e20a0ee868
[4/5] block: Remove REQ_OP_ZONE_RESET_ALL emulation
      commit: f2a7bea23710fceb99dac6da4ef82c3cc8932f7f
[5/5] block: Remove blk_alloc_zone_bitmap()
      commit: 2f20872ed43185780a5f30581472599342c86d4a

Best regards,
-- 
Jens Axboe



