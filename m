Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47721C88CB2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 15:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbjFLPtm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjFLPtk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 11:49:40 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B1D10C7;
        Mon, 12 Jun 2023 08:49:40 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1b3a82c8887so19390585ad.2;
        Mon, 12 Jun 2023 08:49:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686584980; x=1689176980;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TYfVhY3uC1rPtKUOcd4WiYqqlpaKjnLTB5rZELO6dUc=;
        b=Ftek8DWxA5ssnm5r2/DLUxaWOrtSJJ3b5btJETyghxwJ0zfUcu03c1vU3TKEcYoNd2
         OU15G+zQ8Cy0R8LroPfZDQxPJ1+y94qM37t39hrfKxSeFvpUShB9o18aiMIWYjOqlqJ/
         M9ENOh9K2izm4dtszwvpb6mJkgONAKLFYSwTgqh35ZjIe1uE5kT5DQM4uR0XrO3NYlGS
         v/OC+/KjPaz+Pa7SL1VuAnJb8gAvZnykp2vV0KFIxtIxBTk6QxGpgaPC5JusjgM64q1p
         d8knbXdfZVtFQsRjIze8DaVM5m1mzg0xZvOiqwF2qu4cPdoesyOdeRkdYf1WjyaqPhM8
         s4FQ==
X-Gm-Message-State: AC+VfDwHdUhC5gXnilWPnAIaWG8PhMlI/XV8Mq8T0qlOVtxidN8e4UNS
        0VU6K86MpX4zEJXX4hZAlwA=
X-Google-Smtp-Source: ACHHUZ6gkZzTuMHWRnZjo1dy4XM87ORx/ZXp3Eo1PRS4R5ffbhINCKV/wqj4181O4HMMicc52RitQA==
X-Received: by 2002:a17:902:f691:b0:1b0:2390:3674 with SMTP id l17-20020a170902f69100b001b023903674mr7355579plg.65.1686584979479;
        Mon, 12 Jun 2023 08:49:39 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id u14-20020a170902a60e00b001b05e96d859sm8390716plq.135.2023.06.12.08.49.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 08:49:39 -0700 (PDT)
Message-ID: <02068097-2e48-7662-3ac8-96542f64ab5d@acm.org>
Date:   Mon, 12 Jun 2023 08:49:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 6/6] scsi: replace scsi_target_block() by
 scsi_block_targets()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
References: <20230612150309.18103-1-mwilck@suse.com>
 <20230612150309.18103-7-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230612150309.18103-7-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 08:03, mwilck@suse.com wrote:
> + * Note:
> + * @dev must not itself be a scsi_target device.

Please add a WARN_ON_ONCE() that checks this condition.

Thanks,

Bart.
