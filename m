Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731F2CE79A9
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 16:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjISQ1n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 12:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjISQ1m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 12:27:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50B092;
        Tue, 19 Sep 2023 09:27:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78516C433C7;
        Tue, 19 Sep 2023 16:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695140856;
        bh=/YtV+6W6LsODiFxiATsenledXoIGVof4Rjz+HVc9CFM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ey/ijgBoAm4dBs1RlT+Ryr35UkeRsRrjeuR0x7w/3SAcOA3Mh5dfIvoyDq9Hkxq6i
         C3pUSIah0Am3OxoENWZvAtPhksXOg4qBxrurco4pkmc3lJlDnZ4GAZmAmBDqCU6PAk
         ZAbzdoVRmECqAOKW+M1Y89cNEIzGtHYLE7KCWfUlKEOADRUKWxWeRxj6MZPaHSO+5a
         pPPSNhXkIyhSJNkF5Me7gDoYD2KtIcmmiWHgPBzevwgUEjv/PAFySOSPBd3LcxNya4
         qdpH0j6Ifftvo07nPH151ujyQnyomg1zphNkvi64rM8/i8ldijglvkCMOa+hRRMp8q
         b8vQPpn1qGO3A==
Message-ID: <be4525e4-2761-897a-f186-0759e092ab14@kernel.org>
Date:   Tue, 19 Sep 2023 09:27:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 03/23] ata: libata-scsi: link ata port and scsi device
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230915081507.761711-1-dlemoal@kernel.org>
 <20230915081507.761711-4-dlemoal@kernel.org> <ZQmgU/j8OD8t4KLs@x1-carbon>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZQmgU/j8OD8t4KLs@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/19 6:21, Niklas Cassel wrote:
>> diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
>> index 17f6ccee53c7..32968b4cf8e4 100644
>> --- a/drivers/ata/pata_macio.c
>> +++ b/drivers/ata/pata_macio.c
>> @@ -918,6 +918,7 @@ static const struct scsi_host_template pata_macio_sht = {
>>  	 * use 64K minus 256
>>  	 */
>>  	.max_segment_size	= MAX_DBDMA_SEG,
>> +	.slave_alloc		= ata_scsi_slave_alloc,
>>  	.slave_configure	= pata_macio_slave_config,
>>  	.sdev_groups		= ata_common_sdev_groups,
>>  	.can_queue		= ATA_DEF_QUEUE,
>> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
>> index d105db5c7d81..353ac7b2f14a 100644
>> --- a/drivers/ata/sata_mv.c
>> +++ b/drivers/ata/sata_mv.c
>> @@ -673,6 +673,7 @@ static const struct scsi_host_template mv6_sht = {
>>  	.sdev_groups		= ata_ncq_sdev_groups,
>>  	.change_queue_depth	= ata_scsi_change_queue_depth,
>>  	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
>> +	.slave_alloc		= ata_scsi_slave_alloc,
> 
> It seems wrong to add .slave_alloc to all different ata_port_operations structs.
> The .slave_configure is added on all different ata_port_operations structs,
> because the callback can be different for different drivers.
> 
> However, adding the device link is done in .ata_scsi_slave_alloc,
> removing the device link is done in .ata_scsi_slave_destroy.
> 
> Thus, I suggest that we only add the
> .slave_alloc = ata_scsi_slave_alloc,
> 
> to __ATA_BASE_SHT() in libata.h, which is currently the only
> place which has .slave_destroy defined.

Good point. I will make this change.


-- 
Damien Le Moal
Western Digital Research

