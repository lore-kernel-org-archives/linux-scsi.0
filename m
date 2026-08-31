Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46F22C0294
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 20:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788206711; cv=none; b=RKIDUpbYDZiqiDeK14G27dHU1RXfBXsQk8NGAybroVRik6hFQoB6kGjlDxeJwszw+J+YW522QGmSTCrNI3OzZMYPgsdofatpk/bANjXDzw5sQgelpbPcM34ob6gAlkNdVJ6pbxGNYPO1iEk79bOY/bTIC0XhlIQ7saDW5MR/FDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788206711; c=relaxed/simple;
	bh=Lm3im486UpHBD+yADKOaoYzr2+bP9M+hx2YfOKWqbW0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EVUmlnDxv+T2c85lLm3Drz6O8UaSFk55Wd9xx7U1AnmUFWbRYtRQ7RBVnfjeytajiJj6uLDlLVkLKFpDsi/nutyhVCF/6bcWw65UA+pOShYQEMHeAiJrbj0d+vuYFONZP6kw3YMo+rld8nNq16gyhIvASXwFHCIjcaSS45ioQlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3jFJOV5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3jFJOV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FDF1F00A3D;
	Mon, 31 Aug 2026 20:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788206710;
	bh=MsFkc3lt+06EJm1sYK+SruqvaodVyEtK6N/TynSFfcc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y3jFJOV5v58iHcjzZoF7UhsYpFb3NsmbOUNgToBHUDwWwrrklQI3BheOSB0GrqRcY
	 g0WTvO17QpbtZTD5Ff9h+xyrVTg53h5X7tQi+4Jbvq56EoLNON83xrM4RfEVA5OANA
	 CjqvZHlCB58ZrjTPYRft7FVWm0RWeT5UAhdukTZeToRchhk9svEJ6Cnh6WDQfVxJFh
	 MnAGhFUxSr/poLW9ftegbWVJgfUqC2smfmOVV21XnlIhEE5SQLjUgKxWcUfa1dZCSH
	 tZnBmLqleJNWwXEjFtM4+syHo1uiGDGd2QW+vWY4hZtR5otfzFfx7qlRRjGim5+1Bq
	 rf3B3kUFwrLVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] scsi: core: Add KUnit tests for scsi_logging.c
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <ae3eb010e5f6b4451c6e18cae3ae152d45fe2d95.1788198780.git.bvanassche@acm.org>
References: <cover.1788198780.git.bvanassche@acm.org>
 <ae3eb010e5f6b4451c6e18cae3ae152d45fe2d95.1788198780.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 20:05:09 +0000
Message-Id: <20260831200510.19FDF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] Data race and out-of-bounds memory write in SCSI logging test ca=
pture.
- [Medium] NULL pointer dereference due to a TOCTOU data race on the global=
 `scsi_logging_test_dev_printk` pointer.
- [Low] Global suppression of actual SCSI system logs during KUnit test exe=
cution.
--

commit 33967e88f5091c2f971d2edac33840afe7e6e925
Author: Bart Van Assche <bvanassche@acm.org>
   =20
scsi: core: Add KUnit tests for scsi_logging.c
   =20
This commit introduces KUnit tests for SCSI logging functions by
intercepting dev_printk() when CONFIG_SCSI_LOGGING_KUNIT_TEST is enabled.
It captures log outputs into a buffer to verify standard and formatted
SCSI command outputs.

> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
> index 3cd0d30740855..3bff4dea4c6ac 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -15,6 +15,32 @@
>  #include <scsi/scsi_eh.h>
>  #include <scsi/scsi_dbg.h>
> =20
> +#if IS_ENABLED(CONFIG_SCSI_LOGGING_KUNIT_TEST)
> +static void (*scsi_logging_test_dev_printk)(const char *level,
> +					    const struct device *dev,
> +					    const char *fmt, va_list args);
> +
> +static void scsi_logging_dev_printk(const char *level, const struct devi=
ce *dev,
> +				    const char *fmt, ...)
> +{
> +	va_list args;
> +
> +	va_start(args, fmt);
> +	if (unlikely(scsi_logging_test_dev_printk)) {
> +		scsi_logging_test_dev_printk(level, dev, fmt, args);

[Severity: Medium]
Could this result in a NULL pointer dereference? The global pointer
scsi_logging_test_dev_printk is checked for truthiness and then invoked
without synchronization or READ_ONCE(). If a background SCSI event triggers
a log concurrently with the test teardown in scsi_logging_test_exit()
(which clears the pointer), a race window exists where the pointer might be
evaluated as non-NULL but cleared before invocation.

> +	} else {
> +		struct va_format vaf =3D { .fmt =3D fmt, .va =3D &args };
> +
> +		_dev_printk(level, dev, "%pV", &vaf);
> +	}

[Severity: Low]
Does this branch inadvertently suppress all actual SCSI system logs during
the test execution? Because the hook intercepts all dev_printk() calls in
scsi_logging.c and doesn't filter for the test-specific dev structure,
background hardware logs might be swallowed while the test is running.

> +	va_end(args);
> +}

[ ... ]

> diff --git a/drivers/scsi/scsi_logging_test.c b/drivers/scsi/scsi_logging=
_test.c
> new file mode 100644
> index 0000000000000..1dcebc383052a
> --- /dev/null
> +++ b/drivers/scsi/scsi_logging_test.c
> @@ -0,0 +1,422 @@
[ ... ]
> +static struct captured_dev_printk captured_logs[MAX_CAPTURED_LINES];
> +static int captured_count;
> +
> +static void test_capture_dev_printk(const char *level, const struct devi=
ce *dev,
> +				    const char *fmt, va_list args)
> +{
> +	if (captured_count < MAX_CAPTURED_LINES) {
> +		captured_logs[captured_count].level =3D level;
> +		captured_logs[captured_count].dev =3D dev;

[Severity: Medium]
Is there a risk of an out-of-bounds memory write here if background SCSI
events occur concurrently? The bounds check on the shared captured_count
variable is made locklessly, creating a TOCTOU race window. Multiple
threads or an interrupt on the same CPU could evaluate the bounds check
simultaneously and then proceed to write into the array.

> +		vscnprintf(captured_logs[captured_count].msg,
> +			   sizeof(captured_logs[captured_count].msg), fmt,
> +			   args);
> +		captured_count++;

[Severity: Medium]
This increment further contributes to the race, as concurrent executions
would increment captured_count beyond MAX_CAPTURED_LINES after writing out
of bounds.

> +	}
> +}
> +
> +static void scsi_logging_test_reset(void)
> +{
> +	captured_count =3D 0;
> +	memset(captured_logs, 0, sizeof(captured_logs));
> +}
> +
> +static int scsi_logging_test_init(struct kunit *test)
> +{
> +	scsi_logging_test_reset();
> +	scsi_logging_test_dev_printk =3D test_capture_dev_printk;
> +	return 0;
> +}
> +
> +static void scsi_logging_test_exit(struct kunit *test)
> +{
> +	scsi_logging_test_dev_printk =3D NULL;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1788198780.gi=
t.bvanassche@acm.org?part=3D1
