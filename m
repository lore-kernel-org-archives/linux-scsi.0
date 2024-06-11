Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91296171070;
	Tue, 11 Jun 2024 08:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718095253; cv=none; b=mNeF7mp5wgIRMIrtmW2lawzxX+1PFh9qYROpdSgLa+S1K+/PjYv42mzWYELD5javkcHFQDlXusp5bl5AGnFgyLdDvplP9E7ms6GA+PhbXDnj4lwmeJnfs+GrLsOgQObfpUa69iglmkTHK9hXG++Z70ztV1c4gH9UA8q+93SHBdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718095253; c=relaxed/simple;
	bh=3RHFDRFQ2fBe11TJd37EQZmdJ2dcrT7TBQWPPzeHKiQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8X8e7xty1XDiWiwV/rd6bl192QmlXBA6k8zI94B3XKeS1ue2XYi/m+KeFD45pIa3gl8phOANKx4xNpoGZCnIDEgvIIXqMpoYZzYTL7B2efktNVUlAqIDa4NJuyTMcV9ibDKEXoCW/KFD4Lv5ZJx2/SdihS734v8h8hn36aN8MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmziEpvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmziEpvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9DAC2BD10;
	Tue, 11 Jun 2024 08:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718095253;
	bh=3RHFDRFQ2fBe11TJd37EQZmdJ2dcrT7TBQWPPzeHKiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dmziEpvVoBiTc6obitVD6iaEUXpJ9QyIi6DS8GzorQC8IhhmpGbJXJTNO9clOOdGl
	 B9Ry9d7h6yFRcRXSyQ9FPXFonA5GoTVxgWN9FOCaj7ZtdUF921V5cJgNb4unJ7LrrN
	 1XPNEHYrnrvjH5PJkqpnZW912nFXf0lNeCHIPZjziGcUTkp6GVyMNBzjrkYp1ySnu7
	 dMZxjS4S6113ywdEPr5vL6ZJkimtlIpJDqAl6GxwhR64ON9GvPwL+7i2cVIvGIH5IU
	 CjT23fcVCMuou1K1yl98dwYI5Gfiu0H5oUkh1fML4jNp5DYLd6dyTXUMWat6HnnDpp
	 kXjMeZh2LX15Q==
Date: Tue, 11 Jun 2024 10:40:48 +0200
From: Niklas Cassel <cassel@kernel.org>
To: TJ Adams <tadamsjr@google.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH 2/3] scsi: pm80xx: Do not issue hard reset before NCQ EH
Message-ID: <ZmgNkK8haUisJ5-b@ryzen.lan>
References: <20240607175743.3986625-1-tadamsjr@google.com>
 <20240607175743.3986625-3-tadamsjr@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607175743.3986625-3-tadamsjr@google.com>

Hello Igor, TJ,

On Fri, Jun 07, 2024 at 05:57:42PM +0000, TJ Adams wrote:
> From: Igor Pylypiv <ipylypiv@google.com>
> 
> v6.2 commit 811be570a9a8 ("scsi: pm8001: Use sas_ata_device_link_abort()

Do not specify kernel version (it is irrelevant), SHA1 is enough.


> to handle NCQ errors") removed duplicate NCQ EH from the pm80xx driver
> and started relying on libata to handle the NCQ errors. The PM8006
> controller has a special EH sequence that was added in v4.15 commit
> 869ddbdcae3b ("scsi: pm80xx: corrected SATA abort handling sequence.").

Do not specify kernel version (it is irrelevant), SHA1 is enough.

Since the code added in 869ddbdcae3b still exists in the pm80xx driver,
I think that you should mention the commits in chronological order.
(Right now you mention the oldest still existing code last, which seems
a bit backwards.)


> The special EH sequence issues a hard reset to a drive before libata EH
> has a chance to read the NCQ log page. Libata EH gets confused by empty
> NCQ log page which results in HSM violation. The failed command gets
> retried a few times and each time fails with the same HSM violation.
> Finally, libata decides to disable NCQ due to subsequent HSM vioaltions.

s/vioaltions/violations/

I'm not an expert in libsas EH, but I think that your commit message fails
to explain why this change actually fixes anything. You do not mention the
relationship between the code that you add pm8001_work_fn() and the
existing code in pm8001_abort_task(), and the order in which the functions
get executed.

Does calling sas_execute_internal_abort_dev() from pm8001_work_fn() ensure
that the libsas EH is never invoked? Or does it cancel the hard reset that
is part of the "special EH sequence" in pm8001_abort_task() ?

Wouldn't it be better if this was fixed in pm8001_abort_task() or similar
instead? It appears that the code you add to pm8001_work_fn() (that has a
very ugly if (pm8006)) is only there to undo or avoid the hard reset that
is done in pm8001_abort_task() (which also has a very ugly if (pm8006)).

Now we have this ugly if (pm8006) in two different functions... which
makes my "this could be solved in a nicer way" detector go off.

If this patch (as is) is really the way to go, then I think there should
be a more detailed reasoning why this change is the most sensible one.


Kind regards,
Niklas
