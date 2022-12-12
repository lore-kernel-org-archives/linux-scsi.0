Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FE6C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 05:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiLLFgc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 00:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLLFg3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 00:36:29 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C417BC1F
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 21:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670823388; x=1702359388;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IvNtnSwLnggOVmPHOpM15im0WxV3Y8LnGqpCv10zSdc=;
  b=P4Zx5orgdTCKmXQ7SP402v1Upu04zQ1gtlTKSL9X1SJLR6WIoNztkV9W
   eHP1xECzHPBnupO94NMVSN2eOpYg5Fzj/Uxopn1KINGFKCzdo+DkdwwQp
   sZ14dC5LJ2j5LSAP+9Lk3VIexRVyKYqEx8cqgQdKcsnWtLwp5MVwyvzT8
   HIL8Jlo6f9vDYcepLIbVRFISTw0WAXd3niVhgVX0X9/YXMaTAqHKxvSVv
   DFX3cie/6HAvlGh+NSAmfxFsXs8loa8M0qQ+GuksNBBnS1DVR2bYAEYlL
   ag4JIefb8p99ghOb4U1/BeMwK8RDpMBm96wGoqodhYniynQkZh50cOsQO
   A==;
X-IronPort-AV: E=Sophos;i="5.96,237,1665417600"; 
   d="scan'208";a="218672533"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2022 13:36:27 +0800
IronPort-SDR: EI0pVH8Y0V+ENQOzs9HBGGbDQygV8n7okJjmZlHgzU9r2svbXNzLkGwxHJptKmTwzobHY1o9ke
 x6igo6R93e6ukW+N+MOFGF1lAVJYcs49f1fh05WMNK13oRY73zvtdrBZBOkk4XwG9DR305rbRC
 CqB2ad4tcKDli8oj1ZxLvfFUWbJ04u4idh2clYOGrR9U8IPsjLsR/uuSSIuIeuKZMmns7EFw6S
 XoG+LazaWO8iMV4MAKMq0kC0ScA89Q1oKkM5PZ4rqtHFbnZnlleHhg9blHL8DW+2IRMd4k5fso
 3+c=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 20:54:52 -0800
IronPort-SDR: sfwAvDdRF99ezn4fOuj6QAPzD1S8AhhsEwyly3B3JsKQ38yYbonSluCbuj01dnNpqa9z9+rYgT
 LBjqWi+S4lCC8BEZlOUgiQMf14Z8InKIHCC9xnhiG0ioSIfVSHZjUuyL/51xKSpNXYBTgAdJC0
 7MH3LxTvHuQh0lV1CmxVgR5AlOtfOQbDGSgqEnktPtea+2DMuFPHs9ZsYTE0O+WSin+Ga96T80
 HP+3wiwKgXOSRdXWvqvtlgklZndt0Lg9o7y0mX/Xv/220crJu7UWT0LBJDVKQLki20EyWoLtip
 Gkg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 21:36:27 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NVr2z2PDGz1RwtC
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 21:36:27 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670823386; x=1673415387; bh=IvNtnSwLnggOVmPHOpM15im0WxV3Y8LnGqp
        Cv10zSdc=; b=d8CZtBHdrSZY1IXaqL/zSdz9nK0BrYnySFTZtRPUB1JmU0coWv/
        QSfPafCgTdEG9OWXg4jqybFdEdK46Iqlf+nVMcdwUP/69f2L8B1qr73ANh4h851w
        DPBlzWuMKOFNOtDUoklK+VH/jZOAGmTa+mmpIrphA6YjsE4o5NY04t4Mr5ZtX11S
        5FOi1Yqd87Az6VO1e6rp98WwoKtkmCJ7CusJN4mBn7n0y0HP6J65ojn3wGc3dBa8
        SxiQyXNcWgxIVGzZz9FBje3BT5pKtLTypGqHZXlqll6kIjzBqtsCSnT7yfF39XnS
        OpTEZAy8M1bBG5d/jt6WCd+Ub94MvuDkj7w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 59a7qtX5pdUw for <linux-scsi@vger.kernel.org>;
        Sun, 11 Dec 2022 21:36:26 -0800 (PST)
Received: from [10.225.163.90] (unknown [10.225.163.90])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NVr2x492Vz1RvLy;
        Sun, 11 Dec 2022 21:36:25 -0800 (PST)
Message-ID: <ceb05d8a-f96c-6dcf-c63f-8a0ec0d300f1@opensource.wdc.com>
Date:   Mon, 12 Dec 2022 14:36:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 3/3] scsi: mpi3mr: fix missing mrioc->evtack_cmds
 initialization
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
 <20221212015706.2609544-4-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221212015706.2609544-4-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/12/22 10:57, Shin'ichiro Kawasaki wrote:
> The commit c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
> introduced an array mrioc->evtack_cmds. But initialization of the array
> elements was missed. They are just zero cleared. The function
> mpi3mr_complete_evt_ack refers host_tag field of the elements. Due to
> zero value of the host_tag field, the functions calls clear_bit for
> mrico->evtack_cmds_bitmap with wrong bit index. This results in memory
> access to invalid address and "BUG: KASAN: use-after-free". This BUG was
> observed at eHBA-9600 firmware update to version 8.3.1.0. To fix it, add
> the missing initialization of mrioc->evtack_cmds.
> 
> Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


> ---
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 3306de7170f6..6eaeba41072c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4952,6 +4952,10 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
>  		    MPI3MR_HOSTTAG_DEVRMCMD_MIN + i);
>  
> +	for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++)
> +		mpi3mr_init_drv_cmd(&mrioc->evtack_cmds[i],
> +				    MPI3MR_HOSTTAG_EVTACKCMD_MIN + i);
> +
>  	if (pdev->revision)
>  		mrioc->enable_segqueue = true;
>  

-- 
Damien Le Moal
Western Digital Research

