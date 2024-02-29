Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7236D52F
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 22:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709244322; cv=none; b=CqY0nDYwBI+b/+9e4xSZFAmk4GoPIaclXNozFdVac3XBxudIHswY3fdt/whuCe2fAJyTvMjpfmWfqwh9/gCPGG0immPTjQj1tmIJRFy71qWD7th7EgBGlu6q4UzxxIKt/TIMBwaLjXNKizwG1g5YyYLdGBCaJtHJoqq08P4VYDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709244322; c=relaxed/simple;
	bh=5DbVUHySeDB9YEJSKPkg8srk8wvvGFrP3vfhRWS7FHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AhKpWZkPNwd++z1TmYg+905MHbfmImcAay+b4N987+E5Ktwbq9xk1zE/M/Nji7Qvp1qjQkt6DDebdF+5mV9867MkRlTCV8FqClv5+IR3do+fw4KcqQXktAN85bjr7febW4gKpX3RFn5SobQ2EvO6y+T4Zq9GrO/3PH0Tfr9w6Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=opensource.wdc.com; spf=pass smtp.mailfrom=opensource.wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gnVdABYj; dkim=pass (2048-bit key) header.d=opensource.wdc.com header.i=@opensource.wdc.com header.b=PKgyndpq; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=opensource.wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gnVdABYj";
	dkim=pass (2048-bit key) header.d=opensource.wdc.com header.i=@opensource.wdc.com header.b="PKgyndpq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709244321; x=1740780321;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5DbVUHySeDB9YEJSKPkg8srk8wvvGFrP3vfhRWS7FHE=;
  b=gnVdABYjPToIYcAXDlt+/KjbGhTGWMSy4e3R5BRrxZyRYlrjWUd1GnR0
   RX63zOS2abA5JMesFUCrjBy8UGKFwcozuq+csNLczjEaKQyxgo+OZQiw3
   SLctBrV1uQPozvW9WeLBcvhP7eSAvV0Y916zyuHV83DqQri7QclHL73KX
   VgvXJB2T33xaYVuEZz7JXZSXNeiHGA88GG/4Mg79TpLc1/es82ylHrxbW
   dKGo6O07Y/8EXeSMddHUUGH8fVHq+utvF9WoR+7Izp8Ygp1y25Kc7Jjsd
   MU++URzYIApcWz6MrkiqNyu+r4Zfd479x9mYM+kEMAvHyM34Kz40YD4h7
   Q==;
X-CSE-ConnectionGUID: B87f7UpEQb+2Hj/cJ4HxMw==
X-CSE-MsgGUID: IgsFJ3tfSGKXpdilBsA3rQ==
X-IronPort-AV: E=Sophos;i="6.06,194,1705334400"; 
   d="scan'208";a="10764783"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2024 06:05:12 +0800
IronPort-SDR: NNdzDteZ9xnO/7opwr1W6e02CQmhKpZUPddwjpodfjSPvZNFxdtrvBomvoMRwBRpzX8V6+Hh9/
 B9oXf+G0ohRQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Feb 2024 13:14:29 -0800
IronPort-SDR: xGA4BtmtfZZ7UJxEZdUJf4FrE2LAG2tGkOhfzzrqk7LXDgndEWslqkQaZWnoV3e8T4CrZHFxti
 tFvxADeOzldw==
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Feb 2024 14:05:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Tm4yw52jmz1RtVS
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 14:05:12 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
	reason="pass (just generated, assumed good)"
	header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
	opensource.wdc.com; h=content-transfer-encoding:content-type
	:in-reply-to:organization:from:references:to:content-language
	:subject:user-agent:mime-version:date:message-id; s=dkim; t=
	1709244297; x=1711836298; bh=5DbVUHySeDB9YEJSKPkg8srk8wvvGFrP3vf
	hRWS7FHE=; b=PKgyndpqPaoVtbkHJHnNngynZ8i3Cnbj5CubPIpPguFVaxaW79b
	yfdudKrjmX+iQfkitUX5H3wrJCm41H+wcM2lYznfLBNqQQOFifBIlGT7nm5nEWAa
	ki9w4jIlxp1ETlzaZYoVCbgId94JOJmmabmJrsKwQcoCq546jsU/vZYNV9cainvs
	LUOb6SefCZoP39xsxJwjILrSEn6v3APatlMJggXzRpdqnRfROt2BebEPvUThewa5
	EgZKie41VUPR+7xpclyRTdLCmFz65+YJdZ4+9ChnP1x4+5C00UAt6IgnQxbSouHa
	faAg0EbwbEK6zbheCI5MHUIMChadcMv51cA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id E3UsnjveWYtI for <linux-scsi@vger.kernel.org>;
	Thu, 29 Feb 2024 14:04:57 -0800 (PST)
Received: from [10.111.69.9] (c02drav6md6t.sdcorp.global.sandisk.com [10.111.69.9])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Tm4yc5T89z1RtVG;
	Thu, 29 Feb 2024 14:04:56 -0800 (PST)
Message-ID: <18490fc9-7fda-41ee-803a-bda874c2b42d@opensource.wdc.com>
Date: Thu, 29 Feb 2024 14:04:56 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ipr: Remove SATA support
Content-Language: en-US
To: Elektrokinesis DJ <cpubuilder2@gmail.com>, brking@linux.vnet.ibm.com,
 "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Cc: jejb@linux.ibm.com, john.g.garry@oracle.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, wenxiong@linux.ibm.com,
 Niklas Cassel <cassel@kernel.org>
References: <CABa-fKRfE8B2TLVJASB9xQaOXDiYH3YCw0YEEg1UcGu2Le8xWw@mail.gmail.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CABa-fKRfE8B2TLVJASB9xQaOXDiYH3YCw0YEEg1UcGu2Le8xWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/02/29 9:31, Elektrokinesis DJ wrote:
> I am dissatisfied with the decision to remove SATA from the ipr driver, I
> have multiple machines in my homelab that now require manual patching every
> time I would like to update the kernel and initrd image. Bladecenter PS700
> uses the ipr SCSI driver if you install a common SATA SSD into the Planar
> SAS slots. This limits me from being able to use newer kernels without
> patching, unless I would like to procure expensive SAS SSDs.

The ipr driver was the only libsas/ATA driver that had not been converted to the
new libata error handling, and was thus preventing necessary cleanups in libata.
When it was removed, it seemed that no-one was using ATA devices with IPR beside
SATA DVDs, and very few people had this hardware to test anything.

So it seems that devices beside DVDs were/are actually used.

We can try to reintroduce the support for ATA in ipr, but that will not be a
simple revert as the new EH handling needs to be supported.

Brian,

Any comment ? Is this feasible ?
I do not have the hardware to work on this, so patches will have to be done by
you or someone with access.

-- 
Damien Le Moal
Western Digital Research

