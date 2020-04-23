Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266F4C2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 03:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA3962075A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 03:37:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ieh1p164"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgDWDhl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 23:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgDWDhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 23:37:41 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB3DC03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 20:37:40 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id gr25so3581462ejb.10
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 20:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kLsNei33jFWZmv/gpscLu4TxLvMHNm85q5v6xyqw1vc=;
        b=Ieh1p164Q1u+vD+7MhZElRhjlVLAkYmUaeTPR0A2xTTfwYxmQZVAhszbStxrIC5xQb
         VzqcZLLh80nsU4sXFd64M1/NJHL1hsrDjYqD2uXpZ0Mq93FGZZxcJYUgjRJZN3iAXlUP
         PFQq7sAJMkFNef+ACiBaoypkA87TPPJ2NEIxQR+1HXzLluX3vTQ2h2l28N1hqBzBh8WB
         AU3tyhdk1FbrpYItA1IAC1O43xOgd8hEnT9k5KZUEpq5Sn39piVjAH5Pe5DnkyGa6TIS
         H8ED2w9h5ckmBCsIrpXQtUkeYKZ6D+VGUbB/e3dT9iwFbqMAFzo5cKHx/pXC3DSxtkS7
         RrGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kLsNei33jFWZmv/gpscLu4TxLvMHNm85q5v6xyqw1vc=;
        b=OcbNYr72mizblpIFq4VCOFoDEXB+pwA7+0jHkEIN1b4UH7SD2NS0S7weR3mVtS9e+O
         z5OchaTEHDVLBzpFEcB6toYt8h2MoKHJSoyfvJnUIC5yX8GkRgu+D0I0Am23V8S/8Sy4
         Vgmr1Fg/RjsR9Y5QtEF8fIKnEkGC8Pe5H8f3soMo+WdhvhzVU3QcTxZ6rBx38L1r7aGH
         DEXFT677qgTPD9x1n/NEg/GWtXYHrH/9OqI2BMaGRgQOeFZGNZ3XX300+kb5+p6Oopnu
         OfFRs2vy5ejEn+TLhts5iPA7h0srGYj1HRf1Vm4mioAbgRWJ7+yAk4GPouAmaPLDGpjc
         0hrw==
X-Gm-Message-State: AGi0PuYosiFTKWJLqnW/Hu7aMZdnATKGoeCbnY8AnMc9hlX9RB54WMhP
        vU3OEYFxC8vzaUiWupulyFY=
X-Google-Smtp-Source: APiQypJcNdV+0aqOPO0/rpK3V/Jlh6L1ODUBbiyHJ+JlWck9OcG4YRIFNiEqEo3z4tsXAfGyfF0pWA==
X-Received: by 2002:a17:906:340a:: with SMTP id c10mr1131640ejb.218.1587613059486;
        Wed, 22 Apr 2020 20:37:39 -0700 (PDT)
Received: from [192.168.1.237] (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id ch5sm283511ejb.60.2020.04.22.20.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 20:37:38 -0700 (PDT)
Subject: Re: [PATCH v3 25/31] elx: efct: Hardware IO submission routines
To:     Daniel Wagner <dwagner@suse.de>, Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-26-jsmart2021@gmail.com>
 <1af2f44d-ede4-bdd8-5812-9d4526a1f9b5@suse.de>
 <20200416124505.cqqkotnsjhlpkhp3@carbon>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <4c92dd2e-2045-0c89-7386-26610b2dc884@gmail.com>
Date:   Wed, 22 Apr 2020 20:37:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416124505.cqqkotnsjhlpkhp3@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/2020 5:45 AM, Daniel Wagner wrote:
> On Thu, Apr 16, 2020 at 10:10:18AM +0200, Hannes Reinecke wrote:
>>> +	switch (type) {
>>> +	case EFCT_HW_ELS_REQ:
>>> +		if (!send ||
>>> +		    sli_els_request64_wqe(&hw->sli, io->wqe.wqebuf,
>>> +					  hw->sli.wqe_size, io->sgl,
>>> +					*((u8 *)send->virt),
>>> +					len, receive->size,
>>> +					iparam->els.timeout,
>>> +					io->indicator, io->reqtag,
>>> +					SLI4_CQ_DEFAULT, rnode->indicator,
>>> +					rnode->sport->indicator,
>>> +					rnode->attached, rnode->fc_id,
>>> +					rnode->sport->fc_id)) {
>>> +			efc_log_err(hw->os, "REQ WQE error\n");
>>> +			rc = EFCT_HW_RTN_ERROR;
>>> +		}
>>> +		break;
>>
>> I did mention several times that I'm not a big fan of overly long argument
>> lists.
>> Can't you pass in 'io' and 'rnode' directly and cut down on the number of
>> arguments?
> 
> Yes, please!
> 

Agree, and agree with both Hannes' and your comments on this patch.

Daniel - also agree with your comments on patches 16 through 23.

Thanks

-- james

