Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6CE1531C8
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673967; cv=none; b=U2sYFYbiVHkocIZXp7fjHZj5+GOa6MpWXeylJdUDHFY1D9Fsp4oeYWM7M4AY7vp722DRyWxDwkBy+eyXumep9PtDc4H9AtbTvtbO/Fm86+q2wAEpF66dxJLY9yBOuzdAOTS9Unt35AGctaszL0XNr/JXlLTiJ87xo3cJVS/a4LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673967; c=relaxed/simple;
	bh=Tef8ehv176eNiia/g18t84XHszz4M+tUcLlhMIJ8Ot8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JuKC0GvUqFFclgk9RBccvIlFjZLsUQL0MiJgGkjUQy9b84Nh9NDIjo+4td7j/Et5xy9VWQzZyyEGEjNJGd7PY/5qIFqA2kE2Bgl+LxOELWueVLS9xl+Fzsr/NWJsOvUJtiqLe1hcZc95iI0hzvUe8Xq5ppyuvuB2AFHo0gycJJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jF+zi4yY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jF+zi4yY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEC01F000E9;
	Tue, 25 Aug 2026 16:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673965;
	bh=qolEghv5YgZnhYsk+fJKTD+F+EG3rDbBE/FuxnxMlto=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jF+zi4yYFalXy4ReEdOa1RXAfNNC6dOEnsFghFQuNE9FTzEb6infI0s0ez/CA4ja8
	 pG9p0M7Hl8jEKmme1SvfJn998287Cy5TgqDe1CMMQPWEiR+4AiUC4ujahXA2emKO0D
	 5ZujhdqPuNwZqOPchuqCqeXmsxm2kxgaAGVSCPGQjPwyXYPuaASIfogiK4OpOxgNGy
	 h8WWCQeM8z5og0XMLwtPWUL1vEv9+462+trvZBQgISZP44IprWnmgd5uONvZkjHlw6
	 7HKzorEIG2K+yjsMdfvh4rY+c5xoB+J74JZz8VwhVAU1NPicPulTGPvztj46rjcjfE
	 88yPXe+G4zeOA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/17] mpi3mr: Fix out-of-bounds read of event data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-12-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-12-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:06:05 +0000
Message-Id: <20260825160605.8CEC01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Heap out-of-bounds read in bottom-half topology handlers due to ne=
wly clamped allocation size without clamped logical array counts.

Pre-existing issues:
- [High] MPI3_EVENT_DEVICE_INFO_CHANGED events are erroneously processed as=
 log data and entirely bypass bottom-half processing.
- [High] Incomplete fix leaves DMA buffer out-of-bounds reads unpatched in =
top-half topology event handlers.
- [High] Bottom-half event handlers risk out-of-bounds slab reads by blindl=
y casting event data without checking length.
--

commit bbda3bacb81906126bd46f33bc2d5656197ac85e
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix out-of-bounds read of event data

This commit restricts the size of event data read from the reply buffer to
prevent reading past the end of the frame when caching log data or allocati=
ng
the buffer for bottom-half event processing.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 6a80b784200b3..65a6192cf3960 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c

[ ... ]

> @@ -3179,7 +3179,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mr=
ioc,
>  	case MPI3_EVENT_DEVICE_INFO_CHANGED:
>  	case MPI3_EVENT_LOG_DATA:

[Severity: High]
This is a pre-existing issue, but is it intentional that
MPI3_EVENT_DEVICE_INFO_CHANGED falls through to MPI3_EVENT_LOG_DATA?

When this happens, the payload is passed to mpi3mr_app_save_logdata_th()
and process_evt_bh is not set to 1. This appears to cause the bottom-half
event to never be scheduled, and might overwrite firmware log buffers with
unrelated device information page data.

> -		sz =3D event_reply->event_data_length * 4;
> +		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, e=
vent_data))
> +			avail_reply_room =3D mrioc->reply_sz -
> +			    offsetof(struct mpi3_event_notification_reply, event_data);
> +		else
> +			avail_reply_room =3D 0;
> +		sz =3D min_t(u16, event_reply->event_data_length * 4, avail_reply_room=
);
>  		mpi3mr_app_save_logdata_th(mrioc,
>  			(char *)event_reply->event_data, sz);
>  		break;

[Severity: High]
This is a pre-existing issue, but while this fixes the buffer copy size
here, does it leave out-of-bounds reads unpatched in the top-half topology
event handlers?

In mpi3mr_pcietopochg_evt_th(), the bounds checking still uses the
unclamped firmware-provided length directly:

avail_len =3D event_reply->event_data_length * 4;
...
max_entries =3D (avail_len - ...) / sizeof(...);

If the event_data_length provided by firmware is larger than the physical
DMA reply frame size, could this lead to reading out of bounds directly
from the DMA mapping during the top-half processing loop?

[ ... ]

> @@ -3213,7 +3218,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mr=
ioc,
>  		dprint_event_th(mrioc,
>  		    "scheduling bottom half handler for event(0x%02x) - (0x%08x), ack_=
required=3D%d\n",
>  		    evt_type, le32_to_cpu(event_reply->event_context), ack_req);
> -		sz =3D event_reply->event_data_length * 4;
> +		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, e=
vent_data))
> +			avail_reply_room =3D mrioc->reply_sz -
> +			    offsetof(struct mpi3_event_notification_reply, event_data);
> +		else
> +			avail_reply_room =3D 0;
> +		sz =3D min_t(u16, event_reply->event_data_length * 4, avail_reply_room=
);

[Severity: High]
Since this patch restricts the allocated size of the heap buffer fwevt by
clamping it to avail_reply_room, could this cause an out-of-bounds read in
the bottom-half handler?

For instance, in mpi3mr_sastopochg_evt_bh(), the loop iterates up to the
unclamped num_entries from the payload. If the allocation was truncated,
iterating up to the original unvalidated num_entries could read past the
end of the newly clamped fwevt heap allocation.

[Severity: High]
This is a pre-existing issue, but could truncating the event data size
cause out-of-bounds slab reads later if the buffer size is exceptionally
small?

If the clamped sz ends up being extremely small or zero, the bottom-half
handlers like mpi3mr_fwevt_bh() blindly cast fwevt->event_data to
fixed-size structures such as struct mpi3_device_page0 and access fields
like persistent_id. Should there be a minimum size check before accessing
these fields in the bottom half?

>  		fwevt =3D mpi3mr_alloc_fwevt(sz);
>  		if (!fwevt) {
>  			dprint_event_th(mrioc,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D11
