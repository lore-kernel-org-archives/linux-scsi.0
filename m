Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6450C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Sep 2022 22:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiITWCx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Sep 2022 18:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiITWCv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2022 18:02:51 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6CE2E6A2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 15:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1663711370; x=1695247370;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6u/Do0n+DJNOsBzHcFMsX5pbbOEzyvcZYBGc4xAk91s=;
  b=K+5IweE77lIofajyi4a9mjcFwTk5rzpiusSL3p+Af6lTCjoCPBHll4EO
   6gT4m18os94kqEChQ73qPCper5RFl+8uozlcBEavtdGc3bUyUekNAkhsw
   mdJy1WNrAP0U7V/2Vqmc4kcLJps3Kw4ozdscIM/NidsUr6Bt9QVEFqrCu
   MEw8xN6a3iffTGrRuBTEWukHDSzmNxs7AsX0HHmrPHBUiKjnxKS3tlKZc
   zVNIjeUHVBH7IoELHmNVM0vWFhBmY3P0aYKzLSaVEn210y1cAnYQlKN90
   V8A+chAwyofjU9Q1YcOPCcD/UMD6OhSLwyJfxI+7XuEEVYNV6+fM7ygYq
   g==;
X-IronPort-AV: E=Sophos;i="5.93,331,1654531200"; 
   d="scan'208";a="211848338"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Sep 2022 06:02:49 +0800
IronPort-SDR: 06mrDukEYJ0tzgHzvI0x9aJhvFLUEBhdIxq4mqUZUzKzw+mnEMTjFqcXXT8wwRtbAJSxYbvNtj
 XpPv5NlHvb7SwDOXVFBLecUeBHaKL6aOSeuF1FjGJRuyOL1p9ZFhQRwruMsh8hNsL5RflyeCyX
 CMNiH30TowpsUd8eM7TSp93jjaADLUsBKsHy+OM+HaVu5/29ahVq+oJ4MkVCYXz2l3kjMOVfzz
 lfOPOoI8TqZ7m50sjzCI0wKrXh1sYp2u8MUyEtjIEgonKRzHpXhJRe/K4htXtJI6jpj+18KRR0
 WgTQL/810qlgzIhbS/a4tWha
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Sep 2022 14:17:25 -0700
IronPort-SDR: wHSm9iQQIW0eikccIgWf5/v4TO2AmVpOxNdhMNiFKv59TsSkSKldh4C2uTR9EBU3dyItoj/8aF
 9XUBlLOI6OUBN402ITL28XWtCP9NDDdjmGdZPI6tSva68R39Xa6hAapY9td8Mb3Ztj3wYkGSyq
 qVRkIAlOHCEN1wHz5tw6/lhH0kyDI+p7Qv0tmJy4EE9FJ7FHMWDnjtAHrOg+JgUpTZMB/4PJu9
 oVUwp6e9jpEOrthFD/Z/HfxfqjTezCi9oqM4Reeq2Ibb3q5/ojk9pcyozfwOxd6JwpOzth9jES
 8Bg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Sep 2022 15:02:50 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MXFsN4yNMz1Rwtm
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 15:02:48 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1663711368; x=1666303369; bh=6u/Do0n+DJNOsBzHcFMsX5pbbOEzyvcZYBG
        c4xAk91s=; b=Vy2jDG5CWTP1bCLAuV+2/7XzFGagws2IDT2t68UUsgEHlhpJX3M
        omkxRW4wBMkbxtNRPh8Qx8sReRWiy+iwNOTm46I5IoXBDPQbqzfiPydACPVO6Bnr
        QyB9ezhsrXo3fElUVHlyDd0zNMQ21iVQiuuhcSFI9JVgTu54c2HW6toF5UrF3TTi
        L+wi5gdJ6uQso4VxuU+QOz2s56AsCKudramoD9wQpUymOPqASy+cUBbvEQTn7eJw
        8BYLPA0A80j+3eMVzdd7X82P+hIEyk34UFak912EHQKmzoP6YSgiGafXnifyuI/a
        1Kw68xjZ1LHOuPLsqC1VwTGzo2MiOe5sBHw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id PixGdvez3-Gi for <linux-scsi@vger.kernel.org>;
        Tue, 20 Sep 2022 15:02:48 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MXFsJ47y5z1RvLy;
        Tue, 20 Sep 2022 15:02:44 -0700 (PDT)
Message-ID: <ecde5199-bb9e-6df4-832a-f3707babd3d6@opensource.wdc.com>
Date:   Wed, 21 Sep 2022 07:02:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH RFC 2/6] scsi: scsi_transport_sas: Allocate end device
 target id in the rphy alloc
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hare@suse.de, hch@lst.de
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, brking@us.ibm.com
References: <1663669630-21333-1-git-send-email-john.garry@huawei.com>
 <1663669630-21333-3-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1663669630-21333-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/22 19:27, John Garry wrote:
> Currently the per-end device target id is allocated when adding the rphy,
> which is when we execute the scan of the target.
> 
> However it will be useful to have the target id allocated earlier when
> allocating the rphy for the end device. For libata we want to move to a
> scheme of allocating the sdev early in the probe process and then later
> executing the scan (for that target). As such, users of would libata would
> require that the target id allocated earlier here (before the scan).
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/scsi/scsi_transport_sas.c | 25 +++++++++++++++++--------
>   1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 2f88c61216ee..56d325665bc7 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1433,6 +1433,7 @@ static void sas_rphy_initialize(struct sas_rphy *rphy)
>   struct sas_rphy *sas_end_device_alloc(struct sas_port *parent)
>   {
>   	struct Scsi_Host *shost = dev_to_shost(&parent->dev);
> +	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
>   	struct sas_end_device *rdev;
>   
>   	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
> @@ -1455,6 +1456,10 @@ struct sas_rphy *sas_end_device_alloc(struct sas_port *parent)
>   	sas_rphy_initialize(&rdev->rphy);
>   	transport_setup_device(&rdev->rphy.dev);
>   
> +	mutex_lock(&sas_host->lock);
> +	rdev->rphy.scsi_target_id = sas_host->next_target_id++;
> +	mutex_unlock(&sas_host->lock);
> +
>   	return &rdev->rphy;
>   }
>   EXPORT_SYMBOL(sas_end_device_alloc);
> @@ -1500,6 +1505,16 @@ struct sas_rphy *sas_expander_alloc(struct sas_port *parent,
>   }
>   EXPORT_SYMBOL(sas_expander_alloc);
>   
> +static bool sas_rphy_end_device_valid_tproto(struct sas_rphy *rphy)
> +{
> +	struct sas_identify *identify = &rphy->identify;
> +
> +	if (identify->target_port_protocols &
> +	    (SAS_PROTOCOL_SSP | SAS_PROTOCOL_STP | SAS_PROTOCOL_SATA))
> +		return true;
> +	return false;

You could just do:

return identify->target_port_protocols &
	(SAS_PROTOCOL_SSP | SAS_PROTOCOL_STP | SAS_PROTOCOL_SATA))

> +}
> +
>   /**
>    * sas_rphy_add  -  add a SAS remote PHY to the device hierarchy
>    * @rphy:	The remote PHY to be added
> @@ -1529,16 +1544,10 @@ int sas_rphy_add(struct sas_rphy *rphy)
>   
>   	mutex_lock(&sas_host->lock);
>   	list_add_tail(&rphy->list, &sas_host->rphy_list);
> -	if (identify->device_type == SAS_END_DEVICE &&
> -	    (identify->target_port_protocols &
> -	     (SAS_PROTOCOL_SSP | SAS_PROTOCOL_STP | SAS_PROTOCOL_SATA)))
> -		rphy->scsi_target_id = sas_host->next_target_id++;
> -	else if (identify->device_type == SAS_END_DEVICE)
> -		rphy->scsi_target_id = -1;
>   	mutex_unlock(&sas_host->lock);
>   
>   	if (identify->device_type == SAS_END_DEVICE &&

You could move this check inside sas_rphy_end_device_valid_tproto(),
no ?

> -	    rphy->scsi_target_id != -1) {
> +	    sas_rphy_end_device_valid_tproto(rphy)) {
>   		int lun;
>   
>   		if (identify->target_port_protocols & SAS_PROTOCOL_SSP)
> @@ -1667,7 +1676,7 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
>   	mutex_lock(&sas_host->lock);
>   	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
>   		if (rphy->identify.device_type != SAS_END_DEVICE ||
> -		    rphy->scsi_target_id == -1)
> +		    !sas_rphy_end_device_valid_tproto(rphy))
>   			continue;
>   
>   		if ((channel == SCAN_WILD_CARD || channel == 0) &&

-- 
Damien Le Moal
Western Digital Research

