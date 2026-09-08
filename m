Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF12509EF9;
	Tue,  8 Sep 2026 10:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863332; cv=none; b=HzqkvR3F5W0J6oZ8l+xoXJseO+Hq18xhtIQKLKxMZei9/MUrfaz5yHq8RQXfZJA1zakocJdpd0JJdUnDqVuTwGfeOcVtvdoX80B0SZhC6jpiBbg0cBMOz1hVIx3gmOSCaKGGUCicsnnXtzojdzuRLwsrVfeC56yLZUTzWxlPdkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863332; c=relaxed/simple;
	bh=GoX1dGqvtns6SuCfQ1wZxXg1aZruAWmaXdBB1zEmMH8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nRdPK9Jo3jkFRHU6vMSUgsm4L/dbNI6hi0aXMQg/ZSpb4lmJrClgRNzXIgfgnOTomXB3RsJAR7/kiZQV4kZCE6BxT7J6gmYeG6yF1TiQVrxHwZNUfpmCZefC8VHWkF8tUADxpYAOKhSmXbmAHCo/8D+w9mO6hL1zH53733TPjo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBB2olQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBB2olQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F401F00A3A;
	Tue,  8 Sep 2026 10:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788863330;
	bh=nBvqMQYKzwX1Dl+zFTcqzgCcc0SnF6947vWWjqprdF8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VBB2olQwP7ySDAS6E6o1L3f/Y1LcctFJwvLltbKfodvDZSgJWL1YAGi/xVeRKucr0
	 pdP6YqEjJK0xcu8go8ni6QsLkonDcm2Dx9cGsqMOsUj7wnByGTuCib14Tz6vFKlo7X
	 kMuteIhkxjip56DDCA19o4hStkrna/Wa9lap0hY7Fp55E5E0H6tgit6Wl6dPYTMlBA
	 f7MRuUiOla4kbj2ITiPYloz4TvKuQsIRhw7HaC3oMbcMQTNvXjEz7cJLMUQ19u+HVq
	 ugpCwBu3HALZ/CaGqi2QT5Govp96fH46KCPlTRQXochX4a3AHlboRt66mjAntizXos
	 V7uHs22COb7kQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 33/40] scsi: storvsc: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-34-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-34-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:28:49 +0000
Message-Id: <20260908102850.32F401F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-After-Free of handle_error_wq when queuing work during device =
removal
--

commit 35e07dc6633ea8d87cbeafdfe7c19ba41602369c
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: storvsc: use 16-bits defined sense codes

This commit refactors the storvsc driver to use the 16-bit sense_code field
of struct scsi_sense_hdr. It replaces hard-coded additional sense codes and
qualifiers with enum values from include/scsi/scsi_sense.h to improve code
clarity.

> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index ef3cd3bc7390e..625db97d1a03e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1016,7 +1016,7 @@ static int storvsc_channel_init(struct hv_device *d=
evice, bool is_fc)
>  static void storvsc_handle_error(struct vmscsi_request *vm_srb,
>  				struct scsi_cmnd *scmnd,
>  				struct Scsi_Host *host,
> -				u8 asc, u8 ascq)
> +				struct scsi_sense_hdr *sshdr)
>  {

[Severity: High]
This is a pre-existing issue, but is it possible for a use-after-free to
occur here if work is queued during device removal?

Looking at the teardown path:

storvsc_remove()
    ...
    destroy_workqueue(host_dev->handle_error_wq);
    scsi_remove_host(host);
    storvsc_dev_remove(dev);

The workqueue is destroyed before the VMBus channel is closed in
storvsc_dev_remove(). Because the channel remains active during this window,
could concurrent events trigger a queue_work() on the freed workqueue?

For example, if an outstanding I/O completes with an error while
scsi_remove_host() is waiting for commands to finish, it appears
storvsc_command_completion() will call storvsc_handle_error(), which then
queues work:

storvsc_handle_error()
    ...
do_work:
    ...
    queue_work(host_dev->handle_error_wq, &wrk->work);

Similarly, could an unsolicited VSTOR_OPERATION_REMOVE_DEVICE message
received from the host during this same window cause storvsc_on_receive()
to queue work on the freed handle_error_wq pointer?

>  	struct storvsc_scan_work *wrk;
>  	void (*process_err_fn)(struct work_struct *work);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D33
