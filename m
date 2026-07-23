Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D601521883E
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766528; cv=none; b=CsrXFQ56zBd6BetFEFCjo9qtgt6aw1EKaf2TwBSJdotN4Gn0PHSNpZWxV6BhGbfUwgtVa56i+ckaZDVO2KtG3VR9aVIsR9XyHsD1nc23tV9O2WnQaZ8JIAS5o7c8ES9XqMhEQXwvZtJSpvYgz1Dc6jNrhKBrthR7cxQzkIYGuBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766528; c=relaxed/simple;
	bh=N1vMX6PSo5yd8iTLYynNAXsyCQ+5rs3aHa0aH7yiPr4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XwHse4TgLR6vy4qI+4kcCFWX0ZB1Z0hHLNlEo6nODc75mQEt1y/5XATfupcKBPaQy4l7LHHTxgmqxbeOCgpVWX0CPDcj06qjqvRtUT6gGw7OtlUAoqZ7J1L0PakQGB088wgObZ72Q3RCmupBeUReI0FQhdyE2mu67TVfmnSj9Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfSnTKUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfSnTKUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD211F000E9;
	Thu, 23 Jul 2026 00:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766526;
	bh=pOPsQih/aErqoTwpN0+q9s1gCzLr8665jNF3CHMcL4E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RfSnTKUnWOPYH9FeWzrojlwHo0NkCXLBBiaRKBHJSJlIfkhD4axyUDkMdp0+1h8N1
	 vhhHtbaJXOVBqizp52NgfzGaM7D40+y/GP9lS6zxGjewzNAENc8sDi/geRnOVLTeJj
	 HVtnE2FBRYuNoKiZ4kfkry4dmSV4FyVFVwUaGKbO4/iFcK49pFbZ6PKCG0sBHytFkr
	 DW68ydXYMviSVTVpN2aFiiICuL56zqJdxZOE67U8FBymNuMEx6KS77lSVydmZzMpmm
	 MCPUzzpSM0s9xBO0nbFgEatxAwAPad7q+Syo27IYkJ+2pJUx7/Gh5vgY+OlC4nxR4l
	 uzfkC+Qr9QQqw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/33] ibmvfc: add NVMe/FC protocol interface
 definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-7-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-7-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:28:45 +0000
Message-Id: <20260723002846.4DD211F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ABI breakage in legacy SCSI implicit logout MAD length
--

--- Patch [6]: [PATCH v2 06/33] ibmvfc: add NVMe/FC protocol interface defi=
nitions ---
commit ed7fd173b2f77c91dcd53e86ac17a531e4649515
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add NVMe/FC protocol interface definitions

This commit adds the protocol definitions for client-VIOS interface updates
needed to support NVMe/FC over the ibmvfc NPIV transport. It extends the
ibmvfc interface with NVMe/FC-specific capability bits, opcodes, channel
definitions, and v3 command layout support.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvf=
c.h
> index 0e259e9d2e9bb..f8a2bf92da410 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h

[ ... ]

> @@ -377,20 +419,27 @@ struct ibmvfc_query_tgt {
>  struct ibmvfc_implicit_logout {
>  	struct ibmvfc_mad_common common;
>  	__be64 old_scsi_id;
> -	__be64 reserved[2];
> +	__be64 reserved[8];
> +	__be64 target_wwpn;
>  } __packed __aligned(8);

[Severity: High]
Does this change break ABI compatibility with older VIOS firmware for legacy
SCSI logouts?

The size of this structure increases from 48 bytes to 104 bytes. When
tearing down a target, the existing code in the driver uses sizeof() to set
the MAD length:

drivers/scsi/ibmvscsi/ibmvfc.c:__ibmvfc_tgt_get_implicit_logout_evt() {
    ...
    mad->common.length =3D cpu_to_be16(sizeof(*mad));
    ...
}

Since this length is sent for the existing IBMVFC_IMPLICIT_LOGOUT (0x0040)
opcode, will older VIOS firmware reject the 104-byte request as malformed,
leading to target resource leaks?

Additionally, it appears target_wwpn is never populated with the target's
WWPN in this path. Would newer VIOS firmware that recognizes the larger MAD
also reject the request due to the zeroed WWPN field?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D6
