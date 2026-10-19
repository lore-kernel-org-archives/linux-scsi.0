Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFC84E06CA
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416699; cv=none; b=h9CMPouZbCVwswETqydp4JSsvrWi1RNEAo5alCbuMUpWqyxHTqXLdRxh5E6paptkEQ66LSLdec1FVtHwxdXrLe2yGcR072qcXufleE7VrjFyMj1hcQYiH3sa4chwOkvEcmnpj63RyPDre+RAbPM2FwaLC+Ng8fIoCEsrEQPAVko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416699; c=relaxed/simple;
	bh=PpnDZ9ag5A3oHUijStCX9luWVHDBDvlhGLnh75xBn2Y=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=WMiwBo7yw0xOTg3y+Tu4WL5wS/AH/uCPcEtP50bOqBXA0SOWsR4Yq+eZJEobejJcftab8P2l1eYOv8Y85hv2ae1fvUWQ6G0//3RGUT1tbyZY0FZjwyRGfhPLUHeKg4MBdkQNGd0UkJXkp6VGgWu95aUthqi24K2I0ehmtac3foY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0bwWVgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0bwWVgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177E51F000C4;
	Mon, 19 Oct 2026 13:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792416698;
	bh=UkHsw84KjCl9jLMuax71DgdbHlf/SlCGof2AXUsEAvM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A0bwWVgJ1GB+P1jrAyUe2eSx81+H+2SVA8kDl28KAuIn4INFUmimXFhTbmqPNNM0i
	 Cfz4uYGpJXoxKnwi6kZLqVMuvWAxxykrNLpiWqbsE9xddSgOTRO4GJGUYsDluinm66
	 76X8POxWdpXwYBh07vRUpXDQC7SQHqDf5ceYiScoDNd6jGAktVI1E5XBZGUtT/9F8+
	 ZyVFTAglJIk+En84m9yH1w8JWVkGp7oiskU6irxmwX5hC7oOtALlcdD8j5kcPLR5cl
	 ZdNdcOlB68SWWLA+9ANWxpnpaZJ2PABmBDiIjKr/tyubtZm5AEKChZh88hcgzizsUv
	 g5uAU/dCvk8Bg==
Message-ID: <sashiko-outbox-177159@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: fnic: use scnprintf in fnic_get_debug_info()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haoran Wang" <haoranwangsec@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <179241615575.5916.9521598583158892732@whr>
References: <179241615575.5916.9521598583158892732@whr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 13:31:37 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: fnic: cumulative return in fnic_get_debug_info() causes OOB =
read
--

commit 6c596234ba5fa29d815cf93a8c722b4691009e37
Author: Haoran Wang <haoranwangsec@gmail.com>

scsi: fnic: use scnprintf in fnic_get_debug_info()

This commit replaces snprintf() with scnprintf() in fnic_get_debug_info()
to prevent buffer overflow and out-of-bounds reads when formatting fnic
debugfs statistics.

> diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trac=
e.c
> index a3f583703664d..7eeb9c8b8999f 100644
> --- a/drivers/scsi/fnic/fnic_trace.c
> +++ b/drivers/scsi/fnic/fnic_trace.c
> @@ -469,35 +469,35 @@ int fnic_get_debug_info(struct stats_debug_info *in=
fo, struct fnic *fnic)
>  	struct fnic_tport_s *tport, *next;
>  	unsigned long flags;
> =20
> -	len +=3D snprintf(info->debug_buffer + len, buf_size - len,
> +	len +=3D scnprintf(info->debug_buffer + len, buf_size - len,
>  					"------------------------------------------\n"
>  					"\t\t Debug Info\n"
>  					"------------------------------------------\n");

[ ... ]

> @@ -505,7 +505,7 @@ int fnic_get_debug_info(struct stats_debug_info *info=
, struct fnic *fnic)
> =20
>  	spin_lock_irqsave(&fnic->fnic_lock, flags);
>  	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
> -		len +=3D snprintf(info->debug_buffer + len, buf_size - len,
> +		len +=3D scnprintf(info->debug_buffer + len, buf_size - len,
>  		"tport fcid:0x%x state:%d flags:0x%x inflight:%d retry_counter:%d\n",
>  		tport->fcid, tport->state, tport->flags,
>  		atomic_read(&tport->in_flight),

[Severity: High]
Does debug->buffer_len still overflow debug->buf_size and trigger the
out-of-bounds read in simple_read_from_buffer() even after switching to
scnprintf()?

In drivers/scsi/fnic/fnic_trace.c, fnic_get_debug_info() initializes len
to the existing info->buffer_len and returns the cumulative offset len at
the end of the function:

drivers/scsi/fnic/fnic_trace.c:fnic_get_debug_info() {
	int buf_size =3D info->buf_size;
	int len =3D info->buffer_len;
	...
	return len;
}

However, in drivers/scsi/fnic/fnic_debugfs.c, fnic_stats_debugfs_open()
adds the return value of fnic_get_debug_info() to debug->buffer_len using
+=3D rather than assigning it directly:

drivers/scsi/fnic/fnic_debugfs.c:fnic_stats_debugfs_open() {
	...
	debug->buffer_len =3D fnic_get_stats_data(debug, fnic_stats);
	debug->buffer_len +=3D fnic_get_debug_info(debug, fnic);
}

Because fnic_get_debug_info() returns info->buffer_len plus the newly
appended bytes, using +=3D counts the length returned by
fnic_get_stats_data() twice. Since fnic_get_stats_data() already writes
more than 4 KB into the 2 * PAGE_SIZE vmalloc() buffer even when all
counters are zero, debug->buffer_len still exceeds debug->buf_size when
userspace opens the stats debugfs file (even with zero target ports).

When userspace subsequently reads the file through
fnic_stats_debugfs_read() -> simple_read_from_buffer(), won't passing this
inflated debug->buffer_len still read past the end of debug->debug_buffer?
Should fnic_get_debug_info() return len - info->buffer_len (or should
fnic_stats_debugfs_open() use =3D instead of +=3D)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179241615575.5916.9=
521598583158892732@whr?part=3D1
