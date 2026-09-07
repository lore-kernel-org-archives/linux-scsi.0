Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5488A12B94;
	Mon,  7 Sep 2026 02:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749697; cv=none; b=hGsK8oj5xiHzTbzZNXEBWC8aUz1wVbxj2exq7n+yWEQyi8ryVw5x39THvSmpAipQJcw2D8gM/ZmQSDM5K88AAY1jLvgFWolFnyWyKYTs1HlK5pbaEEWtm6k9cGOlpNtS/XRiVm7pRvDfXJZ/uvrckZ4lPnuf/56+0cdfk9Js6cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749697; c=relaxed/simple;
	bh=izEADsHzyR8iduJXCqIDxFKQKX84iF/2u4YOp8D3Vgk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uYv8/3QqKvLwvLfKkg3juVMiwMaJERk/ib2pIpIe3NiPFDWlvKSWqC31/RiVeNyOoahDAUzP1UW3Tg+MLyS2XV8kwpVknI62tAo5Eg177F1zHYfXU4qsgznlq1tQ/GiCK2K+syYmU/vQQmmtL6YSk+1Bj35s9r7XO7CPWec8vYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HzJAud1H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HzJAud1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FDA1F00A3A;
	Mon,  7 Sep 2026 02:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749696;
	bh=8M58bagO90pkKmB5mm+7wbcw79tW0qyzl0xzGM5ODaY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HzJAud1HpPCwK0hpX6YSImlCzIknW8NSLwomSCmk6TIJpSDM7Rdi5Axx5VhpitrrN
	 rOF5OUZL7cmjrJls9dd/Wc8F1Z8sQw3GILaDqgKudHUPfrHkHJ+T1htap/jGc0661W
	 H1zlL+eZw+G5BSeteVz9LiXsIlRg2kEjH+kOaiN+cQ0Ch0eO4wWnT95R8UdUGLVVd2
	 W92+aKn1927rsJdVZM77WezwML/UwRvj9xBEsZS2xe8pplIxruUJZlUddWHBtHAu5Y
	 OVQyPqUvOfcjK42SwtoEslL84tVbkX+aJgDXdBhrx/YfggCPTb5rTHRd1cYe+YV87j
	 4JsNsuIv3nvuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 05/40] scsi: prepare for using 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-6-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:54:55 +0000
Message-Id: <20260907025455.91FDA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> In preparation for handling sense codes and their qualifiers as a single
> 16-bits sense code field, with the values  defined as macros in
> include/scsi/scsi_sense.h, modify the definition of the structures
> scsi_failure and scsi_sense_hdr to introduce a 16-bits sense_code field
> as a union with the existing 8-bits asc and ascq fields.
>=20
> This temporary modification allows accessing either the asc and ascq
> fields individually, or their combination as the 16-bits sense_code field.
>=20
> The helper functions scsi_sense_asc(), scsi_sense_ascq() are defined to
> allow accessing the 8-bits ASC and ASCQ values from the sense_code filed
> of struct scsi_sense_hdr. The helper functions scsi_failure_asc() and
> scsi_failure_ascq() provide the same for the sense code field of struct
> scsi_failure.
>=20
> The helper functions scsi_set_sense_buffer() and scsi_set_sense() are also
> added to wrap calls to scsi_build_sense_buffer() and scsi_build_sense()
> using a 16-bits sense code aregument instead of the 8-bits ASC and ASCQ
> arguments.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D5

