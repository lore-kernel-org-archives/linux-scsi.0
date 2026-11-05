Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793857868;
	b=if/WX4z7ZrWlq8+GOL+jGUXT+AQB+cyXo3xbAbQaPHoMP685s3y05nLcaXq48YuI90sk
	 nSRsia/foxe0n1s9KXGnQHOF+DDeY1NKVu7RSPoS3ldwzzBAb5UlPE4aZRcwUODV7sfij
	 k+YNyK2ktF0hvgrRZ8ZHDp+iwpekBFpQ58yT4csJVWNFqkqjyNFM84FW5j/aaeZhb5VmV
	 K2a4EoEG4/2bq++a8F6QWSkXWJpTcnLxzPIO5Wfmm1jQbfg22SPLQ47wiOwjLQ5tnlXW9
	 r6oqC9s9aQQ+iYWMvkjSjuDtFQOUIza02HKeHxKKw/GUxvK+mmBiijq3tTV11LRbDyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793857868;
	h=DMARC-Filter:Received:From:Subject:Date:Message-ID:In-Reply-To:
	 References:To:Cc:Content-Type:Content-Transfer-Encoding:MIME-Version:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=42OhsrUJtAqO2XjRqgk8J+VMhveaxdciAxbMrx+F664=;
	b=mm/56l5ON372OPC8E1T6ZJ88qgHsHKs9BXdKOqqxtI4umZR31pul+Xs/PzyxkX9z5pwu
	 STOodxrUThkbudCTmy5N/Xg77Ygtv80QbYKHF+p3EfUFRsxj0lgAaYkwvcqw01qYjYAOy
	 zGANmF/9EHJzZ3v65d6O2vpU7860sjQj8Nnw3hMPXeFf4WLwsVnZ/CKGEZnoNYisxtlM1
	 3E35kCmp+j9sv4Z2+nhHyaAm6dGX4Pn8OYn6kRdluujbuVk63QZ1Asa2kib20fcMwUKPB
	 i/7wpdv5Ca/oRGYCldaF49NN6WLvqLUHQBuK2HRV+f/R5NAD/0pMzUDJ860nKL5NZSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668CF606A326
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 05:51:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 668CF606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [172.100.0.8] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowABXZZY+GexqVEdTAA--.16230S2;
	Thu, 05 Nov 2026 13:50:54 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
Subject: Re: [PATCH] scsi: myrb: unregister the SCSI host on remove
Date: Thu, 05 Nov 2026 05:51:03 -0000
Message-ID: <179385786361.1679257.11036002925458972121@iscas.ac.cn>
In-Reply-To: <536a5a8f-00e6-4ec4-9fd6-c317ef1b5ce4@kernel.org>
References: <20261104021419.1468133-1-vulab@iscas.ac.cn>
 <cb17860c-5388-431a-8734-b66dd1efffc4@suse.de>
 <536a5a8f-00e6-4ec4-9fd6-c317ef1b5ce4@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>, Hannes Reinecke <hare@suse.de>,
 Hannes Reinecke <hare@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
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
X-CM-TRANSID:rQCowABXZZY+GexqVEdTAA--.16230S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WFW3uw4xKFWxur1xArW8JFb_yoW8XFWkpF
	ZxKwn0y3srAF1Ivrs2v3W8tFy8ZayrJrWrJF98WryUAwn8Xw4IvrWvva18Z3ZxWan3Gr4a
	vw4S93WDZF4YvaDanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvKb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
	w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26F4UJVW0ow
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK
	82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x07b8J5wUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgYCA2rr-LFh5wAAsL

Hi Krzysztof, Hannes, all,

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

