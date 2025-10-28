Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D31134EF15
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 23:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761693211; cv=none; b=ltDjOuXVDQoLzmYYHPpssU6Zr/rgtIZHGkUAxi0MQC0+CRytBaW1ICISFOZcs0uAbO4Vj4cvejWM1rguoHWg+/fC3+eAKNJNB1vOx+geSS/SOC8KGGTSllkexChHImmHZHR3SftnJwQ1InwaCmO4L5V6QMwBQ4se45a3TGDH82U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761693211; c=relaxed/simple;
	bh=jEv0bfwJNvQLuz+znDideErJv1UWy+9Q2zCFrfX+yS8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=amMcWBBNeE96K71M6gp1Sx5f9o/Y3m3rJ/Cd7Bh6Ld44x6R54dXI+QiZeNgLHAPLSFsEAfCmZ9ebx/3CaXRKgZGqX+JuH+0+FjsMp+cpEjMA5zog0iJp1FwETUU0AWqT02heHHh+mbCrDwpcbprxZaHbNl40Xh7ht6HyhXyanwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D0nbP1y9; arc=none smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D0nbP1y9"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-63bc1aeb427so6854496d50.3
        for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 16:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761693208; x=1762298008; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNMGrJ/KXZ6KzvaUnv5DQgwdVVIKCPeDMVN02PeB3Nw=;
        b=D0nbP1y9Ex9DfdiDTE/m4PioB+gXvRhgfWMetdFpzgruiDoj23PS0xiEbOQT4RCAS1
         +hs/PrbrmSs3wWyPbOdeMRM0+4aBH3zQqW7kpws9WAb9XcOrb0Dj4o1xP5ZYfQRel0fn
         lZ58TVdR8NrrWvADf5fjAiys1xNhf9CILhZEx3xTLZf+MMvUZZdLWkfbyubmD+tFPs0V
         hWxot0skGfhzhpksP75xhuH6wxO6CgKBBdfJOP22p9c1qQmdS877R8yJHsu/cMziEIXM
         bdtQRa5PYfeSjN9nhbt2bKQcj1ShDEqFGinJYkQYD+NRs+PJ1xo7B18G3QEjX2/uCh/X
         DBqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761693208; x=1762298008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNMGrJ/KXZ6KzvaUnv5DQgwdVVIKCPeDMVN02PeB3Nw=;
        b=VNLpVwD6FwGAuoKpJjeGSSioCAZ0vb/IXo2dgEWf4Wy/mLFKscussMH/GEUR+UGXk0
         cg6/XLAAeTbis5iQqhw8SCLGPE5PJg61ApveY+BaXEd3bsyKDNbhj4q8QUDbrb1JJl71
         aEACcpuC9r8h4RVPAr4zX957jFQTeuOpjs3t4MZEDZw/PFznpdyWW/qj1Lqf3200b/qq
         /MvUcu0FmUGTsWqdKuZWwSDnSVU3jBW1XD0N2r8TLNqd+vOKTIjPkE2sNvvo7GRHymXm
         /OPmSbIJi5yg5ohg4hqtl4QSJ6rBzSZoEdFWtG4M2RX4sRc7ty/Q5Rk06JsfU2oKx3NB
         NK2Q==
X-Gm-Message-State: AOJu0YyRfJYsufHx8rDQx9ulB30ZU7fyKPJ/oJURzuEuYI5ar4O61713
	W64I1kPEfRPW21wCn7Dsa++UaFCMQg+NVtxbN56rgtxGSd4n6YHRXeMqlckLpEPVobt0gID7Edf
	q6H/JLWnKZMz51J9sdfHi4nbNqf8DrtQ=
X-Gm-Gg: ASbGnctkurWsnmwiPPM+YOAKfcnbrr8ID4CXZ5z4rhrCjVY9wUBqJZqwaxMy9GliC82
	mzt5oQHM+QYmbWDgkze0Lc/sxSI5FXOVHLgR/+2nMc1/aNJsR6OVZfps8+PIB/aujBVH78WwISx
	mbjnUZbDOzO1AsNdeZykQOL8hlQK8h21W/wKscj7flw7PzY4FOt4s2Kqnvgc3ZeX6WnEPlhNw1b
	MgcslbcRlpzSCb0SfkS63ez604Tfn4iPlaNi6TA/34fA7hHbQERoFqRsUqywg==
X-Google-Smtp-Source: AGHT+IEiD19bVyIk5OFRohBQ3DIwtpxEqEN5lTnK7+XKvVcZ1tzKMz6kA9RNAGkJYZbHMtolpiBw5XKaT+i8Xjse6GI=
X-Received: by 2002:a53:cec5:0:b0:63d:ceaa:2666 with SMTP id
 956f58d0204a3-63f76e153d6mr738779d50.63.1761693208389; Tue, 28 Oct 2025
 16:13:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027235446.77200-1-justintee8345@gmail.com>
 <20251027235446.77200-11-justintee8345@gmail.com> <7c9c39f7-4d25-4a1e-a2b7-a9b09e2034ce@kernel.org>
In-Reply-To: <7c9c39f7-4d25-4a1e-a2b7-a9b09e2034ce@kernel.org>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 28 Oct 2025 16:13:01 -0700
X-Gm-Features: AWmQ_bmoTJLQ4uEYv8TNtbjXH_D7ohQ41bEKBkHywzeacfHjr0qF1I4J9dM6cMM
Message-ID: <CABPRKS8ef+PC4WBBDPk5uh-xZ7Dyz+kzcK5Bnw+45STZCUM7hw@mail.gmail.com>
Subject: Re: [PATCH 10/11] lpfc: Update lpfc version to 14.4.0.12
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,

> This makes little sense on its own. Please organize patches in logical
> chunks. Not mentioning that this is useless information - you are
> duplicating kernel version.

Understood from the viewpoint of the kernel version.  We=E2=80=99ve had
previous discussions about this with James Bottomley and Martin, and
they=E2=80=99ve been gracious enough to allow us to tag our patchset update=
s
with driver version updates.  The purpose for the lpfc driver version
updates is to assist in tracking our patchsets into the various Linux
distributions.

Regards,
Justin
