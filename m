Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AC72931C8
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784916561; cv=none; b=EWreGKJdIX1Eh7RFIDxkhsifuDGGT9BP5LwaVBmjMs8kzKibogjOY1A85M+tnj2cr6ZVPBcUMd2K/stRale/kjpLcVLQ2OMN4p7Yp/FE/m09Qtjkp4SXNkfkgFnJS7vtf1dXMT+EuhIzSpIUwU9w/vWr2B7q8bQDJaxxP7W2Iu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784916561; c=relaxed/simple;
	bh=5BmaNzGOFDkVApo04sNPG/4y3z03zXJRCfkEFFrbmpY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZNQFFZLodS7fieLBeOEuahHJ2LIkolizxLvH9wS46MjVgND7ViH1qlU1Bb4AE7F2m8tnFWkpsdMKKcA8hjl4FG2l1Ka7swWPdKFFaoz9SMxwpa/VoU4t4CVl8L6QITsRXAMr+eO9YARyHTc/DVAevnfpoELpmcYeNJFfdBM1rPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PdKe04lJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PdKe04lJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3148E1F000E9;
	Fri, 24 Jul 2026 18:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784916560;
	bh=1x3D+sdaI8mmOAueCNPpm35ZMIv/oF8bxLOjcHyJvAg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PdKe04lJ/ApkpAJme8LQ16FeJKsEk2Tq+bsbe2CC7i3N/hpVo/sy/oAiagpH2o3Fh
	 3TS0y7+4YTNJqY/6csM6ZlYFcjJkPzWCpa4wWRQa78lu2rYluP4ZVw1LWGYu3O99aa
	 X/E91FHL7hDGG3rxUP8yk0M7ne4IR5vw08LLkNeYubfxzekeTBDyOCndzcWEVqoSLq
	 umx3lpMZpAtfgpHl2ok0E7829TN9O28I6Aw9oX9EHDd4p4XlYPUxvNQ7lVYGxd1gO7
	 2xBntjT7Dof7okUqbxjycmfeC1MYs0FDLbi4v95GXWjpXhV37x6kGGh29lM0OTNk/t
	 byJeAClVEG7PA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 02/13] scsi: fnic: Use fnic_num for non-SCSI
 identifiers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-3-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-3-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:09:19 +0000
Message-Id: <20260724180920.3148E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Unconditional use of `fnic_num` in `fnic_fcpio_ack_handler` trac=
e breaks FCP trace event correlation because other FCP events still use `ho=
st_no`.
--

--- Patch [2]: [PATCH v6 02/13] scsi: fnic: Use fnic_num for non-SCSI ident=
ifiers ---
commit 475f57f36329cdc1feb8aebc23e707d1a0bd9828
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Use fnic_num for non-SCSI identifiers

This commit replaces the use of SCSI host numbers with driver instance=20
numbers (fnic_num) for NVMe-facing entries and trace events. It explicitly=
=20
updates the fnic_fcpio_ack_handler trace event to use the fnic_num.

[ ... ]

> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 0759540f66753..b92260583c67b 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -894,7 +894,7 @@ static inline void fnic_fcpio_ack_handler(struct fnic=
 *fnic,
> =20
>  	spin_unlock_irqrestore(&fnic->wq_copy_lock[wq_index], flags);
>  	FNIC_TRACE(fnic_fcpio_ack_handler,
> -		  fnic->host->host_no, 0, 0, ox_id_tag[2], ox_id_tag[3],
> +		  fnic->fnic_num, 0, 0, ox_id_tag[2], ox_id_tag[3],

[Severity: Medium]
Does changing this trace to unconditionally use fnic->fnic_num break FCP=20
trace event correlation?

Other FCP trace events, such as the one in fnic_queuecommand(), still use=20
the SCSI host number (sc->device->host->host_no). Because host_index_ida=20
and fnic_ida are independent ID allocators, these numbers will differ on=20
systems with other SCSI controllers.

If a user or tool filters FCP IO traces by host number, will they see the=20
IO submission and completion events, but miss this firmware ACK event=20
because it is now logged under the driver instance number instead?

>  		  ox_id_tag[4], ox_id_tag[5]);
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D2
