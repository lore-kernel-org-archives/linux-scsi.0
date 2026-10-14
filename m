Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D353B40BCD8;
	Wed, 14 Oct 2026 03:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950252; cv=none; b=AavNpLRTTba8/p/vcc5mgUfnh86fL4ZFTNhO7OR3O43dnyVz3FSvavKfWzcBqvzmbX+oW0a6HbvfoAiPqM56lWMs9e6ZKMca8p1PNAiDeN+5BhBxJ2VZ4S4vyqI7rtCGmakOdx7f+C4/kxqKpEU+5RaTVy3Ma1PAIckU+L+wwZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950252; c=relaxed/simple;
	bh=ShNZr8QxfBM1jcAeSB6oU71gaIgIcrOCsR20pCzMBYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lBvjCCrYKDbMrwd0Kz8MDXxl3xe4DQGk1Nap2ZNM7dGhyGzMYkxVcMcVDbVcZzkWy/MYsndqCi4iOoCbUVGNvful+kAYNcg2iotCxVp54M9abyeImNqhlkJxhpoMcbSbZ5EogRFxD2UvWhFgyOGCx24sjWMTBEZCbu3uNpoP31E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdssQrAY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdssQrAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4681F000FF;
	Wed, 14 Oct 2026 03:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950251;
	bh=nrAfgiK/R+zBQZhpwA0BndBeOToPTMiF13emh8D/M1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdssQrAY7r48W94xj5VBCA8GVqsYyJKzotwIA6TxiLjQU4CJsC5tspi2NvPt9pvVo
	 iGOTAAnRlX8DjKOYnt2PGiQ+pOQGlpJu4Q7A3Vnu1RHAvsu2DzlnVHphDa9p3fbaml
	 Y9c/a06AkEa8V3k5iFPG6Oqq6TQFc6sLhVbhCPU7GxMjvnOrtqbK+OfF2kjzPYSpuo
	 eNoKSwFZ7XYF9fQLFfSlDQaukXDa7hJL1maQzrzWu1uJmLrsS9InJFvRiHp9hIA1oO
	 kGZn40zJaOnd9od0x5ZjzUC8xaxm8k9ImDJVzxRCPsJNJR/q7b5HHiYihuw+N+LkmA
	 cJmZUKZ3ledOg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Linfeng Sun <linfeng.sun.dev@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Fix race in discovery auth updates
Date: Tue, 13 Oct 2026 23:57:22 -0400
Message-ID: <179194999406.3016381.11994391170573740079.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811124843.6817-1-linfeng.sun.dev@gmail.com>
References: <20260811124843.6817-1-linfeng.sun.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 11 Aug 2026 20:48:43 +0800, Linfeng Sun wrote:

> Separate configfs opens can concurrently update the discovery AuthMethod
> parameter. Both callers may free the same value in
> iscsi_update_param_value(), causing a double-free.
> 
> Protect the lookup and replacement with the discovery TPG access lock, as
> used by the other TPG configfs parameter updates.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: target: iscsi: Fix race in discovery auth updates
      https://git.kernel.org/mkp/scsi/c/e15b81f602ed

-- 
Martin K. Petersen
