Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED11C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 08:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5369761267
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 08:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbhKKItd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:49:33 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:14822 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbhKKItc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 03:49:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636620403; x=1668156403;
  h=message-id:date:mime-version:subject:from:to:references:
   in-reply-to:content-transfer-encoding;
  bh=l5f5zXplHfiHuRi1/EJSqjOCUsrwCfAUsYxTaAypXGo=;
  b=hXx5b7EvAv7k5+Vc82RMdjIfgBx4fCoc1yiPgvD4qBpSoG8ahu9um+WD
   YUQSTHPYuMuwcNbA+/EGEi7CgUA+Iv9N9mOrM7LS7nis0zXEa7xnPmuxQ
   xxB9a+Mqvz1Z4OEn2vaNVetUeDgdBKat9MFwbhBArrGEEfB3QKmex65ps
   e2E5M9g33i6S85HePlX07jfHSmOE6kmjpSBej7Lk2Gi3lurPRNmDSROsK
   2N+unVWRcI03c7eOZmi34CQCvDDm/Z7SOddq4YNBFuAHn3vjpSJSQk/F9
   jTTrSvoj11noOAh3gIQCEGE8YGevF1A/IHo3SQrD84C64Q2TMJHSZIs6i
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,225,1631548800"; 
   d="scan'208";a="185324835"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2021 16:46:42 +0800
IronPort-SDR: ij0jO6R1zK8ktCVgF6u150fKtbKMuL7G0CRPjZP31f0KqORX/lL7kWIhEcab9KmrPaU7Z/JKHP
 A9VZ2UoiIYCNZR19ckQCx60llb8mjuYzh1PVSJW2pCxyl7zPyWKkW4UUpxyW09QmGMDFQUJDpl
 d9PJl0KHAMru831Ne9CHhYOaM6S0utFAQVtX/lseS7nULyC4Xk/SqkpB4hKfX3nKq6IuP5MFFt
 wLHdj71ZlnJI+dzB/aNn1WtA2P8B4QsBD0lH0vA8a/GUGHeVUN8PWVIX6WUqFS4QuY/fWM4yFh
 1zfaGDxshCbD6ZNat85c2ol2
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 00:21:53 -0800
IronPort-SDR: MKFRxn8JydonwFR+8CHY/idcUgylkrQmnRPf3UgivA2ZFc4KEj0ONCNuOueYN69t93IFMtlz2Q
 P3L5/CVeWbhJk6qSXuTq9uxA+L+QvMze3ANqFmZ2yMbWdpeYI6OnxPQH7o27z2SXQ9+pwLiwQs
 b201fLY3tSUIoIG5FPMaFuFz4c0cpu5pNjFn1hqCYanco9RJBCUQdRM1jb3rj/BZ9zo9geIDux
 JmAgixwDcnGER/NXnklLuffFn6IwG0I3RJBXFIaSRial8XE3l2GjTeNxApRGmdn7C/e34SSAyy
 zCE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 00:46:43 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Hqb1H0HkMz1RtVn
        for <linux-scsi@vger.kernel.org>; Thu, 11 Nov 2021 00:46:43 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1636620402; x=1639212403; bh=l5f5zXplHfiHuRi1/EJSqjOCUsrwCfAUsYx
        TaAypXGo=; b=sgZWpyJXALAgVy+P7GHsWyMYyuYt6SbomBsRzmCCM1Ubei6M/ZU
        HSi1WIYVv9DyV4bv+ZOSgB9IHGrGZhTE8N7t2XvZ9RgZi8x4s6QSrW/nQXd8ca4S
        ASS1lEcTA9D6q8GmjL4TEpUulvSkArEe81aOvNXK7E55uy4aqtJ/NsUF6mNiihz4
        poTNTF4daPS8+MW0aOj1MKG5UYTxoqnMDS6zWcFQIOz3QljOt8mKdqgm7qLFeCIt
        0PAFQeWyFcrYttq6sFvlnuoL0YU7teGYeEPpUJg9DGZyxeeiOfuN7mi1DjviwCYm
        80dwZKdKRkqCfYwn/HYzYovKoTK7SGBNkaQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Es-tyAJ5aKzU for <linux-scsi@vger.kernel.org>;
        Thu, 11 Nov 2021 00:46:42 -0800 (PST)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Hqb1F66zVz1RtVl;
        Thu, 11 Nov 2021 00:46:41 -0800 (PST)
Message-ID: <9c20c383-90fe-186c-86d4-e2b381dfbd8c@opensource.wdc.com>
Date:   Thu, 11 Nov 2021 17:46:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Problem with scsi device sysfs attributes
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
References: <4b3e8a72-0b48-95e3-6617-a685d42c08fb@opensource.wdc.com>
 <93498302-c4c6-de7f-f177-e55de2828db0@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <93498302-c4c6-de7f-f177-e55de2828db0@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/21 14:27, Damien Le Moal wrote:
> On 11/11/21 12:31, Damien Le Moal wrote:
>> Bart,
>>
>> Your patch 92c4b58b15c5 ("scsi: core: Register sysfs attributes earlier")
>> modified the scsi device sysfs attributes initialization to use the scsi
>> template shost_groups and sdev_groups for adding attributes using groups instead
>> of arrays of attrs. However, this patch completely removed the
>> sysfs_create_groups() call to actually create the attributes listed in the groups.
>>
>> As a result, I see many missing sysfs device attributes for at least ahci (e.g.
>> ncq_prio_enavle, ncq_prio_supported), but I suspect other device types may have
>> similar problems.
>>
>> I do not see where the attribute groups in the arrray sdev->gendev_attr_groups
>> are registered with sysfs. In fact, it looks like sdev->gendev_attr_groups is
>> referenced only in scsi_sysfs.c but only for initializing it. It is never used
>> to actually register the attr groups... Am I missing something ?
>>
>> This is at least breaking NCQ priority support right now. Did your patch
>> 92c4b58b15c5 remove too much code ? Shouldn't we have a call to
>> sysfs_create_groups() somewhere ? I think that should be in
>> scsi_sysfs_device_initialize() but I am not 100% sure.
> 
> Adding this:
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index d3d362289ecc..a1a30af96e17 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1339,6 +1339,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  {
>         int error;
>         struct scsi_target *starget = sdev->sdev_target;
> +       struct Scsi_Host *shost = sdev->host;
> +       struct scsi_host_template *hostt = shost->hostt;
> 
>         error = scsi_target_add(starget);
>         if (error)
> @@ -1365,6 +1367,17 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>                 return error;
>         }
> 
> +       if (hostt->sdev_groups) {
> +               error = sysfs_create_groups(&sdev->sdev_gendev.kobj,
> +                                           hostt->sdev_groups);
> +               if (error) {
> +                       sdev_printk(KERN_INFO, sdev,
> +                                   "failed to create device attributes:
> %d\n",
> +                                   error);
> +                       return error;
> +               }
> +       }
> +
>         device_enable_async_suspend(&sdev->sdev_dev);
>         error = device_add(&sdev->sdev_dev);
>         if (error) {
> 
> I can see the AHCI NCQ attributes are visible under
> /sysfs/block/sdX/device/.
> 
> So it looks like the LLD attribute groups added to
> sdev->gendev_attr_groups by scsi_sysfs_device_initialize() using
> hostt->sdev_groups are never registered with sysfs, but the default
> common scsi attributes defined by scsi_sdev_attr_group are registered...
> This is very weird.
> 
> I do not understand why. I cannot find where sdev->gendev_attr_groups is
> used to create the attributes in sysfs...

I figured it out: scsi_sdev_attr_groups is set in scsi_dev_type (struct
device_type) and so the attributes defined in this group are created in
sysfs when the scis device sdev_gendev is added. However, the additional
attribute groups in sdev->gendev_attr_groups added by the LLD are never
processed since scsi_dev_type->groups is scsi_sdev_attr_groups and not
sdev->gendev_attr_groups.

I sent a patch. Please let me know what you think.


-- 
Damien Le Moal
Western Digital Research
