Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="q+Qpquwt"
Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4BCC1708
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 13:05:30 -0800 (PST)
Received: from [192.168.1.18] ([92.140.202.140])
	by smtp.orange.fr with ESMTPA
	id BLRVr96vKiZG3BLRVr6OBv; Thu, 07 Dec 2023 21:57:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1701982678;
	bh=pMZp/Kh2N+7XN2m46hz2KqC1GFOWXNo9CYsptw2uodY=;
	h=Date:To:Cc:References:Subject:From:In-Reply-To;
	b=q+QpquwtF3CYm2ts2z+ISVxpvDUuJxJ+5QXBQoE7vxLUWqbNkTxEDFSXBeY/O5ry7
	 L8ZxMEVAEw0vYPbxhVBD1qTemFhbuO3lEH6OoaCnR5156dm+pXdTRwfq/s56XDJXfw
	 E9bkbo1XF7jlWFZypAGXm/sNHriP47TBcKCT9pa6RmrkjDzxXfjOucI7baT5mQLd7V
	 BqHZfG6GIZ8QpAtoZT1Kkp8gkPuT+0LjwgXiTtbmdOQcM1VLb+A7s9YYIspOrU3RGP
	 l4ih+/l3NdWm6fQiwP01sLSIu4CyQuCAWtpoFu3H8ct7FtcGaU7bqFwx3bXdBx3x7u
	 NCAnKfXsYxB+A==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 07 Dec 2023 21:57:58 +0100
X-ME-IP: 92.140.202.140
Message-ID: <b7620e96-0b89-467a-ae63-3cf9d070b9d9@wanadoo.fr>
Date: Thu, 7 Dec 2023 21:57:57 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: thenzl@redhat.com
Cc: linux-scsi@vger.kernel.org, ranjan.kumar@broadcom.com,
 sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com
References: <20231019153706.7967-1-thenzl@redhat.com>
Subject: Re: [PATCH v2] mpt3sas: suppress a warning in debug kernel
Content-Language: fr, en-GB, en-US
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20231019153706.7967-1-thenzl@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> The mpt3sas_ctl_exit should be called after communication
> with the controller stops but in currently  it may cause
> false warnings about not released memory.
> Fix it by leaving mpt3sas_ctl_exit handle misc driver release
> per driver and release DMA in mpt3sas_ctl_release per ioc.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
> V2: separate handling of DMA release and misc driver deregistration

...

> diff 
<https://lore.kernel.org/all/20231019153706.7967-1-thenzl@redhat.com/#iZ31drivers:scsi:mpt3sas:mpt3sas_scsih.c> 
--git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c 
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c > index 
605013d3ee83..96dd2af5cd7d 100644 > --- 
a/drivers/scsi/mpt3sas/mpt3sas_scsih.c > +++ 
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c > @@ -11350,6 +11350,7 @@ static 
void scsih_remove(struct pci_dev *pdev) >  	}
>  
>  	mpt3sas_base_detach(ioc);
> +	mpt3sas_ctl_release(ioc);  >  	spin_lock(&gioc_lock);
>  	list_del(&ioc->list);
>  	spin_unlock(&gioc_lock);
> 

Hi,

does a similarmpt3sas_ctl_release() should also be called in the error handling path of |

_scsih_probe()? CJ |

