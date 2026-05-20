Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0818B36DA0B;
	Wed, 20 May 2026 07:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779263568; cv=none; b=APfSvNeNcvBO2RSW7rlotzlelqiGPxuUHVp4tTebM24/hOMemJ6ekiQD728VooBsHtbXJJ1PZnm53FFyuok/VwULcMTayRY29LDbUEYe4akMo99s7Cp6Xl/X96ITCEwl2cCx3d1vn3iUb6K02kzyZ6U8DMYwxLYufu88fGemjHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779263568; c=relaxed/simple;
	bh=vNVzPpoMk8MxGlwORffA5pUI/sAfTKp2DeLsm6RAy/s=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=BWKuWOes0q0eZ+I46vcCKVuCOz8bYVXJaoDeWVqH6tP8iyMgF04kMMSgMTZbAZn4kAWgxmY+QHC5QQeDT0LsA5EpLv+OY90lvKrKrkwxkBhMSC0NN0Rx/rU3wmEUbmTMkmvkDWMy7Ixaw5878+u9K89wrXyO937uPqUyd4MhXA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=K4YjoOVB; arc=none smtp.client-ip=117.135.210.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="K4YjoOVB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=F6lijeGmFgZsowwk0SJM1nzAzng/87BR6qMDH1En2d8=;
	b=K4YjoOVBotck42ff6Lj81btrTt0PlOVJRsztTmdumKNRGwQpiBvle5VIvzQiFw
	rWhq+JHlL8ZheolYxBdJmbACGhMYZDMNNUBuXGdptwt7vbThkPX+2XkFNwxuenQ7
	muX5jJNlZEJN9UlvVGYA7P0es64aobfFg5T3bIez/zLg0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDnzzgeaA1q1mF+Bw--.11953S2;
	Wed, 20 May 2026 15:51:58 +0800 (CST)
Message-ID: <6A0D6825.8050902@126.com>
Date: Wed, 20 May 2026 15:52:05 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Hongling Zeng <zenghongling@kylinos.cn>, Kai.Makisara@kolumbus.fi, 
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, 
 djeffery@redhat.com, jmeneghi@redhat.com
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: st: Fix lock leak in st_ioctl()
References: <20260520074016.51975-1-zenghongling@kylinos.cn>
In-Reply-To: <20260520074016.51975-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnzzgeaA1q1mF+Bw--.11953S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7XFy8XF1ruryDuw1xAw45Awb_yoW8Jry3pr
	4rX34UCw45Ja929asruayUXrWrZa93KrWDGFW7t345ZFZ0kFyjgF1agw17ZF48Jr48XF4v
	ga1YkFyYg3WjyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-Z23UUUUU=
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBoR7+z2oNaB4WrwAA3m

   Hi,

   Please ignore my previous patch: [PATCH] scsi: st: Fix lock leak in 
st_ioctl()

   The original code is correct. st_common_ioctl() releases &STp->lock
   internally, so there is no lock leak. This is a false  positive.

   Sorry for the noise.

   Regards,
   Hongling

在 2026年05月20日 15:40, Hongling Zeng 写道:
> The default case in the switch statement returns directly from
> st_common_ioctl() without releasing &STp->lock, causing a lock
> imbalance. Fix by jumping to the out label to properly release
> the lock.
>
> Fixes: b37d70c0df85 ("scsi: st: Separate st-unique ioctl handling from SCSI common ioctl handling")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> ---
>   drivers/scsi/st.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index f1c3c4946637..3b08992e1b10 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -3628,7 +3628,8 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>   	case MTIOCTOP:
>   		break;
>   	default:
> -		return st_common_ioctl(STp, STm, file, cmd_in, arg);
> +		retval = st_common_ioctl(STp, STm, file, cmd_in, arg);
> +		goto out;
>   	}
>   
>   	cmd_type = _IOC_TYPE(cmd_in);

