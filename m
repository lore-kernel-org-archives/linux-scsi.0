Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C347284B2E
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 02:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767060326; cv=none; b=WAwzZ/Y6b/X/9iYBIG69ZW2htPaGpBxkSxHrX+Wpq4pZ+jNg3cBkmCLkw7xuOgD7NKeaEgRbqhMZpdqu07odgiEG4EYOFW3U3Uj6c6zgWYIWrdDNyh6q8j8nNJb30D3rUpcrgUQngQt+sJn0ndZk3rGLuphdbr+rCmrMnl7sE2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767060326; c=relaxed/simple;
	bh=msbQQ7oiKP/IfzjSJ4CTwEvqA9cZuILIpukLQsV+xro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mnHp3r22X6Az4S1knteoY1F2LTpOYkYZgm5hCRNH+VAZqQXvlAmh/IjqmUbKt/8/tuIX3KOsbcKSNeALigW9yEH2kyTSU52M1iTE+A239AzALch+UA2KqdradHZqEM1llNGP5xsZTP+sKKWXLMSqYSWu0YSLMGJ2GdeEjXLpu34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jkSc/1UN; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jkSc/1UN"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-890228ed342so15274796d6.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 18:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767060323; x=1767665123; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=msbQQ7oiKP/IfzjSJ4CTwEvqA9cZuILIpukLQsV+xro=;
        b=jkSc/1UNo62Pcx82TeeD6mg/if+v4h12OKW8lz+q2BqNfdnAE1IGmzn82jNnImoM9A
         Wys8GBS1rqYVKLcZQWu+8lSkn2r318PTqt8xOpaqX2znqt37u6jn58JzyamygeEa1n/x
         PahFzbBuaIFO71MelCiDKl9aAGxmmXjNFJn4BvJPk48QBoMBOYncvLf9I3ZVFK7/SQdn
         rsk4a6KrLhIPSkfN5UYzgEvZcmv2ZfIrUuEwLMVYg9OG7eohzcIMMiDXrCd83tyssEj2
         VSwdknBhC0UuLDpQ+tDjcGGtlEqIdcpSYCdqMg3O8bMY8ftawAql17dDTnZmH1am6Di6
         /Tvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767060323; x=1767665123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=msbQQ7oiKP/IfzjSJ4CTwEvqA9cZuILIpukLQsV+xro=;
        b=tFGYBvA2LDWE5OqwQPDXqHeBuGCU0u8WYvbgTXOG+8pkt8gAw84e4Z9+UF9jHDk9ly
         0bNzxDvJvHeO2TnEA76fXrPD5pFZwoWokutTD3AwqcPgZmNF+boWc8qn3rfmaLHF9c3Z
         1pOvgCRH4rkSUF538VoSxJmtmxINP/ZogtU4PpLRmyOwM9G6MMozEWTavSHAlceb5ciE
         97cePxNXTwlWYfr0HAeAt09inoHHGZdK8SLN8ZbSpb5l2QFCQUglGDGdK3UcjfaDg+KF
         rm9AK1dMWZykdtvxtYiyiCg327Jf0qqiRi+lCkl/L+smV/GfowuWcvEh6UlJSiPpLVI1
         uKhA==
X-Forwarded-Encrypted: i=1; AJvYcCUOu/yLXiiZIUtSVzc8NvrWFS0ahDq+p25vJtq7R3mnxc3isQGIIzdA7qkB+e3sMBBvnSnd4TYyXzyF@vger.kernel.org
X-Gm-Message-State: AOJu0YzcokAZmmLzqj8Z5mgsWDRX5zhOF8lJRtGgdeo1469gJ8fikt/O
	Bocuj8OnNTf4af8Us1e/m12r3MsL5+Khy0o2zix0bUxa+L0SOeBIFN36wU8GC+YCzc7VUSYgfY0
	OpQiBOK9UqCe7Ko4aWkzPf2gAxthJ+os=
X-Gm-Gg: AY/fxX6OEHtiYPvERXWGQqEnQTu8iYDpwFUg9JxEX/+f7BaTE1OtXxKuQ6pChALTrCK
	CVnBWCx3R+3qaOBhFe7auEIal5Sl35u6Zg7QTVZHsxQqE687SWsk9UVdyHUuzwV0P+u17psZvTn
	LOIAFzjJvPj+uw6dAV+YRiAoT5AZfMYBCqgXiEBBP8vNUidMJZPsqP/ZgbeGvRDlfLYecT+YVX1
	vFt9R3cOSOjtKyoCh0RnP2Rbl1ZT65cRfmC+h4SvZQOT3Ot1P8gA7FXVupO8lECxedK85uciSQA
	x8p7djI=
X-Google-Smtp-Source: AGHT+IH2nBh3BbpEO93ULXr2h0eVD0VWuVKc3r4eBZaP4u3YHc2bdl3OJdmy8HUTPM0hdkzHP3tJyYr/xIEi75z/tF8=
X-Received: by 2002:a05:6214:53c1:b0:882:33b7:bc34 with SMTP id
 6a1803df08f44-88d81669f85mr452003026d6.12.1767060323362; Mon, 29 Dec 2025
 18:05:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251229071515.155412-1-zilin@seu.edu.cn>
In-Reply-To: <20251229071515.155412-1-zilin@seu.edu.cn>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 29 Dec 2025 18:04:01 -0800
X-Gm-Features: AQt7F2rOLY0ZHW3n5pw136w1RrLuCIVtYJ0pOohgmSb93rwgR1LyRzPHxz7gb1c
Message-ID: <CABPRKS8=__+4TcW9wjzHuVSZa7wKhJpzT4VGubBHet4TSc-u7w@mail.gmail.com>
Subject: Re: [PATCH 0/3] scsi: lpfc: Fix multiple memory leaks in error paths
To: Zilin Guan <zilin@seu.edu.cn>
Cc: justin.tee@broadcom.com, paul.ely@broadcom.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jianhao.xu@seu.edu.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Zilin,

For this patch set, please see and attend to Markus=E2=80=99 comments.

Regards,
Justin
