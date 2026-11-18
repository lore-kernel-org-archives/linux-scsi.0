Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977419;
	b=TOUj8lSDeOTXNo7i1MUI9CVDWhXi210ggcPp/SJJm/Rl1IIU6mQMaVlI6dRrUiKLSo7o
	 1x006eW4z+Ux0KK4ooBvPbdGP6sF/QC2MBIMBJShy6DNIPa/pce9aZiLhWvMDro9xlilz
	 OgkHNSr2iq41wsdo/UVEmMA+pZbTcWHMaAlO0Jh5Gl4WbQfBYs6y2prQ77KCTpo+6wg5q
	 w5qEpBaoMykN3iG7G0cS6e28DWAAU4/2wNjXNonjnUVAaw+WQdOEC9NeLpcJw1afAtqPf
	 i808EJKEo437Tba5fmFPdmHe+4pdh9YwNzAG0uAFbq3kyjoV0qATe2XwOCRF1Day7pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=sAIg7yaLHBGcK132ApIlMwmMwf0Jrco4UuiQIS3pARM=;
	b=sB7z4S1s262uICuZ35Bd2WK85nsq46t1Mk66mxbjtaOwLyGXR3KItpDMKXmQUtIFFL9a
	 3VrMHJ8pOZ3oJzMIVtNyIkqrT556QBtw3I3+2SADdx6nCXTYzG+P0Myk2BDoMTmDCjAct
	 L7/UBXcm5BbhtTMyJDgITaG+RKQYP714F7XarbWhXXzJ6XvSbVzDZ5qeosUEXrttRlJxI
	 cUon4lm7GtydbECCf6cglgeOzbmRHk5WzqBn9MplMeaeFCNH8m1x86mDgc60GXFy+grIg
	 Qt3SU59pu9iF/qN3zriTRycEscdQmR8hfaSA3d9Wy+wxm1FDs9c5m2AuCTBLGfHhSkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dm5MRN8D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1857606A335
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 04:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dm5MRN8D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6361F000C5;
	Wed, 18 Nov 2026 04:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977419;
	bh=sAIg7yaLHBGcK132ApIlMwmMwf0Jrco4UuiQIS3pARM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dm5MRN8DvYgx7yXVojkWB1YNyiu1wVOCf5IeApotBV2a6rDF88SzKz6FL8hYESyft
	 Natsod6Lwoc7GsCtjCv86UrzzSq8nxElHcr3lFLa4ZJsC43WZPf3D6dBORYU6td/fW
	 v6rT3SzacidGvLh6+Z0pO/wXcfmLdzcu9qMFKUU3yQWEP4060oSJ/Ne6Cwl2thdxOf
	 L5WFUvJF2Hkd3xcAli5oIaCBbv56V2ohflbC8G6xLvhMJ1uke6zlpeG/3L8q5Qv3wN
	 9jfcQ2wL9MUPdHDQPUvOstEv7TloeyaxKzg1qewj3qi1c/ld1ePLaPbvyP4utHXUYX
	 CMpTVXE3am7kA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	Brian Bunker <brian@purestorage.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH v3 0/3] scsi: Bind sd to LUs in the ALUA unavailable state
Date: Tue, 17 Nov 2026 23:50:10 -0500
Message-ID: <179485091815.1479907.16126616760313392206.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261029002531.82824-1-brian@purestorage.com>
References: <20261029002531.82824-1-brian@purestorage.com>
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

On Wed, 28 Oct 2026 17:25:28 -0700, Brian Bunker wrote:

> A LU that is in the ALUA unavailable state on a target port reports
> peripheral qualifier 001b in its INQUIRY data. scsi_bus_match() only
> matches devices with peripheral qualifier 000b, so if a host scans such
> a path, no upper-level driver is ever bound to it. When the target port
> later becomes available, nothing binds sd and the path stays unusable
> until the device is deleted and rescanned. A host that was already
> running when the path became unavailable keeps sd bound, so the result
> depends on when the host scanned.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/3] scsi: core: Move REPORT TARGET PORT GROUPS into the SCSI core
      https://git.kernel.org/mkp/scsi/c/746aa1d936b1
[2/3] scsi: core: Read the ALUA access state when a device is scanned
      https://git.kernel.org/mkp/scsi/c/e085b1d6b6aa
[3/3] scsi: core: Match ULDs to logical units in the ALUA unavailable state
      https://git.kernel.org/mkp/scsi/c/6054ce4233db

-- 
Martin K. Petersen
