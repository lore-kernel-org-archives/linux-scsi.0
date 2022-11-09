Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83009C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 05:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiKIFWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 00:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKIFWX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 00:22:23 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4B51C41A
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 21:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667971343; x=1699507343;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=U+aMtLE95I3T0qSgTAy+F3TL1tuxvMZUbW7s3cWn/TE=;
  b=RYDeoYEKATwR+y+bfLUFPfI2jdOT/1/Oe6PAAXBaQqtipKsB62KGtRE3
   KTDld/LW5w0ZyAWdspJXPpIWGXTTHmKF4dCjFWO6lZh3tS2dvu+9TOa+1
   HBqpT53rHYIsPetiHDTfWP/HNLtwzS9s1UczWA1T5f2g/lEh/gY3Esx6o
   Zc/nDVaX+If8yEEWn+mUcFw0jh6SW6siK1nzbqJapQtwSchIZ2nTHSKMk
   wn3ij9ZzDGyN2tYZUP0H0lydDUWIEAAn13qnFM503wzmYQS4WBKe36VyU
   94iGHgrzrKZbb4aF+qTx89vHUiBaEZHu1BWGnEB/vKkq6e6S1YIKwf5eL
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,149,1665417600"; 
   d="scan'208";a="327928768"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2022 13:22:23 +0800
IronPort-SDR: oSIdZKulruZPWT/sHX7TWYtmivbtASXdK4fYV/DVWhPwi4bZKq1F06vBFnke0CbiVNnTZMZAv4
 S7vnMRHItIkF+w0wJBkIm7tMyYzEB6BCynfygQ8OMOAGHf/PB5yUcsk+3zhsxlW5znrI+7MlB1
 zDWm52DZpey+bxq7YODW+2L1GriiHu59hGm7/GAYiF4IVa4anN92XKlJDRWBHlpt0Q/HOhp2yE
 XhqNQZaa0Ib9afBoGxtJAUTmvmGY/VC6oDBN8byT57kr09rbrcEBws5czFe266JQoePgQyx1ce
 fhw=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 20:35:43 -0800
IronPort-SDR: gBz8l490jAOaz/ZMjXCFJiSmJnvRb338OGCz3zsWQdmbcyOIEvvkVrs2rmaxuq2kItI+HdtIUZ
 +SAl/51fuAffqx+FiF0BeyKUgNsXJMAobgnz16hEw5gVtH99DrD7zPF2j0pB/Wbo48aZiac8Gg
 0iARIyt5Nut5Iq/qzMO2PWHeOfDkJmzBJutOYwMOVMxIglK+jn6eSmJYiIB0e8/3alik81hnzl
 6bu6xH0gDy3NJE7N+2NyI1x30YRUFY79hFIebtckqUe2Y0C2oMCzMN1gk3rewmgkCRjRX3CemT
 jUc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 21:22:22 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N6YHy3rjDz1RvTp
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 21:22:22 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1667971342; x=1670563343; bh=U+aMtLE95I3T0qSgTAy+F3TL1tuxvMZUbW7
        s3cWn/TE=; b=oHs2kktg+YqVBIFZOCZVfb5A81g2C327SJJCg0qiPvilt75IIar
        2AS1QdNpKGn0kZQdtZC5RypuWzqvD9gxsd8SjC/geLKto0NQkymvVc1Vji5A0Gwf
        SR8pZIhag6fGUJ+fJEYNquLqALHl7qxSiK7bWjmfn+bWjVoSalWXKdvznSVym/HY
        SuuLLsWV2+UKmGHTGGPkReR1xx6m9IiLtrQ73cT7SxGaDs55D+36/0q6gWeTpJlJ
        0Ex/Gul+pgffNEHhqKrEJR3W+XH18SDjfAgeyrvR8yXcJYJ/lHJqArgJa2UEYDps
        yCX7bSVveiC5AAwdczt58KzkkeNL12uTR7Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EJdqwssby80l for <linux-scsi@vger.kernel.org>;
        Tue,  8 Nov 2022 21:22:22 -0800 (PST)
Received: from [10.225.163.37] (unknown [10.225.163.37])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N6YHw5pQSz1RvLy;
        Tue,  8 Nov 2022 21:22:20 -0800 (PST)
Message-ID: <e4824691-aa3c-d054-eab9-679f83fa9c67@opensource.wdc.com>
Date:   Wed, 9 Nov 2022 14:22:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] scsi: mpi3mr: suppress command reply debug prints
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20221109031207.1605138-1-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221109031207.1605138-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 12:12, Shin'ichiro Kawasaki wrote:
> After it receives command reply, mpi3mr driver checks command result. If
> the result is not zero, it prints out command information. This debug
> information is confusing since they are printed even when the non-zero
> result is expected. "Power-on or device reset occurred" is printed for
> Test Unit Ready command at drive detection. Inquiry failure for
> unsupported VPD page header is also printed. They are harmless but look
> like failures.
> 
> To avoid the confusion, print the command reply debug information only
> when the module parameter logging_level has value MPI3_DEBUG_REPLY=128,
> in same manner as mpt3sas driver.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index f77ee4051b00..2b95d1d375f2 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3265,7 +3265,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
>  	}
>  
>  	if (scmd->result != (DID_OK << 16) && (scmd->cmnd[0] != ATA_12) &&
> -	    (scmd->cmnd[0] != ATA_16)) {
> +	    (scmd->cmnd[0] != ATA_16) &&
> +	    mrioc->logging_level & MPI3_DEBUG_REPLY) {
>  		ioc_info(mrioc, "%s :scmd->result 0x%x\n", __func__,
>  		    scmd->result);
>  		scsi_print_command(scmd);

Looks OK.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

