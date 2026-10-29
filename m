Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239406;
	b=bB2yQ+GyqtBox6BAvn9kT422qFzjwxrzx1P5NP8FcTVhWLaEohZas9uDllvQQvyTz/Ve
	 eBJf1dPVCSo914Bsz3WV6157Bjjprd/soly77vvf3nv7XWs5OOcjaSq9zdbhTOPmhdA8t
	 DQMgjahgLBKololfBoRPjGTiO84ee589NGlJpjf+JGQ+r9liikfv2k40zHgCvepStfIX4
	 MDlH7q0nMEobsJP1fDyyMXOukRmPwLFnlXV6rF9LFw2FXSNeCJE54wWvV9DND0WwLwG74
	 TD83Opn949ou90urEA94fJG9hRSKxPsj1zPlRub+pqyFO2Ay1s5zyXm8pGdetkjuVTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=1izrTgIK5MkBirvotGd/I5vJGe3H9Lg+USaV2HU9hmY=;
	b=sIIZ6qp+yknaAbQ9go50QacWFYLKCZZGuB2Zr48EdETWzQjxtDa3WCiAms+rQCPeSx/t
	 ZYqaikKwgJw3lX1jnko3XaSDFDBanRetGdp9FeLpWDUvkOY82UmY6DRDAqtXpKT/Kz65k
	 N/BvEGEwAC935/MgHQcR/OQ2laHXKDKnoUrI9VCoSLjC0tvEcTA1BXZd0pC8uzo1k4bsN
	 5fpRfQGhJ24VcqqYkDdu0dUXntcyTAlHcawmCMGxSxq3FBdMCW6AtDJOC8raPhhFo0+hn
	 xyuwpkDEPCCSZzzXDMOY/VH7ADBLwRGVvAtMAkI6XmFJCB2M8Q+5GjqT/CwEuko4lBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MFu7oeCv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE67460A2610;
	Thu, 29 Oct 2026 02:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MFu7oeCv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53771F031E5;
	Thu, 29 Oct 2026 02:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239405;
	bh=1izrTgIK5MkBirvotGd/I5vJGe3H9Lg+USaV2HU9hmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFu7oeCv7GH7oAIfENEWQH9q5sEJ6OAVnvGTqaZMEWO4dObtLXJG0/y5YmGVhGTU7
	 pZXwTGhlr08aUdKse8kfMQnZm3zlV429C0cN1EeGjgDE1SbTrx+VIGh3QSIbwfGTQS
	 tt4yPISswcLWcscZlytodOC4QC7c7nLXlogwXFW1x03o3F1bx8rYK5NQqZNr73Fgdf
	 3YEsd5J85w2JZuQ57q8pYV6KGvzbmRa0d1iYjIE3X/aSmCEUHEye7QXvro2TjfqCsH
	 UMwc+Yc+XL/FScXoFIZnVhFfmIOSZc1T5zHakw0iZNnrtHi9W1Gmd7DiHLC/6m2C/u
	 ZFqxPpinVGUXw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	James Smart <jsmart2021@gmail.com>,
	Daniel Wagner <dwagner@suse.de>,
	Haotian Zhang <vulab@iscas.ac.cn>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: libefc: fix resources leak in efcport_init() error path
Date: Wed, 28 Oct 2026 22:02:59 -0400
Message-ID: <179323465363.491807.11508159821264700298.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261008185403.2791781-1-vulab@iscas.ac.cn>
References: <20261008185403.2791781-1-vulab@iscas.ac.cn>
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

On Fri, 09 Oct 2026 02:54:03 +0800, Haotian Zhang wrote:

> efcport_init() creates efc->node_pool and efc->node_dma_pool before
> allocating efc->els_io_pool. When the latter allocation fails it returns
> -ENOMEM without releasing the node dma pool or the node pool, leaking
> both. The caller efct_efclib_config() only logs the error and
> efct_device_attach() failure path never calls efcport_destroy(), so the
> resources are never freed.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: elx: libefc: fix resources leak in efcport_init() error path
      https://git.kernel.org/mkp/scsi/c/b4bd078b78c2

-- 
Martin K. Petersen
