Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E39E42AA9
	for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 04:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791691947; cv=none; b=hUc0VCjqufOIrKucz9oFZkyv2kKwdW4UlNDLjHYsnNY5EKbhznRZzDWCj1fxJICbZrq20XagXZ/tB2Yt6lUMW5J7LAkJZOwqIvsSqYKE1bYjbaldXhRD+4+XAfTo7QeyrE/PXzWRccozJvXLOE1UJUjwByxdslUOE9m97q3tqno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791691947; c=relaxed/simple;
	bh=V9Qin+eO8afUIoV/Bg7PqB7Svl0JGgp+z+yw6P1Hq9Y=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rA2mx+8u8adXObUaJ0Iybm55St/HsWT2lkauP/gtzyEprDT+3wjuiH51CTL469s4a4021llAwSBZutiFDIhRr2dACHSEY0utfYk7QOjzRgBv9UT8u8CLJiJ8mQzOX99Er5oj2f3TwKSxXGVpMcL+ljT4B/MxOPm8nk8ThfQYgGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WWaPFhAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WWaPFhAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E5D1F000FF;
	Sun, 11 Oct 2026 04:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791691945;
	bh=+Rf1obhm4IdEzAU/KsPT2aieecdD8Xgoux7ioLw6DxA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WWaPFhABrGmKxljpGqKg+9itRcKRgIquN0/d6WyeG5oGol+Usg61eAmgOr+eQuzAl
	 63gT3WvqrMmcra3RpLAXb5OgOqnCb4uNPoR1JOdSBsf/YPfzNcNmwA9Rjog9XjlOA5
	 zw+9JqXS2TPtXCuHrqkhQlGCN5TJnNvvoppZPrvldu+ohWy+ZCTF1iKAOlO1/pwpmL
	 Qtw+7dTpxOvHVvqcPmeQCw5ndhSqo5f7cde66h+O6cVFpAkNWQEtTAOIeN097kqP8B
	 k/Au3hONLJwIwWympDwgzBD12QTVTb0nGo10IDAfXaUMUEP8lB9ad8a+JcAWvotfDL
	 v+4QfgmmGqO6w==
Message-ID: <sashiko-outbox-167004@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: qla4xxx: advance the reset-sequence array
 cursor in poll_read_list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261011040257.2017421-3-yhlee@isslab.korea.ac.kr>
References: <20261011040257.2017421-1-yhlee@isslab.korea.ac.kr>
 <20261011040257.2017421-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 04:12:24 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: qla4xxx: missing initialization of reset template array_inde=
x corrupts firmware restart
--

commit f2bbbc943d62eae5bbd2ca3ef4c8394aabc05ad4
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: qla4xxx: advance the reset-sequence array cursor in poll_read_list

This commit fixes qla4_83xx_poll_read_list() to ensure the array_index
cursor is saved back to ha->reset_tmplt on every read. This prevents
multiple reads from overwriting the same slot during the hardware reset
sequence.

> diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_8=
3xx.c
> index 44d285af22727..2ac833c5b1400 100644
> --- a/drivers/scsi/qla4xxx/ql4_83xx.c
> +++ b/drivers/scsi/qla4xxx/ql4_83xx.c
> @@ -1117,7 +1117,8 @@ static void qla4_83xx_poll_read_list(struct scsi_ql=
a_host *ha,
>  				ha->reset_tmplt.array[index++] =3D value;
> =20
>  				if (index =3D=3D QLA83XX_MAX_RESET_SEQ_ENTRIES)
> -					ha->reset_tmplt.array_index =3D 1;
> +					index =3D 1;
> +				ha->reset_tmplt.array_index =3D index;

[Severity: High]
Since struct scsi_qla_host is zero-initialized, ha->reset_tmplt.array_index
starts at 0. During the first execution of qla4_83xx_poll_read_list(), the
polled value will be placed at array[0].

However, looking at qla4_83xx_rmw_crb_reg(), an index of 0 is treated as a
hardware bypass flag to read the register directly instead of the array:

qla4_83xx_rmw_crb_reg() {
	...
	if (p_rmw_hdr->index_a)
		value =3D ha->reset_tmplt.array[p_rmw_hdr->index_a];
	else
		qla4_83xx_rd_reg_indirect(ha, raddr, &value);
	...
}

Does this make array[0] completely inaccessible to the template? The wrap
around check setting index =3D 1 suggests the template logic assumes 1-based
indexing. If the first polled value is written to array[0], won't all later
read-modify-write operations read from the wrong array slot?

Additionally, when attempting firmware recovery via qla4_83xx_restart(),
qla4_83xx_process_stop_seq() resets ha->reset_tmplt.seq_index to 0:

qla4_83xx_process_stop_seq() {
	ha->reset_tmplt.seq_index =3D 0;
	qla4_83xx_process_reset_template(ha, ha->reset_tmplt.stop_offset);
}

But it appears to omit resetting ha->reset_tmplt.array_index to 1. On
subsequent reset attempts, does this cause the cursor to drift continually
rather than starting fresh, completely desynchronizing the polled values
from the template execution?

>  			}
>  		}
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011040257.2017=
421-1-yhlee@isslab.korea.ac.kr?part=3D2
