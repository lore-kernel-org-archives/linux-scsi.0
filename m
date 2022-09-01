Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E0BECAAD1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 02:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiIAC3j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Aug 2022 22:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiIAC3h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Aug 2022 22:29:37 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEC310B960
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 19:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661999375; x=1693535375;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AmAbtgwvf10cQiM7/CdK9N2i6a9/rk3f8YXqb8N5pFo=;
  b=mGerjB+cZgKs97nf4O48lbvL5Aw0tpoJ3Ys04eDesC/CW1RNYgliIydS
   XYRy5hlR+Fcr5tq3t2bEoqq+q/3uffCEaZItc6G7JpvOphy28aJweF/cM
   PJEukvUlkEkesxtbcvzHYeCHVxbukCb8RWKmv5OrqgCXtMd3iLl8CnVXp
   e/h7zK+IUrVeWhwMCoz3M7gki/Tqyyn6+jCzFplHtKLCKKe7xZCxPi+Wk
   d2ECMdPqMz1DtQVOGCUi16PHwTuaGgr0J2HPLr13ADurXm7UM3WCvOohC
   2ireprKhHWuMfZUTgHRlFtIZOAbarUGgQv+drgxcapDgY6vfl0C7/Hlv4
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,279,1654531200"; 
   d="scan'208";a="322292689"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Sep 2022 10:29:34 +0800
IronPort-SDR: 29dmLPPTa6XO/b4qV8dgFJragjJ8gtt1hpovBW+kBQ2Yq4aAJGrE8ymloIUYyF/3o/hXej4pO+
 vEfdJXYoCCXLbWZA06XN/EecHWu/K2SR345iJ5hBtBlDKUMsO+DqN81eFvHWmAUhRhmCfylkuM
 Ft4hmTIjRwVVj5L0O2jRAm/zeDrE9Yi2m4opxo3m6PTDx/2+WFxIGNUuIweC5GoukUzN9zn7yY
 EsOV3g6CAIG7XKMTL0JfuhaU1UTPz2NtMe5nTJq6kkA+XBwyLoVNKzM0xsCePC+MQN1QJNe1Sk
 QrplOOHiqQcw1TyIdL1sgIEJ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Aug 2022 18:50:03 -0700
IronPort-SDR: ze+aGxUwRNw3qEaUw1AahOfQcZLCTAAJKvU31UAnWPtO+SonvOGx31u2VlFcy59P/fmyjzcyzs
 fkGU4kfboXgN8MYe7/l8I3QsXEj+ihqgMIMW0BW/FcKlvIZT3U2JONkE2gzatIimgT+ydPyoqK
 2iFxhVH7NffOJGx6scvHsVWQBwx0lBSNWROmWjq8qfrQUm7uNXFRrt1p9Gp2qcOkGnRPLFtb2E
 Il380+FE0hyOjfVdUzEPvbPtbQagoUkyfDfy6D4lCg00J08zktr9l8cYfu2MJ8Dp8ecCCOcc/7
 Ygg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Aug 2022 19:29:35 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MJ4kP6Sjwz1Rwt8
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2022 19:29:33 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1661999373; x=1664591374; bh=AmAbtgwvf10cQiM7/CdK9N2i6a9/rk3f8YX
        qb8N5pFo=; b=Mz5wRbcJtzaU52xyP+271zksFtmgPwaTj9PY3o2+USGg6JYXYsC
        +4asGD2yhJexB3onnuvbjLyeb/SWM5zqCW0YsUoxjEJfHgTlGKxGUOn6IpKKdUmx
        vZucAPdR0ZT/B4xMG/VPyR1lbO2k2gv4CyDQ3l11pEm01oZjPyB89Am9PenI5Z0R
        nEo9kBxVIrRuF9UdV4PK8yVs2iQ4dgqU/jI765siK8wmAQIycQdCDNQ8kqclwoD0
        Rk3SjZQf989tjeg4HT/xSt7dkq0xEzH9r6yd99JA8tbkhhnwEFGx02PH7E14kTqh
        T/03iMnBb+bsaXMcVWIsDZX4xXlvuYkgbHw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OpC702dffoW4 for <linux-scsi@vger.kernel.org>;
        Wed, 31 Aug 2022 19:29:33 -0700 (PDT)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MJ4kM478Gz1RvLy;
        Wed, 31 Aug 2022 19:29:31 -0700 (PDT)
Message-ID: <8c61be8b-61dc-5b90-43a4-bed15d6a6b8d@opensource.wdc.com>
Date:   Thu, 1 Sep 2022 11:29:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v3] scsi: csiostor: convert sysfs snprintf to sysfs_emit
Content-Language: en-US
To:     Xuezhi Zhang <zhangxuezhi3@gmail.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, bvanassche@acm.org,
        johannes.thumshirn@wdc.com, himanshu.madhani@oracle.com,
        zhangxuezhi1@coolpad.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220901015130.419307-1-zhangxuezhi3@gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220901015130.419307-1-zhangxuezhi3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/22 10:51, Xuezhi Zhang wrote:
> From: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
> 
> Follow the advice of the Documentation/filesystems/sysfs.rst
> and show() should only use sysfs_emit() or sysfs_emit_at()
> when formatting the value to be returned to user space.
> 
> Signed-off-by: Xuezhi Zhang <zhangxuezhi1@coolpad.com>

Looks OK.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
> v2: delete 'else' and extra space.
> v3: delete extra configs in patch v2
>     and use a new changelog.
> ---
>  drivers/scsi/csiostor/csio_scsi.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
> index 9aafe0002ab1..05e1a63e00c3 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -1366,9 +1366,9 @@ csio_show_hw_state(struct device *dev,
>  	struct csio_hw *hw = csio_lnode_to_hw(ln);
>  
>  	if (csio_is_hw_ready(hw))
> -		return snprintf(buf, PAGE_SIZE, "ready\n");
> -	else
> -		return snprintf(buf, PAGE_SIZE, "not ready\n");
> +		return sysfs_emit(buf, "ready\n");
> +
> +	return sysfs_emit(buf, "not ready\n");
>  }
>  
>  /* Device reset */
> @@ -1430,7 +1430,7 @@ csio_show_dbg_level(struct device *dev,
>  {
>  	struct csio_lnode *ln = shost_priv(class_to_shost(dev));
>  
> -	return snprintf(buf, PAGE_SIZE, "%x\n", ln->params.log_level);
> +	return sysfs_emit(buf, "%x\n", ln->params.log_level);
>  }
>  
>  /* Store debug level */
> @@ -1476,7 +1476,7 @@ csio_show_num_reg_rnodes(struct device *dev,
>  {
>  	struct csio_lnode *ln = shost_priv(class_to_shost(dev));
>  
> -	return snprintf(buf, PAGE_SIZE, "%d\n", ln->num_reg_rnodes);
> +	return sysfs_emit(buf, "%d\n", ln->num_reg_rnodes);
>  }
>  
>  static DEVICE_ATTR(num_reg_rnodes, S_IRUGO, csio_show_num_reg_rnodes, NULL);

-- 
Damien Le Moal
Western Digital Research

