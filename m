Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD5B52F88
	for <linux-scsi@vger.kernel.org>; Sun,  7 Dec 2025 21:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765144139; cv=none; b=YuXdSWYzWu4pACS6NNyaXVp18GcVqbk7iBc5sbbEaJuZsOtlUeKrNCtce37j8/VLMPfNS5x1kFgpyiQ6Hz8CDtYVDuZ1VUdmJgADLWFj2i7E+xTDp6i/sG1lXPq7Vnact460x0e4p+eIb7iCABhucoOvGX3DYMsrx6kVjFtDb8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765144139; c=relaxed/simple;
	bh=x41bk8/bG8C1SvpHmRak9vofogCgnix3bLXOKySwiFg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Yfh3xc6sMb2/QSs1C47vOKNhZpzTSvTl4OYJRGnjqmVBnPj2YfqAY3ABeSrz1n+8r1oNqhjKUIoD+0CgVhIUTDTh3FgdbAOQSMP5qM3VUnZF7Qtv+gqw3GbKS0xdU7EfV6xRSO3BIXqmYdJi6eKSkwSW1KB3ocUuxmmHYq06l8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=arW6bDt2; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="arW6bDt2"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so49366365e9.2
        for <linux-scsi@vger.kernel.org>; Sun, 07 Dec 2025 13:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765144136; x=1765748936; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x41bk8/bG8C1SvpHmRak9vofogCgnix3bLXOKySwiFg=;
        b=arW6bDt2MKP++PXKN4yeqtHBkIjcAEwuDVLVtW1hm8ZrD1qZH794u4FmZuGIQfRyqy
         OqtLh3Utmj2Lj2bLdO9nYojuFed4286igJpelXU4f2jXcwLkJX3iaPHQQNzNopL7zWs+
         TWNkP6n+YrC5zAjoqyT3L4MzWPc5E/XtXUqUy1kQPze6w+7D14Zwn+UPcyHU0k/okDyN
         2inSi5gKobBZSsD7KJIbxDOn4wpy58DX2VbKKhmtl/RQ36O7ej1C1QKupBtQi8DlXawq
         4dt7Xgww+3QU+eIhhJbb+if9eQOBW2cwUH7GHxj5nf9sgEQAPmgaIhPxoZ6OgiNQ3fUM
         I5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765144136; x=1765748936;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x41bk8/bG8C1SvpHmRak9vofogCgnix3bLXOKySwiFg=;
        b=h/lmy0m+j/GFWZ3ZwNYar69LeAFKicY7gkm/PN4joNx/nY2yb8q8ST4pL6N4IR5wXr
         3vWK7u0QVUXCFq1M+TYhKX2x4OUg6dL06C1XITb4Wt+VkrroGZZdwKFX24EmkQeRPHy5
         38xFe2VR4poX5Z1ufUyXXbr3Rd0tNNO2uO0xNHFlEAdZy4yyDTmGzbV/bOwrafJnTJP4
         p40NY1UHRusQaJbfHfadgo2+ZS8NyTuK60tJFp2P/ZI+q8Gd2Ipa34Xv6wqhG+BxLh1Y
         ggwJPa7GuyfFRjmcdCKbhh5td2WMZ3R08nCfPtPCZehmmvOfi1txRmC5nRwricWQxzB/
         TIZA==
X-Gm-Message-State: AOJu0Yz4ZJ8hPcKs2nS0kt5QLCs0VYeM9dYC8N5uQ4XfA2MFE0dHE7fh
	fVUP5eqRs/RTGpi8egQQOrMpWm4qOGcCQHmcxZ+CFgsjSIi83S7JOwNRd71lkdObvF8=
X-Gm-Gg: ASbGncs6uqmpsdis4BxklH7xE/8QdjNVD2UaEkK+lECuB0gGYhQd+K3NNfGYJJMPnCX
	O1JrE3ISQeV9vkNKZsYpKconesop9ZkOo6Dr6ZbbTfFlUEIGYfFcu7vqWgpelx3wZXmGWbBY8r7
	RJt6do/hLAjXilwV8RJsxlOukvraAbt8Fk/k7yLJc1MjJYwViCFLYWIu9YlUGob9xK1Ty0KV88i
	fvlYtqb6buyCAuyWADN1bHiBr5nuEJjoqa+j8avBvIsC4GCGDTXU+x53otngxJDxuuqAjLVUhdE
	s7IYHIwjKSbqWttrNwXGJuLaLtxVXnc3g1N7ZRp2zSnJ6GNG+qVwz9Hr5zgghK2523fmnyRLVEh
	VmuhRYbUjiATjx2JLdvQWcWwd539QT1X9QarI5RdS72b7i9M1n9ddceNWSL76yCyX84F4hMvonf
	N8t1GvrmGdtchdkPA8a8sh3vfbfF4=
X-Google-Smtp-Source: AGHT+IFObw15gUEw72WDQRON8fhv2pdsC0B2KeNYbK3jGB5V2TEMQylNojEhSITYudY/qPiCr06BOA==
X-Received: by 2002:a05:6000:2891:b0:42f:8816:9505 with SMTP id ffacd0b85a97d-42f89f58e5dmr6260694f8f.61.1765144135934;
        Sun, 07 Dec 2025 13:48:55 -0800 (PST)
Received: from localhost ([2a02:c7c:5e34:8000:da07:24c6:f91a:9817])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfee66sm21827912f8f.11.2025.12.07.13.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Dec 2025 13:48:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 07 Dec 2025 21:48:53 +0000
Message-Id: <DESBDGL25AYP.16RFXFVTC92H9@linaro.org>
Cc: <linux-scsi@vger.kernel.org>, "Manivannan Sadhasivam" <mani@kernel.org>,
 "Roger Shimizu" <rosh@debian.org>, "Nitin Rawat"
 <nitin.rawat@oss.qualcomm.com>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Peter Wang"
 <peter.wang@mediatek.com>, "Avri Altman" <avri.altman@sandisk.com>, "Bean
 Huo" <beanhuo@micron.com>, "Adrian Hunter" <adrian.hunter@intel.com>, "Bao
 D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH] ufs: core: Fix a deadlock in the frequency scaling code
From: "Alexey Klimov" <alexey.klimov@linaro.org>
To: "Bart Van Assche" <bvanassche@acm.org>, "Martin K . Petersen"
 <martin.petersen@oracle.com>
X-Mailer: aerc 0.20.0
References: <20251204181548.1006696-1-bvanassche@acm.org>
In-Reply-To: <20251204181548.1006696-1-bvanassche@acm.org>

On Thu Dec 4, 2025 at 6:15 PM GMT, Bart Van Assche wrote:
> Commit 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()"=
)
> accidentally introduced a deadlock in the frequency scaling code.
> ufshcd_clock_scaling_unprepare() may submit a device management command
> while SCSI command processing is blocked. The deadlock was introduced by
> using the SCSI core for submitting device management commands
> (scsi_get_internal_cmd() + blk_execute_rq()). Fix this deadlock by callin=
g
> blk_mq_unquiesce_tagset() before any device management commands are
> submitted by ufshcd_clock_scaling_unprepare().
>
> Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()"=
)
> Reported-by: Manivannan Sadhasivam <mani@kernel.org>
> Reported-by: Roger Shimizu <rosh@debian.org>
> Closes: https://lore.kernel.org/linux-scsi/ehorjaflathzab5oekx2nae2zss5vi=
2r36yqkqsfjb2fgsifz2@yk3us5g3igow/
> Tested-by: Roger Shimizu <rosh@debian.org>
> Cc: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

This fixes the regression of freezing/hanging boot in initramfs
on Qcom RB5 board with recent linux-nexts. Thank you!

Tested-by: Alexey Klimov <alexey.klimov@linaro.org> # RB5 board

Best regards,
Alexey

