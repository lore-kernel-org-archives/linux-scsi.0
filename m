Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5232D33939D;
	Thu,  3 Sep 2026 03:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407603; cv=none; b=azhTQY3KygrBO+Z//cbY7Q+5LmKbeTDTJ7agf6pJYJ4xDycLYrJQ67ULWXlSj7ff1jfdUc27RYfFZMglyscozeMCOgv7J/smsAafE5lFZ3Y5xE+SQTklqg6Bpkj+gUEeLbWqxh4BC0FstAljIoW0YUbvn2h4UcrSWQ42ubCAXWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407603; c=relaxed/simple;
	bh=Z4P7EBxlxs1+597xHQRsuC/uofsXNftYzQU5GHVAM8s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e666O2AqHuKRHlk7JmQnWac6uUGBTTqp5EWN45IIwxrZaorTNaeByUqG3gyTYCx7yRj3asnbdV5FgxBW16TQLsDQ2VpelrMOCsdKPWWf9izMwQ/LzcPK8+L+va/PgLE/fE1JMyRwNVa100VZt1FXayFV2Voz12sS7ll8mHyakpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Awa84Xms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Awa84Xms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39F31F000E9;
	Thu,  3 Sep 2026 03:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788407602;
	bh=Z4P7EBxlxs1+597xHQRsuC/uofsXNftYzQU5GHVAM8s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Awa84XmsBOgcNrJEvJVYIC4r95GRth2d7iYjA+IuwAkmO6yo7ToSw5nepRigyb3qI
	 cCntUwXYPQ8WBSI9m9HV/083iU99BxsyJHg6WEMnlzmVVC1CoBnUbXGt0YzJwGnw1Y
	 x/2vXl2Au1d3QVPk5Cf9QP3Pgnl4NW1xjBGhqaLh9pn1tBWzQbt8HNZBW8MC3b+eoH
	 Vo1p6hUhjpEKACwHROYgM1VYCGyywjiaDtlTculjEBbr6XGK8bu94aE4Uc9tx4+KRL
	 MTVz7iSOTz+RcMsKFhEaXAGWVgQYJdIxx/RzYFKAXFv694/jQORYlir+zRdgIFTUqo
	 78gvKstrGc/bA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/40] scsi: rename sense field of struct
 scsi_failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org, linux-s390@vger.kernel.org, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260903034201.112211-5-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 03:53:21 +0000
Message-Id: <20260903035321.B39F31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rename the sense field of struct scsi_failure to sense_key. This makes
> it clear that this field stores the sense key, and also unifies this
> structure field names with the names used in struct scsi_sense_hdr.
>=20
> To be consistent with this change, the macro SCMD_FAILURE_SENSE_ANY is
> renamed SCMD_FAILURE_SENSE_KEY_ANY.
>=20
> Of note is that the definition of the array any_sense_failure_defs in
> scsi_lib_test_any_sense() is modified to change the initialization of the
> result field to use SCMD_FAILURE_RESULT_ANY and add the .sense_key field
> initialization to SCMD_FAILURE_SENSE_KEY_ANY to match the test target
> case.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903034201.1122=
11-1-dlemoal@kernel.org?part=3D4

