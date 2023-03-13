Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D4AC61DA4
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 20:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjCMUUf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 16:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjCMUUd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 16:20:33 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBE0498BA;
        Mon, 13 Mar 2023 13:20:01 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so18096209pjg.4;
        Mon, 13 Mar 2023 13:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678738757;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gnEM2VqhNYm1Q6GY7US8gYzxxU09aVC9RAwHjEYybAs=;
        b=KnnBRfzJxX3ymvtVuje9sy2OV4wBuDG5IbOeO147DagE9YQxe48EZCXKu7tWeXnz5b
         +uN84T2HYomzWKgjg1/Arsh132YKZeSrGJaqrIJAD40veEhW8D9GkHE0WXkSSiHna+HR
         zNglFVnORxIBetAArOcepiDw3O+nRQ8Tx7fccXiJJx+4l/WR6IVfGX2f+7fs7hZAY96v
         QoqD9XBgKqT6nx0DiPkvhkO311lYSTj/iXQRV3c2S7I1WSxVBwr3pEXqeYihUrOWwDNW
         Y01LOTONXoaGnuRezteryyOLqj0377fe5kTIsze5sC2DrZPfmbqxofcflhUGkYIl5uxz
         4eBg==
X-Gm-Message-State: AO0yUKUO1Wb4YCmAatl7a86y+oRrACYxKsoJm1WvNwkrNqkqepN8Hb4F
        mCByJL0vJ31dcnQWRD1nPuk=
X-Google-Smtp-Source: AK7set/Hmi8z5zVtuXthRDubxYAragb/A+uBm1zJBgthUsYeBNxth8nWpZ7Gc3mVrrf9INp/SIUiCA==
X-Received: by 2002:a17:902:e5cd:b0:19a:9859:be26 with SMTP id u13-20020a170902e5cd00b0019a9859be26mr11607438plf.22.1678738757161;
        Mon, 13 Mar 2023 13:19:17 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9cdb:df66:226e:e52a? ([2620:15c:211:201:9cdb:df66:226e:e52a])
        by smtp.gmail.com with ESMTPSA id y17-20020a17090abd1100b0023d2fb0c3a2sm250130pjr.46.2023.03.13.13.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 13:19:16 -0700 (PDT)
Message-ID: <6084d6cf-58a2-6c82-acb7-6033b504a048@acm.org>
Date:   Mon, 13 Mar 2023 13:19:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 02/12] infiniband: srpt: remove default fabric ops
 callouts
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Chris Boot <bootc@bootc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, linux-scsi@vger.kernel.org,
        linux@yadro.com
References: <20230313181110.20566-1-d.bogdanov@yadro.com>
 <20230313181110.20566-3-d.bogdanov@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230313181110.20566-3-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/13/23 11:11, Dmitry Bogdanov wrote:
> Remove callouts that have the implementation like a
> default implementation in TCM Core.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
