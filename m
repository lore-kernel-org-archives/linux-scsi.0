Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795226551;
	b=nPOx35VteRpf/AvK++xSIL9yKWybb0cxP2x2+TbXpkUnZkB8GLgs0/Iack8KsYLG5kPY
	 zhyd/9WYCPONJBS2b06mR5KROilFT321WYX33b/w3T1mRaoelOE1SejfCZFa6ymB0NjeC
	 lsfFdI6WXYZxEJ+Z9RDNaUWNECCvnxRUKHbuQXIQU1O2Jb0ZY+1ABVzUpnLfT3pdPQItg
	 V0uHPRLkeY/vdKj6KZDNCPFiQGOopELJ0fqALKpweN3xU2bH+fNc/9TnKHKZPeNfDV9Ai
	 KtvZOQPvhbpvam0ljlgmSCn7cJ9brpMMjd4ZwUBbajSFsXmO91sazlPQWNFZNvm2GKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795226551;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=xGeNNwI1eCRUe5FOk7ifTfTOPmFtOLejs3yFItHPzhs=;
	b=a5t0Bqzm8fHOInlyNiDeQQBL32vUW5YagiAC7aLOe4BunF/fKH39J99Pq/5+PWw1v2ow
	 rclUzRHnJMltrjBHjUccH3zSH+SrOGLvjCT7xgfYaLZHpv3Qpw8WJUHN39GJ76EWlWKsU
	 s5a7S5ezTXO/J5skj+PWQoOP9s8rKHBRaJ9XxnfuZ6HF3q9Puu+DM2v90mz0hTdvo9Imd
	 SBgG0gTAXRjV9Cm7sUNYlNP0Hgm4zRwxYHFsFb3SbyU/w+AcFZC+siHpNdBS74AfBpgQA
	 IusK5HjI9flmkf6lC0wCxS95sIPKPZFrCUk6ga5Fy2ZG8CL9qvcs8ZQZGtxN89vT9DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nR3oVbRF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E3E606A690;
	Sat, 21 Nov 2026 02:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nR3oVbRF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CF21F000C6;
	Sat, 21 Nov 2026 02:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795226550;
	bh=xGeNNwI1eCRUe5FOk7ifTfTOPmFtOLejs3yFItHPzhs=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=nR3oVbRFun7ehT7RVv7u/h9Gx1x6+59rtKwaVSpdo54oGsBsDa7sFF8uOtaG7lo2h
	 TDka7N8BE2uCwT2MytW5HFwTgebsqavpTHdSIcojjz3hMQo1+rXXPEkQ4l1ug81XtU
	 tc+al4TupfUIVZ+a3O+2Nzn4oUtZ/gZ3//MOOTaqRNHTTrCAhVgzExuSP50OUmyVJH
	 pIs1Sou929Sl7yHdYhtz4m7cj4oYxWy2SDBESAsMnrVyBBEIdTDx7yNBNuoaJruyQ0
	 ZxLtOwX1CNpWMATK/fQSgR4FqjmDK01tLy7ThUaMPqAhQzOB87lHoQaP++7nqs9+U1
	 6r2uIaMsc654w==
To: Ian Rogers <irogers@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  llvm@lists.linux.dev,  Elkin Cruz
 <elkin@google.com>
Subject: Re: [PATCH] scsi: pm8001: Fix abort completion status in
 pm8001_mpi_task_abort_resp()
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261119170905.1530613-1-irogers@google.com>
Message-ID: <yq14idbosba.fsf@mail.kernel.org>
References: <20261119170905.1530613-1-irogers@google.com>
Date: Fri, 20 Nov 2026 21:02:29 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Ian,

> In pm8001_mpi_task_abort_resp(), the IO_NOT_VALID branch assigns
> TMF_RESP_FUNC_FAILED (enum tmf_resp, 5) to ts->resp (enum
> service_response) instead of ts->stat, leaving ts->stat at 0. In
> addition, switch (status) has no default case, so any other non-zero
> firmware abort failure status leaves both ts->resp and ts->stat at
> their zero-initialized values (SAS_TASK_COMPLETE and
> SAS_SAM_STAT_GOOD), causing sas_execute_internal_abort() to falsely
> treat a failed abort as TMF_RESP_FUNC_COMPLETE.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
