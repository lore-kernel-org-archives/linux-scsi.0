Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B463A1DB;
	Fri, 13 Mar 2026 22:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773441030; cv=none; b=m1oGmNsh0ozqHxCQPuolGvqjHUTc+ndCcph0pNBxmHzfniKR2bRbS/7wCc/c5XWRm8sUvY7Kjyy3JPnDDS6NBubJgV1otDjJLH6IyG5ZhrJU7uN64hBVv+8aKx+lnySVdXq95w2LBH5eTWZsi9it013vIwqDJL0ckGMCJVWzBuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773441030; c=relaxed/simple;
	bh=oKSxKCPE8JoYHo3FfGpzlDSDQzu3apsEJL19uw72ClE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cMtcLAUEZGcu5voUhwtD5lia/sLgt2HyXRwIAWwOwgl91a7omqDCaWs7DXc0pIhKMNU7G5ASJVUidrsEHQEf85EydzqbP3+MLvV3Bc502wt98vuwaxJxe9VhPehF1TKhTs5XqYeW+D/rgjeRzYu2qsKPgjZaYXsMCWyAaIdlVa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DEUm4CdX; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DEUm4CdX"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fXfM85JwFzlgy0r;
	Fri, 13 Mar 2026 22:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773441020; x=1776033021; bh=HqoVcELHiTkiUeleTUFQWYKX
	p7a07sbzx4MhVkt2uA8=; b=DEUm4CdXoCCCrduMsGnIbmuM+wGIeK8vHmFLxCAL
	mCSX32S7TBorK+l5kJuar2HX0EvYStyta2r3WzfIefKwH/6E+Kmny2vW1ejD46Ot
	5royHmnADTYHOYEePM/wN1sr05y7d1Q6lZcN4oUmarHnPSmCJhS0IC7lrCEbIszg
	jwXTpSrRlRqTR46JiZp4a3+7hPU5mkHqM79uvgu9IhjgeDFUHt3h94Wugoycs5pk
	X6/YdQJ1IrdOsVy7frJoOwjKys0PtVsc0u4lsoJOmxEWSWvJuTOinKAA/uLEjCxc
	X9d13OLAw98Tmg81E409u5P6tEWNJ0ffxtaUNhiRo5PLGw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 24MmFmDPXrbZ; Fri, 13 Mar 2026 22:30:20 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fXfLx5zVXzlfl5q;
	Fri, 13 Mar 2026 22:30:17 +0000 (UTC)
Message-ID: <bf64badf-161b-421a-a9e6-76e6679d5c9d@acm.org>
Date: Fri, 13 Mar 2026 15:30:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/12] scsi: ufs: core: Add support to refresh TX
 Equalization via debugfs
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-8-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260308151409.3779137-8-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/26 8:14 AM, Can Guo wrote:
> Drastic environmental changes, such as significant temperature shifts, can
> impact link signal integrity. In such cases, refreshing TX Equalization is
> necessary to compensate for these environmental changes.
> 
> Add a debugfs entry, 'tx_eq_ctrl', to allow userspace to manually trigger
> the TX Equalization training (EQTR) procedure and apply the identified
> optimal settings on the fly. These entries are created on a per-gear basis
> for High Speed Gear 4 (HS-G4) and above, as TX EQTR is not supported for
> lower gears.
> 
> The 'tx_eq_ctrl' entry currently accepts the 'refresh' command to initiate
> the procedure. The interface is designed to be scalable to support
> additional commands in the future.
> 
> Reading the 'tx_eq_ctrl' entry provides a usage hint to the user,
> ensuring the interface is self-documenting.
> 
> The ufshcd's debugfs folder structure will look like below:
> 
> /sys/kernel/debug/ufshcd/*ufs*/
> |--tx_eq_hs_gear1/
> |  |--device_tx_eq_params
> |  |--host_tx_eq_params
> |--tx_eq_hs_gear2/
> |--tx_eq_hs_gear3/
> |--tx_eq_hs_gear4/
> |--tx_eq_hs_gear5/
> |--tx_eq_hs_gear6/
>     |--device_tx_eq_params
>     |--device_tx_eqtr_record
>     |--host_tx_eq_params
>     |--host_tx_eqtr_record
>     |--tx_eq_ctrl
> 
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> ---
>   drivers/ufs/core/ufs-debugfs.c | 61 ++++++++++++++++++++++++++
>   drivers/ufs/core/ufs-txeq.c    | 78 +++++++++++++++++++++++++++++++++-
>   drivers/ufs/core/ufshcd-priv.h |  5 ++-
>   drivers/ufs/core/ufshcd.c      |  7 +--
>   4 files changed, 143 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
> index 6f7562846f5b..b3bb2c850ad2 100644
> --- a/drivers/ufs/core/ufs-debugfs.c
> +++ b/drivers/ufs/core/ufs-debugfs.c
> @@ -383,9 +383,70 @@ static const struct file_operations ufs_tx_eqtr_record_fops = {
>   	.release	= single_release,
>   };
>   
> +static ssize_t ufs_tx_eq_ctrl_write(struct file *file, const char __user *buf,
> +				    size_t count, loff_t *ppos)
> +{
> +	u32 gear = (u32)(uintptr_t)file->f_inode->i_private;
> +	struct ufs_hba *hba = hba_from_file(file);
> +	char kbuf[32];
> +	int ret;
> +
> +	if (count >= sizeof(kbuf))
> +		return -EINVAL;
> +
> +	if (copy_from_user(kbuf, buf, count))
> +		return -EFAULT;
> +
> +	kbuf[count] = '\0';
> +
> +	if (!ufshcd_is_tx_eq_supported(hba))
> +		return -EOPNOTSUPP;
> +
> +	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
> +	    !hba->max_pwr_info.is_valid)
> +		return -EBUSY;
> +
> +	if (!hba->ufs_device_wlun)
> +		return -ENODEV;
> +
> +	if (sysfs_streq(kbuf, "refresh")) {
> +		ret = ufs_debugfs_get_user_access(hba);
> +		if (ret)
> +			return ret;
> +		ret = ufshcd_refresh_tx_eq(hba, gear);
> +		ufs_debugfs_put_user_access(hba);
> +	} else {
> +		/* Unknown operation */
> +		return -EINVAL;
> +	}
> +
> +	return ret ? ret : count;
> +}
> +
> +static int ufs_tx_eq_ctrl_show(struct seq_file *s, void *data)
> +{
> +	seq_puts(s, "write 'refresh' to refresh TX Equalization settings\n");
> +	return 0;
> +}

In the above two functions, since the standard uses the terminology
"TX equalization training", wouldn't it be more appropriate to use the
word "retrain" instead of "refresh"?

> +/**
> + * ufshcd_refresh_tx_eq - Retrain TX Equalization and apply new settings

Shouldn't the word "refresh" be changed into "retrain" to make the
function name consistent with the one-line description of this function?

Thanks,

Bart.
