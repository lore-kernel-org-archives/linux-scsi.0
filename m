Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868033E2777
	for <linux-scsi@vger.kernel.org>; Sun,  4 Oct 2026 03:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791086153; cv=none; b=OkZVif5O2igdCPwrHSWC4eqUnfvhmt23STPHvEbzhSakYo9niE/pv/jWnaPnkHuXux9FODy32J4hB8PE+v1vvbFPlxjE0hJyqmqRvpw31bjdvrRINOARylo3t9CZZLvl25Q2RwVNgbc8fgq5KJjYI0RwMpj4QDBOArf/kAfqXKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791086153; c=relaxed/simple;
	bh=bEh7g7qfH8EO2NrQm9bS6os2OGPbOmCHho4ayhW8QqE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=obmB0KfFIe8RnQ42EPXlEoRd8OKwLKiGe8oI7SzxzpaIp0Wm0TJatDl0FKQiI2R9mktLQkNaJsm9D0Gv2Ad5JU8pQz/TcHHgEPRk8jG2gYaBfzM9MVT3+lm/pl9dbP5aLX6jJukIpIk+qhFofik7EfXQ+rbUcPAskWXzmz8kerg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+aX06Us; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+aX06Us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D799C1F0089B;
	Sun,  4 Oct 2026 03:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791086152;
	bh=/9xkjxxNFojWKJSvmeOaLPpPQXSASy2uCoMLWFj/q9k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T+aX06UsxIgCaxuka7bb77sWj0n2+5tbTZv8VKB4anMEhHaMkJDAArYkfa15bgFf/
	 QlOoluQCkPHXN3Ju7fhbguD67NTwDJGiojOJzo8wOhVqSJ08NnFGPE/glSrVITR9+O
	 9aNUGlsXL5pns2Xy+SyIwGvZvaLBVdIRpeVd05sdVtQcPd/PY29ZJG8PjvQaOlt43k
	 0pMvTcS8B2UnX9wtPWEcD75puLLTmP97fwF5kfJdSJ+2bg+Eo749ruij6UI+JzLxQU
	 lEPaa6puafPIKgUsiCKi1A/aE6fEQvxHVkfiJUIvzXFHtNsQQ++tVs3kkbjLLLXVqy
	 mg0/2f7ylVT/Q==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 3/3] scsi: lpfc: Add KUnit tests for mailbox wait
 ownership
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Dinaburg" <artem@trailofbits.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <72eb0bf397cb0cd72a0fbc75a05f0be93c65bfaa.1790968549.git.artem@trailofbits.com>
References: <cover.1790968549.git.artem@trailofbits.com>
 <72eb0bf397cb0cd72a0fbc75a05f0be93c65bfaa.1790968549.git.artem@trailofbits.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 04 Oct 2026 03:55:51 +0000
Message-Id: <20261004035551.D799C1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: lpfc: missing -I$(src) in Makefile causes test build failure
--

commit 58bda9d071979b03b73e5787531c133618f4a219
Author: Artem Dinaburg <artem@trailofbits.com>

scsi: lpfc: Add KUnit tests for mailbox wait ownership

This commit adds KUnit tests for synchronous LPFC mailbox wait and
completion ownership. It replaces the mailbox issue callback to exercise
behavior without physical LPFC hardware and checks various error and
timeout scenarios.

> diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
> index bbd1faf41e806..d2b1f0990b7d7 100644
> --- a/drivers/scsi/lpfc/Makefile
> +++ b/drivers/scsi/lpfc/Makefile
> @@ -34,3 +34,5 @@ lpfc-objs :=3D lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els=
.o \
>  	lpfc_hbadisc.o	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o   \
>  	lpfc_scsi.o lpfc_attr.o lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o \
>  	lpfc_nvme.o lpfc_nvmet.o lpfc_vmid.o
> +
> +lpfc-$(CONFIG_LPFC_MBOX_KUNIT_TEST) +=3D tests/mbox_kunit.o

[Severity: Low]
Will this cause a build failure when compiling in-tree with
CONFIG_LPFC_MBOX_KUNIT_TEST=3Dy? The Makefile appends the test object to
lpfc-y, but does not appear to add ccflags-y +=3D -I$(src) to allow the
subdirectory to find the parent headers.

> diff --git a/drivers/scsi/lpfc/tests/mbox_kunit.c b/drivers/scsi/lpfc/tes=
ts/mbox_kunit.c
> new file mode 100644
> index 0000000000000..2bdc2d5fcadaf
> --- /dev/null
> +++ b/drivers/scsi/lpfc/tests/mbox_kunit.c
[ ... ]
> +#include <scsi/scsi_transport_fc.h>
> +
> +#include "lpfc_hw4.h"
> +#include "lpfc_hw.h"
> +#include "lpfc_sli.h"
> +#include "lpfc_sli4.h"

[Severity: Low]
Since these includes use paths relative to the parent directory but lack the
../ prefix, don't they rely on an explicit -I directive in the Makefile to
compile correctly? Without it, the compiler will look in the tests directory
first and fail with a missing file error.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790968549.gi=
t.artem@trailofbits.com?part=3D3
