Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793857869;
	b=zKe2IHTeWN97Z3/XAPDyOiBlXD/8lAVcEIfjuyEKsKx4iCtT+OVQo5LoLybLZ5saFDp4
	 vzzXGy3fhsPxEt5JZZ1ajFqEZ5BQRFcfHFdPrx48M+7pFSpenxLJpZklLFRRHqiiMV+WD
	 DS/nrO53a8e9V88GmscXGBlYYCZtQgYmXC1XaUNInMvCo3VnKmFwwhSF2JBEhUZe55psg
	 BNedCLHozAwzHLwG3LkNQyw2rZ/39LNYc30JafRcohGyc9n/X9KAeq3TfDCKxySWdt9B4
	 TTZkFMdHzPBGqxjZjzz9LK5TWjrH6epCMm0O7EAffNkr3XDwv+K8owBUwWJZ2B7klag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793857869;
	h=DMARC-Filter:Received:From:Subject:Date:Message-ID:In-Reply-To:
	 References:To:Cc:Content-Type:Content-Transfer-Encoding:MIME-Version:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=GdStonyp7Sj2fAw+HeddqwyrhIi5pFh7iyxBgjQwIFE=;
	b=H780IGVZ332cetaUZx+yLfOoZLC1O3AeeeHP4powwhkhN4yd7atWfMGN5vyszKPE3F8i
	 vtoKVIkwk14t3ycROya27G3rWQBFjje8GpF9X44sQ2JZ8diX5wBoNYDNf5IP814iGWE/a
	 bDuUVnXQCbFsKzp0WxBPjAkCUdGQaez1gAWTEjOPZA/Cn1Ijc+0pKBU8yY9Tun+5TxTNw
	 8husrIyGKEHpy3msJYFshiSkiBQ8g5RAoNFLl0gf5Y/R0zO/yxWUwLT7dPcLIbeVZ/vIh
	 8qg/Y85g6jEuaNvhNRY5O/D1Ddg6YMX2l6/STc766OobF22qqff4X82ej+kudVB9mDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D834606A328
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 05:51:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D834606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [172.100.0.8] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowACXoZI+GexqUUdTAA--.12628S2;
	Thu, 05 Nov 2026 13:50:54 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
Subject:
 Re: [PATCH] scsi: pm8001: unwind the probe on ccb tag allocation failure
Date: Thu, 05 Nov 2026 05:51:03 -0000
Message-ID: <179385786361.1679257.8918146954526006640@iscas.ac.cn>
In-Reply-To: <20261104-fragrant-fascinating-civet-9c5cd8@quoll>
References: <20261104021411.1467970-1-vulab@iscas.ac.cn>
 <CAMGffEkj=rzCiiek=p+9Qc2AjJ1Nkk00H8wFReQ9-0ptWHKobw@mail.gmail.com>
 <20261104-fragrant-fascinating-civet-9c5cd8@quoll>
To: Krzysztof Kozlowski <krzk@kernel.org>,
 Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-CM-TRANSID:rQCowACXoZI+GexqUUdTAA--.12628S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WFW3uw4xKFWxur1xArW8JFb_yoW8XFWfpF
	ZxKwn0y3srAF1Iyrs7Z3W8tFy0vayrJ3yrJF98WryUA3Z8Xw4IvrWvya18Z3W3W3Z3Gr4a
	vw4S93WDZF4YvaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF
	04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWU
	twCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUDd
	gADUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwgCA2rr-KhhaQAAsT

Hi Krzysztof, Jack, all,

I am very sorry for the consequences of these submissions. You are right
to question the safety of this patch and the way we have handled these
submissions. I apologize for the inadequate validation, the volume of
patches, and our failure to respond to earlier feedback. That has wasted
reviewers' time and damaged trust in our contributions. I take
responsibility for my submissions.

I want to state clearly that there was no malicious intent behind these
patches. Our intention was to fix bugs, and we did not intend to insert
security vulnerabilities or deceive reviewers. I understand why the
combination of potentially unsafe changes, repeated submissions, and
unanswered feedback raised this concern. Intent alone does not make an
unsafe patch acceptable.

We did use AI assistance, but the responsibility for understanding and
checking the changes remains with us. We should not have treated a
single local reference-counting change as sufficient evidence that a
patch was safe.

Once again, I am sorry for my actions, and I will do everything I can to
address the harm caused by these submissions. I promise to respect the
requested posting pause and will not send further batches during this
period. I will personally reply to all of the feedback I have left
unanswered over the past month or two. Until I have completed those
replies and received your permission to resume, I will not submit any
new patches. I hope you will give me the opportunity to make things
right.

Best regards,
Wentao Liang

