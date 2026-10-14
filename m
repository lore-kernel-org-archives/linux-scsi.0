Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E5940DB35;
	Wed, 14 Oct 2026 03:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950239; cv=none; b=DsKtQT1AJOoP51WzoYB8WdeJLf/6M+sJ5gUTksAwPcVzbERwJ5mEtQhx9lXK2Wtuwy+VIOWL3XLohA8bKK/2l9Vs2UQ4PmoYW6SA6PF44XRYkyMbAfN9Sw6b87/DdiGcXS20hnOrcX6y4d4HHGCkZxEA7M/5lX/A+Kf4AUMz6kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950239; c=relaxed/simple;
	bh=m+jgrE7cIltL4iWviII1OSYv5ooOYR7PqxoLQxDqMS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HwEscaGVpAVBaytyBRsrOQxp8uBDjMvLJgdyYu8pHxZWe8XXMEKJHANeh8ATkp6jJe58Pt7URblz7b8m6LchHnT6rWcfLxJNp4Bf+1D/JtXJHBu7aYF/ghWwCfzyP02VRt6oPHKeC8wxTJ5gP5VVcaEjn+usd9y+OtZpsRfkOhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=muscrK0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="muscrK0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487C01F00893;
	Wed, 14 Oct 2026 03:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950238;
	bh=GUQ0+6e2JIVGt/4/5Daelr+lnTpVmVZNrPTsWZ69GNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muscrK0VRC+Kl1n9dwsRFMFWUpB03umfNGLocDP+MthEq3woRdhAAvCnzTSspge+B
	 v4ycoEa2PqABO+yn+lrw9OVvdYTJ332a5Rode7VBEfcQSMGz3ZZfm57Vnf2Uk2H3UJ
	 7i+UbBMf8U3lIEvdR8xPp8WshhCLrvR+WFu8ZBF0Yu3attWzMgtJ+u/eQj50RP+yp4
	 4ejmtO1mpgWKAv3opoJvif5ikfjCOV1hlpQKf3ncXF9KzyaVuX7wGKCr0FnyTau1bv
	 UPXjPvUSbFtGKJamduih22MfdSajaskosQ54XmB7hBn9o1xMDsdcap+syS+1fgXZXq
	 8Zu+rDIZa2Npw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Stanley Jhu <stanleyjhu@google.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: rpmb: Fix power-on UNIT ATTENTION retry
Date: Tue, 13 Oct 2026 23:56:52 -0400
Message-ID: <179159633710.2229379.2201534308129823434.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929140806.2859367-1-stanleyjhu@google.com>
References: <20260929140806.2859367-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 29 Sep 2026 22:08:06 +0800, Stanley Jhu wrote:

> A merge conflict resolution dropped SCMD_FAILURE_ASCQ_ANY from the
> retry added by commit a8a34238e5e6 ("scsi: ufs: rpmb: Retry power-on
> UNIT ATTENTION on the RPMB WLUN"), so only 29h/00h is retried, not
> the other 29h ASCQs.

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: ufs: rpmb: Fix power-on UNIT ATTENTION retry
      https://git.kernel.org/mkp/scsi/c/2f4880c22e83

-- 
Martin K. Petersen
