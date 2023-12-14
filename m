Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VyAvHfJh"
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E3DBD
	for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 02:46:14 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-3364ab04eb8so179321f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2023 02:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702550773; x=1703155573; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CvWOWuJlXBUzyg9eDna4F2YgGHQHVoXVeHQtMyBjyWQ=;
        b=VyAvHfJhSkLo1DyJsTQF2U6W0yK+OJ+u79FSInBJ7xGrV9kjjoyOwqOTCI5rlLYYRc
         j5b/ZEWqXzrZDlkK10Kvr9O6WpZjtPR+oWvW/5seQHwue7tYD1ru2GNskwalLezxvo9A
         Wq9LCo+w0tgoYkAL2/PbWqQy64JPC3kM5RtOOSaSBxq9ykslvA+neBPaJFh6dPv0lPz6
         TCxJLu0+zuFCwHd94UQ1IjfIucOK8JqXfq8uS8nKi8ZjekstvR8AFxJ0fC5ESj2vzXv0
         q+9ak7Eie0cGbPWAyue0pclv8xkGNdTFbmAp+OxN/yqc9so1p7RoTO9da8Ap83cDd/cF
         iNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702550773; x=1703155573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CvWOWuJlXBUzyg9eDna4F2YgGHQHVoXVeHQtMyBjyWQ=;
        b=FqZuxVcNLKFHGIprL04m8Shu/5cMtI+KAJIaPkh+l/3l3oUcCI6hXKC7YBlVSXd5Yq
         yz8aY2wu9XKNomKkgceXd7/hbeYcjbN193Po1g+3Usu+2Hh1/BGsyjzscBIlRlUTTBCo
         AONceZfqiicB/bEz8iF7fqZIMvFqnETmHvzj+fJ0tl+XejIOcSw9L76d39XK+DGpy2G+
         GgmWm/BLruVS+cdvPA2ctNfc7wDQAbP96UguMdeLEF/nyEbr4Y7Jx5EOm99Vk4l2SeJ3
         537VDaAUckc8s44soOHVgpWhSYHGWIIAALZH6/W5iJK1BAnh4oW0mIE1pEPLxn1uiEro
         wirg==
X-Gm-Message-State: AOJu0YykQTSuP32zJYOZ93gYE0iCBs40wBzzkvkXERSPSPf+7YRheiJA
	qOVn45yG1IbreGORZaPkJNb2XA==
X-Google-Smtp-Source: AGHT+IHypTimBY53/CeLVDHgOHr3fM/puN7zaUg9dYpsNFyw1F4zgUtmxfbfIc65ZvAkSoUTqTiwHQ==
X-Received: by 2002:a5d:5192:0:b0:332:ffdb:e9ad with SMTP id k18-20020a5d5192000000b00332ffdbe9admr3336509wrv.46.1702550772982;
        Thu, 14 Dec 2023 02:46:12 -0800 (PST)
Received: from localhost ([102.140.209.237])
        by smtp.gmail.com with ESMTPSA id o12-20020a5d474c000000b003333dd777a4sm15781290wrs.46.2023.12.14.02.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 02:46:12 -0800 (PST)
Date: Thu, 14 Dec 2023 13:46:09 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Wei Yongjun <weiyongjun@huaweicloud.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Chad Dupuis <chad.dupuis@qlogic.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2fc: Fix skb double free in bnx2fc_rcv()
Message-ID: <0d50162c-b531-4cf9-a2e7-c2933791c0e5@moroto.mountain>
References: <20221114110626.526643-1-weiyongjun@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114110626.526643-1-weiyongjun@huaweicloud.com>

What ever happened to this patch?  I was reviewing old use after free
static checker warnings (Smatch) and came across it.  The patch looks
correct to me (I wrote the exact same patch myself before seeing this
one on lore).

regards,
dan carpenter


On Mon, Nov 14, 2022 at 11:06:26AM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> skb_share_check() already drop the reference of skb when return
> NULL, using kfree_skb() in the error handling path lead to skb
> double free.
> 
> Fix it by remve the variable tmp_skb, and return directly when
> skb_share_check() return NULL.
> 
> Fixes: 01a4cc4d0cd6 ("bnx2fc: do not add shared skbs to the fcoe_rx_list")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 05ddbb9bb7d8..451a58e0fd96 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -429,7 +429,6 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
>  	struct fcoe_ctlr *ctlr;
>  	struct fcoe_rcv_info *fr;
>  	struct fcoe_percpu_s *bg;
> -	struct sk_buff *tmp_skb;
>  
>  	interface = container_of(ptype, struct bnx2fc_interface,
>  				 fcoe_packet_type);
> @@ -441,11 +440,9 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
>  		goto err;
>  	}
>  
> -	tmp_skb = skb_share_check(skb, GFP_ATOMIC);
> -	if (!tmp_skb)
> -		goto err;
> -
> -	skb = tmp_skb;
> +	skb = skb_share_check(skb, GFP_ATOMIC);
> +	if (!skb)
> +		return -1;
>  
>  	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
>  		printk(KERN_ERR PFX "bnx2fc_rcv: Wrong FC type frame\n");
> -- 
> 2.34.1
> 
