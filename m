Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD7E3D2FEC;
	Mon, 14 Sep 2026 06:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789367149; cv=none; b=PZXmlN5foUTqyKaGm9ufa92kIhJX/n/sEGZKKX1mClrH5lpnLYtCXSBFZleeHZeYPAagqK6iFC9A0DcPlmx8u716Gm+TuqxY9uhZnBLEGdzfE0GvAn7V9LZeIQ0T5J+d+b4lNONFxxBD/PtuYY41mYhqeLNj37qMmQiJewc6G44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789367149; c=relaxed/simple;
	bh=bnGs+yWqX/V/Fw725+f1YC7V99wtaXgV64cYoZ8HXok=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OFCJt+mXCixRgjahxHsI6nC+9hBROxwYRhtSHwJScsvtcyT7MFVDccJoNBl+KUnqwEyGdM3C45CqFIF+BMEqstwUL5N6AVoWFm/C1EZox6MzXikgdE5gmIOxjcIG3ynhZq17Iyd/Zn0FcQAHjaBNIrUmjE8E40ntha/SuPxL+yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hjvxv0RnXzKm5t;
	Mon, 14 Sep 2026 14:14:43 +0800 (CST)
Received: from kwepemf200017.china.huawei.com (unknown [7.202.181.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 17B1C40586;
	Mon, 14 Sep 2026 14:25:44 +0800 (CST)
Received: from [10.67.121.58] (10.67.121.58) by kwepemf200017.china.huawei.com
 (7.202.181.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 14 Sep
 2026 14:25:43 +0800
Message-ID: <02549976-d4cd-4357-892d-9ccd27e5c021@hisilicon.com>
Date: Mon, 14 Sep 2026 14:25:42 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] PM / devfreq: Add more details to the
 get_cur_freq() comment
To: Bean Huo <beanhuo@iokpp.de>, <linux-pm@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi
	<cw00.choi@samsung.com>, "Martin K . Petersen" <mkp@kernel.org>, "James E . J
 . Bottomley" <James.Bottomley@HansenPartnership.com>, Avri Altman
	<avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, Stanley Jhu <stanleyjhu@google.com>, Bean Huo
	<beanhuo@micron.com>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
 <20260907192140.2701755-3-beanhuo@iokpp.de>
Content-Language: en-US
From: Jie Zhan <zhanjie9@hisilicon.com>
In-Reply-To: <20260907192140.2701755-3-beanhuo@iokpp.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf200017.china.huawei.com (7.202.181.10)



On 9/8/2026 3:21 AM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> The comment for ->get_cur_freq() only says that the device should
> provide the frequency at which it is operating. It does not tell the
> driver author which unit to use, what the return value means, or that
> the frequency should be one of @freq_table. These have to be found by
> reading the devfreq core.
> 
> Add these details to the comment.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com>> ---
>  include/linux/devfreq.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index dc1075dc3446..809ef29b9af5 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -90,8 +90,11 @@ struct devfreq_dev_status {
>   *			use this directly. Instead, governors are recommended
>   *			to use devfreq_update_stats() along with
>   *			devfreq.last_status.
> - * @get_cur_freq:	The device should provide the current frequency
> - *			at which it is operating.
> + * @get_cur_freq:	The device should provide the frequency, in Hz, at
> + *			which it is currently operating, and return 0, or a
> + *			negative errno on failure. The frequency should be one
> + *			of @freq_table, as it is used for the transition
> + *			statistics.
>   * @exit:		An optional callback that is called when devfreq
>   *			is removing the devfreq object due to error or
>   *			from devfreq_remove_device() call. If the user
