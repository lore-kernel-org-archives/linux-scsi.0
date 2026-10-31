Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410829;
	b=MXBlg7wKVhgmcWpBGUkMQl/iQ93qs+AsaYhhR7mL4UlEzeLC+z0zlEqBje1BCwJx9rQQ
	 Q4FLoo4AUV1x82v7ePuvYzxglA+NXwLknaTqeGGKkpFr8iiYrk4t9BybE3D3UT/ELZUK/
	 jnK28qZLpNY7CGhsZH1OsZdYWBOD6mop8GdK/5ZgkjtMxnAXX6mMuJJ5SLPKVaO1ANAI3
	 aKrWn398dQtEsnzeAf7MQFmRjn/7r+AHhC7iGUhRcSSqQRq9BP/zXONWvyD4P2pNERX+1
	 izAJ9iYFF/y++VDN/EDguaMdJFHuFcLCg3Vc9DEIeHsLdi5uBAMLGUKb/vqh4bL4+vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=MBlceEt+4mEljeq2hsp2XYucp9LXGvcpcIt5fjYTIUk=;
	b=Gi+rNeg73xf3p/xPhShLZIaI2ztliJxBimdTiYglYPKnyDQGA0lmcoqlal6Ycx901tdo
	 Ox2aaknETBaXcwOGGNq+NBlvObfaUjPgMgEgOqwqD1wutlbWN1bJbBwDAprYWfkaPVs/o
	 YqyygQnep59GWWULr3FDaZvlz7oZUF4LszTU0aie3ys7t6RzyTbzqhcRM4Fb3XN3Qgerl
	 J/7iZvjOCvG1hOwz3aRnZ0aC9jqFTeopfaQS/cZ7/wL+5ES118a6TLEGrrXfdgESQnF3/
	 Udcl9WwD08Y3bbHMrsxwQIHm/CSTzA5+hfAFt+0lPund1Pg7o1vW/ttECE0owL06Icw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="QxQ/Tk9Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D2460A2602;
	Sat, 31 Oct 2026 01:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QxQ/Tk9Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C3F1F000C1;
	Sat, 31 Oct 2026 01:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410829;
	bh=MBlceEt+4mEljeq2hsp2XYucp9LXGvcpcIt5fjYTIUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxQ/Tk9Z9wU0HsMCdP9GbLj4oFvcmJTbpoeqFRw/qwtKTTrYxcofMJKjrYYXXMzJZ
	 kg1QovJVWsLsDyGBULLc+zFqSiStazNCM4kCQbXsk7iQo8nIuVaG4cV6Wu6uqn9FQU
	 kqmhZzzwTtKlu38punne4zbDnMZePZFQiUcPFYp+xVttwld0XW+n7aG10OUqOGVNFd
	 Ow40s2uTP68Q3ka+O27mSaDGg/mASE17L7XpaErcTLv6F3OdF9u7DhWWcuR8hhturN
	 zhMRiSmOmtqAJo4tMMyW+KMCUoDXJfP2f4kMk0L4RdlUBirwW6mSdbEQ8E5yhhzBlo
	 a5//YhrW9fbCg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Yu Zhang <yuz08559@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mike Christie <michael.christie@oracle.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: fix demo-mode dynamic ACL dev-entry UAF vs LUN teardown
Date: Fri, 30 Oct 2026 21:40:14 -0400
Message-ID: <179340755640.952351.10257728609640989807.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014013746.46705-1-yuz08559@gmail.com>
References: <20261014013746.46705-1-yuz08559@gmail.com>
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

On Wed, 14 Oct 2026 11:37:46 +1000, Yu Zhang wrote:

> A demo-mode (generate_node_acls=1) login that allocates a dynamic
> NodeACL populates that ACL's per-LUN dev entries in
> core_tpg_add_node_to_devs() *before* the ACL is linked onto
> tpg->acl_node_list by target_add_node_acl():
> 
> 	core_tpg_check_initiator_node_acl():
> 		...
> 		core_tpg_add_node_to_devs(acl, tpg, NULL); /* builds deves */
> 		target_add_node_acl(acl);                  /* only now listed */
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: target: fix demo-mode dynamic ACL dev-entry UAF vs LUN teardown
      https://git.kernel.org/mkp/scsi/c/6a6e7d7230cd

-- 
Martin K. Petersen
