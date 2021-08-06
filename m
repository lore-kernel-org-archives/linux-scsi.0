Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B690BC4320A
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B6AB6113C
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244295AbhHFJ2d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:28:33 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35092 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244128AbhHFJ2c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 05:28:32 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 292E9223FC;
        Fri,  6 Aug 2021 09:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628242096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iyHdLPuM0oBeoKQ/J5SsuzPUB9ioFfj40s/5AglIqx8=;
        b=Y77aREhWuAtivGRtROW/eEsEnA+9tDiA3DI4aP3qd49+N6ogXiqEsICRKRtp6LAxLt/WCO
        7xIcaEUiEpIPWW0jsAymU4wYgzXyuWkRoGJ/18jXwqluglobn1xvdpNTkhcnAetaV+MOd2
        Y0GGB4ivh5Hb2JpUzm8AQBWdskQCFH0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628242096;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iyHdLPuM0oBeoKQ/J5SsuzPUB9ioFfj40s/5AglIqx8=;
        b=srCs2ji+nEOdV+cM3Q0oi8w2JVlnDlNZbtsdjXAD3MWpS8kCUEpZARAWxCwwTJyrngJz0E
        q6IblU2OB1EKNmDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 18E5013A62;
        Fri,  6 Aug 2021 09:28:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WwTBBbAADWGGcAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 06 Aug 2021 09:28:16 +0000
Subject: Re: [PATCH v2 4/9] libata: cleanup ata_dev_configure()
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
 <20210806074252.398482-5-damien.lemoal@wdc.com>
 <cbba17af-a35e-a837-a5a6-1b12d6445f0a@suse.de>
 <DM6PR04MB708145CEBEF79D709B679090E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0fd18f2f-dc71-9d57-cfb3-afca4b37b3e9@suse.de>
Date:   Fri, 6 Aug 2021 11:28:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB708145CEBEF79D709B679090E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/6/21 11:12 AM, Damien Le Moal wrote:
> On 2021/08/06 18:07, Hannes Reinecke wrote:
>> On 8/6/21 9:42 AM, Damien Le Moal wrote:
>>> Introduce the helper functions ata_dev_config_lba() and
>>> ata_dev_config_chs() to configure the addressing capabilities of a
>>> device. Each helper takes a string as argument for the addressing
>>> information printed after these helpers execution completes.
>>>
>>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>>> ---
>>>  drivers/ata/libata-core.c | 110 ++++++++++++++++++++------------------
>>>  1 file changed, 59 insertions(+), 51 deletions(-)
>>>
>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>> index b13194432e5a..2b6054cdd8fc 100644
>>> --- a/drivers/ata/libata-core.c
>>> +++ b/drivers/ata/libata-core.c
[ .. ]
>>>  				return rc;
>>> -
>>> -			/* print device info to dmesg */
>>> -			if (ata_msg_drv(ap) && print_info) {
>>> -				ata_dev_info(dev, "%s: %s, %s, max %s\n",
>>> -					     revbuf, modelbuf, fwrevbuf,
>>> -					     ata_mode_string(xfer_mask));
>>> -				ata_dev_info(dev,
>>> -					     "%llu sectors, multi %u: %s %s\n",
>>> -					(unsigned long long)dev->n_sectors,
>>> -					dev->multi_count, lba_desc, ncq_desc);
>>> -			}
>>>  		} else {
>>> -			/* CHS */
>>> -
>>> -			/* Default translation */
>>> -			dev->cylinders	= id[1];
>>> -			dev->heads	= id[3];
>>> -			dev->sectors	= id[6];
>>> -
>>> -			if (ata_id_current_chs_valid(id)) {
>>> -				/* Current CHS translation is valid. */
>>> -				dev->cylinders = id[54];
>>> -				dev->heads     = id[55];
>>> -				dev->sectors   = id[56];
>>> -			}
>>> +			ata_dev_config_chs(dev, lba_info, sizeof(lba_info));
>>> +		}
>>>  
>>> -			/* print device info to dmesg */
>>> -			if (ata_msg_drv(ap) && print_info) {
>>> -				ata_dev_info(dev, "%s: %s, %s, max %s\n",
>>> -					     revbuf,	modelbuf, fwrevbuf,
>>> -					     ata_mode_string(xfer_mask));
>>> -				ata_dev_info(dev,
>>> -					     "%llu sectors, multi %u, CHS %u/%u/%u\n",
>>> -					     (unsigned long long)dev->n_sectors,
>>> -					     dev->multi_count, dev->cylinders,
>>> -					     dev->heads, dev->sectors);
>>> -			}
>>> +		/* print device info to dmesg */
>>> +		if (ata_msg_drv(ap) && print_info) {
>>> +			ata_dev_info(dev, "%s: %s, %s, max %s\n",
>>> +				     revbuf, modelbuf, fwrevbuf,
>>> +				     ata_mode_string(xfer_mask));
>>> +			ata_dev_info(dev,
>>> +				     "%llu sectors, multi %u, %s\n",
>>> +				     (unsigned long long)dev->n_sectors,
>>> +				     dev->multi_count, lba_info);
>>>  		}
>>>  
>>>  		ata_dev_config_devslp(dev);
>>>
>> Hmm. Can't say I like it.
>> Can't you move the second 'ata_dev_info()' call into the respective
>> functions, and kill the temporary buffer?
> 
> That would reverse the order of the messages... And I wanted to avoid having an
> "if (ata_id_has_lba(id))" again just for the print. Moving the 2 ata_dev_info()
> calls into the respective functions was the other solution I tried, but then the
> functions require *a lot* more arguments (revbuf, modelbuf, fwrevbuf, ...) wich
> was not super nice.
> 
> This one is the least ugly I thought... Any other idea ?
> 
Well, it should be possible to move the first 'ata_dev_info()' call
_prior_ to the if(ata_id_has_lba(id)) condition, and then we can move
the second call into the respective functions, no?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
