Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FC8C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 22:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 860A22230E
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 22:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfKRW61 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 17:58:27 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:41424 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfKRW60 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 17:58:26 -0500
Received: by mail-pj1-f65.google.com with SMTP id gc1so1932559pjb.8
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 14:58:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hjVNHVMvq7qP7iB87xygJ8wStYfd9mTFUVQeL80LYSc=;
        b=kzF4QVOk9zBXI3YR+bO1WI8sg89ry2tDEX6iMem207w7AuDHRlmn+NOAC8k/Kaz114
         +aqCKRowtZK18yaYcV++yzzZ24pcKqPkCfOkj+ikpu6xmV2TPz1seEge1upyOFC2C9Z1
         apRYDDWv5qJFsTxBfdGhSDjU40QkijcZs9c5Xl7YMX6xxKBRVxyYCIpBcyKGAEUdIF/E
         hA+0dh2NVXbnNiayqkzGV5wbdunFrW816mcqHeMxI5HgSPxbguuvngOXUn15BLAsvyOd
         Ni9Mn4Rn1c1xVfFStwHAF0fYKaeX3lzKEmEkLg67kgA76fLIA0wf+qi7ATSa9El2r3aW
         hXjg==
X-Gm-Message-State: APjAAAX8z3HhQ3KY6e0lzYONdPPHjZhAmNwKYzMxnFP2113KGu6pxf4l
        Z1mZ/Bza4In0wwVXzTU8f5Q=
X-Google-Smtp-Source: APXvYqwrMVAcA9uwDRqnkEFhYhKH/0xlYq9+1ptTmHXATwvSkJBV3Qq8ZfDhIRy8jo5I5ffAwrG3nw==
X-Received: by 2002:a17:90a:f496:: with SMTP id bx22mr1894415pjb.101.1574117905953;
        Mon, 18 Nov 2019 14:58:25 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id d23sm22996518pfo.140.2019.11.18.14.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 14:58:25 -0800 (PST)
Subject: Re: [PATCH 3/9] dpt_i2o: use scsi_host_flush_commands() to abort
 outstanding commands
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
References: <20191118092208.54521-1-hare@suse.de>
 <20191118092208.54521-4-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <138fc0d8-f8e2-b9b5-38c8-a37a0ba9247c@acm.org>
Date:   Mon, 18 Nov 2019 14:58:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191118092208.54521-4-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/19 1:22 AM, Hannes Reinecke wrote:
> Rather than traversing all outstanding commands manually use the
> scsi_host_flush_commands() helper to terminate all commands during
> reset.
> With that we can drop the cmd_list usage from the midlayer.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
