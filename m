Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022A4C77B78
	for <linux-scsi@archiver.kernel.org>; Tue,  2 May 2023 20:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjEBUbU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 May 2023 16:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjEBUbS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2023 16:31:18 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687E519A2
        for <linux-scsi@vger.kernel.org>; Tue,  2 May 2023 13:31:14 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-63b70f0b320so4902465b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 May 2023 13:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683059474; x=1685651474;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DXYc+YdblicNXxtNH1u9tm7GDIcl/ZLGdJ/6NHS6pRM=;
        b=V4GbEN3K2YqEH4S65i5FLinfksLbZrVAKglXfblym9FKtU7PhRmT2CIKijwJN9rDf2
         JKy+2+RWimcRqW8vq4y1HrfPMUtufnGULL63QDNTBM9fmmkRuPXeEqnPcKGQwbD1wbYo
         hcPm6CRdmgpy+qf+VVtgGfpcz/B9OjR2kzxV/r5CdJRvAEivEd6+dFXDCTTfZoaW/qFX
         aFmpXRT5Kh6zv5fHy+PvAn2WCwKZepXZjRKG9MjSYm6E2wa1wIqJbmUqVMZY9Vj2b/gO
         JpCN9M7CjKqkCS8TtNF+EDgLoRWSAdaANG6BsVX3ql0K+nKdkwjZiVllAKdMTrsYPMeR
         bgiA==
X-Gm-Message-State: AC+VfDxXIHXLJEEYO7STnCbdP90F7TOybkZXg1Ik1XEQYUleYbpi+2BD
        9hUkpIeCubn5oN5jKMRE/ms=
X-Google-Smtp-Source: ACHHUZ521twYhZjjRGLfJnDJxkGkA11uUe6VTKmV2sD7TSIWc2a9U8GC0NA0RTt2FWqCIue7BGTZVw==
X-Received: by 2002:a05:6a00:14ca:b0:63b:599b:a2e6 with SMTP id w10-20020a056a0014ca00b0063b599ba2e6mr26789744pfu.27.1683059473740;
        Tue, 02 May 2023 13:31:13 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:c683:a90b:5f41:5878? ([2620:15c:211:201:c683:a90b:5f41:5878])
        by smtp.gmail.com with ESMTPSA id 8-20020aa79248000000b00625b9e625fdsm22737502pfp.179.2023.05.02.13.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 13:31:13 -0700 (PDT)
Message-ID: <1232c27c-4da6-a738-c138-b0e65fa74467@acm.org>
Date:   Tue, 2 May 2023 13:31:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 4/4] scsi: Trace SCSI sense data
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        Damien Le Moal <dlemoal@kernel.org>
References: <20230425233446.1231000-1-bvanassche@acm.org>
 <20230425233446.1231000-5-bvanassche@acm.org> <ZEt/SD/GiqIo5aIm@x1-carbon>
 <e859baeb-f7e7-9d58-bcfd-9b11115bdf0d@acm.org> <ZFDdWY7LqLQL0nb6@x1-carbon>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZFDdWY7LqLQL0nb6@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/23 02:52, Niklas Cassel wrote:
> i.e., something like:
> 	if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
> 	    scsi_command_normalize_sense(cmd, &sshdr)) {
> 
> instead of cmd->result & 0xff.

Hmm ... doesn't the SCSI_SENSE_VALID() check above duplicate the
scsi_sense_valid() check inside scsi_command_normalize_sense()?

Thanks,

Bart.

