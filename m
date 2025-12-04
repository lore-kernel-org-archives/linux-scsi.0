Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE1D3191D6
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 23:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764890432; cv=none; b=n1hLK/ejGtc8ZJLqegNH56PEK4/5GriQbrpxG8VKi0EZ+SM89dK/8t9ig5+mjphvREq90Ls1eF8zyuBC3T9RT88iW12/WIdDcIqyG06rIOv5YbOOQpsf3Rg/3c+2+lFHNlYvy7J5hPVx7ymgVoostlCmOhu9AoAQQRTkH8CDLjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764890432; c=relaxed/simple;
	bh=Ht7e/k3I6peS5bAMtLY//VbHHr912bqZUpjqoC2aIn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eZ59Lv61gpSt0JLggd1ztk36OrHCrBpaZzKq8FotFu4WbH6X1jvqv9ZaUprSdkrd1ECAfM1E/rrE/tCoJcOm09QVpnw5cs/GjcjQGnLtK7OyI88dQeL8+PUMaEA7aJ19jtZBs6DTPGcAPchBlzQQzjvdEPTEqR69xWx16aHhiRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VJxCsxKm; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VJxCsxKm"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-643165976dcso1772a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Dec 2025 15:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764890429; x=1765495229; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ht7e/k3I6peS5bAMtLY//VbHHr912bqZUpjqoC2aIn8=;
        b=VJxCsxKm/srzjXTJglcV7st+2GoFACZJ4LA16cKwpEdaYxXpEQwluBPVKD3HHQbwvM
         4b4SEmzK1mpKhA6ru3/feijWvaj6+cp/JmEaSMJ8GIgq0sxMiVewFk16Tw0uv2YtG7M4
         UrvTrHPGcs2LjU/HKm6KV0VfJTh9/Hxr6NVlG1PcmUUB8nfXWTG+CUv0KUVdhLlg2SoZ
         R5ptLVaHuKRPXAyM7Bhg/pwfhDbey8S6jiULIvtp82OWe+krqeSLrUobKbmh6MExMx5h
         pnLVMgRn+K8NV8F5GjFRn8BiimGn93Cuy1MWdm1ZadUG/M3C6TTB2gt+DhrQNWn6ab1Y
         B4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764890429; x=1765495229;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ht7e/k3I6peS5bAMtLY//VbHHr912bqZUpjqoC2aIn8=;
        b=HCUNfCX+LU7yaokeTUIT9c8K1do2Ktd1La85rNlG2Yl1mt+V2RorfV9C5ydQPdkJ6y
         89zv9NZtfcSQqmgIdBfqv3i8rNK8ouJ6Iw3+rlIqNfih65vRXBS7ETUMx45yyrpaW9p2
         AIrJEMxkDwQI7RldC0ZxsBCCuSpeVWvOGCtEuGKduPP7ZEe1Yv9bZYVDEgu3gDMVL84k
         hNlv7uyQArDUNDK+XtISo0cS8gs9+wwsBAIbOv7yXuYzAdZco8W2dgn0l5SilvOnQvur
         /0ye5BrOowVacGA/DZnR/Ja+a2/eqTsl9YJ881wzcNeh1CwM6FJR9TD5M0BIIesqVPqZ
         HT3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVNELWJ2gh4ENRUYi2dNgdIkMYdMUg3RG5KHk+I3ttDY3Zbc6+WBHozvAzAwnFx/3YWH0SYjmUOuBKx@vger.kernel.org
X-Gm-Message-State: AOJu0YzIm7OcitT65+eoFEzYyV3WUFxSWhasYuVF4O5x72T9X/+XVFw1
	0mKyno22nGN7LnzL6PUsXxM/qwB4F0AdvmWlHZXC9SXwfegam1ZPW5ez84gdtzvreJxpMdd7NPD
	IYa2EeKFkFyUauZrcv/dL4u9vwii5SBwKcxN+RFsB
X-Gm-Gg: ASbGnctT7UQMPTE6lvdBQSnjJoFoKyaAGMWpjfUcG5winQn5M+hs5H98DYu3sSepEs4
	IG925Q/UoHfWKH6Av0lGEWdMSxfWRG5Fk/stlbZ5vYNKc597pKrEsySNJNJx2RzbxtLrdvYf0ow
	aaWGAUAqLEsVddK1Nkn6wzGgyOdonPhzgqWY9I9F0TZ+ccif8myNZaDu+sVIddgYzmNIbuQo3Cj
	t8jukwT17l1Jb2oNCQCaHPb/l5N/N2FUvkrmd8wiQhcrCo+PCauRl3pb7ECImFOF+wmQyMloIM+
	hafv
X-Google-Smtp-Source: AGHT+IGJ6/o1ziOxQQT0jQL0kYiEs46az9DtQ5ERCjdJMrn2kDREPXyMNiutxbdWnv6Kpb2QGh/yUB6vckvWGljAry8=
X-Received: by 2002:a05:6402:558:b0:647:853b:affc with SMTP id
 4fb4d7f45d1cf-647f1944f7bmr6978a12.19.1764890429314; Thu, 04 Dec 2025
 15:20:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203073310.2248956-1-powenkao@google.com> <aS_pE4nf7wQ031Y8@infradead.org>
 <9d678edb-0db0-4ee5-9ad7-b2b141575026@acm.org> <aTFe48CQcpCt6bm8@infradead.org>
In-Reply-To: <aTFe48CQcpCt6bm8@infradead.org>
From: Brian Kao <powenkao@google.com>
Date: Fri, 5 Dec 2025 07:20:17 +0800
X-Gm-Features: AWmQ_bkz6mUaGmvd3kJkMVXWBqLy0XAvyMqAtlrNLCPyT-FK1EDEPNRtqUp_UbQ
Message-ID: <CA+=0d2ZaA1Szjvg0A9iAejsMu-DbY=D7OJ8vM1vy_gwi7bKBdA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] scsi: core: Fix error handler encryption support
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi all,

Thanks for the review. I will fix this in ufshcd instead. Let's drop this patch.
