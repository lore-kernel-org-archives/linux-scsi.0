Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196549;
	b=usXWNg/YXL/dJ6qEFa/SXWMv0yF3ayHZJJ9gSbdtRM+EUK3CAJaJaG+jAPpTckNqpcNG
	 V/kgneBFJdBq+Srv6GX7q5NQMPQ9Q06f1PfUdVChVL7cnjDSX1IntFauxOgTFI+TMGOGv
	 W/zT1s71shWGhlx1FvOtFTUqY0X2kbmMvK+bJm9p+lj3U4slu0oIPPE7ossyO2yEzrM5q
	 QZkRFPTMVN4KCa2MNTEPTjYdVGJjDjz/9+wKouLYVE3qVEpkIXhdfFhxp2fP3aYU93apv
	 j61wzRvnk5zWy3A8vpkP2UYjOkKpT7MCFwTBwaio1YvDyo9t7h8ZripqHgqcRqpGoCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=2QHduY7QRBGYLTY6K22XQVDTFclXeKjALaCeqC7h7s4=;
	b=1F2faDCeVxxXgT3UHaPYGh4KXgj1gP/KJNoWsI0D1/u4etSdz2GbXRPst3g0mnwACcL4
	 k9mtFcGvh/vMagx3qyPdm1uUYMYcHCx6vaQe2U8khCSE76LiYff+qFi5H/6FAfcHpkMAm
	 vaOiuNjHvhyfOKdVloaE2MNtWlZzPClF8Piu3b5k1wzGpjlgAdlJ/f7FVSBSABKvoj4WE
	 YtPBGRTf03kNCuBJLWSudGcjuX/Nr7x7mwk0C28a0188k+GNB5WNI1+vT2k+9Jz/mVpgR
	 7wFHipVE1/WyZkk7Lq5MNy26fnwSF5UdU+NhuFkMSJHlX19/pFkL4qfGGiXHnEcQqJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=heF2RTMc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E995606D811;
	Mon,  9 Nov 2026 03:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=heF2RTMc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54481F008A1;
	Mon,  9 Nov 2026 03:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196549;
	bh=2QHduY7QRBGYLTY6K22XQVDTFclXeKjALaCeqC7h7s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heF2RTMc7Q+cscYHQRa1GMtwehsEPim/CMQcAFKRvudIgdH8qrxNMJT44Fz5pvsDO
	 7L0MnQwe8eZxKksnMrp481E3q2Y2lZDe8Hy5MxtU+WED2+aCZVFXGChLhN8CDKa0xO
	 bo4W/UxOHqVtfmlLJHIhGnYu2PkeMH5lBlmUkrrzkP91PQpkrjXGjWHjQRC4eOPRJn
	 /9NoL1qmoTbS9+zzEbkQO22By6TPxdtOaIRqQ57AIz9KJAnTUjjJsJFAj4R2RbLdXn
	 QsNEXp7Vj9WZeiMsT149KVp/lQVKzb/0Ab1zleiwfnuneKnDhYyfidPYCQfY/ntHwN
	 MyU3VugCPOHxQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	shao.mingyin@zte.com.cn
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	michael.christie@oracle.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix NULL pointer dereference in target_dev_alua_lu_gp_store()
Date: Sun,  8 Nov 2026 22:55:30 -0500
Message-ID: <179419615234.1941224.11103122342148610453.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026194955694FnXGoQ352dstLk5HPBqCG@zte.com.cn>
References: <20261026194955694FnXGoQ352dstLk5HPBqCG@zte.com.cn>
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

On Mon, 26 Oct 2026 19:49:55 +0800, shao.mingyin@zte.com.cn wrote:

> Writing "NULL" to the alua_lu_gp attribute clears the ALUA LU group
> association of a device. The attribute can be written again after the
> association has already been cleared. In that case lu_gp_mem->lu_gp and
> lu_gp_new are both NULL, but the code still calls
> __core_alua_attach_lu_gp_mem(), which dereferences the NULL lu_gp
> pointer:
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: target: Fix NULL pointer dereference in target_dev_alua_lu_gp_store()
      https://git.kernel.org/mkp/scsi/c/fe5988e8708e

-- 
Martin K. Petersen
