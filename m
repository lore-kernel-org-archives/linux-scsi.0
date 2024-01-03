Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEF84A0D;
	Wed,  3 Jan 2024 00:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBJ1CRuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6731CC433C8;
	Wed,  3 Jan 2024 00:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704240152;
	bh=g9r3G9V5xJz2Gaj6MeWkVtAQ1b0eUPtfCXR750Wsrpk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OBJ1CRuLoeiphkxiVOqt7KYgBqZ0m6b/GNHD5bXwMiWwZqeJwQ1RXuVWVww3g6vU6
	 TqLNwjBCEbvEBQLW9jSDlNzdzoaq2Vw2JNskuJQ2iNo4RCEwHKO51ps6zRuXQ5ouiw
	 795Cr77+rGnchFkKdQwgOpRaEdMGxJZ5W31kh2yIR8QCTrLxY20ELQ+42UFiWp8fyB
	 aYzjJaGEeq2hIYSZvw+grIIiuynAHrzUhcqnsW0cA4Qf8t1aYQTSXAAKKBpgoIt0Ee
	 vFMECgK9olRdU9kbqEAROwT8BwjhPQKvVDaF1jb3Cyw3PSBPnSojxzzsl0Emr8TsbV
	 HWuswArI5CkRQ==
Message-ID: <9d9f421e-08fb-44a5-8d07-ccf5f55db468@kernel.org>
Date: Wed, 3 Jan 2024 09:02:29 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: remove another host aware model leftover
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org
References: <20231228075141.362560-1-hch@lst.de>
 <6933c048-f77b-4645-a667-adae0f89b347@kernel.org>
 <20231228171445.GA25852@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231228171445.GA25852@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/29/23 02:14, Christoph Hellwig wrote:
> On Thu, Dec 28, 2023 at 05:45:29PM +0900, Damien Le Moal wrote:
>> On 12/28/23 16:51, Christoph Hellwig wrote:
>>> Hi all,
>>>
>>> now that support for the host aware zoned model is gone in the
>>> for-6.8/block branch, there is no way the sd driver can find a device
>>> where is has to clear the zoned flag, and we can thus remove the code
>>> for it, including a block layer helper.
>>
>> Hmmm... There is one case: if the user uses a passthrough command to issue a
>> FORMAT WITH PRESET command to reformat the disk from SMR to CMR or from CMR to
>> SMR. The next revalidate will see a different device type in this case, and
>> SMR-to-CMR reformat will need clearing the zoned stuff.
> 
> scsi_device.type is only set in scsi_add_lun and thus can't change without
> a re-probe of the upper level driver.

OK. I was worried about what might happen with libata/libsas drives, but
checking the code, ata_dev_same_device() throws an error from ata_reread_id() if
the device class (device type) changes. So that will force the user to do a full
rescan for this corner case. I think we are OK.

Feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

for the series.

-- 
Damien Le Moal
Western Digital Research

