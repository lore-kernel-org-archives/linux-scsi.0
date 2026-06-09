Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476273A0B31;
	Tue,  9 Jun 2026 09:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780997717; cv=none; b=f016HJVHI4MN67UPcWo8CcyX4mjrgeBpL+aMnitB1PO5Vf6goBQAj1GxgsBLykmsiVkUloP4/TTbWfbawRK6dA7dQp+O3Lr5y8Eb0MTtmkhtOTbHfct51Dp23UYpo5LghKfri+aZGkDwFHMGf5Z5kVnjVCzMLnV97l5TNT3NR4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780997717; c=relaxed/simple;
	bh=Ihobr2NoPz+IDgT5CzNxs/60fUZ6UiSQdfpcZZbFJWk=;
	h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mmHHahcq68ZM/XciKa7n447O7tNjYrK2t7On2v0tYCjUaDT2Q4H2142CutLR5Sxn3sOOTe4SeDjyDLGTXD865nKtVOJ3PeZSlohBnzlkjqig2foFSqrGNBm0DPKrfW3WRez3vsRChXPdj9L4I+Ix9J/mgwCcMVEaWBCIy9Tomlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8DxFOhQ3idqBTQSAA--.42462S3;
	Tue, 09 Jun 2026 17:35:12 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJDxjcJN3idq9aigAA--.40227S3;
	Tue, 09 Jun 2026 17:35:12 +0800 (CST)
Subject: Re: [PATCH] scsi: megaraid_sas: Add dma read memory barrier during
 complete command poll
From: Bibo Mao <maobibo@loongson.cn>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhangtianyang@loongson.cn
References: <20260529012620.815886-1-maobibo@loongson.cn>
Message-ID: <f7ad0956-fefb-4933-6a62-20846d3314ad@loongson.cn>
Date: Tue, 9 Jun 2026 17:32:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260529012620.815886-1-maobibo@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxjcJN3idq9aigAA--.40227S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Ww1DGFW7Jr4rXw1UGw1UXFc_yoW8Gr1fp3
	4kG3WUtw4DX34F9an8Cw45AF15Xas3Gas5tan3t34Y9rZ8KFyYyr4jk3W5CFySyrn5K3WU
	Zr4qqrZ5GF4DtrgCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUxYiiDU
	UUU



On 2026/5/29 上午9:26, Bibo Mao wrote:
> Control dependencies do not guarantee load order across the condition,
> allowing a CPU to predict and speculate memory reads.
> 
> Add a dma read barrier before reading the complete SMID entry in
> structure reply_des and after the condition its contents depend on to
> ensure the read order is determinsitic.
> 
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>   drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 2699e4e09b5b..6ec6e5fa71ce 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -3589,6 +3589,8 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
>   	while (d_val.u.low != cpu_to_le32(UINT_MAX) &&
>   	       d_val.u.high != cpu_to_le32(UINT_MAX)) {
>   
> +		/* Read SIMD after ReplyFlags and d_val.word check */
> +		dma_rmb();
>   		smid = le16_to_cpu(reply_desc->SMID);
>   		cmd_fusion = fusion->cmd_list[smid - 1];
>   		scsi_io_req = (struct MPI2_RAID_SCSI_IO_REQUEST *)
> 
> base-commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7
> 
Any comments about this simple patch?
gently ping :)

