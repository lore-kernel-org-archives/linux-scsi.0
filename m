Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C960B3672A2
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 05:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780639202; cv=none; b=Y2NWnINHyxjHqsy9R0mNqsq1JtvTBlzp1wkPUAKywQqaHhtz4bxyVPkesZHrGuiTBjObMvKm1pyjFof8JnV1El2OltOYeBS6VsOqsLuOOQZD5pMcXo5myzlx4K6CWxTNMurH+XKWxFHdBS0fHA/vGksOnZrRjPx/FApRyrxy0tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780639202; c=relaxed/simple;
	bh=wIt2BIIvEZYEQNyARMvbAAeSVcMVm+CWy2lcBwf10eg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GhkxT4eSGfZd1xCrdu+nNW22D8SvB15pPOp13SF3AxEFgW0cc20Uhfh5KrU+7buiTDA0IjOTfPM3MPw6c2mttzrWE3SxTRURCr8hoaAZaDgI8W/t56QrztCw3IUhApKRQCfkgyWW5B+1XwGveEiHi+zjg+uQHjF+mL15tMc8uWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=h87oJ/il; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="h87oJ/il"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=Dd62zMhOx1L1LDLnprRZRcjVyhtsaKK1HG4aQQ+k9gs=;
	b=h87oJ/ilW0KNBI9Rifh/EHLpExCvrv7VWhDLoSwh3mCiD6+wWv0WCErNhCy8mQ4p1Q597TsuNWCXa
	 RI9kmOs1+Ck/PCPg3P8k/2fI3fMGjSVIak9Mbnma+hiEc9Cv6L/q9mpEGj45Y97aj27no4JLA1AQeg
	 yIGmmyEBg7ZHVpiqBUpwRVh11h/Q9MBKRTsNg0DlCdWQPUwKLn1R7QKnM2zNBxP2AICk5h4o78Ad1e
	 s4KHcgiY8tfDVq7W8JfQ2AFuajFG1AHrE7go9NxscSNIVIJj8HJOeBlSymjsmOkeKSvYls4HhC5r4y
	 hC4MNebNyxxbu5NMbf/40gNVcGnvLGQ==
Received: from smtpclient.apple (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id c58cb440-60a3-11f1-8e05-005056bdf889;
	Fri, 05 Jun 2026 08:59:55 +0300 (EEST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3] scsi: scsi_debug: fix one-partition tape setup bounds
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20260604234724.1936118-1-sam.moelius@trailofbits.com>
Date: Fri, 5 Jun 2026 08:59:43 +0300
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A287E87F-0A9B-46CA-94AF-6ABF1FAE44B9@kolumbus.fi>
References: <20260604234724.1936118-1-sam.moelius@trailofbits.com>
To: Samuel Moelius <sam.moelius@trailofbits.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)



> On 5. Jun 2026, at 2.43, Samuel Moelius <sam.moelius@trailofbits.com> =
wrote:
>=20
> The tape setup path uses one tape_block entry as the end-of-data =
marker
> after the usable tape blocks. For the one-partition layout, partition =
0
> uses all TAPE_UNITS data slots and partition 1's marker is written at
> tape_blocks[0] + TAPE_UNITS.
>=20
> Only TAPE_UNITS entries are allocated, so that marker write is one
> element past the allocation during device initialization before any
> command is issued.
>=20
> Allocate one extra tape_block entry for the marker. This keeps the
> existing partitioning paths unchanged while providing backing storage =
for
> the sentinel.
>=20
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> ---
> Changes in v3
>  - Use TAPE_UNITS + 1 approach

Reviewed-by: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi =
<mailto:Kai.Makisara@kolumbus.fi>>

Thanks, Kai

