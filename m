Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E584DC43331
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 20:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3FF420737
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 20:02:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=blockbridge-com.20150623.gappssmtp.com header.i=@blockbridge-com.20150623.gappssmtp.com header.b="dh7k8Kqr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388696AbgDBUCJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 16:02:09 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40432 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388584AbgDBUCJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2020 16:02:09 -0400
Received: by mail-ot1-f68.google.com with SMTP id r19so4833088otn.7
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2020 13:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blockbridge-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TIcTkXTYRJR7AtlYCnt8yyQTGfCnZqsJuGJxqpgkmWk=;
        b=dh7k8KqrHO8RsZZcBBC7/e9Aj7AN0uIqboJx7ddXMEhaGUzLcJp0up3Yujz3ByXiAS
         deMiC0OJWIR1Cw/zf7wd09TNfCrcgH6X4Uhl6CTjViDBxH3t34s4RZGJpY6I67HHRiBk
         4L0xZeX2kaoWUwpkBIXAxNPyN3+ccoBteoccQeaXPwvzx2aOO832sLcQk1zQCOamB+vi
         P7oqqRydM5H3jtolnEq06SEYxejeh46f342EhKZ7Unqo3NUG4pzYOZQYsumeW6R3mmyW
         TCNG68rXkGdvXNCyMdIF2QqCVO60fuf4n4QjE5heTPnAirkyySG+/DC+E/DFjN0iFbm2
         Dt2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TIcTkXTYRJR7AtlYCnt8yyQTGfCnZqsJuGJxqpgkmWk=;
        b=bdEjCBcDLnlq6FoeTuyKt6hlvczoINWy34LphRpgbtbDDwWCm2xIffwaAiyh9JjTeG
         WHfqAXxC67WXbdqPSMyjr5ydpKISGgwz3VQA1sfJ0KXqDVP3Ccyfs/AsdkyESmRvG4d3
         xoei13o8DuZU1JDaAKTiy1a0f9kYvX95klx4dwr1f2tS7voUjue2JXzXFdrhl0xJPILG
         xpgNZ2ht84l2rPjO2TSQ1g7xWTbE6w6mmmNBav2qvZ4KmBpU/ZK+NZmf0Mbq/8CO3b/a
         t8br2u6jJVts0/OHZdBRHUMQeFYY9NEe3vy1neytensPMj2LKGVEis4qI/uCmFmFDWF3
         w0FQ==
X-Gm-Message-State: AGi0PubkrKYDTjPqj/v6k+zYhC/awPE5yev/+EjnVz8+7qCQT1qj9d1P
        XZpyXPAMfLXcLkFALs9GZjeqkyLZo5QtlsJ5k0dJ7g==
X-Google-Smtp-Source: APiQypJFrqNt8RtRbjyzYOGmuL7Yn51xEcFdM0RPgRLwDEEb4JyqAU3ggvGCnBaYzGaKql2zs9wMkwPpg1qBjuUq4tM=
X-Received: by 2002:a9d:68c5:: with SMTP id i5mr3947879oto.266.1585857728074;
 Thu, 02 Apr 2020 13:02:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p> <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p> <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
 <CAAFE1bfpUWCZrtR8v3S++0-+gi8DJ79X3e0XqDe93i8nuGTnNg@mail.gmail.com>
 <20191203124558.GA22805@ming.t460p> <CAAFE1bfB2Km+e=T0ahwq0r9BQrBMnSguQQ+y=yzYi3tursS+TQ@mail.gmail.com>
 <20191204010529.GA3910@ming.t460p> <CAAFE1bcJmRP5OSu=5asNTpvkF=kjEZu=GafaS9h52776tVgpPA@mail.gmail.com>
 <20191204230225.GA26189@ming.t460p> <d9d39d10-d3f3-f2d8-b32e-96896ba0cdb2@grimberg.me>
 <CAAFE1beqFBQS_zVYEXFTD2qu8PAF9hBSW4j1k9ZD6MhU_gWg5Q@mail.gmail.com>
 <d2f633f1-57ef-4618-c3a6-c5ff0afead5b@grimberg.me> <CAAFE1bdAbKfqbf05pKBcMUj+58fijDMT-8WBSuwiKk2Bmm4v2w@mail.gmail.com>
 <95750c05-eb49-d1db-311f-4edf9b4fd6ec@grimberg.me>
In-Reply-To: <95750c05-eb49-d1db-311f-4edf9b4fd6ec@grimberg.me>
From:   Stephen Rust <srust@blockbridge.com>
Date:   Thu, 2 Apr 2020 16:03:15 -0400
Message-ID: <CAAFE1bcmFxb6MYbicUVdVsK6QNjweaow3v+vHe6szwfFN6K-=A@mail.gmail.com>
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Rob Townley <rob.townley@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Max Gurtovoy <maxg@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sagi,

> Does the attached patch work for you?

This patch _does_ work for our tests. I see all the writes aligned to
512 bytes as, I think, would be expected. Thanks!


Just for your information, using the bpftrace script earlier in this
thread, the output is as follows. The lines with 2 values shows the
first two arguments to 'bio_add_page()', the lines with 4 values shows
the first 4 arguments to `brd_do_bvec()`.

For the successful case on the new patch:

# bpftrace isert.bt
Attaching 4 probes...
512 3072
512 3072 1 131071
4096 0
4096 0 0 0
4096 0
4096 0 0 8
4096 0
4096 0 0 131064
4096 512
3584 512 1 131064
512 0 1 131071
512 0
512 0 0 131071


And for the failed case on the older unpatched code:

# bpftrace ./isert.bt
Attaching 4 probes...
512 76
512 76 1 131071
4096 0
4096 0 0 0
4096 0
4096 0 0 8
4096 0
4096 0 0 131064
4096 76
4020 76 1 131064
76 0 1 131071
512 0
512 0 0 131071


Thanks again!
Steve
