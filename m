Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883191E7C34
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 23:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763595859; cv=none; b=K+2q95S9qbtzqlBUI1aGGpsW6JSjfMprGT9prkDhfYvMuxDlm9SHyvbbHfjhkLIT8RR5BHud2SBNMjml1MhPONPTNdFOIbmJFnFO2B0aoBVBJkKmp0w6yspD5JBg+sFBjR7Tf24ULCGaDkh4fXfPjW8Hz6v7Oec4YtxqxmZxxm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763595859; c=relaxed/simple;
	bh=HeUtzAohRE8EmVAj5Xnfhb9nWLZ6yvqZJBZxrRzYqM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R9OPwXOk3NbVtNpXyqqSl0o2FNflqTwk9nG+NAFtSLZ1MrQ+W1SYfEKZjOYqzrX95P7KDK4RAdjDA+qIJaWL/1E5y4Dwi8XFHJiW+fyhx1EdS1l9wFNhWOHCcle9CDcn2ntBMRVT0zwooOEX+6MMzX8GKdZ7GnTzxfxUm0MU9Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CGVZXyv9; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CGVZXyv9"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-644fbd758b3so4476a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 15:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763595856; x=1764200656; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HeUtzAohRE8EmVAj5Xnfhb9nWLZ6yvqZJBZxrRzYqM0=;
        b=CGVZXyv9riY3HS9YVaK685uy37baJbHqy3Y6I/mNP0jfzdcNQMFcnfwND5tgrFNP63
         GWIMyTzmyA0dGckJ+Jbb0b692xP82oLqogJsbdzk/mGU22GEEy3OwS2OIClw+nygnbZQ
         hl4oTrA1N3CMCjLpf9bvvT5VRDTrDkA91S6oIZEy0Nzboo/023j3YbCH0eMGz+aX2ESt
         +7Gtm4cjsZ6QekJTv7aszDqQLXFlrX1vs9Gl223IuvLFr5deGThAm19ZENXEo+zmQrpf
         J6Ubfq228MAC5TsfIQGukqveY/6tOI1pOKBTQ0Z5R3/ieFHQ0G8+iPd00cynQNc9UbZF
         /46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763595856; x=1764200656;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HeUtzAohRE8EmVAj5Xnfhb9nWLZ6yvqZJBZxrRzYqM0=;
        b=Gxyz0VpmtiqUJr7kD7ALtrpgR4qh4EWwtI6LFLgTAX0tyvI6kEO9mlxQgSiQBETM+s
         5CrKkAuBbwjLhCGBhEXUN8wT06WxN0jXtzLYFcA8WKM/aGyrfSszYTLso1569MZ5T6EY
         ffmYepOtzKDGFYkgH8lRXfGX8RczK0olLFKKQ+koRXxheBY7bQbGQZEeUgDQ+uQqKo8g
         beKaBbFHHW8bPb7PhWehhLift0Ti8Tg62CFmHl1glJLG+MzjdR1Mx5gFXWrhN9hUyYmS
         JHwF++0sY9HtL0ikrQeMKqfLe3+a4hvCzRc0yDWTCAjqo05V3cB3nEV+oPqyVupwUrcP
         ssMA==
X-Forwarded-Encrypted: i=1; AJvYcCUEIAxtZQTzSQSX3q8qpJF1JvkbEsWP+ZNruc1UHknE39u+CkWBtTJn82zYU6ADeDI5fAC9KmY6Lz7v@vger.kernel.org
X-Gm-Message-State: AOJu0YwM9LXBI0sy7F8N8Ly21j6izJSJxLMwDrlTePeFQ8NhaSD1Vqcb
	whXYY8KTSVgtNQ87Jx0tOIaS6kkKdCrWfPHFm1+W14GYEOza+sjHRoLCkhML5GxnX6b6mjNkaW3
	gXl+Jq6tOj6NqXhR7ayMlaj1fBonUBodplKEqELDt
X-Gm-Gg: ASbGncuuWvfr729E7LUO3xdHM2L+Tmngrj/NGNXyatP5L3/e9R1TTUkegdnsYpErDpo
	mgTbsdB6vMW+1i9IhfJvppUz9bxARcpC08XwyloiUnBU5zHBNA56vdqMuJtFFQMT2Ij+ZVTKXoW
	xs9sd4UDPHcpci+22ByQ//f0sm0Pp4Nfs+iaiLQgTPv1iZvapNKwSw/U6rxcg+u0HDeCSJUTEXj
	qZ5JllWVsi4UBaVhQk1H1Qc5cy/t6gAKrYdtpVJNwcjL2TENh9poHL5MefzhZoC4xGdTGz8nYjI
	+5zTbtwkyh6YyTBWhGF1OjiaOVN6ta43ho/t
X-Google-Smtp-Source: AGHT+IECxMgeB6hGldjiCyyVM1CUwH7nPUoRpi007aec7GNkGRHNxXg/yJU1gwSArBmSXF/P8S+WAa5vtxyMdbFwJPg=
X-Received: by 2002:a05:6402:5642:b0:640:4aeb:b4d3 with SMTP id
 4fb4d7f45d1cf-64536c3bf3amr20733a12.2.1763595855810; Wed, 19 Nov 2025
 15:44:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251112063214.1195761-1-powenkao@google.com> <7d964e31162bf93f583e6e78a3044152894ecb94.camel@mediatek.com>
 <CA+=0d2YnrDL41DXtC8kDmtXioy4+hohGsmrOPxJY31jqt22uww@mail.gmail.com>
 <c4bd6532b003089fedf518db878a3843c516217c.camel@mediatek.com>
 <CA+=0d2aYn_q=i6Yy=zSu6eE=Fj0oTk4t00e1uezBxqNc5E7pdg@mail.gmail.com> <301cc0724a9e22bf195cb0bafb0c5d298e93e99d.camel@mediatek.com>
In-Reply-To: <301cc0724a9e22bf195cb0bafb0c5d298e93e99d.camel@mediatek.com>
From: Brian Kao <powenkao@google.com>
Date: Thu, 20 Nov 2025 07:44:03 +0800
X-Gm-Features: AWmQ_bm4cahJS4Lohnad2QmDb2yx2c3yF0HSW0FcnEoAweWJLIFn1Fj4RIsNgLc
Message-ID: <CA+=0d2a6YKD_OGcM89b4ZUn=gEhF6G-YxTfRBouiX-wYcyxS7w@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume error
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, 
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, 
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, "mani@kernel.org" <mani@kernel.org>, 
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"

HI Peter

Yes, that is correct. :)
