Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF6FC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 01:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiBTBhg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 20:37:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiBTBhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 20:37:35 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7414162B
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 17:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645321035; x=1676857035;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sA62GIn4J7Vn1J8aTsNQLtDPF43p9ytzlEaBVC5jSkw=;
  b=P2SPcIzS5G/WBCfOO7XmHDsaAkETxW11rGBfWY3IsnRtg0hYEE51ajhi
   fw3U+l60NJSNOsFu+Fyw9HIcBfhcOldnJN9qr0UCdRfxJ2vE8Q9Pht85X
   XSvCBHjYW3qXwaX/xHTlXVkQufjFn/WZ1yeY9jJnWvfIOS/BT/0b3oIkB
   UqghA1F3i/unezC0kxTUhmMgcqPOiTasalZLnHJsOmDQOjcvZ0z0zoDkv
   HIoGVHd71ZrdgQQtGaVuVEkWIB8WFMz52UbntJ4WhFg93zONPwYY/WYYX
   gU4HL2Q48eCMcIvHxTeb7EgNcCCNkcqyIRSsXwIEJqzdWfNhR3S/YN4qk
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="192333131"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 09:37:15 +0800
IronPort-SDR: vJ3LWYq8Z47+w+1OA7Y9o9TCBoGISrqYwKhPrAAQH/xSPYhRgrj5Xm8vN/c0qMwkHDHpbHuawQ
 WTNw5zNKxs5Z7FRIwi065nCJcQZ6wNmfNVEFmR4IlJNg4bcJi2eBGSEhyza2px2iUoHHMs5j0K
 M+TPr8YBx2SF9+1clo1VA56ipWvW8NNuPdpoLxBWHnf+s+ES7QCAeutepafLrrNKNThVbg6ebf
 UkvjZ/nMrImRQpE1JsOecW15IOFuVvk0pe+HVPrq+ykFh2tS9pDLZh+jKA8YLzO7ZnYcl4f1ah
 WibAGUTPpx50a4trXxTdTSx6
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 17:09:57 -0800
IronPort-SDR: tyMSefatI/KPbDodb/RrmwAC2Oewio4YswnCqT3Iud+I3VWhi0eV0fGGFSal8ePm8zwF6W6xiA
 WIvEPcR39k0W7ulx4/Z1t1mqV+Ci6rliCeA34e0/HcFcGdF604IQoKuEOXLXrNwlvN7ldf+FL6
 vEjXt81Zd4CdnXO2dSxSTWNCZHKwoRC3tr7TNPSIrvcQHTxV9w7gDV5sxvbfU434bX74xlgom2
 k1OAa4AAooXSIxeEJ0/RzCgipWbx1V+uY+f76GCa8UFEj0yVcoW68Qly0lzp2Fz1JYxJNRWGXr
 aEg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 17:37:15 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Sj64NXFz1SVp7
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 17:37:14 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645321033; x=1647913034; bh=sA62GIn4J7Vn1J8aTsNQLtDPF43p9ytzlEa
        BVC5jSkw=; b=sMnG9vHr3Nj2EDJv+2DzQnkkhfjha2fa1kvJdm+SzAVf8VH8eAA
        TwLYiYRhPGOcsMd0npt18GrjIQy0UMXEzTwzEMpLHd/biEeExWOfD+JGK7tc/0RS
        sbbmkIziZRHn1NBmWmlyOyMC34pPPZJxOCcTl2Zhqp8ROMWfDN71jGJl+xl+Rlps
        quYi1O9dULdrUtAqUxifXANCmv4pgqeqEPMxJq3JR+HPFtHDGxZoIx+bijcI0XnG
        obgZrxeTmOCpCDy9jO2D+VWOUzNAs3ghh0fm7eoQBamJkWTBdu7FL2Xurmr4ANGE
        Po4KWtZ02aZTn4U13XRaTRTVJ4lbFBpj0wQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6QxTffvn0Hc6 for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 17:37:13 -0800 (PST)
Received: from [10.225.163.78] (unknown [10.225.163.78])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Sj33bjNz1Rvlx;
        Sat, 19 Feb 2022 17:37:11 -0800 (PST)
Message-ID: <0d4f988d-881c-3717-f9d8-38739cf17e91@opensource.wdc.com>
Date:   Sun, 20 Feb 2022 10:37:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 00/18] scsi: libsas and users: Factor out LLDD TMF code
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        artur.paszkiewicz@intel.com, jinpu.wang@cloud.ionos.com,
        chenxiang66@hisilicon.com, hch@lst.de, Ajish.Koshy@microchip.com,
        yanaijie@huawei.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com, liuqi115@huawei.com, Viswas.G@microchip.com
References: <1645112566-115804-1-git-send-email-john.garry@huawei.com>
 <yq1zgmmh675.fsf@ca-mkp.ca.oracle.com>
 <b9aea895-4b24-4529-0d87-5148e6990c95@opensource.wdc.com>
 <yq1ee3yfhnj.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <yq1ee3yfhnj.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/20/22 10:31, Martin K. Petersen wrote:
> 
> Damien,
> 
>>> Applied to 5.18/scsi-staging, thanks!
>>
>> Did you push this ? I do not see John series in the branch...
> 
> It's there now.
> 

Got it. Thanks !

-- 
Damien Le Moal
Western Digital Research
