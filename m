Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C3242A83
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 02:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750040911; cv=none; b=RgMhsreNDaeHGq6roLunPTYCQDYKNTSiG9uX3RsSwAQ59w8Bc1d4jEWn6tuZVUW1jVIR4hZ5hBKXMI0fhoCe07jj78mHwFMefp+UrMznE9NqN7WG8JQ+68Z6RJLA/mzvJiKlb8SzMOvhpGjDvZ7ppi6COk15tZbfFs6WgNa6IUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750040911; c=relaxed/simple;
	bh=Lr5XniD6xJgKsimOAlSL86dbFs0urVgYcRWmjU2mYk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RZQHXlwu2+Ghe0UzlpDo9r9d90zDTXFbFAzU12alkZKQBmNiH9ln6wkK2l7/EjcxI8lzMm8J0vlOjMZyRHht1Xi/9tFaQhL1f8mI+HNPPc6O4nyoM2NZo2Tpm4vkmmNQJ5Yhy95m90rXEcpYmlxlkGgjPdIRpScjfnaHLlzg/oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIvTBZxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIvTBZxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41051C4CEF1;
	Mon, 16 Jun 2025 02:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750040910;
	bh=Lr5XniD6xJgKsimOAlSL86dbFs0urVgYcRWmjU2mYk8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tIvTBZxeDcleOrAvlB+/5o8jg89BpVj+WMzF7tMdY/fYj1jgT78u0ICA/r4zwERwk
	 wNxOAug0jYshDdMlAsruEuGa8ukH2xzm90sdKkYgXFIGPO8fLgwd66HaUc+qlaKcTB
	 uhw+k+vGn+NoSM2GDaEpEUrDrup1hMElpqIm0wz7UQvb0qwCwcqEqpbV457DFgR/ib
	 qc4ThYFLqNpt1qVecqK8JT0GqdJjcgdMlS6WPnWMyHAsbQ9Nbc7qwPLI5R66CFYKTV
	 SyWFmbqucbt7Obx/22N617RM9OKx8BhKRUDOGMv9kJk4vBKtXz8fOOJsuU8ArL5how
	 6eWgw2F9WVINA==
Message-ID: <e0ac9296-a688-4146-bb1b-e5ef7dc4b5e1@kernel.org>
Date: Mon, 16 Jun 2025 11:28:28 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
To: Yafang Shao <laoar.shao@gmail.com>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
References: <20250606052747.742998-1-dlemoal@kernel.org>
 <aEZ2C93sEiFRzGEE@infradead.org>
 <CALOAHbDmSjaBjG7-yTm4FOxwY-mhR0ea610ZyTb-TPzLZOu2Lw@mail.gmail.com>
 <CALOAHbBkdjz+ujYnAKYvxaQsyd_juDKg38-G8Sk+cKCN_0HftQ@mail.gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CALOAHbBkdjz+ujYnAKYvxaQsyd_juDKg38-G8Sk+cKCN_0HftQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/16/25 11:13, Yafang Shao wrote:
> On Mon, Jun 9, 2025 at 3:09 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>>
>> On Mon, Jun 9, 2025 at 1:50 PM Christoph Hellwig <hch@infradead.org> wrote:
>>>
>>> Adding Yafang Shao <laoar.shao@gmail.com>, who has a test case, which
>>> I think promted this.
>>
>> Thank you for the information and for addressing this so quickly!
>>
>>>
>>> Yafang, can you check if this makes the writeback errors you're seeing
>>> go away?
>>
>> I’m happy to test the fix and will share the results as soon as I have them.
> 
> We’ve confirmed that the DID_SOFT_ERROR issue no longer occurs after
> applying this patch series to our production servers. Since our
> production servers only use mpt3sas drives, we can verify the fix
> specifically for this driver:
> 
> Tested-by: Yafang Shao <laoar.shao@gmail.com>

Thansk. I tested with the mpi3mr driver.


> We’ve encountered another instance of DID_SOFT_ERROR triggered by a
> reset on an mpt3sas drive. Do you have any insights into what might be
> causing this failure? Below are the error details:
> 
> [Thu Jun 12 17:57:35 2025] mpt3sas_cm0: log_info(0x31110610):
> originator(PL), code(0x11), sub_code(0x0610)

This decodes to:

Value     	31110610h
Type:     	30000000h	SAS
Origin:   	01000000h	PL
Code:     	00110000h	PL_LOGINFO_CODE_RESET See Sub-Codes below (PL_LOGINFO_SUB_CODE)
Sub Code: 	00000600h	PL_LOGINFO_SUB_CODE_SATA_NON_NCQ_RW_ERR_BIT_SET

So it looks like a non-NCQ command failed. What were you doing when this happened ?

> [Thu Jun 12 17:57:35 2025] mpt3sas_cm0: log_info(0x31110610):
> originator(PL), code(0x11), sub_code(0x0610)
> [Thu Jun 12 17:57:35 2025] sd 8:0:9:0: Power-on or device reset occurred

And this command failure is trigerring a device reset (the HBA may be doing
that, or the drive did not like what you were doing and reset).

> [Thu Jun 12 20:07:53 2025] mpt3sas_cm0: In func: _ctl_do_mpt_command
> [Thu Jun 12 20:07:53 2025] mpt3sas_cm0: Command Timeout

This looks like an ioctl() to the adapter diver, and it never got its reply
apparently. This is 3 hours after the above power-on-reset, so these 2 events
are likely not related...

> [Thu Jun 12 20:07:53 2025] mf:

This is dumping the mpi_request bytes. Maybe you can try to decode that to get
hints as to what action triggered this.

I would love to get feedback from the Broadcom folks on this kind of problems,
but apparently, debugging issues with their HBA does not seem to be high on
their to-do list.

Broadcom folks,

Could you please comment on these issues ? Not the first time I ask. A reply
would be welcome so that we all know that you at least care about issues with
your drivers/HBAs. Thank you.


> 
> [Thu Jun 12 20:07:53 2025] 00000013
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 9fcda615
> [Thu Jun 12 20:07:53 2025] 00fc0000
> [Thu Jun 12 20:07:53 2025] 00000018
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 000000ff
> [Thu Jun 12 20:07:53 2025]
> 
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 00000006
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 02000000
> [Thu Jun 12 20:07:53 2025]
> 
> [Thu Jun 12 20:07:53 2025] 00000012
> [Thu Jun 12 20:07:53 2025] 000000ff
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 00000000
> [Thu Jun 12 20:07:53 2025] 00000000
> 
> [Thu Jun 12 20:07:53 2025] mpt3sas_cm0: issue target reset: handle = (0x0013)
> [Thu Jun 12 20:07:56 2025] scsi_io_completion_action: 22 callbacks suppressed
> [Thu Jun 12 20:07:56 2025] blk_print_req_error: 22 callbacks suppressed
> [Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 190811280 op
> 0x0:(READ) flags 0x80700 phys_seg 28 prio class 2
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2305 FAILED Result:
> hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=17s
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2336 FAILED Result:
> hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=16s
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2305 CDB: Read(16) 88
> 00 00 00 00 05 26 e3 68 40 00 00 04 00 00 00
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2158 FAILED Result:
> hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=17s
> [Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 22127274048 op
> 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2158 CDB: Read(16) 88
> 00 00 00 00 03 0d 08 dc 38 00 00 04 00 00 00
> [Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 13103586360 op
> 0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2369 FAILED Result:
> hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=17s
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2369 CDB: Read(16) 88
> 00 00 00 00 01 50 ee 50 48 00 00 04 00 00 00
> [Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 5652762696 op
> 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2368 FAILED Result:
> hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=17s
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2368 CDB: Read(16) 88
> 00 00 00 00 05 26 e3 64 10 00 00 00 20 00 00
> [Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 22127272976 op
> 0x0:(READ) flags 0x80700 phys_seg 4 prio class 2
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2304 FAILED Result:
> hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=17s
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2157 FAILED Result:
> hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=17s
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2304 CDB: Read(16) 88
> 00 00 00 00 05 26 e3 64 30 00 00 04 10 00 00
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2157 CDB: Read(16) 88
> 00 00 00 00 03 0d 08 d8 38 00 00 04 00 00 00
> [Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 22127273008 op
> 0x0:(READ) flags 0x84700 phys_seg 128 prio class 2
> [Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 13103585336 op
> 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2400 FAILED Result:
> hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=17s
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2400 CDB: Read(16) 88
> 00 00 00 00 01 50 ee 58 48 00 00 04 00 00 00
> [Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 5652764744 op
> 0x0:(READ) flags 0x80700 phys_seg 128 prio class 2
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2309 FAILED Result:
> hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=17s
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2309 CDB: Read(16) 88
> 00 00 00 00 05 26 e3 78 10 00 00 02 c0 00 00
> [Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 22127278096 op
> 0x0:(READ) flags 0x80700 phys_seg 88 prio class 2
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2376 FAILED Result:
> hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK cmd_age=17s
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2376 CDB: Read(16) 88
> 00 00 00 00 03 80 11 3e c8 00 00 00 20 00 00
> [Thu Jun 12 20:07:56 2025] I/O error, dev sdi, sector 15033515720 op
> 0x0:(READ) flags 0x80700 phys_seg 3 prio class 2
> [Thu Jun 12 20:07:56 2025] mpt3sas_cm0: log_info(0x31140000):
> originator(PL), code(0x14), sub_code(0x0000)
> [Thu Jun 12 20:07:56 2025] mpt3sas_cm0: log_info(0x31140000):
> originator(PL), code(0x14), sub_code(0x0000)
> [Thu Jun 12 20:07:56 2025] sd 8:0:9:0: [sdi] tag#2336 CDB: Read(16) 88
> 00 00 00 00 01 50 ee 96 50 00 00 05 18 00 00
> [Thu Jun 12 20:07:56 2025] mpt3sas_cm0: log_info(0x31140000):
> originator(PL), code(0x14), sub_code(0x0000)
> [Thu Jun 12 20:07:57 2025] XFS (sdi): metadata I/O error in
> "xfs_da_read_buf+0xd9/0x130 [xfs]" at daddr 0x484022c68 len 8 error 5
> [Thu Jun 12 20:07:59 2025] sd 8:0:9:0: Power-on or device reset occurred
> [Thu Jun 12 20:07:59 2025] sdi: writeback error on inode 12885147175,
> offset 1285156864, sector 13979483112
> 
> 


-- 
Damien Le Moal
Western Digital Research
