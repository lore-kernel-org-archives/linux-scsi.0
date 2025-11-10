Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4006C3009E1
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2025 09:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762768364; cv=none; b=mRkb7AdXCXB8OMtFsRR/3qMsy0NXDzOgUkjPgCCtDFWAV2WyjGbupMptUdlGlUkcGeqrI2al+j2MBYyz6o0xG9FS+xMmI3DNwwo2GVRC1yxuzhXs7z3S10s5UtEhU4SemZkCevHi+AINFuYySTT3nDQ2IMOoQKd8Jb6Xq5T9uNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762768364; c=relaxed/simple;
	bh=G7WE+sFChPhr5tYJIEHGZKg9Jvy5agevnA362qwCV4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WKdkOQlz6BTk9R4aybkjprMB8eJxI8wyHQIE9fgZLuefhWWm/IzzujrUhdsvXL7q17rWmE93eQLklnHXoVy4HyZvki8jMysUBtfjEBQe+jJuuWeCZUzriy35m7ACGt0YXlbT+m3i+SOMbhqrlpVFUEOefIul+zlAVQlE5kUt8RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=Z9UgWNiO; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="Z9UgWNiO"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 654294E41606;
	Mon, 10 Nov 2025 09:52:39 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 2DB9D606F5;
	Mon, 10 Nov 2025 09:52:39 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B1ACE102F2431;
	Mon, 10 Nov 2025 10:52:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1762768358; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=4o+HFMVw9pNSmt889GtEDWEIrkLOsCgLMQQvfN6aCYc=;
	b=Z9UgWNiO+TJxI1q9PxHUjsifhDiJ0Tk6adEeRVEORr+YhSQk5Isg41czVFIXs2YV2t55Ye
	rhaRuZqSRMRKJMlmugmOfgfOoAgGUTQqKMWdCr8VywZO3WTdbMDf8xuNg8mWX/gH7A4c37
	5lR8nStaqqy0S/iCUgLNOVntzxItg5Ghv5ZnqkDv3V9cVQZ2G/i5xegAf7ECy+fVw6nPBx
	dn7EHDEPL4t6SaY/VpyDi1htcAV+cl0IVQQoc70JJgrX6nbkL7cdf7c6AneRxn3M1MGmR1
	O7MNYeU/xYfNtUpyqAvBS7w40EnVC7QpjY33sWPdah51RTC+J7pjHwvY+C94ig==
Message-ID: <0018bdab-1f61-4b1c-94ff-eefd795dd281@bootlin.com>
Date: Mon, 10 Nov 2025 10:52:28 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Revert "Make HID attributes visible"
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>,
 Peter Wang <peter.wang@mediatek.com>, Bjorn Andersson
 <andersson@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Huan Tang <tanghuan@vivo.com>, Avri Altman <avri.altman@wdc.com>,
 Liu Song <liu.song13@zte.com.cn>,
 Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Bean Huo <huobean@gmail.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 Gwendal Grignou <gwendal@chromium.org>
References: <20251028222433.1108299-1-bvanassche@acm.org>
 <176179516243.2050237.11349123845566493377.b4-ty@oracle.com>
Content-Language: en-US
From: Thomas Richard <thomas.richard@bootlin.com>
In-Reply-To: <176179516243.2050237.11349123845566493377.b4-ty@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hello,

On 10/30/25 4:32 AM, Martin K. Petersen wrote:
> On Tue, 28 Oct 2025 15:24:24 -0700, Bart Van Assche wrote:
> 
>> Patch "Make HID attributes visible" is needed for older kernel versions
>> (e.g. 6.12) where ufs_get_device_desc() is called from ufshcd_probe_hba().
>> In these older kernel versions ufshcd_get_device_desc() may be called
>> after the sysfs attributes have been added. In the upstream kernel however
>> ufshcd_get_device_desc() is called before ufs_sysfs_add_nodes(). See also
>> the ufshcd_device_params_init() call from ufshcd_init(). Hence, calling
>> sysfs_update_group() is not necessary.
>>
>> [...]
> 
> Applied to 6.18/scsi-fixes, thanks!
> 
> [1/1] ufs: core: Revert "Make HID attributes visible"
>       https://git.kernel.org/mkp/scsi/c/f838d624fd11
> 

I tested kernel 6.18-rc5 as requested by Bart [1]. Issue is fixed !!

[1]
https://lore.kernel.org/linux-scsi/7a4d0770-cb2d-4a0a-b82a-f9da635ee36f@acm.org/

Best Regards,
Thomas

