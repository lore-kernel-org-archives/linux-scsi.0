Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BA01F959;
	Wed,  7 Feb 2024 07:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707291237; cv=none; b=f+EfELUkx1gNdO8cPG5q5vRTuvkWiRmqoYBJzUC8/42HZRzx181VPQLi0oOrJocYM0yK+x8ikaVr+AsFfSTbsB89y+gWG4sTnvSXDSKLn2vV/U9egUApFauUHwqfQbhysE6LCKzUToHuSjt06J+gox9jiBKzIzEKZh4bOPvkB6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707291237; c=relaxed/simple;
	bh=T8PUm993YLp4bR2SyyF3pzi+76eviDrHyB9PI5tswVc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rcdoCSIJDdoInkXluZq3gcE2ePXeCWc/MuplsBz+38f4ji17RG+Rr+NtryN+vxKMHiEeB3mOH5+n6Tp884nMHuUqf6tcpvi5aao9Kl3R+fd4U5DXa0yr2jyvykd30nivxsgxpDEO7+WKucI4IXOrVpkIRNPjKxwK1Gs6DqvpSA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=dQuVYSF0; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=bDRRBtah; arc=none smtp.client-ip=89.207.88.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="dQuVYSF0";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="bDRRBtah"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com 68839C0002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1707291229; bh=vhWjbDMjfHH6ZrKfP39yp8IJURf0XjvmF9CuA9xZ5kY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=dQuVYSF0xkMDrM8/9KbNKnJxDljVhlGYf+WdtI9OntOfXOh2/si6NkHWABxHnYHxy
	 rdlP6i9uKaXCSX4hTBcbydyqiKwaQ7mi6mObjnJiBfLLVCJCb+Tjaq/4NdA9RC4rsS
	 HU5ObCAu7HejsKa59Jl8wEEe8ljWqGZfgHCJUE72bIsJLmh/xTb8zGtx1rCGTm7Jed
	 XpuVirOdQdmORtxlGjRrdgbfvC8bgrEPqvWEUAmfE1+vrEeHZYZTsNrCbqYk2zjdsM
	 /fU1J92ircqv+UoJPbUzZDMYTE8BxWTz/5mIfHyW+u82v+hS6TSi/EXrFQmgYkRYtd
	 U7YjMlJYQLmHQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1707291229; bh=vhWjbDMjfHH6ZrKfP39yp8IJURf0XjvmF9CuA9xZ5kY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=bDRRBtahZC7UHs0tfLjGcg1UtkDwI99QQZ7H0ZWqhs8lvlAnLEsN+yTxQQkhKNa8g
	 suK1ZV64ZKdcVj8Vw5qdG0TO5z8y0hogJ3ZWEexkCHemqlK3k/8ts+882eOA44/LXA
	 IDV/+xsPpsOdCwNVaqVZpvrI9Mt5tuAMGgzO6LpXGuirTgoRho1DmX6idiHgmHyVBJ
	 bsj0j5YwlU2KcfMmcNhWedDhCps5R673Mgx8xDMTa8l6JYafsikRSxPGIguHKTpJO2
	 lGhxMd7qOmmznVzoqxNDG5i0iUwVIdQIEoFHDAOS4AVqTzCIJmStRXhL6N0CKhJwyN
	 fXnxYSRajGM+Q==
Date: Wed, 7 Feb 2024 10:33:36 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Mike Christie <michael.christie@oracle.com>
CC: <me@xecycle.info>, <target-devel@vger.kernel.org>,
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
	<james.bottomley@hansenpartnership.com>
Subject: Re: [PATCH 1/1] scsi: target: Fix unmap setup during configuration
Message-ID: <20240207073336.GA19965@yadro.com>
References: <20240207021919.7989-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240207021919.7989-1-michael.christie@oracle.com>
X-ClientProxiedBy: T-Exch-05.corp.yadro.com (172.17.10.109) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Hi Mike,

On Tue, Feb 06, 2024 at 08:19:19PM -0600, Mike Christie wrote:
 
> +static int target_try_configure_unmap(struct se_device *dev,
> +                                     const char *config_opt)
> +{
> +       if (!dev->transport->configure_unmap)
> +               return 0;
> +
> +       if (!target_dev_configured(dev)) {
> +               pr_err("Generic Block Discard setup for %s requires device to be configured\n",
> +                      config_opt);
> +               return -ENODEV;
> +       }
> +
> +       if (!dev->transport->configure_unmap(dev)) {
> +               pr_err("Generic Block Discard setup for %s failed\n",
> +                      config_opt);
> +               return -ENOSYS;
> +       }
> +
> +       return 0;
> +}
> +
>  static ssize_t emulate_tpu_store(struct config_item *item,
>                 const char *page, size_t count)
>  {
> @@ -776,11 +797,9 @@ static ssize_t emulate_tpu_store(struct config_item *item,
>          * Discard supported is detected iblock_create_virtdevice().
>          */
>         if (flag && !da->max_unmap_block_desc_count) {
> -               if (!dev->transport->configure_unmap ||
You removed this check but that callout is not mandatory and exists just in
2 backstore modules.

BR,
 Dmitry
