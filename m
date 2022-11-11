Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D965CC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 01:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiKKByh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 20:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKKByg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 20:54:36 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D47112094
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 17:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668131675; x=1699667675;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=xbTRsx7Zf97gcKJirlnEs6B95JZ9jcLrGVPLxjiEN84=;
  b=M+dRnajU/sCvxZ4B/iP+SVJTjckNMJqYYqo9XR20vt5E2CJeK8/NQ0/1
   YgaoUDTty8QIYHU/FHWitl/zhK8lI9Qm1Azo2PsmhRaK/6kZV+Mw+NVB0
   nptNqYeL6dD2n4WQm53EIlcvmm3kUSgFUXgM//Cbc22qpuP8cPuuwT57o
   +PUTNQcz1RWgJhWWjxNR7P4Kg5RBL6fOgeutWlQvGg+ivS2WRiz0h30dl
   AcJvMgzyI2NRG3rbDVUxbPSWqhzOnvVNn8qHNLm7h9haN+8w7rythJgvb
   Ngt/qRWGJVjf/mfhIwk6uNHDr6cjXAPaAbZ5xnkH3lRNMliwHQePiLJcB
   A==;
X-IronPort-AV: E=Sophos;i="5.96,155,1665417600"; 
   d="scan'208";a="214285877"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2022 09:54:35 +0800
IronPort-SDR: 8swx2/N0FT9WbAFIljklLwSpCIMQTCjT9UFu/4peQbMjsmD/eo6xZp7xEszhVn/KTN9bYpDNe5
 I+X96FTOl/ZlDMZI1vRf0Oypr4HCpqWRjIQCVjF0R6VgLdT4piyR6BluFxcG+ewBHHdcHVCePL
 mIDcvqUqEx2RpERIUiXUKJKRIIV81jdAUDRawTVd0b7Dup/9TZbpQhAxiM1Rkuxc7Ht0SRLXD7
 xmWq7pW5EO82Ch4hjPtJRj37LaIFgsOr8MWa31VT2+qEbSluFEvl/S6V8pwfMi9dDddOUGhAFb
 Tto=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2022 17:07:53 -0800
IronPort-SDR: ZuF0++qIdzw+Byy4la93WcsPDgWY6BnS0lWaxQuSpQ4m5W+zwNzRwSzaQQTlJ8PHP1If2/xNIG
 WwY+0Q4mzE9SQS9y8/QtppJlA6CPlLQe+TjvSO4DtKqnYc0mrRy5bWqWvmlp7Dyb5c25txEqyi
 yEvZJ5/KJLlj8sd/fP5eRRlkWiqaaEzqkf9zzOF03QBs36Dv5zxIsJq2gc+OdeymS2hb9kHKds
 e+tLSP76uABYjHwDgNJkABkPPeSa35rTpgPE4h5QqQdJxUJumUsFv3e2SqKZUWQYf/A6y3Orsr
 Ja8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2022 17:54:35 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N7hbG4n7Rz1Rwt8
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 17:54:34 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1668131674; x=1670723675; bh=xbTRsx7Zf97gcKJirlnEs6B95JZ9jcLrGVP
        LxjiEN84=; b=uf0aOrMGa6/DxDihAednplARbVr5zUfsv23wyJIHo4hHjTEWfbz
        K1niDSTxgTFcjm/328Aze5XW72guT7FAtDvRaQCZMoEY90coVz5j0eg/JFst8X9p
        QZIMf75PCd2ECDsrg66wNPAgqp/4m6vUmLgq0ojQPqFlcPyp2v5/qxAR6ceieXv+
        z8qFcbGsuCkBmDcmQ6EF1zCYg8VLWFpXgnlWek+gCCPJ15rehKTgWHjsWWsdQO/k
        oMYV1zASeajsoThShmd6eZdj4IUk+UPvkTNOlN6NFKrNnMjONRVL7c2Dxh3I6hRi
        b0Bf9JOZOLOQ6eCqlfDLDcDcWGOqjacEzwA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EdrqhwBupASu for <linux-scsi@vger.kernel.org>;
        Thu, 10 Nov 2022 17:54:34 -0800 (PST)
Received: from [10.225.163.43] (unknown [10.225.163.43])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N7hbD5X6Vz1RvLy;
        Thu, 10 Nov 2022 17:54:32 -0800 (PST)
Message-ID: <83d9edb8-bb36-80e0-1da7-30300c677a8b@opensource.wdc.com>
Date:   Fri, 11 Nov 2022 10:54:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2] scsi: mpi3mr: suppress command reply debug prints
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20221111014449.1649968-1-shinichiro.kawasaki@wdc.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221111014449.1649968-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/22 10:44, Shin'ichiro Kawasaki wrote:
> After it receives command reply, mpi3mr driver checks command result. If
> the result is not zero, it prints out command information. This debug
> information is confusing since they are printed even when the non-zero
> result is expected. "Power-on or device reset occurred" is printed for
> Test Unit Ready command at drive detection. Inquiry failure for
> unsupported VPD page header is also printed. They are harmless but look
> like failures.
> 
> To avoid the confusion, print the command reply debug information only
> when the module parameter logging_level has value MPI3_DEBUG_SCSI_ERROR=
> 64, in same manner as mpt3sas driver.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
> Changes from v1:
> * Changed logging_level flag from MPI3_DEBUG_REPLY to MPI3_DEBUG_SCSI_ERROR
> 
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index f77ee4051b00..3306de7170f6 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3265,7 +3265,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
>  	}
>  
>  	if (scmd->result != (DID_OK << 16) && (scmd->cmnd[0] != ATA_12) &&
> -	    (scmd->cmnd[0] != ATA_16)) {
> +	    (scmd->cmnd[0] != ATA_16) &&
> +	    mrioc->logging_level & MPI3_DEBUG_SCSI_ERROR) {
>  		ioc_info(mrioc, "%s :scmd->result 0x%x\n", __func__,
>  		    scmd->result);
>  		scsi_print_command(scmd);

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

