Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0474EC64EC4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 16:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjCFQR1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 11:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjCFQRN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 11:17:13 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C54C4B83B
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 08:13:33 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id bd34so6137073pfb.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 08:13:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678118838;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vpMpMCf2gWVQmktuqXgkJZxIBCWJt8bS3mp/UmYgH4o=;
        b=AxzPGitE5uHQZDJ6nTg2CyKxKe0PNMa/CPfgL+kgGR9cKfQjScl4I+jWo+ufPocAZ0
         aFo2vcV+w4NPIY/BNwT3ldaRZ6LECCdNguhfw1PdPITlbe8FzsLWtWzOKxyGbSzHoUVX
         FNh5AgApaCjb+9qs3336uSMPKMjytDzGrrOQuHEIgzJy6moKUuabJcLnPXQ+dCBh9z2K
         BNKpbBYKHwFdZUVMiC1+u2QGYVBBW9u46d3h9jDRJBWm0Ce5+LXpDCCq3dWIIAQRnmB1
         zfSQPEPNc6rGwA2awXYHwI5Iewu6T82VQyut05VWAsQqiCObqkeKIYLqhWqIiQHo1x0M
         3qKg==
X-Gm-Message-State: AO0yUKVBC6GvyNLcTKTH/goiYVnVbvT0b01SjKwEBI4ThYJG0oSY73rl
        CYFnZLSI3o6p46wdDPuDpu8=
X-Google-Smtp-Source: AK7set9f06N5k6576+smeDB2MYZomRDqJ17vcEc3lj9AIaXhqsYb36CKYzDDRWQirg/aUmwh1j3Tyw==
X-Received: by 2002:aa7:98c3:0:b0:5a8:e3dc:4337 with SMTP id e3-20020aa798c3000000b005a8e3dc4337mr11682066pfm.16.1678118838243;
        Mon, 06 Mar 2023 08:07:18 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id w19-20020aa78593000000b0058e1b55391esm6674062pfn.178.2023.03.06.08.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 08:07:17 -0800 (PST)
Message-ID: <d8503629-3151-b408-a298-9583ec71a099@acm.org>
Date:   Mon, 6 Mar 2023 08:07:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 02/81] scsi: core: Declare most SCSI host template
 pointers const
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-3-bvanassche@acm.org>
 <495d7eeb-bf5c-8333-1945-2ab1614f011f@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <495d7eeb-bf5c-8333-1945-2ab1614f011f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/6/23 06:29, John Garry wrote:
> You wrote that most pointers were now cast as const - which ones where 
> not? From a quick scan they all seem to be const

Hi Garry,

Some SCSI drivers modify one of more members of the SCSI host template. 
An example can be found in drivers/scsi/pcmcia/nsp_cs.c:

	sht->name	  = data->nspinfo;

Another example from drivers/scsi/bnx2fc/bnx2fc_fcoe.c:

	bnx2fc_shost_template.can_queue = hba->max_outstanding_cmds;

Thanks,

Bart.
