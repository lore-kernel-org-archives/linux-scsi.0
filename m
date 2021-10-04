Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5807C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 17:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC2E461251
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 17:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhJDRKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 13:10:37 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:33623 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbhJDRKg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 13:10:36 -0400
Received: by mail-pj1-f53.google.com with SMTP id cs11-20020a17090af50b00b0019fe3df3dddso347204pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Oct 2021 10:08:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VETDCia8k5JyiH8ymCDL8SPAXOx8qaGhKyBHQ8thTkQ=;
        b=OZvbM/QiGqfd5lO9yHw0liZ+N++jxuYyoLuaHd14dhZA2+aU5Gk9t7c161eE+HMQ2I
         c9M4GZ6kzLdhwcJj9A5PybrVnBudjqYw+GBIEDtRTbJr0qYTje860lLdhiwpj9WEu9J0
         cShhsB8wf0nAclpfL/uULGrfQswaL00FkSK4Za4A6bv0SCphHyZEFbDPxDKOwQpUtKQW
         ZAhta5dEB+qwhW37+7y+BNGjk5KtCVoADpHVpnXtfdLUm5AZTQZyrA3xUVRjLyK4hVu+
         JYHyDd7mbN2ZL+Jrk33WIR88uSvpVyHcLsKQZInMCHNyu4l1eNy219jHVtXwG/mPZvJk
         cIgA==
X-Gm-Message-State: AOAM530eioLmC5ges6PAPOpEDzKyMy7YVzhaolOtTiYeZ4pUXrZzD0aO
        jhxaI7Pb1eEpKsTsAyFg4I8=
X-Google-Smtp-Source: ABdhPJx1ypbDwX48eiLJEEQkdBVBBMmjlUJwMgaULxiy2JLeSLmk7VA5H8ZM4wJIoKeIiP8TIBSUxw==
X-Received: by 2002:a17:902:7e84:b0:13e:d793:20d8 with SMTP id z4-20020a1709027e8400b0013ed79320d8mr694423pla.67.1633367327269;
        Mon, 04 Oct 2021 10:08:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:1e3d:a218:87c6:1612])
        by smtp.gmail.com with ESMTPSA id q18sm18472132pfj.46.2021.10.04.10.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 10:08:46 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: Fix task management completion
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20210922091059.4040-1-adrian.hunter@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9f02fc7d-2798-5b10-1600-3ecb6bbbb1b2@acm.org>
Date:   Mon, 4 Oct 2021 10:08:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210922091059.4040-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/21 2:10 AM, Adrian Hunter wrote:
> By using blk_mq_tagset_busy_iter(), the UFS driver was relying on internal
> details of the block layer, which was fragile and subsequently got
> broken. Fix by removing the use of blk_mq_tagset_busy_iter() and having
> the driver keep track of task management requests.

Tested-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
