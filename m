Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43611C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 17:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238384AbiBIRjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 12:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiBIRjU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 12:39:20 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E01C05CB82
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 09:39:23 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id y17so2826838plg.7
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 09:39:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8TYOV18jMSELK4+kf1J2v0PF2lBr5WaZ61hcmpZKg1M=;
        b=7LT72RxoNSSxjKNMk5TtGkouM1wHv1uj7vvJ3xHAhhIimNUJB0Wj1qlPgnPg5YkHIZ
         T9mQ9CI80OmuV1u2Y2ezSkp7FKDOf1IHQYWVpYzdCH9qWTxajltnfZzTUW9vq5t8ZPcZ
         xCgAY8XlGsD9Y9KDDlVYBDRNQ8ArSzFsB8iN0lC2GoOlUE+J8PKJJpDj6yK0/HHNSPNg
         P654r5v0miapI4KWqCghbmV6CvhxBm6CKbTNLrwUcqVCDzbDJxP11BtjerMawEATcsKP
         w4rXGRVpi1D1eYRh3ZSxuFmLAX8w7j+v3AcG446pham2idX+xAENytcN4VhCnYXkRLDk
         c7+Q==
X-Gm-Message-State: AOAM530QkHynTU9NRAhNwHmfplRk35aaH7LVktwyTXogw0zJGMaXbbLG
        Jjr13jVvmtwsQB+4ekgkDeA=
X-Google-Smtp-Source: ABdhPJxT5Lw+7fAVlvxkRRD3nrIs32ZFuqEqzEHQwyqHdyiJLgs4gO0cmONvsBU2zPucAnwUOZAcoA==
X-Received: by 2002:a17:902:cf0c:: with SMTP id i12mr3277217plg.64.1644428362920;
        Wed, 09 Feb 2022 09:39:22 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id j4sm20793072pfc.217.2022.02.09.09.39.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 09:39:21 -0800 (PST)
Message-ID: <c21e1439-5d92-b376-6215-06cc0cd37368@acm.org>
Date:   Wed, 9 Feb 2022 09:39:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 03/44] scsi: Remove drivers/scsi/scsi.h
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Russell King <linux@armlinux.org.uk>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Oliver Neukum <oliver@neukum.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-4-bvanassche@acm.org>
 <4983e3e3-6706-c257-5a4e-7e9ad0e95533@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4983e3e3-6706-c257-5a4e-7e9ad0e95533@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 23:26, Hannes Reinecke wrote:
> On 2/8/22 18:24, Bart Van Assche wrote:
>> -#include "scsi.h"
>> +#include <scsi/scsi.h>
>> +#include <scsi/scsi.h>
> 
> Duplicate include line

I will fix this and also the other duplicate.

Thanks,

Bart.
