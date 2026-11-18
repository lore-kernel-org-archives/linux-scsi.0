Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977372;
	b=QrrshHanjX7AulfjX2epV2rWDap/QNpf1Mn5n2G7/cr4Hz4liCLvonBYnshanOheRBW3
	 KIGoW0dI5VMqHRN9iMZUUl5OxMWvQwwZx/BU0PhBWKOnKUg98pazthzrvbe/0EmYwUxTd
	 kvkrOGglmwz+3RemEpXAnu778V4hlDKCy8LSyC1qvBbvOk7pXfedH47dtu2HwrmWjcbIL
	 fp1p/1u0h0F6sSepnG1PZidpsepGWQXlynyT149ACtxLeSPW4Ew3dkV4Qhanhjr3AQZQr
	 cgJlZNo6Mp101am8T/+T6qVg97KYpNYQtLkcDoMd8GAUf/LYCXp/p+z3dxnJQipF4dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=UWEK1AajbpT0vN3lvqJ1sxOkKqm6WxnTFq6rpzs239s=;
	b=lHU1QSJ0zGYQotcxtMkjFz7xRWabG2r7pkO8QraIK3W/1J+tZRSbfNaPm9VUHfYQl19h
	 qaujP9esNaRGa2ooL70wldj04TPmFuf8/CHIAQxTY2U4DNqV9/Yo0JEJwraFhoE2Vp0h6
	 WL/q6tVKu65ZOUXhxtcpmasewZOSwdPji/q0AhhWoVStKzt3nnqn317MDZQKd4Lq0bs0d
	 nrCjaTRjP3UsLNStHVGeCaUsaxrVd+5TaW7C8m8tmW91DJiflzv1pOQD5ATdfZ+j/+gS5
	 sb9t5fvUJ5KWb0JF5bRmGKMkOztQmjfG4gVOvEL2BYEn4TPby7/y2H59UutMWhrEbPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vtjg2Blc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC21606A333;
	Wed, 18 Nov 2026 04:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vtjg2Blc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA021F000C5;
	Wed, 18 Nov 2026 04:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977372;
	bh=UWEK1AajbpT0vN3lvqJ1sxOkKqm6WxnTFq6rpzs239s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vtjg2Blc+O8tdHVa9mYgbwKh7tt9i6STnerw7oANZvms5rVmzlnraIaD2IITH0JPR
	 HQAG38kB1rx4OekeiQZfT9Gz68HOtnUJOiIBQ+BpibLw/JLEKAsiTOBpwlG/y20Slg
	 ssv1EAHqt/eOBWBBNCNXG59RjZbzizybcy0g4NdQCf2jLWlmMnMFNJYS+flr1bWkQJ
	 iJsJLwUhDJ8NOjtdd5ANrmZwoYRMfoi9BKW2KayPBH8Yp5GrXrpn0jisqaCOT8Acs+
	 DmF2KouQJqRg4OcLOZrWgyiaN+wUlmGfzB5OS5Ub8QuBvUGn6SN8cdoAo9EKN5qrhM
	 /damYE0WtSUAA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Paul Ely <paul.ely@broadcom.com>,
	Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	msmurthy@linux.ibm.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4] scsi: lpfc: Fix race conditions in ELS retry handling
Date: Tue, 17 Nov 2026 23:49:21 -0500
Message-ID: <179497726105.2093762.8367939589349968463.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <dcea48dd-f76c-4bb0-9275-c12ef9bd78a2@linux.ibm.com>
References: <dcea48dd-f76c-4bb0-9275-c12ef9bd78a2@linux.ibm.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 11 Nov 2026 11:47:41 -0600, Kyle Mahlkuch wrote:

> This patch addresses a race condition in the lpfc driver's ELS retry
> event handling that can lead to a use-after-free in the
> lpfc_cancel_retry_delay_tmo(), where the NLP_DELAY_TMO flag is cleared
> before acquiring the lock to check if the retry event is queued. This
> creates a window where the timer can be rescheduled and fire, causing
> both the cancel path and the worker thread to release the same reference,
> resulting in a double-put and use-after-free.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: lpfc: Fix race conditions in ELS retry handling
      https://git.kernel.org/mkp/scsi/c/7470a1f2a84d

-- 
Martin K. Petersen
