Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E651218ABD;
	Mon, 28 Jul 2025 16:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753720696; cv=none; b=OyDtmBMbcevFKXi1dSRakeDwZFPudW8s+nYCos6dt/PO+ixtayUOdGWIKATqE/GH0Zi83mBM93WHicIiHunBCku/MnHWRDEH0IlCIkIO5wsHvfEBKK0f9sHBFSyFQZKcB0Vg+zQFmAc5/EpztsXD/497G6omLXeWXgXdef0LdQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753720696; c=relaxed/simple;
	bh=Xyb0Kd7/s5SMUst0jTFFhaUhzpthD5qwX9AQX3DL+v4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FmnESvifY6HiL5c1luUJUhvq/0NGyLGXFXE5DWro+1lcM/b6deDgudeUGmY7amVqS7J44XTmomt7K2CCc2sAn4bFlEgGNiRs6ofk4mhnJlFNiczp+I1ovHQphp0rf8Mk94xaaF7kg6QZI1emwvi3pWu+yQOSEercOLevUp4Otl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fOyqvpOj; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fOyqvpOj"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3321296a8cfso1124471fa.0;
        Mon, 28 Jul 2025 09:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753720692; x=1754325492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EjvKNy798ZafvqK1Fg8IgvE0hyHOKDDcKFHt6ehC0Is=;
        b=fOyqvpOj4IzfjQ9nZGyJyYJZHNJUn8NQ1vHn4IQgbmnLYpNmIqMKfV4vzScRRiVPaQ
         y0E4P6qOfWsViEf7CaHrEGPHevD9N0B6g3uS8edfNQNY3zarLg7MgpqH327Y8OcI8net
         cbCCc2zsL2LTshUOPbONiACSEUOQQNDjFtjSiogAL+hrAop4TibO+GoJdlHPK+MAloMf
         n60xrxZqJ/1Bd0sGEJwjWlCmfozRyrii0LKd0hCnetHkYdkkCGhCVpJ7sGNseHuyAyGW
         56soGslUZfAfMAS0e1hWef8O2S96BKr/y4zQexjc+kjkvN+95/3K4nwt/4+c9KA9pEkA
         vWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753720692; x=1754325492;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EjvKNy798ZafvqK1Fg8IgvE0hyHOKDDcKFHt6ehC0Is=;
        b=cv7dE5aUlF/KgioGL0Vd4oh5jnzV5XXD6VUgS5jsn9OaYK2lNW7WXLEg/CFvtrzmdP
         NRkPRueiLVnzyWJvSEUAtEhaEKBV3uFLWe8Kd5XX/SCQZG1gGK6KPVwkkBuO/RtmAmIo
         OPNFq+jOS+binneR0NCc+mLg6HIojftrIiTucA542IrtPu6sx1LLAjI/IYmkaMsJ4rnE
         1SyVFY0g9uuWkIYh4N94PN5m92Z//ReJPjAk61yAqXTthpib3JgSJSaEy8XdWmPQmbY1
         mKDn9YGq+/u2hNrzJErSI/+WeskkhGgzruVsENidnVr8QZiPD7EPRrNgz4hAy7U1oDgD
         YXmg==
X-Forwarded-Encrypted: i=1; AJvYcCVFRFaezT+zw3HtPP3/PIBN5cMclf6M40xfeEdRvmcuGPLUhDpNXjzmKVykVQWIrtfOOVP+fZNicD9Dqg==@vger.kernel.org, AJvYcCX50wn0zDrepB9HMmB7rS6yvrdeoi++mPW7NYLTH9tC9fQjZmwAJ8vl2di0T3DKlte/BKuLIPzO/c2KQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywzgp51X7ZHpNVHeI9T9lFhrZsE66XQxES/iK+H5qUD9y5hv5IW
	SQHC9EpUEuiXpwHCr8EQsvh5tvvSmfl9b8jDuZdK+Ekr95b5ZN6DYMUACnUNM9Wc
X-Gm-Gg: ASbGncuapqbNNekjyk1U5CuavXfP2CuRxk0Dh/1OpdCCfRYfySpw75j57b2MvauSODl
	SSQ8TcMtaG+zOiTdti9KN1SHHMNgHVNzp5qB11CtURsiduS9vonJu12nXV1PxYBEXeiokrCa0sj
	tuWmZxyPV6L7CaVa7F6D7XsHJ5JZgsXeqx2sOvHJ8dblYuNiYq0peAor/YyMtMvS9IgvneH+MBu
	Fd9DMCVyLqRvYJjZhQf4dA2A78cs8ipnBLCCVlBkNQ/y4i2DBIbE9WwnR4muw1A+9iKT3KMASKL
	tBSYJN1cz/Xqqfh3DraC3t7EEDUoYJYp1/I1BDymlZBlU9o20tqKx6B4ihMVmQe4c9ZhhuwlANh
	6wK2DuejgvLIQQpjTXSkN/tDwbesRmmR5kYDQizS4cMg1qqZS0jDkkoQyYco/FA9vkFDQhyO7Qc
	U=
X-Google-Smtp-Source: AGHT+IFt6z3Bgx5b7Zb8Rb9wlUqIqkwdUEzrLDlfNKX63D6jB6tELA4/IJbqcIorIss4ixss5CJV+Q==
X-Received: by 2002:a05:6512:a81:b0:552:21db:8f5b with SMTP id 2adb3069b0e04-55b744f3f43mr78253e87.27.1753720691628;
        Mon, 28 Jul 2025 09:38:11 -0700 (PDT)
Received: from buildhost.darklands.se (h-94-254-104-176.A469.priv.bahnhof.se. [94.254.104.176])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b633631e9sm1322659e87.90.2025.07.28.09.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 09:38:11 -0700 (PDT)
From: Magnus Lindholm <linmag7@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-alpha@vger.kernel.org,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	hch@infradead.org,
	macro@orcam.me.uk
Cc: linmag7@gmail.com
Subject: [PATCH 0/1] scsi: qla1280: Make 64-bit DMA addressing a Kconfig option
Date: Mon, 28 Jul 2025 18:34:13 +0200
Message-ID: <20250728163752.9778-1-linmag7@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After spending quite some time trying to make the qla1280 driver work
with 64-bit DMA on alpha/tsunami systems with more than 2GB RAM, I
haven't given up on finding the root cause why this doesn't work but
I propose making 32/64 bit optional in the kernel config. Many thanks
to Martin, James, Maciej, Thomas and Christoph who has take the time
to provide feedback and testing during my attempts.

Some platforms like for example the SGI Octace2, require full 64-bit
addressing in order for the qla1280 driver to work. On other systems,
like the tsunami based Alpha systems, 32-bit PCI Qlogic SCSI controllers
(like the ISP1040 series) will not work properly on systems with more
than 2GB RAM installed. For some reason the combination of using PCI DAC
cycles and the enabling the DMA "monster window" on the tsunami based
alphas will result in file system corruption with the Qlogic ISP driver.
This is not the case on other alpha systems, such as rawhide based
systems, like the Alphaserver 4100, on this platform cards like
the qlogic 32-bit PCI (ISP1040B) works fine with PCI DAC cycles and
the "monster window" enabled. In order for the qla1280 driver to work
with ISP1040 chips on tsunami based alphas the driver must be compiled
with 32-bit DMA addressing. Most SRM firmware versions allow alphas to
boot from Qlogic ISP1040 SCSI controllers and hence having a simple way
to limit DMA addressing to 32-bits is relevant.

 drivers/scsi/Kconfig   | 17 +++++++++++++++++
 drivers/scsi/qla1280.c |  2 ++
 2 files changed, 19 insertions(+)

-- 
2.49.0

