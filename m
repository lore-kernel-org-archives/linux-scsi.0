Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F61E7D0A2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 20:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjIUUrW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbjIUUrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 16:47:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D3E81FFE;
        Thu, 21 Sep 2023 10:36:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AB3C433C9;
        Thu, 21 Sep 2023 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695317428;
        bh=eddwPnBiRc58KTRuW67Y0mwiLdLjVpwMPN9Kc012Nrw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VZPkzXOBkkwCrPZl25Ie63srC1FMRQKxkcufqIYEeB85XeRwGdbUsEyEr0hbwD0iY
         zSleFI7GLIGdBAzuGA2d/LseoUGALHkssv34NuiVCskS7GiHMNCgDfpSXwLbNNiuj8
         h1CAkJqV5Nr3x99ygJCNTOwpfIcj/PlTIfewo5C7cL5Zl6W03vZ52IFr96L6lSF0++
         3K899oqJtuXpNdytOsHZxURD5gbe+8G7+aEoc1xBtP1kCS714xsbfE47/O16FNN/ix
         Scb0D0VWATW4VYytWBzRsuAfNkxKrdhCIoIT0JLcCs6yh4SAWz6245apdUnvelUu68
         Jwb2YRX0Z2uSg==
Message-ID: <2699e173-7fb5-59f5-c87c-32988c8cc90e@kernel.org>
Date:   Thu, 21 Sep 2023 10:30:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v4 03/23] ata: libata-scsi: link ata port and scsi device
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230920135439.929695-1-dlemoal@kernel.org>
 <20230920135439.929695-4-dlemoal@kernel.org>
 <906621de-eba1-5a1c-dd26-c3030ad7b983@oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <906621de-eba1-5a1c-dd26-c3030ad7b983@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/21 7:16, John Garry wrote:
> On 20/09/2023 14:54, Damien Le Moal wrote:
>> +int ata_scsi_dev_alloc(struct scsi_device *sdev, struct ata_port *ap)
> 
> nit: why not static? I could not see it used elsewhere. Indeed, I am not 
> sure why it is not inlined in its only caller, ata_scsi_slave_alloc().

The initial version of this patchset used this function for libsas as well. But
that is now gone, so I can indeed inline this.
Note that with the STATELESS flag added, the linking of ata dev and scsi dev
should work just fine for libsas now, so we could add it. But I am still not
convinced that is necessary... Will have a look as a follow up.

> 
> Thanks,
> John
> 
>> +{
>> +	struct device_link *link;
>> +
>> +	ata_scsi_sdev_config(sdev);
>> +
>> +	/*
>> +	 * Create a link from the ata_port device to the scsi device to ensure
>> +	 * that PM does suspend/resume in the correct order: the scsi device is
>> +	 * consumer (child) and the ata port the supplier (parent).
>> +	 */
>> +	link = device_link_add(&sdev->sdev_gendev, &ap->tdev,
>> +			       DL_FLAG_STATELESS |
>> +			       DL_FLAG_PM_RUNTIME | DL_FLAG_RPM_ACTIVE);
>> +	if (!link) {
>> +		ata_port_err(ap, "Failed to create link to scsi device %s\n",
>> +			     dev_name(&sdev->sdev_gendev));
>> +		return -ENODEV;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + *	ata_scsi_slave_alloc - Early setup of SCSI device
>> + *	@sdev: SCSI device to examine
>> + *
>> + *	This is called from scsi_alloc_sdev() when the scsi device
>> + *	associated with an ATA device is scanned on a port.
>> + *
>> + *	LOCKING:
>> + *	Defined by SCSI layer.  We don't really care.
>> + */
>> +
>> +int ata_scsi_slave_alloc(struct scsi_device *sdev)
>> +{
>> +	return ata_scsi_dev_alloc(sdev, ata_shost_to_port(sdev->host));
>> +}
>> +EXPORT_SYMBOL_GPL(ata_scsi_slave_alloc);
> 

-- 
Damien Le Moal
Western Digital Research

