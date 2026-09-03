Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1439357CE9;
	Thu,  3 Sep 2026 03:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405029; cv=none; b=N/YDKy/zInV3KrfuVQgoDClFsJwFwxcdat+TTseePpgzEKxjKhlHLeuhV5YnESJyggYlxEAt2ivH3YYrN9a8wGzuvBu4vQY4MN8LYExl5kxtiz6rhDj3NvNuNuk3kzLOuVjZIRORZYo8u94tsRRVeB4nijkshOCvisY8uxrLj4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405029; c=relaxed/simple;
	bh=yDUYyQaFlq8tXXASfcARcljHFMLdm3RuonF8ltHah4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fosUGkRuVmZxyNpTLWRBDmn8zp+9XxgR9f6Xke9hwCinBxpnPvc/4mMDRxP+/L1QelgKk/BF1jfIKljmGN3ets9xtVGyd2Bjjz4FfjzVGH1KEvhseKlQJUmr08rshqsQK/XT894wSo+pqn9GsGLrqBTxR7LeivDbgXF4mZ88daE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6OjU7wj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6OjU7wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2535D1F00A3A;
	Thu,  3 Sep 2026 03:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405028;
	bh=caX7x7i80gxUKHQCtZGsBvZac/QLQkNHPvkqj51y0dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6OjU7wjxVazV3ru3gGUnKIkWmYVS+gdbMQdhxxOErXRfEDA1B6RK+7v3exoF91Kf
	 HRuxTQpPiXgAG99eC2WTC3zhgfrqWaB50z1ctQ4em2YOcQFOhZfOsoasCrije79IH6
	 r2jKhRk3jl/ro5ECfP8eN2s1G6lTgwrE6gjix3ofwfFR3goxbiWiJ0HpQ4yxosSjOi
	 PnOTCm0e/JBbkXWfGr4YnjnxQKFZE9ikDNu+3jVD8XZ2FWytO+seOA/kH2iOoVUvj9
	 x01fZMe9e+LpkYHUr/rhVK0xO4952YJJuMbrxxhodD2emqFyyzw5G/yoHW8SlfPEJF
	 Gom9TjSXFAT5w==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Linmao Li <lilinmao@kylinos.cn>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH 0/2] scsi: fnic: fix NVMe/FC local port setup and teardown
Date: Wed,  2 Sep 2026 23:10:07 -0400
Message-ID: <178840472579.670675.9863331512584936736.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819114242.3598034-1-lilinmao@kylinos.cn>
References: <20260819114242.3598034-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 19 Aug 2026 19:42:40 +0800, Linmao Li wrote:

> Two small fixes to the NVMe/FC transport path added in commit 5efdd5cf9281
> ("scsi: fnic: Add the NVMe/FC transport path"), both found by reading the
> code rather than by hitting them on hardware.  They apply to
> scsi/for-next, since that code is not in mainline yet.
> 
> Patch 1 initializes struct nvme_fc_port_info in nvfnic_add_lport().
> dev_loss_tmo is currently left uninitialized on the stack.  The transport
> does not read it for a local port, so this is hygiene rather than a
> behaviour fix, and it carries no Fixes tag; nvfnic_add_tport() right below
> already memsets its own copy.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/2] scsi: fnic: initialize the NVMe local port info before registering
      https://git.kernel.org/mkp/scsi/c/98f0a1422e28

-- 
Martin K. Petersen
