Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977377;
	b=MHmsm4mHaQ4EsNzKz0729iwWAryytkYwJzcZYlEiyldYyzKNSuiL0HM1RczM4EcoE0nd
	 ho2+rTNXEYT5w36LfZkZc/t7BUpiAIwJ4j3VVMuiaTGMdUY3CgiHl4EP3c+9YaI27VcFH
	 yxiMSje6HySmk/sIp/8iwGzzyqE8i8GBoeGpLehGGYWdcqIBjcEyNKqN/jOjy4WzLCppE
	 wYStLdQx/feRdPlwmpp4/qeLRmKxdjbb0CL0BThXoaAb6ZtW/TqRzMmdwqe37uBPp1vej
	 +7Xk+Z6PApUKOeAx1DRACFhCCGwUQrormVesFN1daMisGwy+6NYpMAiL+9e2Z4Z0o2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=8+QgvUb85vZLIdW2rrmmErSWuYeeqZH0EoUoa+InvZE=;
	b=bBX8QpIRjwcxwlbqoL6OZMOH1P2VLAJKlU5fJDvGUXiks8D0JW4DwOzJEKaT+OEUja+l
	 LtRJBRdQ9QBwCmtfgfiiFG0EGZFNmK6XcDXhhE0vLkPb0BOh6U6Uzpq/OWlxkStHWlZRS
	 UrCJ4ECT+7pQoLBo1fyETrE5l068TW61Sjw+OH6YuAwaUEg8Ovk2iJVJKiwvuAxy85Yrs
	 zcgCfmRYnP+gizHer9NCNsx79Cr4nUua91fc0G/P0V+H9RMoyh7V4gO9xJwxdGVbOwVJW
	 TCt9p8/m1zOSdSNODHzAp5a86Or6S8cfzmt2W8X/3nrNjiAVwZs5fSDFY/nTVHlFQSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mdV4cSDG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE78606A31C;
	Wed, 18 Nov 2026 04:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mdV4cSDG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A891F000CE;
	Wed, 18 Nov 2026 04:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977376;
	bh=8+QgvUb85vZLIdW2rrmmErSWuYeeqZH0EoUoa+InvZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdV4cSDGL73FXhsmlh/i96DcuPK5QvvKD0AukH9N4ag4L2w7KRaMpQ4RE6VcyYrxV
	 XGQYJcvRJxtVt06BgWoVyLbPsM5JdSL15ZazzZTPzjyJML2++VdHvikut0+JWaYj68
	 fFb/W6v9kmyOYhk+pyotR+VRDuvvPWLtQzaPTeWL742o9x2yDf2lkMjxuStVCfeGq/
	 62/GchbjlZPwWQDXYYKQTpgEql8qLDmkVpZrgJ9uL3u2C/luTxznTnojYo25+dLyPR
	 m+7kSMHkmj6b9fSldxvMylksFKCcMhmEb9U9eaOuRhU1RneRnFabM/HlZaaYiCiGN9
	 +ONOBx+ZUagtw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	Laurence Oberman <loberman@redhat.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Martin Wilck <mwilck@suse.com>,
	Hannes Reinecke <hare@kernel.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	John Garry <john.garry@linux.dev>
Subject: Re: [PATCH] scsi: scsi_dh_alua: set handler_data before alua_initialize()
Date: Tue, 17 Nov 2026 23:49:24 -0500
Message-ID: <179497726107.2093762.12353078197804900109.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261109201120.1067815-1-loberman@redhat.com>
References: <20261109201120.1067815-1-loberman@redhat.com>
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

On Mon, 09 Nov 2026 15:11:20 -0500, Laurence Oberman wrote:

> Since commit 50759b881e1d ("scsi: device_handler: alua: Call
> scsi_device_put() from non-atomic context"), alua_rtpg_queue() only
> queues an RTPG when sdev->handler_data points at an alua_dh_data whose
> port group matches:
> 
> 	struct alua_dh_data *h = sdev->handler_data;
> 	...
> 	if (h && rcu_dereference(h->pg) == pg) {
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: scsi_dh_alua: set handler_data before alua_initialize()
      https://git.kernel.org/mkp/scsi/c/a410375a249c

-- 
Martin K. Petersen
