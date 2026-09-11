Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29201434982
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 20:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789158202; cv=none; b=ofbcQgt+igp0exdrgjVTNmzQOmLakH6VY4SfQV6emXr2bFcbRYPvk6eSWV2CSjTYQFkktCCk0uwYTLQb1VpuzfoCRI+5iHeRqULP4WRFrATI8zuyj/BKXIM8X0upbwa+TI7cz1+WgnCQZXajz+Rsf5hbesO1nv6jddeOF6DE4XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789158202; c=relaxed/simple;
	bh=y8CI72ZyEWNNCKqwYZvxNxWIr7iB3IMHuOsoE9BVbt8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Smw/zUR1cTDfaxu+DLEuPJroFyWOA66l+OoslLbNvIZSIf4EZ/xXqVXKLsU0E8b1Kof3wlvYLzA1zfPfj/7p5FOPaI5os/BXHOVMqnknD1S1vvatV/rQiGi5I9O32imQYoqjI2+EyQQToSREqfc0yhlWwElNb9pkYE9XvXdvy5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JgMx9GSy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgMx9GSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559491F000FF;
	Fri, 11 Sep 2026 20:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789158197;
	bh=eE33nIOvAndIIrpZikrov8IHHjeEFNjcrftosOa7/do=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JgMx9GSyJ85X7OuX4FzsP4J+sd9axaagp/Ef8pVrcSyqoVfWGVBKloYjcnE4kJMer
	 seaZ+VKQUaPcEiaCvpBTBmUrqxdIbrJoVDLOTiVGXkFnYhBsDRA0/dSBf/WoSBGw/H
	 cnyFb7sohXe5ifLdVWTC072gC7f+AavSIr91VfKUoOOHxmvIw3yQgWsLw5ytL4O57B
	 17Uk9k/MQz2nygw2JzWiyUo1sHXbf7YdaT4JyuLIHWFoNjTi9SOL2ePNqoAhflfNDR
	 D/sv8jUfm26tAdoxHicUehXL6l2wlnsBeymXcm5SCrzWsrjWexGhP+8syXUHlj8lnE
	 yXJuRtVOf1O2w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: core: Make SCSI host scan interruptible
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <74786683eadc0a32ab335373ead8dd76a9d5a342.1789157339.git.bvanassche@acm.org>
References: <74786683eadc0a32ab335373ead8dd76a9d5a342.1789157339.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 20:23:16 +0000
Message-Id: <20260911202317.559491F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Non-fatal signals and TIF_NOTIFY_SIGNAL silently abort SCSI scans =
due to incorrect use of signal_pending() and mutex_lock_interruptible().

Pre-existing issues:
- [High] Transport-backed sysfs scans still sleep in TASK_UNINTERRUPTIBLE o=
n shost->scan_mutex.
--

commit 78930d642b0da5b5ffc8a1e28c1f7cf1e6e1e5b5
Author: Bart Van Assche <bvanassche@acm.org>

scsi: core: Make SCSI host scan interruptible

This commit modifies SCSI host scanning to use interruptible locking and
check for pending signals during scans. It aims to prevent hung task
warnings when tasks waiting on shost->scan_mutex receive fatal signals
like SIGKILL.

Link: https://syzkaller.appspot.com/bug?extid=3D1f678bd2872aefb11d8a

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 4a4f11d2c7798..3161aa1bc8dcd 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c

[ ... ]

> @@ -1591,6 +1595,9 @@ static int scsi_report_lun_scan(struct Scsi_Host *s=
host,
>  	 * the header, so start at 1 and go up to and including num_luns.
>  	 */
>  	for (lunp =3D &lun_data[1]; lunp <=3D &lun_data[num_luns]; lunp++) {
> +		if (signal_pending(current))
> +			break;
> +

[Severity: High]
Can this silently abort LUN scanning on non-fatal signals?

If a non-fatal signal (like SIGCHLD) or TIF_NOTIFY_SIGNAL (used by
io_uring or task work) is delivered to the thread performing the scan,
signal_pending() returns true. This causes the loop in
scsi_report_lun_scan() to break and return success, leaving devices
undiscovered without reporting an error.

>  		lun =3D scsilun_to_int(lunp);
> =20
>  		if (lun > sdev->host->max_lun) {

[ ... ]

> @@ -1913,23 +1926,30 @@ int scsi_scan_host_selected(struct Scsi_Host *sho=
st, unsigned int channel,
>  	    ((lun !=3D SCAN_WILD_CARD) && (lun >=3D shost->max_lun)))
>  		return -EINVAL;
> =20
> -	mutex_lock(&shost->scan_mutex);
> +	ret =3D mutex_lock_interruptible(&shost->scan_mutex);
> +	if (ret)
> +		return ret;
> +

[Severity: High]
Are we risking silent discovery failures by using mutex_lock_interruptible(=
)?

Since mutex_lock_interruptible() returns -EINTR on non-fatal signals,
it prematurely fails the scan lock acquisition.

Furthermore, do_scsi_scan_host() silently discards the -EINTR return value:

drivers/scsi/scsi_scan.c:do_scsi_scan_host() {
    ...
    scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
                            SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
    ...
}

Will this cause module loads to incorrectly succeed without discovering
attached devices if a non-fatal signal is pending during initialization?


[Severity: High]
This is a pre-existing issue, but transport-backed sysfs scans still seem
vulnerable to the original hung task issue this patch addresses.

Concurrent sysfs scans initiated by transport layers (FC, iSCSI, SAS) bypass
scsi_scan_host_selected() and block uninterruptibly in scsi_scan_target()
and __scsi_add_device():

drivers/scsi/scsi_scan.c:scsi_scan_target() {
    ...
    mutex_lock(&shost->scan_mutex);
    ...
}

Will tasks initiating these scans still exceed the hung task timeout if
fatal signals like SIGKILL are delivered while they wait on scan_mutex?

>  	if (!shost->async_scan)
>  		scsi_complete_async_scans();
> =20
> -	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) =3D=3D=
 0) {
> +	if (!signal_pending(current) && scsi_host_scan_allowed(shost) &&

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/74786683eadc0a32ab3=
35373ead8dd76a9d5a342.1789157339.git.bvanassche@acm.org?part=3D1
