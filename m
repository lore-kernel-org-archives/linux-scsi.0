Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B303D7D9F;
	Wed, 26 Aug 2026 15:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757626; cv=none; b=qKk+CKWINLIV/WrW2ZXdmrsB8b/Z6qvTZTj36M4DEJIq/oX4+Vac3nTBgEnIjPZIn+pBP7WyM8aVW5xlajf1Lh0zY1pSeprxbzI4WM2WGYCpc/aXAnC1OsSGMWxoQvY9kgVn9FIlDWZDcbswGms9GauOgda10XfjXa4VXW8msPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757626; c=relaxed/simple;
	bh=zTq7OPOCN35f4BkO76AMeHYbLu6L/QoE9jUrDZ6rz6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MPfvh3gS79iuTjc1cPGbjsV6M3WbRhteg7FeJ5Ch3+wgGPrjR3p5pN92hJDGMTM07YoeeK9m6tt11Oagtq51L8eUprBMaoZQYEWG9OL5yjLCdFdzMwnH0IIJXjzlhsMwK4/RFEV6/TkBLf9lhhff88frVUfUWr/yWXlV1FsRdr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0cuzyja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0cuzyja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180791F00A3A;
	Wed, 26 Aug 2026 15:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787757625;
	bh=uswjoA9ofSXo/xTj27ydE5eDJ/zEABsCqYmAt9BKDj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0cuzyjaUtO/+IKGwEVEjlB85ZJi71kfzi3Wl3PrXoF2umzlZiwtAdAU7+29gQT4o
	 6aLpdefh62kQi2BaCeDxVx/YB5OBPOk96hthGknl+1B0+q1Pjd4PZ0yHcpldsURy4q
	 2DR77dcXJ5EWtbEbsoNUWBi7bgXtsOWL7pt75V/E7O6UatNRSv+6wKPw/fn9QSiaBM
	 QGw7xgNzrQrz72hA74DQB0Tt4WiEhN16x80QEtZ3BuF+eBYAL7zB5gcNjcnTTXevOR
	 PdoJDxJLdhu2mq7vHqi4v9QaLo9IdR7xMrohQdd4mW0u80Z5bF8wdJ6MDJ9D4ttTGf
	 w4lnsLPMd9rQA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Nilesh Javali <njavali@marvell.com>,
	Dan Carpenter <error27@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix an error code in qla_get_tmf()
Date: Wed, 26 Aug 2026 11:20:11 -0400
Message-ID: <178775714069.3862282.675299578234377713.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <an1taxANE_4_vzJT@stanley.mountain>
References: <an1taxANE_4_vzJT@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 13 Aug 2026 10:08:27 +0300, Dan Carpenter wrote:

> Negative -EIO was intended instead of positive EIO.  The caller, doesn't
> care so this doesn't affect runtime.  It's just a cleanup.

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Fix an error code in qla_get_tmf()
      https://git.kernel.org/mkp/scsi/c/ff9365a4c999

-- 
Martin K. Petersen
