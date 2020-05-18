Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73739C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 06:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52FBB207D4
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 06:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgERGSy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 02:18:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:48290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbgERGSx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 May 2020 02:18:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6D817B15D;
        Mon, 18 May 2020 06:18:54 +0000 (UTC)
Subject: Re: [PATCH v6 15/15] qla2xxx: Fix endianness annotations in source
 files
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-16-bvanassche@acm.org>
 <77c33a4e-c67c-1978-8b72-ceca58d4309d@suse.de>
 <fdc5993d-ffb8-cd7f-06a3-20e16a1017d0@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8b47f67b-d4d3-9ca4-139c-8d55dbef27c5@suse.de>
Date:   Mon, 18 May 2020 08:18:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <fdc5993d-ffb8-cd7f-06a3-20e16a1017d0@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/15/20 9:22 PM, Bart Van Assche wrote:
> On 2020-05-14 23:50, Hannes Reinecke wrote:
>> On 5/14/20 11:35 PM, Bart Van Assche wrote:
>>> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c
>>> b/drivers/scsi/qla2xxx/qla_tmpl.c
>>> index f05a4fa2b9d7..b91ec1c3a3ae 100644
>>> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
>>> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
>>> @@ -922,9 +922,9 @@ qla27xx_firmware_info(struct scsi_qla_host *vha,
>>>        tmp->firmware_version[0] = vha->hw->fw_major_version;
>>>        tmp->firmware_version[1] = vha->hw->fw_minor_version;
>>>        tmp->firmware_version[2] = vha->hw->fw_subminor_version;
>>> -    tmp->firmware_version[3] = cpu_to_le32(
>>> +    tmp->firmware_version[3] = (__force u32)cpu_to_le32(
>>>            vha->hw->fw_attributes_h << 16 | vha->hw->fw_attributes);
>>> -    tmp->firmware_version[4] = cpu_to_le32(
>>> +    tmp->firmware_version[4] = (__force u32)cpu_to_le32(
>>>          vha->hw->fw_attributes_ext[1] << 16 |
>>> vha->hw->fw_attributes_ext[0]);
>>>    }
>>>   
>> Why do you need (__force u32) here?
>> It should be a 32bit array, and cpu_to_le32() trivially returns 32bits.
>> What's there to force?
> 
> The hw->fw_{major,minor,subminor}_version and also the
> hw->fw_attributes_ext variables have been annotated as CPU endian. I
> inserted the (__force u32) casts because that suppresses the endianness
> warnings without affecting the generated code on little endian or big
> endian systems. Thinking further about this, storing CPU endian values
> in a firmware data structure is most likely wrong. How about modifying
> patch 15/15 as follows?
> 
>   drivers/scsi/qla2xxx/qla_tmpl.c | 10 +++++-----
>   drivers/scsi/qla2xxx/qla_tmpl.h |  2 +-
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
> index b91ec1c3a3ae..8dc82cfd38b2 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -919,12 +919,12 @@ static void
>   qla27xx_firmware_info(struct scsi_qla_host *vha,
>       struct qla27xx_fwdt_template *tmp)
>   {
> -	tmp->firmware_version[0] = vha->hw->fw_major_version;
> -	tmp->firmware_version[1] = vha->hw->fw_minor_version;
> -	tmp->firmware_version[2] = vha->hw->fw_subminor_version;
> -	tmp->firmware_version[3] = (__force u32)cpu_to_le32(
> +	tmp->firmware_version[0] = cpu_to_le32(vha->hw->fw_major_version);
> +	tmp->firmware_version[1] = cpu_to_le32(vha->hw->fw_minor_version);
> +	tmp->firmware_version[2] = cpu_to_le32(vha->hw->fw_subminor_version);
> +	tmp->firmware_version[3] = cpu_to_le32(
>   		vha->hw->fw_attributes_h << 16 | vha->hw->fw_attributes);
> -	tmp->firmware_version[4] = (__force u32)cpu_to_le32(
> +	tmp->firmware_version[4] = cpu_to_le32(
>   	  vha->hw->fw_attributes_ext[1] << 16 | vha->hw->fw_attributes_ext[0]);
>   }
> 
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.h b/drivers/scsi/qla2xxx/qla_tmpl.h
> index bba8dc90acfb..89280b3477aa 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.h
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.h
> @@ -27,7 +27,7 @@ struct __packed qla27xx_fwdt_template {
>   	uint32_t saved_state[16];
> 
>   	uint32_t reserved_3[8];
> -	uint32_t firmware_version[5];
> +	__le32 firmware_version[5];
>   };
> 
>   #define TEMPLATE_TYPE_FWDUMP		99
> 
> Thanks,
> 
> Bart.
> 
Yes, that's better.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
