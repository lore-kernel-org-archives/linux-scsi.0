Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267C437B02A;
	Mon,  7 Sep 2026 02:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749658; cv=none; b=J7i7fEJHBMqOJntOmwR/L1mMUUceLbYtFKazt7htp7RUO11xziG6QTHRtWOjAqKInopGuuAeii0Smw9BG8etytpSJajqhKt94R7zFvQV5JeSA32WHrYRlzjPHa7MvcupUGTCQZJsTwItD7lJJL/BjbwUZUq8j77Gs5Ui81mY05c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749658; c=relaxed/simple;
	bh=Cpx37AmNiam5u+1jm4mtGGdOOaoml8oHbV8eUzu84W0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C7kXie1qnG3bnw8lImONVRX7/RogYjBlztq0tl6dnCNd5X4h+NxPclmf5u8dbjTEUTOIwzUzrQNd2DG5hs1fjG+vSUyGyCkwPRvLGzw/ETzmm0baXlZQnEddHyNp974uF3jHfxJSTqFi/NOnUUegnEiADzYZR/erUamCeBUivE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSYmZ7A3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSYmZ7A3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4167C1F00A3A;
	Mon,  7 Sep 2026 02:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749656;
	bh=Cpx37AmNiam5u+1jm4mtGGdOOaoml8oHbV8eUzu84W0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dSYmZ7A3NUKnMU3hCpe+BxTHTzbW5Eq2gI0FlzPEWlWjXLU6bc7AVKu8HhmVvTwi0
	 NWdgz9VCAKInt6uYibQqtkZohaB+lZXQynpZSwr69X9MWfkuV1yJQ/sRjgiydQIFhO
	 0jVthJrVnV1SjLBr47/gbU/A1iA8KPNM6X4zjVTzkeo9kzW6zyBtkfXWuRhJh/C94W
	 hvre34nenWRvrKqxHtzwAuHoT1lDU17Q2YlxZL37Tq1W4aGy1ckScCuue5gxCgemF4
	 tDsX3rCtx1xnhm6fuaNa9M0BDWXMrkeim0tLW9or9HPUlk3V09fojtkEhf3nIsVC8Y
	 sYecUpfA1fZzQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 04/40] scsi: rename sense field of struct
 scsi_failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-5-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:54:15 +0000
Message-Id: <20260907025416.4167C1F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D4

