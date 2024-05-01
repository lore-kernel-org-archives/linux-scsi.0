Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED69DD52F
	for <linux-scsi@vger.kernel.org>; Wed,  1 May 2024 22:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714602515; cv=none; b=hgpJY1RmE6s74rlmZadY+CnXZEKWMfnGGVQPm04jct3KyF4OGatX3PVFH+ogq4GuriHXoJGx4JRJhhJnBTtZap2lbsKVrfOxPmpf3D5wfJYIhASktgZYM/eOz3YGSGpxfuh45iivX7+2pfgaCBEp0FK5ArpO+lZ8h75GgF6YRBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714602515; c=relaxed/simple;
	bh=G4yU3i3D7iWXqrHs/cx4FIuZNY42xzeWB7oBybnsoZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dwaI32sSg6qDMc7cX+f2ToCpIg10VvRsL50nipfWhqFSzvTTo2gOQXHEoapedVokxkA9Ihv1XQEZ1i/Q0GVWGOwS1JfUEZzI0rVkFcubs5fhRqboT2oXraSNTA25WBw5Nx5pdc69NvAGcQ9V+oweOZjW0oLMbIhL6QbqIDUTnh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TaWnXjiP; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TaWnXjiP"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-571ba432477so7767189a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 01 May 2024 15:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714602511; x=1715207311; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fo4NkaAY9olHEXrwzAnl+QQ7GyXeY9AkPLImzz46dEQ=;
        b=TaWnXjiPyR9kovuewJJrkYkITqErfVxdjEXNP0cQbo1zPn0WUKWn4cPdOVFmSVDCwz
         TrJIRdatPRuXEDhfGNIYyvBFspEp1qcKwKb0Nl3D4q7MbkFR7/OHOTd4429z4AZ6aEpp
         Nbvi8jSbl0f9+CH9fLsiToO106IGDH36GRHLt7Irvo4BYs8tdlqhpLjnKihqey2y/EhD
         8tnldV+mTVoQucRBkdCg/IMGQRkgrViLgwUIwCSUkwxXNIw9NINuDB/Sxuh3YJTkgTlO
         Z/C3J/fSvjkinyqXMYs6RC0X5rzCVLfsJ5JHaNzAZjvzOHtFGR2O9iMcGVIw1rjKepjV
         n/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714602511; x=1715207311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fo4NkaAY9olHEXrwzAnl+QQ7GyXeY9AkPLImzz46dEQ=;
        b=QPXgP3U5idpeeOn7scVyLt72Y26gmLDvsCKD/KAn2KGhZGfs1Gjy+EN+Sx2fH3f/x6
         IEstG6mEXjXBLGTPPx+m43TCzd81HoXMsvNPtHgsWWCuqXCqz2nkP0dNE2MvGz2kCtUN
         VeKN8AmIPUKjd6TfiGIQPPmyRmVHiTS2v5gMjCeyVj1hS61g5o/FoBDbF3w1OtYxh5rc
         LwnBJyeUhtlPrs+MaS1PTzOWv/2lUqb8MifMVbxQSNKosIVdYLQfmYra/wKePbWL9e4Z
         ZX5rr39o00Bi3kRzPtv4WDAHLhoCzjLDyUss/VRhebG/NyfQRxgTDiX4vYbBluASTLBu
         Cilw==
X-Forwarded-Encrypted: i=1; AJvYcCXKPPBn7z728bFvyDGU0CFNPtuNTLdujmWQvg8Vqd+U5Z5yylvrj9vzPRZ/PgjFmdVMi6r1cv+IowgRPw1KX312eXsqDpMC3w4xuw==
X-Gm-Message-State: AOJu0YyfqJVs49T2R8iBqjMXTMgUSCymIO2o8/zEqZv4UuU3dqj8Wszb
	LqpGWzd42rNCTJsBWbl7t/IJQJHSQQoLtkTr2ir2g+fXzgrfhQZqyr43MukW/61sJW4+fv8IdzI
	Yw5pgtzgTd7k3KobiozasX7sjB0KlReTZOLA+ch79pvHCFGn7
X-Google-Smtp-Source: AGHT+IEWPR3vYlBNXzZ4oYAMP53wu4XLgwEYEngBxfeY9OoHJnRnGfjdt/GPDYx5ZzzVadJuSsB7KdYgK7tkjR6EELQ=
X-Received: by 2002:a17:906:26d9:b0:a58:7941:2718 with SMTP id
 u25-20020a17090626d900b00a5879412718mr1220008ejc.47.1714602511290; Wed, 01
 May 2024 15:28:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240315100600.19568-1-skashyap@marvell.com>
In-Reply-To: <20240315100600.19568-1-skashyap@marvell.com>
From: Lee Duncan <lduncan@suse.com>
Date: Wed, 1 May 2024 15:28:20 -0700
Message-ID: <CAPj3X_U4RWi+3Lgo9bOFNAUcyK9AfzNFJ0E9YhCQRf2qUS_W6w@mail.gmail.com>
Subject: Re: [PATCH 0/3] qedf misc bug fixes
To: Saurav Kashyap <skashyap@marvell.com>
Cc: martin.petersen@oracle.com, GR-QLogic-Storage-Upstream@marvell.com, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2024 at 3:06=E2=80=AFAM Saurav Kashyap <skashyap@marvell.co=
m> wrote:
>
> Hi Martin,
>
> Please apply the qedf driver fixes to the
> scsi tree at your earliest convenience.
>
> Thanks,
> Saurav
>
> Saurav Kashyap (3):
>   qedf: Don't process stag work during unload and recovery.
>   qedf: Wait for stag work during unload.
>   qedf: Memset qed_slowpath_params to zero before use.
>
>  drivers/scsi/qedf/qedf.h      |  1 +
>  drivers/scsi/qedf/qedf_main.c | 43 ++++++++++++++++++++++++++++++++++-
>  2 files changed, 43 insertions(+), 1 deletion(-)
>
> --
> 2.23.1
>
>

If not too late, for the series:

Reviewed-by: Lee Duncan <lduncan@suse.com>
