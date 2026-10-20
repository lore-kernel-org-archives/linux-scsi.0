Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484840;
	b=NAxKrY/U1SRh/Aw7POwv2V8jT2HZCof0MP3tCrQzEnCRp58GRyO+08o+Q5F52oETItQd
	 K+UYA4//ddtWyQcqak+sjJw1EFbJ7mOuiE0AxO7BDN3n+OJk7uWFfM8rmhOHwTQrpADjs
	 K1l/RVV+NaE5LFSdkHAFXPqBbC3gTaXCoh9oVErWOkdhWeLkf3f3HMkULSnbWyd/Spttp
	 z4rwVDHaeaU9xU2BorpChuLkQDJ5qnGYmU1TXJuxWVIjpmxy7WAvmO3tsev1NCur8O1aM
	 d5HMeAHruLnwQnuNxlteaM3SJrWpA3OzuPcD/igczUT8SPRNu0U5Zfonff7Dozr6DNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484840;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=kX5wt9uloTBUKENvuugEarR+eHumxWJlY0qWlOLNBew=;
	b=Po4VGlr7l2l2Au7FeqRc4MJzNgin+CfH4rimVfuXbq272AcZR2wMIwfMTiNC5d02vsYl
	 wPWvQg7caichTqg8eWvKXVHGWAEe8QDmquBeKySrrvS+dGgEnNs/50UwEPr2xjocGXokp
	 bH6t3GIjcsdOR/RmF6kj5nlEUqw3I0RUOgXxhLdEFOL6oOjkZ4W8I7yr2hvAilzvxEn8J
	 NlimZbElzHzgkJIJiBdIoJEYKbhlYyD4aKoczl+tJgvZCuuARizoynKJHDaglLKa5BmPx
	 QPEcu4cjaF8gQNCQ+e0UM9ZvZwqRbVYk6T3Ourm0w5C8dKt78mNz+S5du5RiYdJRJGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=iUAtxhlc;
	arc=none smtp.remote-ip=209.85.215.198
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D843660A261B
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 08:27:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D843660A261B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=iUAtxhlc
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cd0cf3b1c70so2046134a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 01:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792484839; x=1793089639; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kX5wt9uloTBUKENvuugEarR+eHumxWJlY0qWlOLNBew=;
        b=iUAtxhlcoUBtjAQsA2ZKXqqDMSMvLIdtm9auFahckVtDcaW8+Ak6DrnJYAllkMPAbW
         m7WHL1NJfvdBHNa77/9ZX/1+LxT0UzpCDKG5VdiWRP5P1/wX7aGXoyNn7WUUcyPDK0eH
         6EtKfSXwGJ9cXaG9+VGSYz03X8BEAzQbVMDbD2bw+EC/jGpUsAYElhgU+2PZh1LdgJL0
         j7qfUrEFB1p+AfT7q1qdQGlHZgBeuwQe0qK1nihU/vuXYjiXy20mp8WEWGlV/EEV0+XM
         UcYwqLeRdq/pYDWdpDNvV2avQAExYjyIZJZ548BT7KRGtY32bfv51lnqR7Y0hyVfX1Ek
         c/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484839; x=1793089639;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kX5wt9uloTBUKENvuugEarR+eHumxWJlY0qWlOLNBew=;
        b=T/9BerukR0Cr2xC7kZopQBQdvgnRZbKK7dWF3wQAtKlqlCzfBO8KRBsleNI+BrX8KN
         6+/dxOtxlUJzVMVNrsjJXkRY/Zak5paHUWPuec66J89XUhwoC8vizEUJ+DvlBCE9Aah+
         AmxUHyvxALXhCKrrLSdDpb25ATtDRDZVU5SHIL2yAp0n3s2b/Sc3uJTpgU2x11YafshV
         V5wmr5dhVWrTuhbt3ob3y0dqb3KKJw4QOE9GAyCHHbGyYyDORLadoY94YISV6g5LXQMn
         RAbQeK9I/71wIrC8V6yp7aJ2iQuUAIzWP0vKrPdVkRzPJy+fSAdXU97lr3/Ce4Q0fdtj
         Eurw==
X-Forwarded-Encrypted: i=1; AKwUvBzZuCB9+V5uL8FW4edifUnTy568dagenr3/uuEWxr9T/jATeukJoOTDBu1pOPVr9lLqy559011nDTio@vger.kernel.org
X-Gm-Message-State: AFq9FYKSt6GKvqMcOx2BjlxPwvQwkIVnDMawVCol/WuYxTkMsYWBzVKD
	zg0LFn2cLT/PFO+NLXraM1+mjKSbGQxwLEe1e3Yaz/2/7F41Tvl6a3bw6+3po2U4UelOYfTy2a4
	xGZoXlv7d8TiO6w22Rq3l3w==
X-Received: from pgp6-n1.prod.google.com ([2002:a05:6a02:62c6:10b0:ccb:62e:3f01])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:a120:b0:3e2:257a:a61f with SMTP id adf61e73a8af0-3e226025463mr9267663637.59.1792484838935;
 Tue, 20 Oct 2026 01:27:18 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:27:17 +0800
In-Reply-To: <78888420b7c60d2d5177cbf76f5efba04fab5d7b.camel@mediatek.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261017084403.875420-1-stanleyjhu@google.com>
 <2e042211ca0ebc974ad5ec4c0de9f3f93b3c75c0.camel@iokpp.de> <2060a8da-581b-46d1-a510-779f4df716cd@acm.org>
 <78888420b7c60d2d5177cbf76f5efba04fab5d7b.camel@mediatek.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261020082717.3540301-1-stanleyjhu@google.com>
Subject: Re: [PATCH v2 0/4] scsi: ufs: core: Factor hba->outstanding_reqs
 helper and fix double completion
From: Stanley Jhu <stanleyjhu@google.com>
To: Peter Wang <peter.wang@mediatek.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@iokpp.de>, "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 2026-10-20 at 11:16 +0800, Peter Wang wrote:
> So, should we remove the call to __ufshcd_transfer_req_compl from
> ufshcd_abort, which was added by commit
> 64180742605f ("scsi: ufs: Fix the SCSI abort handler")?

__ufshcd_transfer_req_compl() is a wrapper around
ufshcd_compl_one_cqe(), so calling it from ufshcd_abort() has the two
issues Bart noted. In addition, ufshcd_abort() called it without
clearing BIT(tag) in hba->outstanding_reqs, which left the command to be
released a second time by a later ufshcd_poll() or LU reset.

In v3 6/7 [1], we replace that __ufshcd_transfer_req_compl() call with
claiming BIT(tag) via ufshcd_clear_outstanding_reqs() and calling
ufshcd_release_scsi_cmd() if it is a SCSI command, matching the end of
ufshcd_abort().

[1] https://lore.kernel.org/r/20261020082110.3511797-7-stanleyjhu@google.com
