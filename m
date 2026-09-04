Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DC217D6;
	Fri,  4 Sep 2026 02:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788488459; cv=none; b=tAAXfmXqsA3w5Lfdd6MXL+vqGAAhXFMq8K4XBLQRsHJ6MZzDlUzdyvSCv6bIT122g+Uoj8okzTUeX3aCi9iXs9f7hp4NlbNcSWLHNGFN75zcAiKN+8DWo7DEENI+YahLVWtUOZMFzNrIKOQeX+frShpYNo8Wq2/TpBoACIZWnp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788488459; c=relaxed/simple;
	bh=YEls82BbPFzkOn0qp7fp/KyMrwnxS0LClixvrddXWxg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZumcJofJquRz8sOYrIe9g0+j6jAKdaIBREKpVenFSQDoUblRFA6DfbLWh39Zvp6PVzfphJs1Bf2HDRNFVJz21Oobz/jTLRs0zSFrOi0Vir7UtPkyoJOhrR/Y8y2RO4IJ3meWDYi8UVaONKmIewpAhUHOnVTL+C0p/20gz2pC1jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzmrRhGl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzmrRhGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF571F000E9;
	Fri,  4 Sep 2026 02:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788488457;
	bh=m7xPE2zVFGVJNJ6gNfBF42NP4zUSHPYADY6e99Asdyk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bzmrRhGlF2DXNjSJl09MCa9T6I+Zdzw2QCzqDeAZ6X227KDpsiPZYt5Fk2DPYTg7b
	 fJ30mVEAtJ/03hn9rEDFZchj0P2VD3dEmb3S9znP3N42Ya1kxqhRNvxQy2Y5tBfsIi
	 xIv4xO2NiVlU3+54HyqNL4QPN82Y82ZyNKHjcKkRdr8FbofCMW+tU78Uh5zCljfo6s
	 d31HJcBkpta0wiCcWx7eyjh14t9uDPkBq7K4z/PTdpll/YMD3s3F1ivDgJtNKancY3
	 VO+IhCO6pEACua5XUqy0rXRpF7KVrDVGqXDI5eYJmTrlLm9m/WEb/v35ig+BLp+uMZ
	 H4uZa13JGbusw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 30/40] scsi: ibmvscsi_tgt: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20260904002644.157668-31-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-31-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:20:56 +0000
Message-Id: <20260904022056.EEF571F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Silent Data Corruption on RDMA read transfer failure
--

commit 63c9746d76bba6c84fc3e8bc8ef80bf322e5cac0
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: ibmvscsi_tgt: use 16-bits defined sense codes

This commit replaces hard-coded additional sense codes and qualifiers
with enum values from include/scsi/scsi_sense.h in the IBM virtual SCSI
target driver.

> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -3757,9 +3757,8 @@ static int ibmvscsis_queue_data_in(struct se_cmd *s=
e_cmd)
>  		dev_err(&vscsi->dev, "srp_transfer_data failed: %d\n", rc);
>  		se_cmd->scsi_sense_length =3D 18;
>  		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
> -		/* Logical Unit Communication Time-out asc/ascq =3D 0x0801 */
> -		scsi_build_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
> -					0x08, 0x01);
> +		scsi_set_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
> +				      LU_COMMUNICATION_TIMEOUT);
>  	}
> =20
>  	srp_build_response(vscsi, cmd, &len);

[Severity: Critical]
This is a pre-existing issue, but does this error path hide RDMA transfer
failures from the initiator?

When srp_transfer_data() fails in ibmvscsis_queue_data_in(), this code
sets up the sense buffer with a timeout error, but it fails to update
se_cmd->scsi_status to SAM_STAT_CHECK_CONDITION.

Since se_cmd->scsi_status remains 0 (SAM_STAT_GOOD) after a successful
backend read, srp_build_response() evaluates rsp->status as 0.

This bypasses the if (rsp->status) block in srp_build_response() that
copies the newly created sense data into the response.

Consequently, the initiator would incorrectly perceive a successful read
despite the RDMA transfer failure, potentially misleading it into consuming
stale or uninitialized memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D30
