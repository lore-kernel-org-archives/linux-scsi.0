Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B6F44C4FF;
	Wed,  2 Sep 2026 23:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788392893; cv=none; b=NyJ3zEmxspboRF9nOMLvV7P3rJbTj+LDrmgbsUbwnjuUDTVpiR0Uf1oPAbgl/AVY4ubb01U3YS9/G6gST/9T1grKKItkFtuUUGgFvRkLiKPJrjWx1Nlwlau+3Rk6Ya1P3+vJJQ3p1CWP70XkPHivwW5I8bKe/Co4XscQoGD+w1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788392893; c=relaxed/simple;
	bh=Eo7ra9z2bA0aaBishdVE7k1dujTMoQjHCSi05hRbaG0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cJFeSLkbUy2N2+zmkKpzyrWS+N21iC2+ctZsubOnQK8sfscousXUdsdwfIlu0tuOdU/Fwa1BbMEzIV9dh6WBfdYJrk4t8qHzYwj/uZd85txaM4XG0EpsrAn4f/49h8DfWOs5c9iDC7OKd+4TE1COd3flJ+tD/G8z8iysWa03WA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8zXy9+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8zXy9+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6964A1F000E9;
	Wed,  2 Sep 2026 23:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788392886;
	bh=i/GwMT4U3xnVi5MO4i6/tHZeK2B907WFmo17+jtp7Dk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g8zXy9+/OBdihwlKGzIj2liMZObR7ovzsPYsQd9EJR95DmUaR3g3TmWISSViGEonR
	 nPids4BANuHG43MrLlfzdcjyHzn1sVC9PeImw03/2AYDPaLuMccoN0sJVXeDE3RAhQ
	 EOVZ93HohilCISs9J4IEQ8CvC54h+/W60eGeAx2YRDuO2KrCTAy7u7z55VmxylvUjT
	 aDJ3WJWnIGlwMb8lQvq+OwZ3SvUn758eK3N0i5OtpGUTcKJPuQ3LoDZk8sOyjn+jhp
	 AikEcjw1lGVjrxASAGV+49aXE5N0sGdwZdzCpLsVDQDkN4iRDb+njK+eX3Ua/HMyCD
	 8gM+F6Fxoga+Q==
Message-ID: <d2d31879-b01f-4af3-836c-d0372f90c26d@kernel.org>
Date: Thu, 3 Sep 2026 08:48:03 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 36/37] ata: libata: use 16-bits defined sense codes
To: Niklas Cassel <cassel@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-37-dlemoal@kernel.org> <apgIfRr9MjNov6FV@ryzen>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <apgIfRr9MjNov6FV@ryzen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/2/26 20:29, Niklas Cassel wrote:
>> +		if (ata_scsi_sense_is_valid(tf.lbah, sense_code)) {
>>  			/* Set sense without also setting scsicmd->result */
>> -			scsi_build_sense_buffer(dev->flags & ATA_DFLAG_D_SENSE,
>> -						cmd->sense_buffer, tf.lbah,
>> -						tf.lbam, tf.lbal);
>> +			scsi_set_sense_buffer(dev->flags & ATA_DFLAG_D_SENSE,
>> +					      cmd->sense_buffer, tf.lbah,
>> +					      sense_code);
> 
> However, here you call scsi_set_sense_buffer() which is just an inline
> function that calls:
> scsi_build_sense_buffer(desc, buf, key, scsi_sense_code_asc(code),
> 			scsi_sense_code_ascq(code));
> 
> which will call scsi_sense_code_asc() and scsi_sense_code_ascq() to
> split sense_code to asc and ascq again.

Yes. I considered keeping the original call to scsi_build_sense_buffer() but
went with using scsi_set_sense_buffer() to be consistent with the fact that we
have the 16-bits sense_code and to try to stick with using it as much as we can.
I do understand that this is a bit silly to combined and split again the
asc/ascq, but this is all done only if there is a sense, meaning there was an
error and so things went through EH already and thus have been slow anyway. So I
do not see this as a perf problem at all and prefer to priviledge
readability/code simplicity.

> It seems that you series has decided to not kill scsi_build_sense_buffer().
> 
> As long as scsi_build_sense_buffer() exists, and since we already have asc
> and ascq stored in separate variables, I think we should let this code
> continue calling scsi_build_sense_buffer().
> 
> Especially since, even after this series, we still will have a call to
> scsi_build_sense_buffer() in libata-sata.c:ata_eh_get_ncq_success_sense().
> 
> I think either this function and ata_eh_get_ncq_success_sense() should both
> call scsi_build_sense_buffer(), or both should call scsi_set_sense_buffer().
> 
> Is there a reason why you don't convert all scsi_build_sense_buffer() users
> to scsi_set_sense_buffer() and drop scsi_build_sense_buffer() ?

The target code (and ATA code) fill the sense buffer from asc and ascq obtained
directly from command results, not from a sense code. So I kept that function to
avoid doing the combine/split asc/ascq everywhere. This is not great: blame the
scsi specs that define asc/ascq as separate fields while the sense codes are
essentially defined as a 16-bits value combining both :)

> You could even keep the same function name (scsi_build_sense_buffer()) and
> just have it take an u16 sense_code instead of u8 asc + u8 ascq?

Yeah, I wanted to, but that would mean having a single gigantic patch that
change the function use is all scsi and ata code in one go. I did not want to do
that to facilitate review. But if that's the preferred path, I will do that.

> (Doing a git grep scsi_build_sense_buffer shows a few users even after this
> series.)

Yes, I can completely drop it if everyone is OK with a few unnecessary
combine/split asc/ascq in some places.

-- 
Damien Le Moal
Western Digital Research
