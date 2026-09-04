Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB3B377AA6
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 12:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524819; cv=none; b=JizdT9rOB2UTVHxu69k6cptw6q8gnpQZDF/5PJ5E+4yZFFEql35RyxgzPjJl97fK3u+DXnWNbmchcCyEzzizlQipQcUFZ595elS8+x7zKrTPJPm9feFuOYlFCDo7pEAlCuXM8PVfbRWz/KNyLIjqPOXtj/3y51x+9cs9TRG6ohA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524819; c=relaxed/simple;
	bh=bAAS9jjN1AOXrTI+1mZk7gz59YP5It5Y11fzK3qjd8s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DlOsXSgev54w666/yud8KtGb1vbJt4x465rdjbKBw7fZgvoLRe6jVyl5pIFRJhYJi2hYuApMompD0yWQLWD8zbVTlZSUJp2TZlpPeG5dtenlPkZPpwIySZVp13I75Zq1rgHbZl8KxgomaKKYnorgcnLch22uMIoWUmFzmznnVIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AScDjjMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AScDjjMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6B41F00A3D;
	Fri,  4 Sep 2026 12:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788524817;
	bh=QR6K4j7sVPwtUJKnZCCmL8FeL0faBOBXtAITITjfGlc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AScDjjMgpc992zmq+T6+famHEG+e8jjn0I0RxrNEl42RRly+QxsgFcSoqjcx7ZAhP
	 Che/pYaQg9RfhpY3lgoR8JNl4FHCAOdlFqUTqjaw8yWON3Yi/B9e7aIIKMt9jIFc52
	 sLOv46dyP/N2bB1bwgy/4d0GGrBj6cFX6DqDc2n5wYfOa02nG7YjkQdtrQY2XjG9is
	 VAw2S1Myodwf0ycmZm33kyPI3mE14Bks83Aj/FyR9Eju1tj2TtW0xJmKD5Iqqa0Ews
	 hPFlz7TDcq4SP/MLJlfcMJzatiHHkb4k9eAaaDwXiCr78rxq4WCa8cZjWmM2XzmkSz
	 81ZeSWB8AkZ6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: fix typos in comments
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hemanth Selam" <hemanth.selam@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260904121449.24178-2-hemanth.selam@gmail.com>
References: <20260904121449.24178-1-hemanth.selam@gmail.com>
 <20260904121449.24178-2-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:26:56 +0000
Message-Id: <20260904122657.3B6B41F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Double completion and use-after-free race between normal I/O compl=
etion and abort timeout.
--

commit 557225524672ba2157c18527e3000f5d88170125
Author: Hemanth Selam <hemanth.selam@gmail.com>
Subject: scsi: fix typos in comments

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/cs=
io_scsi.c
> index 0114e70e98844..ff924be3ecbb9 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
[ ... ]
> @@ -1968,7 +1968,7 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
> =20
>  	wait_for_completion_timeout(&ioreq->cmplobj, msecs_to_jiffies(tmo));
> =20
> -	/* FW didnt respond to abort within our timeout */
> +	/* FW didn't respond to abort within our timeout */
>  	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) =3D=3D cmnd) {

[Severity: High]
This is a pre-existing issue, but it appears there might be a race condition
between normal io completion and the abort timeout here.

Looking at csio_eh_abort_handler() in drivers/scsi/csiostor/csio_scsi.c aro=
und
line 1968, the driver waits for an abort response via
wait_for_completion_timeout(). If this times out, it locklessly checks if
csio_scsi_cmnd(ioreq) =3D=3D cmnd.

Concurrently, if the firmware completes the original io, the interrupt
handler calls csio_scsi_err_handler(), which unmaps the dma and completes t=
he
command:

drivers/scsi/csiostor/csio_scsi.c:csio_scsi_err_handler() {
        ...
        scsi_done(cmnd);

        /* Wake up waiting threads */
        csio_scsi_cmnd(req) =3D NULL;
        complete(&req->cmplobj);
}

If the abort handler's lockless read occurs between the scsi_done(cmnd) call
and the pointer assignment csio_scsi_cmnd(req) =3D NULL, could it mistakenly
observe that the command has not been completed yet?

This sequence would cause csio_eh_abort_handler() to proceed into its timeo=
ut
recovery path and execute a second completion on the potentially already fr=
eed
command.

> =20
>  		csio_err(hw, "Abort timed out -- req: %p\n", ioreq);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904121449.2417=
8-1-hemanth.selam@gmail.com?part=3D1
