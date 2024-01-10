Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51C74F892
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2024 23:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=opensource.wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AkptRpCz";
	dkim=pass (2048-bit key) header.d=opensource.wdc.com header.i=@opensource.wdc.com header.b="VGh9muSR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1704927699; x=1736463699;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0/bHahharmUXrSMZDp5yTKdSyXLQ0GDT1qfeEfE7Tww=;
  b=AkptRpCz5cD9l05qMIR96JXdDeWhDMEEgw04sIj65+gPEisg6vtx2Zpj
   UcO227JhwAME+nzwmnMZwLo528Gk2Iw4KC8hEcZdpPgEglN5Z0r/gzG5B
   0VWpgLOqnDhMBiHunkFJnDBWw3A9oC6j++ogSXaQoR7bq9/GlopcTZmE6
   k06U0gAOthWA3+URPVmLPCmaT+J1JwZUP7OjMoJskWmOmlXz3UWScgS0j
   +/MmCQkUR3ocDuDSzC+sHMjqlvA71RcptC7yJacLCGiyQabQBURNtbdBu
   ni/p803eZLfytSKqCBjyyIyLKH+pROwHZlhjwEwTjvVJ+/etfpCT2e7i6
   Q==;
X-CSE-ConnectionGUID: kfbBN2CPSEe2Y8xRB+NcUg==
X-CSE-MsgGUID: OnztHlR4SXCfSASwC26KmA==
X-IronPort-AV: E=Sophos;i="6.04,184,1695657600"; 
   d="scan'208";a="6830983"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2024 07:01:32 +0800
IronPort-SDR: MmVvTRPN1rarwNXSpUIffiYWnurE5RfxubafAdwdNXWkjA1TUNqOcsY+WWtuh1Ep6SCjt5a6Hd
 dv+0Cd/qQHAg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Jan 2024 14:11:50 -0800
IronPort-SDR: i5/tRsmcRPpm0W3KBIdUJidaoPZe65jfosorwuaR7vQEjhpipiPcKOPeFtACX8USxe54MiNi+F
 +jPrzHGcBsbQ==
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Jan 2024 15:01:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4T9Nb008Xtz1RtVT
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2024 15:01:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
	reason="pass (just generated, assumed good)"
	header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
	opensource.wdc.com; h=content-transfer-encoding:content-type
	:in-reply-to:organization:from:references:to:content-language
	:subject:user-agent:mime-version:date:message-id; s=dkim; t=
	1704927677; x=1707519678; bh=0/bHahharmUXrSMZDp5yTKdSyXLQ0GDT1qf
	eEfE7Tww=; b=VGh9muSRvN8mrA/HTMYAbhLgVrTczm4UbinJGxsjjlw8DzlJ+DN
	qH3l2mLnQAevgljal2WlMbSUs4HPQpLXGFWaTB8vQVJ3YNjjVQBWwtgasHF+ERyy
	bMD0F6nSSdkZjbH9eekEiQ4pjtJXZ1OeIKp2XOTvSdJsaygbCn8Sd1IczczgYPPb
	GWnxfYRCoLWcXnr7AktIsz+/IfwHILAnI4SOp/dYt0H/ezCbGkKu0vjlS+Z41kf2
	BuYCKiLmL0xBRnvayLS9f1nwK9HsNZKVAwQ0UsUWSFrsIQG2MLKLKsM2LahpOE1h
	4paWToosEWp+Mw34rCU4gDyA83wsBDB4mMw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id UBjJ_eu2vnjD for <linux-scsi@vger.kernel.org>;
	Wed, 10 Jan 2024 15:01:17 -0800 (PST)
Received: from [10.225.163.21] (unknown [10.225.163.21])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4T9NZh3PrWz1RtVG;
	Wed, 10 Jan 2024 15:01:16 -0800 (PST)
Message-ID: <4214e790-cc9b-40ef-96c3-167569cddb44@opensource.wdc.com>
Date: Thu, 11 Jan 2024 08:01:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regression] Hang deleting ATA HDD device for undocking
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>,
 Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: Kevin Locke <kevin@kevinlocke.name>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <ZZw3Th70wUUvCiCY@kevinlocke.name>
 <c7c4769c-5999-4373-90df-f2203ecfc423@acm.org>
 <ZZxvPtrf5hLeZNY5@kevinlocke.name>
 <8bbbd233-69c6-4f20-904c-332bb838cc42@acm.org>
 <ZZ2-hMYVJlF4ayqk@kevinlocke.name>
 <d585753a-b5f3-410f-a949-8b52252307ab@acm.org> <ZZ8CzOaXBkxyKxNw@x1-carbon>
 <1c34e2e4-4bc5-4142-bc21-3db3a55f638e@acm.org>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1c34e2e4-4bc5-4142-bc21-3db3a55f638e@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/11/24 05:52, Bart Van Assche wrote:
> On 1/10/24 12:49, Niklas Cassel wrote:
>> However, I'm worried that applying that libata patch will simply hide
>> an actual problem in SCSI, which might lead to someone else stumbling
>> on this SCSI bug in the future.
>>
>> Thoughts?
> 
> Since the hang is caused by submitting a SCSI pass-through command, I'm
> not sure this issue can be called a SCSI core bug. Aren't users on their
> own who mix SCSI pass-through commands with commands submitted by the sd
> driver?

I would not expect a correct result from a user mixing up passthrough and
regular kernel sd management, however, having the system hang is not acceptable
I think. So we should fix this, avoiding this hang. Is Niklas patch OK for that ?

-- 
Damien Le Moal
Western Digital Research

