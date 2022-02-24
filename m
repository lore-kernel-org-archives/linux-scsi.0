Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9ADAC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 05:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiBXFv6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 00:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiBXFv5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 00:51:57 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04432649A9
        for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2022 21:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645681888; x=1677217888;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y7ovshWXavovqNwSWM4vADOjZzxYbsup6lywxIbOhis=;
  b=iaGmUAZjYy8Z3skrJm7r+fzyDm29/6KLocnqrKY05vr633SO2rhTykk2
   YGWHo5Z4fMXISMwcaQSaZXMOFY7XdasSewCZqdIDyRRrxWqlNie6WN3sh
   uOmIkV1/Cca28jXLLdQ7zimfIoIrW2zF2swyCg4wRFNIccujmwabbE25f
   Yx+JAoQstIc19kN/khD2595NhBvhw/l+I7Pxq8Eoo4G0fGOUAL62DEFrJ
   tA9llGTDz9ButmmYqEX7PbjQerr0yn2pi1CLJqEGRJISHXAN93/1/JRBL
   NnKCP4ysOCqLKtVzd0+IcGNw+LIGoCF3K3AERrL9wTetsbmyBri4fbrj/
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,393,1635177600"; 
   d="scan'208";a="297948722"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Feb 2022 13:51:27 +0800
IronPort-SDR: /y9epxTv7AoqD9Tu8LsAPqPfyyW2BvAHNiepCeVpvaXJNddtfWTeMXuNMFkDH4NGOklB/8tEF6
 zQ6ENv3zYeyBi/IDSbr8OOh+sltGr7QBkzrPeMFyAx50MBsnvlpTxFj9Yl/ViuLMUq9KPO/S+O
 Fhkqwap3F1itZmNnBorYKzARskYohJFqDKSN2oCJ21HQOQYsPSLvV8CnhLwPyuExPCFQojQij9
 E93kEtvJ81/knoRmfDcite53N9GPi1XijAumDXdXe0imdlXIv7IViDzwTOI+xa+Ygx5eGvUeLt
 TpHxYF6O3tagIyTeMLr52Vdu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 21:22:58 -0800
IronPort-SDR: 3sNRxQgZ3Xz2deQjt0yf4vC9CK+EUmwwdPR9un+dO6YfDvM/0247UuIU+fwpgk7h7LCkmrADbL
 1CY4u1HqnFfrIJ7445mHycMDernb+T6RBO9bFcbKlFPnrw3JukybCe8IX56wc2m4C7nE75rol8
 bxzjmaKBymP8an41tSFzKPis69RM2TPtppnCso3qmFB3vb/pGjkmmlaMFIT2JrREsZi0vVA2up
 TiQCWb2S5XyyIP4KyZ70vXv5X81cC+YNmqH/QCJBauMksz1XGUzXSQJnj0B/W2RKidqCzucrEB
 YYs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 21:51:28 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K428Z3mtcz1SVp4
        for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2022 21:51:26 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645681885; x=1648273886; bh=Y7ovshWXavovqNwSWM4vADOjZzxYbsup6ly
        wxIbOhis=; b=myOmQ6c6qtJL6xA5AVR878wAEF8PR8B+EJFgbQF5/YN59UZa3EP
        iGDhe/ufDPdEGCh2X0KfanDcn3N/NPIGIGtlcXAdvH/jbWJ+qd8dcyV2/Kex7u1d
        HtxNWq3YttVHxf3LZFJ2W8uZ0Ud1V2ZOyatZ+c2f1Iuw3k0WcBuQdbX5cCx7rUmI
        bZ8hYYIH3HDk/XMbuZmQNJlaN16dk7a1tjtFM4ioiIAtTkcKQJaxHhM7vKzVjHIR
        yhFZpjfU4nJN/rkzzJbIHACEE4i87ob2XbdW7bHHS0SOyhQd3z1ZLMKn1fRXuyAW
        UU+0HjdYFE482kIurErikk5VNoQvDgdKi7A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id k2F7y4peiEk2 for <linux-scsi@vger.kernel.org>;
        Wed, 23 Feb 2022 21:51:25 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K428W6blfz1Rvlx;
        Wed, 23 Feb 2022 21:51:23 -0800 (PST)
Message-ID: <b62a0767-db0b-ad4f-2fdf-9b4e32e59af2@opensource.wdc.com>
Date:   Thu, 24 Feb 2022 14:51:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH -next] scsi: megasas: clean up some inconsistent indenting
Content-Language: en-US
To:     Yang Li <yang.lee@linux.alibaba.com>, kashyap.desai@broadcom.com
Cc:     sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20220224004748.59442-1-yang.lee@linux.alibaba.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220224004748.59442-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/24/22 09:47, Yang Li wrote:
> Eliminate the follow smatch warning:
> drivers/scsi/megaraid/megaraid_sas_fusion.c:5104 megasas_reset_fusion()
> warn: inconsistent indenting
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index c72364864bf4..aab600ef4cd6 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -5101,8 +5101,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
>  				for (j = 0; j < MAX_LOGICAL_DRIVES_EXT; ++j) {
>  					memset(fusion->stream_detect_by_ld[j],
>  					0, sizeof(struct LD_STREAM_DETECT));

While at it, you could fix this weird indentation too.

> -				 fusion->stream_detect_by_ld[j]->mru_bit_map
> -						= MR_STREAM_BITMAP;
> +				fusion->stream_detect_by_ld[j]->mru_bit_map
> +					= MR_STREAM_BITMAP;

Still inconsistent: missing one tab, no ?

>  				}
>  			}

Given the depth of the indentation, this initialization loop could go
into a little inline helper function.

-- 
Damien Le Moal
Western Digital Research
