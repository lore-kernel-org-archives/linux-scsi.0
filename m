Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1F0199222
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727907963; cv=none; b=OAJ4UhVdy0e1JKVCWelC9CP2MenlNZ/OTcrayxrh+1ozKbz+PYvwYxK3v/wttFKeQIrHLRD/n5Ikpl3kcWg1Akd0b+8w78+1zGpDmj3rmh/t4In7GlXmgj3wtS1Nz+pSvuJU3BZZ5sQQHGRWVVAe36lGo5UN1KroPZTM24XaEmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727907963; c=relaxed/simple;
	bh=I4XFZ1jwqjNLc0GiTdFSmi/TxX1oq0Au2lfbb1BDruo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MNvmpz4FgSft/+ezU21mHho8HASecB78EK6ab4DkQMsBmdvWFDm1dSX8WynEMl4RDNpVYVi0OzSfryoaoXX2jUOcTzTVzUfieNJUFbrg+O/bDMgTEtyYqel0fyuRzYlB0yB/Tabd6beJzAMg3U67kk1wIc0mibkxLWx1pl6fBok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxxHvhw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxxHvhw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF58C4CEC2;
	Wed,  2 Oct 2024 22:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727907963;
	bh=I4XFZ1jwqjNLc0GiTdFSmi/TxX1oq0Au2lfbb1BDruo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lxxHvhw3U63HniC3rXose73v9gS+FffED4tLegs9gE4CjDXU29lCBR/P+7d+EhDW0
	 Aa4YX2dGqN4o/AEYeczVnwUnLwza/MopRrMmyuAPd1S/bS5NwiEfabx3ZPw9Ktgv6g
	 EdasFcUUvcCsDqbr+fth1TOjouj1x1ieDI8BnMMtMCpt3Q7r8O/C44Mqnt58Y1lzur
	 U2rxrKiDqABmAOYmJxByGTSZLrYv4L+F6PMbJ4T1Ya9Dn0sONpJULWbo4VkyDC1B5i
	 WnKjRgzYAH2tZP/qg4Ou7LqKi7wbxiR0vLyjZ/+qcboZjbLtYIuJB7qlsnJ0KNLxUr
	 i+FbWUm5QTomQ==
Message-ID: <9adb1b8a-5b46-42da-81c3-76c8ed50f3c1@kernel.org>
Date: Thu, 3 Oct 2024 07:26:01 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: Rename .slave_alloc() and .slave_destroy()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20240930201937.2020129-1-bvanassche@acm.org>
 <20240930201937.2020129-2-bvanassche@acm.org>
 <5b3e96da-9fe9-4eb5-ad0e-0377622df5c2@kernel.org>
 <376dfcb4-a25d-457d-acdd-4af77290b05b@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <376dfcb4-a25d-457d-acdd-4af77290b05b@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/24 05:23, Bart Van Assche wrote:
> On 9/30/24 5:10 PM, Damien Le Moal wrote:
>> On 10/1/24 05:18, Bart Van Assche wrote:
>>> diff --git a/include/linux/libata.h b/include/linux/libata.h
>>> index 9b4a6ff03235..e04184b6d79b 100644
>>> --- a/include/linux/libata.h
>>> +++ b/include/linux/libata.h
>>> @@ -1201,10 +1201,10 @@ extern int ata_std_bios_param(struct scsi_device *sdev,
>>>   			      struct block_device *bdev,
>>>   			      sector_t capacity, int geom[]);
>>>   extern void ata_scsi_unlock_native_capacity(struct scsi_device *sdev);
>>> -extern int ata_scsi_slave_alloc(struct scsi_device *sdev);
>>> +extern int ata_scsi_device_alloc(struct scsi_device *sdev);
>>
>> While at it, drop the extern.
>>
>>>   int ata_scsi_device_configure(struct scsi_device *sdev,
>>>   		struct queue_limits *lim);
>>> -extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
>>> +extern void ata_scsi_device_destroy(struct scsi_device *sdev);
>>
>> Here too.
> 
> Hi Damien,
> 
> Can I declare removing superfluous "extern" keywords as out-of-scope for
> this patch series? There are plenty of superfluous "extern" keywords in
> many Linux .h files. Removing the superfluous "extern" keyword for the
> functions renamed by this patch series only probably won't make much of
> a difference.

That is fine.

> 
> Thanks,
> 
> Bart.
> 


-- 
Damien Le Moal
Western Digital Research
