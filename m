Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196549;
	b=qxIBYDFm0exYu2+ywAeteCQQlKSfVq0DhYgn5X3QHriaIAXTdvMuqtnYlgNTxD6mCJUZ
	 uKIsPgmfQMBFdW2rDGIlBYyE7gnBGpqR/mAk/65V9V4vDayUYmZUKgkL2fHCv7K+aD3N6
	 EPSJJ/hlw65V8Ve3R+1TlY4n3lBED2MF9sem/QJiQDFU3guyh7epiHyPUHhEs22TS7spI
	 XBhHas/MvfMpmyOaUHk71rFS77C/Dw10iGhg7GswxNTONDDjPFZ0RUfoe+ayeDYlzhBSG
	 345LfQMT5hF4QZNeOwQlusP89bLPYjjXAqc2PM7Z1smnOzYZ7T/w+Puipe1PpNXXO9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ROdqwXcZpsSHl4ybTWbGmZ5YKrRrEnDl4wILqeiJeh8=;
	b=cr5DS/AjroziO9WiYseSuLhFJVBLa9i5ugFKT92dQ1472KoDaf4eNAkY1rlMPl0aZkvF
	 SA6t4UMpfGZxNqToQXVhOlyI/3J+V4wp8ZoHaEs3Z5zl679YiLsYHmSRujH8QKwztJiOc
	 9NNCXYUGY2rd41/jP3r4vwczfPMn2D+Avh5VsOSR9QqDT3hcXr83nIt2IgniDrHhO6PdZ
	 HS6VvvJmpsXfAIirlJGETYHvYbs85TjBN63YYVgqHEqbs/n6Jz4pAm6L47cSY2FaSCFFR
	 dvpr1TzhbZv3znDdCUOyIhJFy15MTG5J3tXKQhSjJXPZaeAj4lP4YPb6PdqoAAEU9bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q5eQhuGe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F18606D809;
	Mon,  9 Nov 2026 03:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q5eQhuGe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15991F008BE;
	Mon,  9 Nov 2026 03:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196548;
	bh=ROdqwXcZpsSHl4ybTWbGmZ5YKrRrEnDl4wILqeiJeh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5eQhuGesij01f+WYvWSG24n9WuTLhTWMNwv0MCQbwf33TSCPnoAXlRuoIopF/16b
	 +i2TGdElLLxEl2/u6TZKhTMDo8oxLG9y3l1YNskufmsFwXVizcV1iZIZbTpKNWRbFF
	 I/VlKx2AKdjpQ0hsSzTr8FR94KGBJ1cVjcVOJHhAzjyFckcmcg7xD7W23F6DBY4bpl
	 orPsdtZVu2nIIgS4taI6stl6AfPQEdimZUDu2TNtbxfA6ygCZ94OrbmhZ0K0Q2yPSP
	 iZumP4p5+lPGVJ95I6eoyTAehmEwmkNlceZVfrcI877OS2DzR6xtaIasffGkgGXs2F
	 KljDkEPnb8E+w==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	shao.mingyin@zte.com.cn
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	michael.christie@oracle.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix NULL pointer dereference in core_alua_do_port_transition()
Date: Sun,  8 Nov 2026 22:55:29 -0500
Message-ID: <179419615235.1941224.10228625629108243932.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026195133237y2UxJLoV1FK6aD1zrFbIU@zte.com.cn>
References: <20261026195133237y2UxJLoV1FK6aD1zrFbIU@zte.com.cn>
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

On Mon, 26 Oct 2026 19:51:33 +0800, shao.mingyin@zte.com.cn wrote:

> core_alua_do_port_transition() assumes that the device has an ALUA LU
> group member and that the member is associated with an LU group. Neither
> is guaranteed: internal-use HBAs never allocate dev_alua_lu_gp_mem, and
> the association with an LU group is dropped when "NULL" is written to the
> device's alua_lu_gp attribute.
> 
> The configfs path can reach the second case. After clearing the LU group
> association, writing the implicit ALUA access state of a target port
> group calls core_alua_do_port_transition(), which dereferences the NULL
> lu_gp in atomic_inc(&lu_gp->lu_gp_ref_cnt).
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: target: Fix NULL pointer dereference in core_alua_do_port_transition()
      https://git.kernel.org/mkp/scsi/c/c0bb6614132c

-- 
Martin K. Petersen
