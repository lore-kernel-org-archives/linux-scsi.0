Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152F082C60
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 16:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712940378; cv=none; b=NwJ5XwZ2Wqex2jut1FaR2drc9gfk9rX3tgq4PVKTkGxMQFeRru2X55mUJ4XuaJZ8Jw7ZiEIhOGkeTygfrICNL3UOnV5PGLRk5lCwaArDfaXDdPnSxAG/4mleEDb523o6iCv1qykm+0mE7Z3qFqw7Nca/xY687X849rUiwQ+uVhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712940378; c=relaxed/simple;
	bh=rNQ+jV9xLRCKXzKKGlSyU9fplBIiWR1FOTPvtA+dmVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YGL+ktW43EAbUGui16+k/xBbiolbgO4UnsWVD6KlFy+9RY2doxbd/PS5O4VETXGnteu65oViN+6UmrZdC6bzs9xa+2gbCCJFals3iwKP0BTEDJKU2wckl/DsN/d/iIYD3++LpcbZEoXRH0RWMIiR8GDOAq6y1fW8mdBEj5H6cd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FJzzhJ2A; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FJzzhJ2A"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VGMs42DQ1z6Cnk8t;
	Fri, 12 Apr 2024 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712940368; x=1715532369; bh=9RA0xjlcCM9ZsgcYlHjoR56M
	kM3/EbBonxtImkhwME4=; b=FJzzhJ2A3iUIdE85fPkq1tdEHMfAkIhZkNjY1Qnx
	nQYHSyl6Rz0EFuDnzu3gYY0mJCk1fUeY+pkfRXQ2JO9FpPkD3bB/P1RYu76rAguK
	iRDJPiy6Mhy23rgtFOZ5JYvuLc3xcP0ZYObyAhMOhXMoT1yer95sBFKNlbOstsFC
	aadFCUIcETyElV/ayCGnqnyqx8AaZn+F1Jhefd9msBQ86rpQIuwxHjwPzHBO4/n0
	SMlkoixKynV2F0lvMbtIUb/W18U5c2gN1HIgAtxi1Jp+4zEa08biVTImV7/UL4vW
	vK5itQjWJrhL8qw5xtEH121E5J4YWnX51MryhhZLmsIuuQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ExSBypeF6Pzg; Fri, 12 Apr 2024 16:46:08 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VGMrr36s0z6Cnk8m;
	Fri, 12 Apr 2024 16:46:04 +0000 (UTC)
Message-ID: <4b0d6ae8-3370-4ad4-989b-ed7c640784be@acm.org>
Date: Fri, 12 Apr 2024 09:45:59 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: ufs: Make the polling code report which command
 has been completed
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konrad.dybcio@linaro.org>, Stanley Jhu
 <chu.stanley@gmail.com>, Po-Wen Kao <powen.kao@mediatek.com>,
 Can Guo <quic_cang@quicinc.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 ChanWoo Lee <cw9316.lee@samsung.com>, Yang Li <yang.lee@linux.alibaba.com>,
 zhanghui <zhanghui31@xiaomi.com>, Keoseong Park <keosung.park@samsung.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Akinobu Mita <akinobu.mita@gmail.com>
References: <20240412000246.1167600-1-bvanassche@acm.org>
 <20240412000246.1167600-4-bvanassche@acm.org>
 <DM6PR04MB6575F0D8B742E1328E73CB97FC042@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575F0D8B742E1328E73CB97FC042@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/24 02:14, Avri Altman wrote:
>> -static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
>> -                                  struct ufs_hw_queue *hwq)
>> +/* Returns true if and only if @compl_cmd has been completed. */
>> +static bool ufshcd_mcq_process_cqe(struct ufs_hba *hba,
>> +                                  struct ufs_hw_queue *hwq,
>> +                                  struct scsi_cmnd *compl_cmd)
>>   {
>>          struct cq_entry *cqe = ufshcd_mcq_cur_cqe(hwq);
>> -       int tag = ufshcd_mcq_get_tag(hba, cqe);
>>
>>          if (cqe->command_desc_base_addr) {
>> -               ufshcd_compl_one_cqe(hba, tag, cqe);
>> -               /* After processed the cqe, mark it empty (invalid) entry */
>> +               const int tag = ufshcd_mcq_get_tag(hba, cqe);
>> +               /* Mark the CQE as invalid. */
>>                  cqe->command_desc_base_addr = 0;
>> +               return ufshcd_compl_one_cqe(hba, tag, cqe, compl_cmd);
>>          }
>> +       return false;
>>   }
>
> Maybe elaborate on explaining why the tag isn't enough to designate the completing command?

Hi Avri,

Anything that uniquely identifies a SCSI command would work. I think
it's more a matter of making a choice rather than arguing why not using
the blk_mq_unique_tag_to_hwq() return value?

Thanks,

Bart.
