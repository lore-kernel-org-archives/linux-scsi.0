Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A12EAC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 19:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjEQT5D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 15:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEQT4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 15:56:44 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F1F4680
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 12:56:43 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-534696e4e0aso56550a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 12:56:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684353402; x=1686945402;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gHURxQ0mXua0Osum6HNFQeQlbEm93aWF+mJzTB39SYQ=;
        b=DRoZj9ZvuhLL4lJpugZFzoET6BOO9tnBnwmZeOf+bx6x7k2SOpJ6/5ojuUSFlRpy66
         Nf2JLuo9KxuHXE8eX4Lk9mdAUTbMCPEfYYNw5QrJ0PSKWL00YxrnLwIsMQkMdxrfVaNl
         TcQaI/kBqXG3npMEKj40YtkhGnHbkaZwQ4Oy8Cx0TMQ4TagRRwFFNih3o2NuIii8sVfG
         n32ZIvT63ZzomCRzSEuIJ51XwMhbbqBkpVyqbWgTtVqYrqVn/FTem7tWChUaT55/Y9ZK
         Ky5hcMFePGjniMoW8aKRUjS0pa7PM6Rkvg7p6fHCXShk5sJyKMQbLhsc1m6e3cOXI0Ju
         xECQ==
X-Gm-Message-State: AC+VfDzLrBZByCjeI7G4wiWjsk2Mo0FphWnhc+S8NmmMqKJCrjch0sJ5
        hfVHg1UHzLKWiQ/AsDcYOCU=
X-Google-Smtp-Source: ACHHUZ7Hs2Ko+LtejxDNcGgslylkvYHocJrI7uECuh6XQGfPopPPPVFSb4+czl++f9QMrqSPYo3mkQ==
X-Received: by 2002:a05:6a20:a10c:b0:107:6f3:71d with SMTP id q12-20020a056a20a10c00b0010706f3071dmr7623014pzk.14.1684353402528;
        Wed, 17 May 2023 12:56:42 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 16-20020a630d50000000b0050fa6546a45sm15813824pgn.6.2023.05.17.12.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 12:56:42 -0700 (PDT)
Message-ID: <7b54fb6f-f289-08e3-32bc-cb17fea6b169@acm.org>
Date:   Wed, 17 May 2023 12:56:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 3/5] scsi: core: Trace SCSI sense data
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Changyuan Lyu <changyuanl@google.com>,
        Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>
References: <20230503230654.2441121-1-bvanassche@acm.org>
 <20230503230654.2441121-4-bvanassche@acm.org> <20230505060145.GC11897@lst.de>
 <yq14jop2i2g.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq14jop2i2g.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/6/23 15:48, Martin K. Petersen wrote:
>> Although, I'd also love to see pre-decoded ASC and ASCQ codes in the
>> scsi_cmnd at some point.
> 
> Yep! It would be nice to have these readily available.

Implementing this seems nontrivial and risky to me. As an example, 
whether or not scsi_decide_disposition() calls scsi_check_sense() 
depends on the command result. Guaranteeing that 
scsi_command_normalize_sense() is called independent of the command 
result implies moving this call from scsi_check_sense() to somewhere 
else, e.g. scsi_decide_disposition(). Unfortunately scsi_check_sense() 
is not only called from the SCSI completion path but also by ATA code 
that is not related to the SCSI completion path (ata_eh_analyze_tf()). 
So I consider this change as out-of-scope for this patch series.

Bart.


