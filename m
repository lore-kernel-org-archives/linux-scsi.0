Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C55A30DEA3;
	Thu,  3 Sep 2026 03:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405034; cv=none; b=X3EIqnD+YQB2KvRecSgYM4eJjEJJUn7SLSbBIiymMcMaND2foxVA+rbhtM5VKReIDgfOKM7/1omm6Y8o3l9HnT/SXf1r2pCIB3u8HptTBKe7wQEMwT8I6HJudk3hDWpl95Faciycdi8fH5vxz0oKqNkzrtiX7b9dNCrrNMZ77Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405034; c=relaxed/simple;
	bh=tA4Q6N1CIJ3hKf0vm/GvRQ4H7b+TI1vJ4t4jhEptkOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mNMfZFHn/nDWEmxj3RIvGjScl4av/PuaJFTs1aLlxl0JpKQ04K5heQOrerVCrQPHqEC/fzf3GBZ9sXiDNF+gKMzDYU/gv+NCvB79Mk/i+KrhZuTmQzupy8Qlx0irVQmZI1RtqeW1XdoaUkxyVrfvcdu+ourTOmbvOp+4j0iZvvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePOdoNQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePOdoNQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CE81F000E9;
	Thu,  3 Sep 2026 03:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405033;
	bh=lmT/4gYql1mcBSDghObg9HMhiUerb6MIaPyswNem1rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePOdoNQ9eO/0lxTRJfl4HolZ4jnX0sW/j4KRhlsVisxw3FN/7gjqblRoEX7cI1dZR
	 N8oIqisFpy6yZDgh9oerYVq8lJWmD1EUdMXSIJGYuNryfO2PuRNs6Uox6ICBnNCI6G
	 aGhtJiX3o40AlpkKEcmCkVs9kHYuffuuoELB0Q9Y3fwtFoQz7QdjSs//mJ/I59CCN+
	 UMIGgebu6wUtM1hlq+c4csEsyUWmS6zosXlomwLEVAJ95Lxhn/GnOQvlyasyqGmQ6t
	 K7ybcYmxCp6KNTS/BHP2aHqzSJgRruH0v2/Fra7hPG7lxIrG4p9PC/ZG++w20DRpFF
	 FK0p2bwb0Y9GQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: dgilbert@interlog.com,
	raoxu <raoxu@uniontech.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sg: report request-table problems when any status is set
Date: Wed,  2 Sep 2026 23:10:12 -0400
Message-ID: <178840472589.670675.4347743833855760197.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <26BF67F369E2123E+20260706084443.805598-1-raoxu@uniontech.com>
References: <26BF67F369E2123E+20260706084443.805598-1-raoxu@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 06 Jul 2026 16:44:43 +0800, raoxu wrote:

> SG_GET_REQUEST_TABLE reports per-request diagnostic state through
> sg_req_info::problem. The field is meant to indicate whether there is
> an error to report for a completed request.
> 
> sg_fill_request_table() currently combines masked_status, host_status
> and driver_status with bitwise AND. This only reports a problem when all
> three status fields are non-zero at the same time. A normal target check
> condition, for example, has masked_status set while host_status and
> driver_status may both be zero, so the request is incorrectly reported
> as clean.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: sg: report request-table problems when any status is set
      https://git.kernel.org/mkp/scsi/c/11300f8ddee3

-- 
Martin K. Petersen
