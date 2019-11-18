Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCC4C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 02:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F300F206D9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 02:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="mpXVTt2u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfKRCqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 21:46:08 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36952 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfKRCqI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Nov 2019 21:46:08 -0500
Received: by mail-pg1-f193.google.com with SMTP id b10so352791pgd.4
        for <linux-scsi@vger.kernel.org>; Sun, 17 Nov 2019 18:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z9AbyDvtIlqA8teGPhwS3XwAlLU5YBdWg0suzOZUyY0=;
        b=mpXVTt2uGXtfurvuXttr2TL940xEsOmdAa+jgl6//9SepZGyDy4oMGX4oE9aDeuyGb
         ZaUVCzWwhtM+KfrGstPdTg8ymBlkkaMV05+8veiRD1HTULCSrVg4pUM4DhX70sdldCgP
         1AT4XnRcwhs1h0goTlEOeHSoqZ3M1pMC6aAFnjwga4epv8wgg0jG+LnaW9dwGiGTeVJ5
         fTfuNk0MC7fQqPzkTuAfHK20nIczQL/2byQpQGw3LCMnfKx8Zxf9SvDuWIeFrETwg6RQ
         8tOhro56uE/3cL55fZlhQobqutiBosWSeUzg6AEMtnTCdMpxMQYcVUY5rXVPCk95BdqV
         z7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z9AbyDvtIlqA8teGPhwS3XwAlLU5YBdWg0suzOZUyY0=;
        b=KKU3vD+yEsMUvEn8XJwXnPrLqyIzRksJeScEO9D9RVFu3hKuLCWrR/CR2MYArasQPY
         JSLeJ+UPsSQL7WUA0cYBuIxp4elOhbsQfPAFJFB+6hddGntb6v3I4fsMXCeNRxEqNUFZ
         r97QrQpg/YYsZCVj7TOAXIyMmNrYHGhH9MIUswyi9pgToe5YkU9udHT5+7pEMjzVY83F
         t+ufkpU7lMAOEfBrFBBLJYtIfSzDSgXmJMiIAJZGeSa5BUqJmqcYJG8cpxPH9cYESKot
         CbvjP6+bgI5NO1mSHLgack5UsFb54HsskjUeERKHYTPGXi/9cDiQPUA/3fu9njrm37Zt
         m3Gg==
X-Gm-Message-State: APjAAAXEFgvDXcExMv0MXl1vPfeG4E3kAYYkHNv5VxrvWQp7zXkz8NB6
        NWYNyPlN2ogd0VQajSk6P07nPw==
X-Google-Smtp-Source: APXvYqyN6lR4gUByRUeVLBv2oS9jxr1gXRxII5ymqZZf0HJghyxYcg2NZ7XD87pujYL7vi8KuOsTtA==
X-Received: by 2002:a63:1f08:: with SMTP id f8mr1128798pgf.145.1574045167153;
        Sun, 17 Nov 2019 18:46:07 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id c13sm19409481pfi.0.2019.11.17.18.46.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Nov 2019 18:46:06 -0800 (PST)
Subject: Re: [PATCH] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Long Li <longli@microsoft.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20191117080818.2664-1-ming.lei@redhat.com>
 <BYAPR04MB5816F43072584F8F20EF4292E74D0@BYAPR04MB5816.namprd04.prod.outlook.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f6c6bc65-8fba-e415-ee08-c2efed24a450@kernel.dk>
Date:   Sun, 17 Nov 2019 19:46:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5816F43072584F8F20EF4292E74D0@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/17/19 5:18 PM, Damien Le Moal wrote:
> On 2019/11/17 17:08, Ming Lei wrote:
>> Now the requeue queue is run in scsi_end_request() unconditionally if both
>> target queue and host queue is ready. We should have re-run request queue
>> only after this device queue becomes busy for restarting this LUN only.
>>
>> Recently Long Li reported that cost of run queue may be very heavy in
>> case of high queue depth. So improve this situation by only running
>> requesut queue when this LUN is busy.
> 
> s/requesut/request
> 
> Also, shouldn't this patch have the tag:
> 
> Reported-by: Long Li <longli@microsoft.com>
> 
> ?
> 
> Another remark is that Long's approach is generic to the block layer
> while your patch here is scsi specific. I wonder if the same problem
> cannot happen with other drivers too ?

The block layer is just doing what it's told, and I doubt many drivers
would have the crazy kind of re-run logic that the SCSI midlayer does.
As far as I'm concerned, the fix belongs on the SCSI side of things
instead of being papered over on the block side.

-- 
Jens Axboe

