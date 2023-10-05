Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F2FE92707
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Oct 2023 14:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237537AbjJEOqd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239078AbjJEOoM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 10:44:12 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D86AB6FA
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 07:21:51 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-65af1037ca8so5348416d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Oct 2023 07:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1696515710; x=1697120510; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KLi5kEVp7wM1kR6SXKn4FnJQGq1aKEW0YrkYzX5AsPk=;
        b=oFgQTzjQdg7oSjp8ptSiQxoWOaiNy8yX2kEGKzwPJ7iC/eW/Xbsb9AVw/2ID5dBLmP
         ibW/dZy1wb1Sdvk+LiUjWFmjygA0J/HpNSdLKHrEdr8vg5C74+SDT6VXGcJHnu3y7kPA
         QiQp+AzzDjea1SEtEKR2ynwDNksRzEJbrP1QBiMnUJpBn+Pmp5XtnDpZlzEf7sc8hLmL
         zEEQBH2yFafry7INJQFgNOtM6DU+dIsDGxB8mYiyY4QVEcqq50r7C6fSUzRXTaSTHBD6
         g3tlZ9Y1jHNhtjjZxZxXa7OPKaAkarmKXvlMdwOiCJV4tZUCw673vYs6AyCEAXq2J18B
         CyCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696515710; x=1697120510;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KLi5kEVp7wM1kR6SXKn4FnJQGq1aKEW0YrkYzX5AsPk=;
        b=dyar9S0BGrIZ5Qx2pRZyrZ+0fm0e91ZChJd6NPiTo2NbjUPHWwhNzES7dCkw9p8BIc
         VCQyKxsg25QOB6roj/7f8ebiWc4dc/x/AWKs9hPHxbotYBAPfeWb5JqoJhWC/YGoYYpf
         KIpdbEFVoU/vo7Vu1UilHyJql1miInNe/JgFqyvg0ryfonpUmH5HtWb73mpk1fdVPrxE
         lOzbgylLlCEIpYkUSGWhK0hs1AjKjzz4staMfx5lTtoE2EkdoD8QLsiJSgkvetsL4nlE
         XNImUhEJ7O8MWUeQuHCfuvWr+kwzZYMUHE+S1Yjpm5/XNV6npQWHLg7/jL2GwVEtQNBJ
         uHqw==
X-Gm-Message-State: AOJu0YxVFNir1BX/wDcYx7oPrpelOnzcuGpl4bvjmAXJ9w/dQ/PmALZf
        /d83zNBB6X47iRaqYJxM9DR6uA==
X-Google-Smtp-Source: AGHT+IHo/gGWVUv0W/igUd1P3ug0bMk35uJFzqIuqgP4SHAU5rjIqqIh05NULoEnDccg7+tCD8rZrw==
X-Received: by 2002:a0c:a982:0:b0:65d:afc:3a52 with SMTP id a2-20020a0ca982000000b0065d0afc3a52mr4388602qvb.49.1696515710311;
        Thu, 05 Oct 2023 07:21:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id x6-20020a0cda06000000b0065b1c26c89asm519760qvj.145.2023.10.05.07.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 07:21:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qoPEa-0044Mc-Tb;
        Thu, 05 Oct 2023 11:21:48 -0300
Date:   Thu, 5 Oct 2023 11:21:48 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Zhu Yanjun <yanjun.zhu@linux.dev>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Leon Romanovsky <leon@kernel.org>, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, matsuda-daisuke@fujitsu.com,
        shinichiro.kawasaki@wdc.com, linux-scsi@vger.kernel.org,
        Zhu Yanjun <yanjun.zhu@intel.com>
Subject: Re: [PATCH 1/1] Revert "RDMA/rxe: Add workqueue support for rxe
 tasks"
Message-ID: <20231005142148.GA970053@ziepe.ca>
References: <20230922163231.2237811-1-yanjun.zhu@intel.com>
 <169572143704.2702191.3921040309512111011.b4-ty@kernel.org>
 <20230926140656.GM1642130@unreal>
 <d3c05064-a88b-4719-a390-6bf9ae01fba5@acm.org>
 <b7b365e3-dd11-bc66-dace-05478766bf41@gmail.com>
 <2d5e02d7-cf84-4170-b1a3-a65316ac84ee@acm.org>
 <2fcef3c8-808e-8e6a-b23d-9f1b3f98c1f9@linux.dev>
 <552f2342-e800-43bc-b859-d73297ce940f@acm.org>
 <20231004183824.GQ13795@ziepe.ca>
 <c0665377-d2be-e4b6-3d25-727ef303d26e@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0665377-d2be-e4b6-3d25-727ef303d26e@linux.dev>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 05, 2023 at 05:25:29PM +0800, Zhu Yanjun wrote:
> 在 2023/10/5 2:38, Jason Gunthorpe 写道:
> > On Wed, Oct 04, 2023 at 10:43:20AM -0700, Bart Van Assche wrote:
> > 
> > > Thank you for having reported this. I'm OK with integrating the
> > > above change in my patch. However, code changes must be
> > > motivated. Do you perhaps have an explanation of why WQ_HIGHPRI
> > > makes the issue disappear that you observed?
> > 
> > I think it is clear there are locking bugs in all this, so it is not
> > surprising that changing the scheduling behavior can make locking bugs
> > hide
> > 
> > Jason
> 
> With the flag WQ_HIGHPRI, an ordered workqueue with high priority is
> allocated. With this workqueue, to now, the test has run for several days.
> And the problem did not appear. So to my test environment, this problem
> seems fixed with the above commit.
> 
> I doubt, without the flag WQ_HIGHPRI, the workqueue is allocated with normal
> priority. The work item in this workqueue is more likely preempted than high
> priority work queue.

Which is why it shows there are locking problems in this code.

Jason
