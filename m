Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCB0CA0ECF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 07:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjILHw3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 03:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjILHwS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 03:52:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3ACA10CA;
        Tue, 12 Sep 2023 00:52:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A955C433C7;
        Tue, 12 Sep 2023 07:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694505134;
        bh=7RziTGtFs4XWiI0qMIkpq6u2RT7BBMRF7ihhn7LshJs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IFSvBa/YDTY8r9C7/SoDzLmhtFsbZDfhyiZ6W6i1Lwgcu9vN/AaxgCi79GeQG6VoJ
         6M1HwgV5qIjbs1ZcUOPg8subMJVZgnLLn/ztobll/tzqv5WZIPwdJh8468S7CzT12e
         G0OlkpAVE6oCb88iXRYb8t9TOq9/H7ZaMgZ31FSlhdtqS4GtNRehVFfqX7r96K3Z/i
         qcdJ7s2FgzsZv4AX/NlVBr+HUvt/uKIkgAKvHQWAnnnER2qMq9jorx+ndnZOrGpb64
         Yo3gmZryl794QdCOavDWvp+Ku1aQ3mQRc3kAKBkGJfQpldGMZBS1Pk1Qek9R43jpjW
         MZYUDPoFD0EQw==
Message-ID: <3b50010d-efd5-a38a-7dec-46aab50f3071@kernel.org>
Date:   Tue, 12 Sep 2023 16:52:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 18/21] ata: libata-sata: Improve
 ata_sas_slave_configure()
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230912005655.368075-1-dlemoal@kernel.org>
 <20230912005655.368075-19-dlemoal@kernel.org>
 <6b137561-a5f0-4dc2-c4ff-1c31cb1a0c7e@oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <6b137561-a5f0-4dc2-c4ff-1c31cb1a0c7e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/23 16:43, John Garry wrote:
> On 12/09/2023 01:56, Damien Le Moal wrote:
>> Change ata_sas_slave_configure() to return the return value of
>> ata_scsi_dev_config() to ensure that any error from that function is
>> propagated to libsas.
> 
> This seems reasonable, but does libsas even check the return code? From 
> a glance, I don't think that it does...

Indeed it does not. This functions still always return 0 at present, so not a
big deal. But for consistency , I will add the check in libsas.

> 
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
>> ---
>>   drivers/ata/libata-sata.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
>> index 5d31c08be013..0748e9ea4f5f 100644
>> --- a/drivers/ata/libata-sata.c
>> +++ b/drivers/ata/libata-sata.c
>> @@ -1169,8 +1169,8 @@ EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
>>   int ata_sas_slave_configure(struct scsi_device *sdev, struct ata_port *ap)
>>   {
>>   	ata_scsi_sdev_config(sdev);
>> -	ata_scsi_dev_config(sdev, ap->link.device);
>> -	return 0;
>> +
>> +	return ata_scsi_dev_config(sdev, ap->link.device);
>>   }
>>   EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
>>   
> 

-- 
Damien Le Moal
Western Digital Research

