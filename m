Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27BEC6FA8E
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 14:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiI0Ot6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 10:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiI0Otb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 10:49:31 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4548742AE2
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 07:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664290040; x=1695826040;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=eIjFG2QjGniZp+G5vDqdUNv6hmPMAe5D7wALVX7IDMc=;
  b=CGpyXsEUJnS8855ZOy1YJewJ2wLT9s6sDB1sKoo1c8vHUFPDLdGE7uFP
   9ZrGjd5RA0Ubph7fGt2M0zmKBp+ob8PAXCwTvIQrXe5NbiFbTueepu728
   UvmWZBwHnV3Tphq9L3fy3WdGsCiw2W1fT4UXAUUY+zUdOH2//T1Ks1+/i
   2VzXlTOiRg4/1A4TSCUswfxyXAh21zEmpJdTkGkMBO6LGycVtr+6yNvIM
   zL5RLyhqWKrWDihkg5QLkzWjbe7G9QKtKDibSmHUxIoV1q8BgupM20OZr
   QY8Srvogh9llEP5vdD/Gp1wOnA9IXOcST9mxTnxZVC6QPovlIgOEGQeuf
   A==;
X-IronPort-AV: E=Sophos;i="5.93,349,1654531200"; 
   d="scan'208";a="212806027"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 22:47:19 +0800
IronPort-SDR: jAUJFVggMChERZ9cxZMDG1u/L8Hbm6RicAXYqNeR7Tj1bccnFf6JqkYtvuUtLMROhUfYG8BeUa
 jjq3AO4C3BK0PIUgLeihXvOZeR3ZJDYQnQ2iOc5YxlBE8VzxY5BhXwHKeZmtqoPap9IAzbYXcb
 AFU1PjdyR7Gd0jlcm+goADlzyfXsgMqW4KfqfhmfQEpWkhJL9wi8dj1V2ayzDLOzFJ6WWI6zLc
 yMS4LT6MHaJL6VL32fgkvMFg9ETNoTn6sxxGngDrtOGM0/xa4uITUNkcIk8JQgHcMLC7qkb66P
 EhjTrkrX1N+pOMnOc6R/a95r
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Sep 2022 07:07:16 -0700
IronPort-SDR: QnHjskHpPOwyPuKLVhJ+YJvpt/8S+Xo1RZYZvwW2XmnEaMfupwdUe/xVHEZG5qTElkz3u0FDxs
 b3BWD2ZuIkqQEm2qJGBVzRom4G5fLg7BcQKAndoqTPsOcbq1NL25vu9uI7hlIhvE5tHR0a9JQn
 2r66euCw5zFMnn2XpdN70PFsGwmV1b/gSatBD568XbPWzuCQb66Pv0b2Y8+U5JzR/5YDLSMBYk
 FM3iB5MCUizi5wEzrnDy+eBHVueVeuu1L4cd+16hhwO38kwKfO+VRPsMOStr4YOrK9i8zCcRt6
 Ekw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Sep 2022 07:47:19 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4McMsg0qjlz1RvTr
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 07:47:19 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664290038; x=1666882039; bh=eIjFG2QjGniZp+G5vDqdUNv6hmPMAe5D7wA
        LVX7IDMc=; b=LwzVBpZx1CesCw1BT/Gk0y+8ZW3sjem6IfiSnvNK9JObswYPWqj
        SdgajpXBLDXZX5cWeRsOUr14K0ZK6YDSZ2ERFvbWVy+7eaOvjIjLiscJ6ERcgsMK
        jZ/wkQ6UdkYRaH6gDB16wtbePpY5vZD7SeGv9zM5a1dqR/FsP/yuK5r8TNEtCRot
        UGsHxS3UpoV/p7BQX6yauuv19fIAufVwlhX/lj3U08CxRY3igbsaPnIdYLHit/Fn
        TsZ73K81w9sp981bgxlO5gSMPXQOfW5h6hM6oCrUYUJS7EfeFFK+jSchEHeCwTw9
        t0+9KZtNYkrWTYFxXBE3GRsyBhdExEUnQZg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AA4pjRWX1jat for <linux-scsi@vger.kernel.org>;
        Tue, 27 Sep 2022 07:47:18 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4McMsf09ZYz1RvLy;
        Tue, 27 Sep 2022 07:47:17 -0700 (PDT)
Message-ID: <b69343eb-617f-04bd-df07-b62a445fbe77@opensource.wdc.com>
Date:   Tue, 27 Sep 2022 23:47:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 2/2] ata: libata-sata: Fix device queue depth control
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220925230817.91542-1-damien.lemoal@opensource.wdc.com>
 <20220925230817.91542-3-damien.lemoal@opensource.wdc.com>
 <5bab7eb9-7b91-8c06-e8c3-f2076bac78dc@huawei.com>
 <92d87d6c-9bd0-0cf9-1ced-bac104ea2d66@opensource.wdc.com>
 <f3e90970-5153-f6bc-5be8-c2c379be0d7f@huawei.com>
 <60721293-14e2-98be-37af-ce7c1b227f44@opensource.wdc.com>
 <d2c4a043-e998-db98-1fe1-47b53516d7cc@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <d2c4a043-e998-db98-1fe1-47b53516d7cc@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 18:47, John Garry wrote:
> On 27/09/2022 10:28, Damien Le Moal wrote:
>>> Sure, we can use sas_to_ata_dev() to get the ata_device.
>>>
>>> I am just suggesting my way such that we can have a consistent method to
>>> get the ata_device between all libata users and we don't need to change
>>> the ata_change_queue_depth() interface. It would be something like:
>>>
>>> struct ata_device *ata_scsi_find_dev(struct ata_port *ap, const struct
>>> scsi_device *scsidev)
>>> {
>>> 	struct ata_link *link;
>>> 	struct ata_device *dev;
>>>
>>> 	ata_for_each_link(link, ap, EDGE) {
>>> 		ata_for_each_dev(dev, link, ENABLED) {
>>> 			if (scsidev == dev->sdev)
>>> 				return dev;
>>> 		}
>>> 	}
>>> 	// todo: check pmp
>>> 	return NULL;
>>> }
>> I see. Need to think about this one... This may also unify the pmp case.
>> Are you OK with the patch as is though ? 
> 
> I'm ok with your patchset, but let me test it and get back to you later 
> today.
> 
> We can improve with something
>> like the above on top later. Really need to fix that qd setting as it is
>> causing problems for testing devices with/without ncq commands.
> 
> Out of curiosity, are you considering your patchset for 6.0?

Yes. But I can send it for 6.1 with cc: stable too.

> 
>>
> 
> Thanks,
> John

-- 
Damien Le Moal
Western Digital Research

