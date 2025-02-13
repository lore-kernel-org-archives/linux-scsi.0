Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DB2227E94
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 11:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739445892; cv=none; b=MIA3yQWQ+fX8hh/5YpEJT8T/JgdsMRYhzQpXdQI5szUon86PoyPL1K54mzkjUEKI9bKZZSy+GCzOe2NlS3fzgR/Q2haQ66KJdFLlYKED8IMoxXUIToKhOQfcgMuf3XoDjBKfmx0Q26wfCNC93DDZxT63rcuM3Hln85xfZdRFz+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739445892; c=relaxed/simple;
	bh=TrqZQ55skZTEXJEjUlXW0jtm/l2cPFM8QthEOGpqvUU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=U4MimxsyhLcszq9vaDuBHmJ3SE9G2Zbs0NZU5HmxcjBAK1dMMRVaeXO/gGVCHO+I2wlx8+HY695fpWUEpsI2Nvo2fbdKxVbByPcWpRCII4VsBh8GD12sp85uq2h5Clc0yL2mjtx8va9OZ/1Zxb/sQfZKbsBwr9D7UWOHISg3s4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kzck7Mel; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kzck7Mel"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739445886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GdHz7WZoxJQP/6i9ahhNRirmtERVrbghz+wuhiC82JQ=;
	b=kzck7MelYDJxOSs2OcrmS9Gs1IT+TP/TVAqwA5gr/i2VAyNgkmCa0yGDpk18rPkp6namMf
	8CRlgv6XYKf8LyGjjTx1NaTfc9Pe7yjYx8MT/jeQeZye6SWntn3cgHf5gjGDkvwImMbD/g
	qAfaHzMcf4oERyXNWwvhuHQ35TCtvNQ=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.1\))
Subject: Re: [PATCH] scsi: hpsa: Replace deprecated strncpy() with strscpy()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <20250212222214.86110-2-thorsten.blum@linux.dev>
Date: Thu, 13 Feb 2025 12:24:33 +0100
Cc: linux-hardening@vger.kernel.org,
 Bart Van Assche <bvanassche@acm.org>,
 storagedev@microchip.com,
 linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <34BB4FDE-062D-4C1B-B246-86CB55F631B8@linux.dev>
References: <20250212222214.86110-2-thorsten.blum@linux.dev>
To: Don Brace <don.brace@microchip.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
X-Migadu-Flow: FLOW_OUT

On 12. Feb 2025, at 23:22, Thorsten Blum wrote:
> strncpy() is deprecated for NUL-terminated destination buffers [1]. =
Use
> strscpy() instead and remove the manual NUL-termination.
>=20
> Use min() to simplify the size calculation.
>=20
> Compile-tested only.
>=20
> Link: =
https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-=
nul-terminated-strings [1]
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/hpsa.c | 10 ++++------
> 1 file changed, 4 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 84d8de07b7ae..9399e101f150 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -460,9 +460,8 @@ static ssize_t =
host_store_hp_ssd_smart_path_status(struct device *dev,
>=20
> 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> 		return -EACCES;
> -	len =3D count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> -	strncpy(tmpbuf, buf, len);
> -	tmpbuf[len] =3D '\0';
> +	len =3D min(count, sizeof(tmpbuf) - 1);
> +	strscpy(tmpbuf, buf, len);

With strscpy() it should probably just be sizeof(tmpbuf) without -1, and
then add +1 to count for the number of copied bytes to be the same as
with strncpy().

Like this:

	len =3D min(count + 1, sizeof(tmpbuf));

This subtle difference between strncpy() and strscpy() regarding the
number of bytes copied isn't really documented anywhere, is it? The
documentation I came across so far seems to focus mostly on the
different return values of the two functions.

> 	if (sscanf(tmpbuf, "%d", &status) !=3D 1)
> 		return -EINVAL;
> 	h =3D shost_to_hba(shost);
> @@ -484,9 +483,8 @@ static ssize_t =
host_store_raid_offload_debug(struct device *dev,
>=20
> 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> 		return -EACCES;
> -	len =3D count > sizeof(tmpbuf) - 1 ? sizeof(tmpbuf) - 1 : count;
> -	strncpy(tmpbuf, buf, len);
> -	tmpbuf[len] =3D '\0';
> +	len =3D min(count, sizeof(tmpbuf) - 1);
> +	strscpy(tmpbuf, buf, len);

Same here.

> 	if (sscanf(tmpbuf, "%d", &debug_level) !=3D 1)
> 		return -EINVAL;
> 	if (debug_level < 0)

Maybe someone can confirm my reasoning before I submit a v2?

Thanks,
Thorsten

