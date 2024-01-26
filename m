Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8E7200D8
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2024 17:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706290994; cv=none; b=Pk4ZY7gK0AKsm9L2GTyufmTXihaG/ypNDQ40z9df2tJWSfIbTFJn9gkgL/MQWr/UhuPczX+NYBtNGs9EHWdDYfWgy3Xf3naOQrX4/ANrtqcJ0Z60JvLMAaYJrxSP2IiztR8xTgpgmV30JLBZGSiEsNtkuO3cHHwVBl2EzOX66pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706290994; c=relaxed/simple;
	bh=SXylSozMIFvQcgeeHiv2u7d8n6Xr+YfeABQSd/Jah/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MxqqBkJTULy+Hw4SJobq7qNnVKbDhdAYAeLkPkpPtjZfHc3h0FolsI/j3o4cLvnnjwAhuJt2rjsTla/WRzmKAUq2AW/OiFYyA3+mn85YIHQmRlxskixUD0PzkRup3L1DodBa5rIB4DxuLtQAH5fLmthlxUdu7KiBmEC70z5DsLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SPUi2GE1; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SPUi2GE1"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40e800461baso13617015e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2024 09:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1706290991; x=1706895791; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggkqhy1FEbzA5h/m9nSB2QSTIebzKmuAmAgA30UHV7c=;
        b=SPUi2GE1f34Gu8hYOAq6eKwv6nNIrcJlQPPX0gTyIwCcTdYwe+LrThmd3+pijcToeB
         XGkIbcOMzN9sfzTU1LPBNxDmZIKRMGPPTPPDWeJnFhvaNi61yPr3AWqN6R83qCQbW9Qi
         QQmKmPzmkV93Vf/ggQiLhmUshFCvUv2Ra93GuI/jq4X1jF+2T7uEp8s3km1y7nMBRH+Z
         +z3HCFTjqJKtqiv1GvT1J/nu1isqSOfN2DRI9FijjM16wHmzKDKRIFOn6VDEUgjp6tX9
         ID2YtmOLKY1lon2IcOINmUXdcpY3FrrjItANYw+T8MNxpH7G+ckn5g5ccQrgq99qzJ8u
         3dZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706290991; x=1706895791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ggkqhy1FEbzA5h/m9nSB2QSTIebzKmuAmAgA30UHV7c=;
        b=b3PSl6IdCe+j1nbsYBWnpe4Mw02pDWX2W2ZMepqNfXu4FyL+AI7W96gj4A/8d3qZCP
         zUVj5NTGd0IozWGD68TnxagESQP8Q9fEzXCcwpxgwrM8QfqqmHHmRDxYBFWVJ6iZYS76
         8Ejrgw/RZ9jcYTphZ6d3kM0wq+W6eAOPB8ZhxhB2hMtq5+IJPz7/kYRmiXEfPFWVFxOi
         4SWhFtBSRD6b7fUpqpMqjd9KVl/0BTKQl/BuePi7QNMspwWIz5AZiwvxJVovf0UEWv//
         Md3hA97Kp6emlKBCVXZAL9vSgvcaOl8X1RRo1M0TxBkaSwtHJrpftj2d8qP/vg3Bk6pK
         llaQ==
X-Gm-Message-State: AOJu0YzcqDqUAq9fVSktcOZTN3gP4uXvmIkDtohQJeIx3WYO4HAyAyDL
	tY3OXdlIyxp1+R/LnjxteetC+b3vAwJOZ3EsSsvhgl0jtvSY/WWkBWOQ51umWMVI1kDphs5hyOZ
	udrbNd+81a7vriqnQiy4RBvmTSSgZmwP6UpKxHQ==
X-Google-Smtp-Source: AGHT+IGymZGOhPiBKUQdsU+xfemOOTrCKN1ifGOHRfzo2kxHI0JiEurg0pV4VOJN2l1MG+o8Srz9ZjMpBoWYfzOBwbg=
X-Received: by 2002:a05:600c:3d91:b0:40e:5577:189 with SMTP id
 bi17-20020a05600c3d9100b0040e55770189mr66580wmb.147.1706290990772; Fri, 26
 Jan 2024 09:43:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1701540918.git.lduncan@suse.com>
In-Reply-To: <cover.1701540918.git.lduncan@suse.com>
From: Lee Duncan <lduncan@suse.com>
Date: Fri, 26 Jan 2024 09:42:59 -0800
Message-ID: <CAPj3X_UWL8a3iXxA64bN5NDqWV2Try2-q84fYxaXk5uLCfGezQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] scsi: target: iscsi: Fix two protocol issues
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dbond@suse.com, 
	hare@suse.de, cleech@redhat.com, michael.christie@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ping.

I believe I've addressed Chris' issues. Chris?

On Sat, Dec 2, 2023 at 10:45=E2=80=AFAM lduncan@suse.com <lduncan@suse.com>=
 wrote:
>
> From: Lee Duncan <lduncan@suse.com>
>
> Recent boot testing using the fastlinq qedi iSCSI Converged Network
> Adapter and an LIO target uncovered a couple of issues with the
> kernel iSCSI target driver. The first patch addresses an issue
> with the handling of iSCSI "immediate commands", which are allowed
> but not common, and the second patch lowers the noise level of the
> driver when initiators send PDUs with the read and/or write bits
> set but no data, which is also allowed. (See RFC 3720)
>
> Lee Duncan (2):
>   scsi: target: iscsi: handle SCSI immediate commands
>   scsi: target: iscsi: don't warn of R/W when no data
>
>  drivers/target/iscsi/iscsi_target.c      | 17 ++++++-----------
>  drivers/target/iscsi/iscsi_target_util.c | 10 ++++++++--
>  2 files changed, 14 insertions(+), 13 deletions(-)
>
> --
> 2.43.0
>
