Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1471D9A70
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025008; cv=none; b=N7/Na6AoTnHZYoBnngDAJJf6k9bZ1M92NFFOqt9X0y3JPbLC5NaBYhGI7R+KZh78ePfvvm0MmX/xv7ARITRakce/RHRqj/ROpuhDIJa7PZbeBkQr0QLM85BCj8PHBzbKnntUTsrUu7EBQZMMWe4YyMB72D8SyMnDJvG0uHMXnRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025008; c=relaxed/simple;
	bh=lt5sqE/A1UTQwYGO3mB+R7DENqnuvnMFQ9g9bPWPCTw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Sik3qVzHn/DWMR3x/QXJEirNh4XeD6dJOFLwQ4qWhU6BtKi040eMA+aNSSfIhlMERYrzjPOztcdcz7Vjw+dC+1kYUjbgTxAatnW6SFKV/HQXNfW3Mq4PAE/oggpunubg8lLloz2dlq/uDQeRv33WV/I1EBMaXWgxznqMiw/4i50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=adTLkP5L; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="adTLkP5L"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc11b5dd54dso2786744a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792025006; x=1792629806; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lt5sqE/A1UTQwYGO3mB+R7DENqnuvnMFQ9g9bPWPCTw=;
        b=adTLkP5LbJJzlbrhpxeR/38rFHrP/Fwa0VxW+HVhZbs+SxPaMCVdAoFBd5Jixsxlnz
         FyH4MySJK+O2D+oTJAyxYzJ7AEA3wW5SKmAxA1HSGXUE7iNet9dcgQoBsv6KQvjFsEF7
         XWP7mJIJPhLo86KsSLDG7IugxxaYTMAKrdeeOcjkM9reP+V+Ce2mfcIsECeeCNfpHV9/
         uSKzLnGQObM2y58BztFJfB/RUHT/RFu+rUSprDxWHuRmRsxiGRwUF8kgzsNuQyo6pcgj
         6pL/FPhft3QTH5yMD4BROVrKfWcsQ6e8j34L0llZgrB/87JGxtdHayhHAJyffRwmdMog
         QbXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792025006; x=1792629806;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lt5sqE/A1UTQwYGO3mB+R7DENqnuvnMFQ9g9bPWPCTw=;
        b=n9d293blxBv/UJj7nQTyqRhOvFXRn87QUd/NUmffmskc2fvGPKiIEmziwl7iS/cxOn
         yfICa02uGaBtzEhfmvVFT9C8+8pH2n6QcjTtZcoJMr0y+0mfa+GrHaDKaNK+D0msfK6H
         EmiV8NyoTu85hLQMcSUbhL3UNKz7O1cUWcpGaSNJ5fSEmxivwxVdKZ2enpScdRFpNp8E
         SrAVUan0fARuivf3ApS2FU05KvRvIhEtBvBOBcWsAo3uFNDSP3mg4Rj9FZ1HMpPcF6sy
         EYFRwopZAe8CFIXhDjN5ulPqI+PoxJrc9a46nEiZgLesGXL5tsDu8FrZ/NUb3OZq/W06
         PAZg==
X-Forwarded-Encrypted: i=1; AKwUvBwsvKN+FFTOh8ASddOndKbfSBCOgB29aDwvw0knhw7NPI6ygIcx8LM0e2CHHaG4t4aLXX6FO9gQWkI2@vger.kernel.org
X-Gm-Message-State: AFq9FYJ5MG/ptUe8adTgVuS9+bPVATXxwZGAlz6zIzhRKXKUPQ/3SIJb
	XOgvZ/8xB4VNjfV+aMljC+zqvj4KoMFZ7pxC+wqbdZ/oQe8hV8e+dapARLcwqLg5vyDE5YAI+vM
	Lprgz4cNMkg2QA6Qx1MDt7Q==
X-Received: from pfbg13.prod.google.com ([2002:a05:6a00:ae0d:b0:888:f79:15e9])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:4598:b0:3dd:85aa:452e with SMTP id adf61e73a8af0-3e16be2fc4amr14607733637.32.1792025006252;
 Wed, 14 Oct 2026 17:43:26 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:43:24 +0800
In-Reply-To: <sashiko-outbox-172056@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <sashiko-outbox-172056@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015004324.3509676-1-stanleyjhu@google.com>
Subject: Re: [PATCH v2 5/5] scsi: ufs: core: Clear stale UIC result byte
 before peer DME retries
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Brian Kao <powenkao@google.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 15, 2026 at 12:32:04AM +0000, sashiko-bot@kernel.org wrote:
> Can a retried UIC command be prematurely completed by a late interrupt from a
> previous timed-out command?

This patch does not change that path. The retry loop and the UIC
dispatch/completion handling are the same as before; it only resets
argument2 and argument3 between attempts.
