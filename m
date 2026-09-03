Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83BA1E1DF0;
	Thu,  3 Sep 2026 04:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408258; cv=none; b=u9+Ug81UvL79fW2jVc1fWPE072ssZUL0pqXTzSKEctLCZkrLWcagmI/c9LQa50i5H2gvCd4lwZUMbzpCw+/s+hac0ceuelIdpZhG/ODxwFZNDSB2/UWVl7RRWlDT1Clf5o8LuwXUilTePS4o3oS8kec136Vwt/p+JhfnVuanhuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408258; c=relaxed/simple;
	bh=nFNT1m+Pbou9KMuJE2CugWiXJyBWU6tns3C5QP3APBE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tEzDRqHTVpvyZAEmKXvuU8YBjBla3WAHhXG+me+OE0bd92JOvJzUguanpLDHFwZGhU1xAqnHkHq18wjrzsEocPOB71Hr3T18ht6MKBABWuhY2joV/EdqL5NnV1uiWuj3EfaYiEq8OJjG46coyIqB17LreDM3nt9fK3h1Oy0ePao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=no+2206K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="no+2206K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155661F000E9;
	Thu,  3 Sep 2026 04:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788408256;
	bh=g371Y/VUO+1itVHUs1V7hivWy+ril+2sw9HjWdR63zg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=no+2206Kz9f0qOUCS5s/CXlkAXQbW5UkwJ5n6ufRPk252pdmnkG46Egv+IJbpq0cZ
	 OvgGeOZHG5dEU9vYClF0zLm9/yBHMk5tPlRyu30HCoE3rwuUNn/KSDqnQIjXZzIYEv
	 LLVrydEzpPqKi0no7pvjJcB39oQp2Fcp1Ln4UGZ7ZHTrnEADmoc0q5y6e/NH4U5I5E
	 bjqOTwALKH/xoQvW0YwLWVPM8kKC9JpiHBf2djMUUl+0uBmFo9KYDdk/7hhBSJ8GMW
	 eSXon+qVP0CZUrgkkHwQECY8YeSQyY4iorjObhDm4MV2HzgkMzKXbLw4SiCRxdcr7K
	 y4rckfnfh6WNw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 30/40] scsi: ibmvscsi_tgt: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260903034201.112211-31-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-31-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 04:04:15 +0000
Message-Id: <20260903040416.155661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing assignment of SAM_STAT_CHECK_CONDITION to scsi_status caus=
es the constructed sense buffer to be silently ignored and a falsely succes=
sful response to be sent.
--

commit b057f4e0cc70d975ef62438361ce78cb340d3412
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: ibmvscsi_tgt: use 16-bits defined sense codes

This commit refactors the IBM virtual SCSI target driver to use
scsi_set_sense_buffer() and standard enum values for sense codes. This
improves code clarity by removing hard-coded ASC/ASCQ values.

> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
> index 61f6828007654..e2af90b6da39b 100644
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

[Severity: High]
This isn't a bug introduced by this patch, but does this error path properly
set the SCSI status?

When srp_transfer_data() fails in ibmvscsis_queue_data_in(), the code builds
a sense buffer but doesn't appear to update se_cmd->scsi_status to
SAM_STAT_CHECK_CONDITION.

Because of this, does srp_build_response() evaluate rsp->status as
SAM_STAT_GOOD (0)? If so, it skips the logic that copies the sense buffer
and sends a falsely successful response without any sense data. Masking this
transfer failure could cause the initiator to consume uninitialized or stale
memory as valid read data.

>  	srp_build_response(vscsi, cmd, &len);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D30
