Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643171D6DDD
	for <linux-scsi@vger.kernel.org>; Tue, 27 May 2025 07:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748329360; cv=none; b=ERZDaTv/AvwVffzDigDF43MEnYHvBZ510rIJtd/b934WNG9FoOOxFYIddPiWgrfNky+eHyKtgIRBdV0gbu/JXxo7uu1UkP685JYaHalmQm9o60k5LWzZ3flkjIhOSF+3ijKvjpTEn8Zkvwi7qZXLAC9ln707+e4kN7wP7bjxcHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748329360; c=relaxed/simple;
	bh=uerM567QcQCVqLcNbyZwn68Uozgpe9FXmx2lyhpHDvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lLW8upo6Gl3E/zoYE1BKP0xXZKXGKamjDIj72ogqxoIKWKT/WBp7xYTkj44XaYFqQdPYXQM8AclTu29g1MitCZomfXQTRDE4CXjfN0hWPT9DUJy5nNffdBgSwiDHQ2H6ec+98Vqa+Jj6kQ7ZQTErxuWYUPROMlyz6yVGGVx78xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ikjz3TI2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ikjz3TI2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748329357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lPj65lDKBn8X+w6dITxUNDiVhmFCDqyup7L8wrKjKWs=;
	b=ikjz3TI2RNF/P/IQm7jZhhyyq/ZfulKQ2wJ5drc/IDwl7zP1qZP5RdDhfUDLrv7bmy1YAO
	Ip/lLhyR8Vd38TcClkZZ5pVVxNzT5YTjNcgETdwbyAowODJs197GtAexiTnJnZGT/iSnQZ
	8jnc/bZ30tStRVRL3hscPSEqz+C6bSc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-UFUDdkvrO_qowi-tqjVbkg-1; Tue, 27 May 2025 03:02:34 -0400
X-MC-Unique: UFUDdkvrO_qowi-tqjVbkg-1
X-Mimecast-MFC-AGG-ID: UFUDdkvrO_qowi-tqjVbkg_1748329354
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4d51e563eso789098f8f.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 May 2025 00:02:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748329353; x=1748934153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lPj65lDKBn8X+w6dITxUNDiVhmFCDqyup7L8wrKjKWs=;
        b=W6tY2W6eSQgofPk37PCIw3HA7Ws6wY09sQGR+Mo23tBSbAGr5SnajGhqvlsq1RBQJ4
         MYUjEmI1cztKvGl/EHhYbd9kzDce2hIleDKAGS7xbSpGYp2HeD1dq1FR0YPzX8vYYyla
         v/9tTSWM42xO+Dw00JZQi6foKc6ktxnRIbVTW2lGuGTCZ/2dHnUCZ8uLvlLd2c+Q9pTC
         Lbgv8hiYUu1l2GH340nSgEPbu2+2561mzNF1KhAdOPzQP+AU6EAu86z+8pKm+yPtHE5M
         lqyDDE+Wx7PQGEoE3QgxeJ0AL46is0W+aYOrWI8ByvIdF1KLiyxmx9xyFqP3Whhd1ZVi
         9jAQ==
X-Forwarded-Encrypted: i=1; AJvYcCV463nF6TDX2vMjW3KtUGSTqlfSogCbIREqVaV+vpYj1/16LLHiPPPKEQ1NC43uRENvtuEej5HTsWmU@vger.kernel.org
X-Gm-Message-State: AOJu0YyhOj7MiNTURMssajfNtk4qwQB37vQXoo9MV/LRB6z6SAgGp8xn
	TxcDr4FP60Rn5qPs328FnarAaGWeC7k29oNLRHPd5OQPvSLiMxnfAWRn82nKEzV663ubV0B2uWz
	xjeWP+HujRJJ/SBHHX7a7BvOUprReSVEb4vBAmcclLKKSIPHZBiXV4/ljBXLBb3U=
X-Gm-Gg: ASbGnct3XnY7dq+nG1GbaEOuFK8/7vHxmS6gldUK5uHRwOcCfGAC9JfBU9X3xWIAYvM
	5u26PeaKVsD+VBZ2rQWNNUtHHDS6hAHKqKAoUkvLPGcbyq871KUQWg+2t050mCsPPanIESSw0mS
	L0awGeZQn0f3q9obn/js8HNc8lI4fJmusnW++CzcaDyImKa3PTFfEfPZWbqE/cXD218gap4ZFbD
	IqrF2NfdjfnctdZYiZFPBPNHsl7Z+rhuI1UJERG6EVmsxoh2PViWybD/0iyCnjis2deSydWIaFM
	rVXKJE6fXmIaxDRuvotYfELOi3X6+IYIFmXI8c1DMZh/vZKUjKvQVylhnrI=
X-Received: by 2002:a5d:5543:0:b0:3a4:cf66:efbb with SMTP id ffacd0b85a97d-3a4cf66f1f6mr7608655f8f.57.1748329353548;
        Tue, 27 May 2025 00:02:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGex5mHhM/OYaq2gRKUAD/HxHUJY3MptMrHBU8jm/eQhY8uxpjEvS25/QUCzUXZRuezIVGAwQ==
X-Received: by 2002:a5d:5543:0:b0:3a4:cf66:efbb with SMTP id ffacd0b85a97d-3a4cf66f1f6mr7608571f8f.57.1748329353087;
        Tue, 27 May 2025 00:02:33 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2728:e810:827d:a191:aa5f:ba2f? ([2a0d:3344:2728:e810:827d:a191:aa5f:ba2f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4cc52ab88sm9930473f8f.11.2025.05.27.00.02.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 00:02:32 -0700 (PDT)
Message-ID: <e1429351-3c9b-40e0-b50d-de6527d0a05b@redhat.com>
Date: Tue, 27 May 2025 09:02:28 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 8/8] net: core: Convert
 dev_set_mac_address_user() to use struct sockaddr_storage
To: Kees Cook <kees@kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Jason Wang <jasowang@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, Cosmin Ratiu <cratiu@nvidia.com>,
 Vladimir Oltean <vladimir.oltean@nxp.com>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Kory Maincent <kory.maincent@bootlin.com>, Maxim Georgiev
 <glipus@gmail.com>, netdev@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Mike Christie <michael.christie@oracle.com>,
 Max Gurtovoy <mgurtovoy@nvidia.com>, Maurizio Lombardi
 <mlombard@redhat.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Mingzhe Zou <mingzhe.zou@easystack.cn>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 "Dr. David Alan Gilbert" <linux@treblig.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, Lei Yang
 <leiyang@redhat.com>, Ido Schimmel <idosch@nvidia.com>,
 Samuel Mendoza-Jonas <sam@mendozajonas.com>,
 Paul Fertser <fercerpav@gmail.com>, Alexander Aring <alex.aring@gmail.com>,
 Stefan Schmidt <stefan@datenfreihafen.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>, Hayes Wang
 <hayeswang@realtek.com>, Douglas Anderson <dianders@chromium.org>,
 Grant Grundler <grundler@chromium.org>, Jay Vosburgh <jv@jvosburgh.net>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Jiri Pirko <jiri@resnulli.us>,
 Aleksander Jan Bajkowski <olek2@wp.pl>, Philipp Hahn <phahn-oss@avm.de>,
 Eric Biggers <ebiggers@google.com>, Ard Biesheuvel <ardb@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Ahmed Zaki <ahmed.zaki@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Xiao Liang <shaw.leon@gmail.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-wpan@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <20250521204310.it.500-kees@kernel.org>
 <20250521204619.2301870-8-kees@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250521204619.2301870-8-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/25 10:46 PM, Kees Cook wrote:
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index fff13a8b48f1..616479e71466 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -572,9 +572,11 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
>  		return dev_set_mtu(dev, ifr->ifr_mtu);
>  
>  	case SIOCSIFHWADDR:
> -		if (dev->addr_len > sizeof(struct sockaddr))
> +		if (dev->addr_len > sizeof(ifr->ifr_hwaddr))
>  			return -EINVAL;
> -		return dev_set_mac_address_user(dev, &ifr->ifr_hwaddr, NULL);
> +		return dev_set_mac_address_user(dev,
> +						(struct sockaddr_storage *)&ifr->ifr_hwaddr,
> +						NULL);

Side note for a possible follow-up: the above pattern is repeated a
couple of times: IMHO consolidating it into an helper would be nice.
Also such helper could/should explicitly convert ifr->ifr_hwaddr to
sockaddr_storage and avoid the cast.

/P

