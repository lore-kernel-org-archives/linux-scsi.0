Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8240EC64EC4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 19:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCFTlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 14:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjCFTlf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 14:41:35 -0500
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF93410AB
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 11:41:35 -0800 (PST)
Received: by mail-pj1-f53.google.com with SMTP id y2so10897449pjg.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 11:41:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678131694;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4AjnKsS1Z0aEc+1zjDhyJb1G88tMFVTPEfUwUi7CU7A=;
        b=GnsYotCX6O+pE0kLMK76G6NqlJGsBk73eEG3mfAx8l/qFkeTp8P9cvvUBOxjNQhGNQ
         katnb7dI0uoi+qsZ6YvNiDl/IcUJNd20x9e8rqNZVBMvcyu5FI2GTAFjk28r9sj0Y6RO
         8MHGFHS3b6+YgIiwpialnR1mVbHdLdTy7zknqvZRUqaSq7sIv4OUYRnBiR2PGR/KKhzD
         POJ4SetV6i03Zgh+9RB1dI6DBi0++RSZ2DqUYo2WjUlGiove1UgUv5BF9lk8kTJ+vOvY
         6BtFt9ZDAFWjCJTHzUPs8eplyz+S3xrgoeSXOjxdBvvhA1c8HmPqeU7arlg+gNlan8mZ
         q4ZA==
X-Gm-Message-State: AO0yUKXhwLVXdqguIgbS2awuYDveX+KMMv/7843+yh4ZYqP37c5SUu0B
        +PHpf0wky/WzmCTjlOatUUx49nIClFk=
X-Google-Smtp-Source: AK7set/mUHw+YSV4TwlDLagC21J7YS8GV2y1tlFfSx2Knjn2tRXgicP3Eu9z5Q1z1IkkY3Y67t8FJA==
X-Received: by 2002:a05:6a21:6d81:b0:cc:63c6:5a09 with SMTP id wl1-20020a056a216d8100b000cc63c65a09mr13963293pzb.18.1678131694405;
        Mon, 06 Mar 2023 11:41:34 -0800 (PST)
Received: from [192.168.132.235] ([63.145.95.70])
        by smtp.gmail.com with ESMTPSA id 21-20020aa79255000000b006089fb79f1asm6585681pfp.208.2023.03.06.11.41.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 11:41:33 -0800 (PST)
Message-ID: <d438393a-4047-40e7-c6fc-15ba6631973c@acm.org>
Date:   Mon, 6 Mar 2023 11:41:32 -0800
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
 <d8503629-3151-b408-a298-9583ec71a099@acm.org>
 <59da25c2-a903-d004-ba23-712df9259f5e@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <59da25c2-a903-d004-ba23-712df9259f5e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/6/23 10:55, John Garry wrote:
> On 06/03/2023 16:07, Bart Van Assche wrote:
>> Another example from drivers/scsi/bnx2fc/bnx2fc_fcoe.c:
>>
>>      bnx2fc_shost_template.can_queue = hba->max_outstanding_cmds;
> 
> BTW, surely we should be setting shost->can_queue = 
> hba->max_outstanding_cmds after scsi_host_alloc() and not modifying 
> bnx2fc_shost_template, right? The series is already huge, so this stuff 
> would be done separately, I suppose.

Hi John,

If anyone else wants to work on this that's fine with me. My view is 
that the SCSI core should support declaring host templates const but I'm 
not sure it's worth it to make changes in old drivers such that their 
SCSI host template can be declared const. One class of SCSI LLDs that 
does not have a const SCSI host template are the NCR drivers. The NCR 
SCSI host controller was popular 40 years ago. There are probably not 
many working SCSI devices left that are based on this SCSI controller.

Bart.

