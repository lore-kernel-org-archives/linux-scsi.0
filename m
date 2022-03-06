Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F082AC433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 01:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiCFBDu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 20:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiCFBDu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 20:03:50 -0500
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78467FC9;
        Sat,  5 Mar 2022 17:02:58 -0800 (PST)
Received: by mail-pg1-f175.google.com with SMTP id 195so10599974pgc.6;
        Sat, 05 Mar 2022 17:02:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+LjUQ4hqF7YDhbYcdTsu1hwBQg0nD/xvn2rUE/13XHw=;
        b=W5P0JaM4Z0cLnImx/ePCob1P2hTvT0GWSlD8zMA4P0I+fkxDCgvBCQM7l6CXmUgrm8
         mXKPgX6pRZQWp1PBWTV8hwux5sSqaTPe+Jhv4t+pq/EOaAvHzY5P8FcQ6DJgsMqck9LH
         4AzWlVOg08pqBUooG1iORoPoq5IldysTCJTPk8UwWEFDc+z8xqYq3cJmWphbTLeCG4Hn
         D8gfueUtWHsT3C5aUj/tTgJblfPsOfpdP6FvmT5PzaLWLsXrl9m7l7ZVsRApaDZp/N3A
         xmqTC+6yItW1f8O4ei0P/aYGptKRa/MIuyESHyP4Z/r/guZ8voBh9zLoB2e1hR8xjG9W
         Lmog==
X-Gm-Message-State: AOAM532PieUmm7sPslxs6BJiDHSq619g0ioF+YsC/izhF9w/GPhI6p2X
        OWaWZrq7V3xFVhGS711Zd5Y=
X-Google-Smtp-Source: ABdhPJzbLAd6eM9ViH1Gk2Gz3wuEQgH6uxJ/Lx3H9jJhECnn/MtOR6wAezEhNxxB+tAdPZOXmAHZXA==
X-Received: by 2002:a05:6a00:3023:b0:4f6:aaa1:8f8a with SMTP id ay35-20020a056a00302300b004f6aaa18f8amr6164704pfb.49.1646528577804;
        Sat, 05 Mar 2022 17:02:57 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id w23-20020a627b17000000b004f6cf170070sm4283186pfc.186.2022.03.05.17.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 17:02:57 -0800 (PST)
Message-ID: <acfe9169-bcab-44d1-cb6c-e7ac6d40261a@acm.org>
Date:   Sat, 5 Mar 2022 17:02:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 01/14] blk-mq: do not include passthrough requests in I/O
 accounting
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-2-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220304160331.399757-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/22 08:03, Christoph Hellwig wrote:
> I/O accounting buckets I/O into the read/write/discard categories into
> which passthrough I/O does not fit at all.  It also accounts to the
> block_device, which may not even exist for passthrough I/O.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
