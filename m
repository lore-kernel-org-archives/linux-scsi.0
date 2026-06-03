Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCD139D6E7;
	Wed,  3 Jun 2026 07:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780471024; cv=none; b=cM7HwIisNg/67/z3rTsWV5cNQRpLWWvDIZtVyf6vvpDFGpMmE4AMGKz1f2IwMlrRV0qREO0okyyTI8Aw2O4izOZ4r70gp2thjrlx5GOkFiqMC5vF7hzjqEmUHuQDFqmGtmkmeXt/nse7fHmTqr/yz9w8IXPFEoPnA8L+d1BymkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780471024; c=relaxed/simple;
	bh=/bJP/cqR2Uy0QPTKBk6KJWfsi4wNy7P2SrZbeTAO5BE=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=rqLHoJdWA8pcTBw7NFq/oP90FU2Y/AwXJn8akhSojX7HTWqV41hQmAQuY09sZjAM5sZtuhTW+7Jtbjw9M7qG/YDunOQkMVzLZ2QM6aA+ZvHXpBv9UJB65HFqZHvnrxRNmYdotWqEWeQjcdrB28i90JirsurzzuyBWBbDnws14AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=IfKnlg5i; arc=none smtp.client-ip=220.197.31.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="IfKnlg5i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=tPE+ow8HDUfaMSvM8M1Q5AzM8Z0glVBNFmaCUwVPlNg=;
	b=IfKnlg5iCuGsfM0WF83O2DXd4qqR+Wz4YxljaA2Dsg5eY1QAI4xD97weY/LwNG
	0M2MNqPdiLBUvbhk57/w5DG2L5ZzpD0rvUJ8nn5Fdx18WuxmP5SMKigKtL7HEEdx
	fenwdBq2euFOSRYUuZxlkYFGVWJ5DsqzEhDYTddvJ7lO0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3L6m+1B9qxjVWAw--.54470S2;
	Wed, 03 Jun 2026 15:16:14 +0800 (CST)
Message-ID: <6A1FD4C4.1080801@126.com>
Date: Wed, 03 Jun 2026 15:16:20 +0800
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
References: <20260603071119.149362-1-zenghongling@kylinos.cn>
In-Reply-To: <20260603071119.149362-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3L6m+1B9qxjVWAw--.54470S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XryrZry3GFy3GFy8AF13Arb_yoWkJwc_Gr
	WYqr1xKryjkws3Z3WS9r15XrWavaykWw18CF1Yqry3Z397Zrn5AF98tr15Ar4UGr45CanY
	kwn3Zr9Ykr1DZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0Ha0DUUUUU==
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBrh7Gl2of1L6jzQAA3Q

   I sincerely apologize - I sent the wrong patch in my previous email.
   Please disregard my previous patch submission.

在 2026年06月03日 15:11, Hongling Zeng 写道:
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

