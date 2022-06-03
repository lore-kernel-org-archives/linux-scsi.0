Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5055C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 05:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbiFCF3s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 01:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbiFCF3q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 01:29:46 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C6D38DB4
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 22:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654234184; x=1685770184;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9FZQVzxn063Bhfy6844nVlKb+4MlHlf2A6QM9Xv1sKk=;
  b=BjH2BSRdTZgYszmJegFRUBVRZCoEy/bTfj+7xUczcyJQyZ8yerTYF60b
   ApuJfcNNDIVBB3rx89+lGcabyko42gdjSOk3ZEPI7+vpSRsOntoXkx4g4
   6AvtQthc2KvwRH2oGJ1nbnX6/MbQE9ccilLFEH6brsFK72/hKhtdl2fr1
   5vgz668Sc0SahMw3kkuPsoQWUoa5UTRxDVc+k5b25TNl2bjcYxv0is9yM
   TDo/8+tkG/R/iho4mb/NkeNGNCcItOdTKPGQfFZ3tKQk4J7baRCOXWeLl
   wSh9S0soUINxMjQRdMhzN4MyIHjsVdR8fEC8gsvEsc58+n/Y1qfHEhzwf
   w==;
X-IronPort-AV: E=Sophos;i="5.91,273,1647273600"; 
   d="scan'208";a="207027460"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2022 13:29:44 +0800
IronPort-SDR: VP4/11ZIAW6dMgzDsO4FOgsXaUVCnx/rNbcELXb+D+8n37FygaSkt5kwbvs3kebr/hSgK1bDCJ
 AIslAGaSSHgcPxRis7YltJlZUu7Q0s3eXOqpIqEiDCRZ8V638Ih8nDseFRd7Mf+Ibfi1cWQrfs
 0i90xbMCRhudCH680YMf3MBsi6SYug9qeRdjsBvqoxpRvawriQyZdYS93iBgKyY2T3pX4mYmUK
 WenaQ8MBHKwlW0N+EEhXzOO5tJaweaUX4yIp4Dn+Wsw5V/RkXEE876tQyiExYv19Y8B+Sfn/Vd
 WB9S4J5gb3bebD857e01Cg5l
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Jun 2022 21:48:48 -0700
IronPort-SDR: z/dbDTSwpYFrleMxFODMMEU+3j2OiJK3h9R1+xU78e13y8nlmv3Uz0IqtO0DOsnRWJhC8a202J
 +VSzcHcxj8hSH4knrwSWvEv+s031NCNxMAW6gzA5UAYSK8BUngtTGQpaLz2qQ5DmWvLS7lQgEh
 vMY1bTiF9EtpCHxRp3z3JzUzQtdpi7Je5JtilqjByVQEiqfOWrTTw18RkFWPUU1hgNS8DBu8/8
 2Rx+qcQZRLD42ZTlo+fhuRqQaksttXFrcUXM18dyFDICSC6505DwsZKbJtI4BUzoWPomlFfrIm
 7EQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Jun 2022 22:29:44 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LDrzq3fKyz1SHwl
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 22:29:43 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654234182; x=1656826183; bh=9FZQVzxn063Bhfy6844nVlKb+4MlHlf2A6Q
        M9Xv1sKk=; b=kfaadWAs8FmqQ6vJbZxLr3Lx8fr9mnQCZhihD1TC4pKGLR6drQ2
        ryl8jZn2R4TSomFAJeUDJQpXTNPt9Q85h7hCiJJ91dKuv1WZauKR3J9LXxYhwqzO
        5+Y3eOOiMRjKUC3bVF21dvyANxEb32RBo/lU6cfbCS/52cX2L0ChGvrNNeCmaeW2
        DHAqGcuSEaE0CP/0J8ugTMF80NNVFdEGJcIucUzLNJvy1SRzx1O8yEqoWWHRPn8Z
        GCbWRljKwX7igUkyH60nSV4L6UPYpTW4ETzIXl70QIQZrxl3nN7ElGHPWSCD53YQ
        58dBj0XfIt1o6SDMpsvoJk5I4cJOXJ78JzQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vrXRAcKn4nzi for <linux-scsi@vger.kernel.org>;
        Thu,  2 Jun 2022 22:29:42 -0700 (PDT)
Received: from [10.225.163.68] (unknown [10.225.163.68])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LDrzn5wNMz1Rvlc;
        Thu,  2 Jun 2022 22:29:41 -0700 (PDT)
Message-ID: <7fff85a3-b375-2dae-8555-b2d88210f9cc@opensource.wdc.com>
Date:   Fri, 3 Jun 2022 14:29:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 0/3] ata,sd: Fix reading concurrent positioning ranges
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Tyler Erickson <tyler.erickson@seagate.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, muhammad.ahmad@seagate.com
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
 <d3cc3cff-b483-b2dd-b6eb-131500b97d54@opensource.wdc.com>
 <Ypma2xNMaHYJflNx@infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Ypma2xNMaHYJflNx@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/22 14:23, Christoph Hellwig wrote:
> On Fri, Jun 03, 2022 at 10:30:04AM +0900, Damien Le Moal wrote:
>> Looks all good to me. I tested this and really wonder how I did not catch
>> these mistakes earlier :)
>>
>> Using a tcmu emulator for various concurrent positioning range configs to
>> test, I got a lockdep splat when unplugging the drive:
> 
> You probably want something like this:
> 
> ---
> From 4340b85be3532149310326b5f0caf329e1f4c748 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Mon, 23 May 2022 09:18:44 +0200
> Subject: block: don't take sysfs_lock in blk_ia_range_sysfs_show
> 
> sysfs already synchronizes internally against kobject removal, so remove
> the extra lock.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-ia-ranges.c  | 8 +-------
>  include/linux/blkdev.h | 1 -
>  2 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/block/blk-ia-ranges.c b/block/blk-ia-ranges.c
> index 853be76b9808b..e9e7ebf02737f 100644
> --- a/block/blk-ia-ranges.c
> +++ b/block/blk-ia-ranges.c
> @@ -54,13 +54,8 @@ static ssize_t blk_ia_range_sysfs_show(struct kobject *kobj,
>  		container_of(attr, struct blk_ia_range_sysfs_entry, attr);
>  	struct blk_independent_access_range *iar =
>  		container_of(kobj, struct blk_independent_access_range, kobj);
> -	ssize_t ret;
>  
> -	mutex_lock(&iar->queue->sysfs_lock);
> -	ret = entry->show(iar, buf);
> -	mutex_unlock(&iar->queue->sysfs_lock);
> -
> -	return ret;
> +	return entry->show(iar, buf);

I sent a patch that Jens applied doing exactly that. But forgot to add the
removal of the queue pointer you have below. Sending an incremental patch
for that.

>  }
>  
>  static const struct sysfs_ops blk_ia_range_sysfs_ops = {
> @@ -149,7 +144,6 @@ int disk_register_independent_access_ranges(struct gendisk *disk,
>  	}
>  
>  	for (i = 0; i < iars->nr_ia_ranges; i++) {
> -		iars->ia_range[i].queue = q;
>  		ret = kobject_init_and_add(&iars->ia_range[i].kobj,
>  					   &blk_ia_range_ktype, &iars->kobj,
>  					   "%d", i);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index a72203ed25454..0ceb85ca52af4 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -348,7 +348,6 @@ static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
>   */
>  struct blk_independent_access_range {
>  	struct kobject		kobj;
> -	struct request_queue	*queue;
>  	sector_t		sector;
>  	sector_t		nr_sectors;
>  };


-- 
Damien Le Moal
Western Digital Research
