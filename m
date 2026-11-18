Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977382;
	b=NkBxggXBbm+kdsq3V8q00Ccg2ivzD1H36m2+e02xO+MMTAy+lmPIHVnnD8oxl1NehoLV
	 UMAo9kq2k7SiqGcWBnivWykiTMxAUpSOJ8l+HAjQAhJzggM0UTkevsRbZ4aWlLKVHPWFq
	 5BFNv8hfPmvDPWYsOsqnKkqUSKu8x+yGhTeY559JNKOvz40u6BJDSR1cLYPtogsGHAyC1
	 Nc6iSVmRDYhIX1wkyWfghVE+X4SySrO0/EpfiWBgAJObu+1L1vXIRccYJjdzyejfagzfU
	 10EvCzktaRIZBrI0Od9GmMXRNT2RxZh/1uyKwhin3pvYx6sDdDAlHz+KukpkWhiLWoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=9Ne7L63wjGTXxfO7wcLNtUjDPl7tUU9eVJYUKDOx/Uk=;
	b=P7TubhnQp4mBbDglsilVkQZY0k6JMZNodQSoya1QtfMX2h+tMK0u1nnbb30S205aRiKM
	 2RIVgOzm2T6Xl6zslhhqTn9GNgvpzjC5QZz581K1z111f+P+iSR/h4g12lWNzAIcPxgtT
	 FtLmUiIqx90SGHzZEHewEOWCihdbEplJ6qexRIEcdwMe6mRwWqmt6xIcSoVTM3xRddSbf
	 SZqo80d1AH5Tq9PD8VJUnYy6UktTzU3dG53t+eT1vf4+7ZvbjSvAGjh/d9uIvl4SflJYj
	 jpN+aQYI1v3qhW7GraEtXEOr8sJ1J2YTaU1gtyzPE62OKT46YLrp22dB7sRd49YOlsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TLgNdL2u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D16606A336;
	Wed, 18 Nov 2026 04:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TLgNdL2u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161C71F000C4;
	Wed, 18 Nov 2026 04:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977381;
	bh=9Ne7L63wjGTXxfO7wcLNtUjDPl7tUU9eVJYUKDOx/Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLgNdL2uLOthJUpBylNqGP0411IqJIPVhoUkhSXhWaOzYREg4ISBj0sjgrLBFZDiA
	 n3SeHNRGC7kFwmvzQfbgOA0C08w0Mavgc2lGmk0v8qDVlAOCfglXxbD/MCQiFi9E4f
	 A/lXh9ZBDrNkN55iQBAONbK3GDxy6k5nYT/1ASIcw0cXPpriFtfz4gH/l5PN2mucys
	 s2LthPzoWWCHrK09uGTYISR7Ri/fp37BKAP/KfLzWPFOm/Y5pl0ZFEtL/goZilPJQS
	 oMoiI4Hh115YI7+QTEdvT7y79MPCheGqq835pNQVZWL6QWKcVMb53lH9SNAx6mQ1GO
	 fBDxBoe+/GdLQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Hannes Reinecke <hare@suse.de>,
	Weidong Wang <weidongw@illinois.edu>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: libfc: Fix rport kref leak in fc_rport_enter_ready()
Date: Tue, 17 Nov 2026 23:49:27 -0500
Message-ID: <179497726101.2093762.2693118779770513336.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261108-h123-send-v1-1-b7672ff849f0@illinois.edu>
References: <20261108-h123-send-v1-1-b7672ff849f0@illinois.edu>
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

On Sun, 08 Nov 2026 03:01:08 -0600, Weidong Wang wrote:

> fc_rport_enter_ready() takes a reference on the rport unconditionally,
> but only queues event_work, whose handler drops that reference, when no
> event is pending. If rdata->event is already set, the && short-circuits
> past both queue_work() and the compensating kref_put(), so the reference
> is leaked and the fc_rport_priv is never freed.
> 
> This is reachable from the wire: a PLOGI from a well-known address goes
> straight to fc_rport_enter_ready(), and a second PLOGI for the same
> S_ID while RPORT_EV_READY is still pending enters it again. After the
> rport is logged out, kmemleak reports:
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: libfc: Fix rport kref leak in fc_rport_enter_ready()
      https://git.kernel.org/mkp/scsi/c/cbd9818ebed3

-- 
Martin K. Petersen
