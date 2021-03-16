Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03489C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 20:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C732664F80
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 20:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhCPUj2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 16:39:28 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:40219 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbhCPUjM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 16:39:12 -0400
Received: by mail-pf1-f172.google.com with SMTP id x7so9631166pfi.7
        for <linux-scsi@vger.kernel.org>; Tue, 16 Mar 2021 13:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/fUrJE4iOom0WFKTn87vRE0onBtC0f8X2GV8Dp6lZU4=;
        b=Ac/M2Is/So9Z76jcVkByjpZNLbUuOs16oJnm7ogsNiuNZpVa2ly6TDFq/Rw8xuKXLm
         h9QInCMm42jp1PkhFwjk21OkIeKEcjpqIx/BnxqzMLUpjbpbFg7YvzHu4W8SatM8wBE4
         DDDTtutjXaWhVaeulLAmoGnTBeoUXaDL+9NSYBlLf7eReKbq79k5dP29pMrW1J72Yy61
         ActNsLP1kpnxqPok4+5kL8pnZz5OLvg4NeGQHrPRhqIkX17hZKPRQs3H8F5gVi/TA9tA
         mubbJpY9SvPS3g80wwsjFjchoMhJ0l6ibEkN/dDj6D6O8q5xnxHo7GDofdNbSWGdZ4aO
         MPvw==
X-Gm-Message-State: AOAM532DtL1CPjvP2dmpvUKOxHsOGhA1qSkjPQPW89soVVDywpdFlHTz
        1dQCHKTB1+/UTdORVN01kkw=
X-Google-Smtp-Source: ABdhPJzCneqc7daor4LTLC/8TeD1hGSrBGdUGidtmlkAhbzbmxybSPoKtUFtqGSXDxf+qWyEBtFFCQ==
X-Received: by 2002:a62:6413:0:b029:1f3:a5b4:d978 with SMTP id y19-20020a6264130000b02901f3a5b4d978mr1297048pfb.44.1615927152078;
        Tue, 16 Mar 2021 13:39:12 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b6b5:afbd:6ae4:8f83? ([2601:647:4000:d7:b6b5:afbd:6ae4:8f83])
        by smtp.gmail.com with ESMTPSA id w15sm10480044pfn.84.2021.03.16.13.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 13:39:11 -0700 (PDT)
Subject: Re: [PATCH 4/7] qla2xxx: qla82xx_pinit_from_rom(): Initialize 'n'
 before using it
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-5-bvanassche@acm.org>
 <20210316083653.e7gxi6qn4juctfdl@beryllium.lan>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ff6ef2af-057d-f625-7841-46b8cf06ac54@acm.org>
Date:   Tue, 16 Mar 2021 13:39:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210316083653.e7gxi6qn4juctfdl@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/21 1:36 AM, Daniel Wagner wrote:
> On Mon, Mar 15, 2021 at 08:56:52PM -0700, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
>> index 0677295957bc..5683126e0cbc 100644
>> --- a/drivers/scsi/qla2xxx/qla_nx.c
>> +++ b/drivers/scsi/qla2xxx/qla_nx.c
>> @@ -1095,7 +1095,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
>>  	int i ;
>>  	struct crb_addr_pair *buf;
>>  	unsigned long off;
>> -	unsigned offset, n;
>> +	unsigned offset, n = 0;
>>  	struct qla_hw_data *ha = vha->hw;
>>  
>>  	struct crb_addr_pair {
> 
> I think sparse is not able to see that n is initialized
> before it is used.
> 
> 	/* Read the signature value from the flash.
> 	 * Offset 0: Contain signature (0xcafecafe)
> 	 * Offset 4: Offset and number of addr/value pairs
> 	 * that present in CRB initialize sequence
> 	 */
> 	n = 0;
> 	if (qla82xx_rom_fast_read(ha, 0, &n) != 0 || n != 0xcafecafeUL ||
> 	    qla82xx_rom_fast_read(ha, 4, &n) != 0) {
> 		ql_log(ql_log_fatal, vha, 0x006e,
> 		    "Error Reading crb_init area: n: %08x.\n", n);
> 		return -1;
> 	}
> 
> I suppose this n = 0 should be dropped if n is initialized at the
> beginning of the function.
> .

Right, the variable 'n' is already being initialized. The patch that
added that initialization code went in after I came up with the above
patch. I will drop this patch.

Thanks,

Bart.


