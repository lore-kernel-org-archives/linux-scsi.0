Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91557C001E0
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 13:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjJWNjt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 09:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjJWNjs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 09:39:48 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB844E5
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 06:39:45 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-40837ebba42so24427555e9.0
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 06:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698068384; x=1698673184; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Oex7vPSNi+K4wyo+SJFiOJvbKKmAeNdDpD4hzG0BrPE=;
        b=wTRt2dLgXtTfcjgSlKJO0BnIf+1ysYNsl4AdW0SZkomG13IfUZe9CRa3e5DiDg7I50
         Rx1eiBSMa8NsXgBT81Pl1DKvbQYloJYuK9H9MeTdoTtQh00Dz9MlSQ2eTJNJ8ahMGnDL
         edVRUy68rSES3jW5+ZQALZZtjk/DqpBKZonV/RyHPCzJlbDd3hGQwZX9pKxi/u9NwnV7
         VzvEVXM5yuHWqiRrnNIe07rByVhaVz/21wDjUKrXk9fB50EE9l1x06hmZOA9ZyODjMH/
         fG1IXyDPZxHkTPYLVYoMg94IS7tPtZzerESYErw5cDR1rZfchcAlw8ZaSEg9jxpidspo
         hYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698068384; x=1698673184;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oex7vPSNi+K4wyo+SJFiOJvbKKmAeNdDpD4hzG0BrPE=;
        b=bMZJoX+/c9g8mzXoqgBSzQzbrlSGkN/7lvDIBSRgfYzwwITNkg4r6wJXL9ZZp2cDlN
         ROnx+x7r2DtafS2VfqYDT7zKoSx+gFBoZOoHaPvgspNCm1oGJCBZDpBchiP87m/qy3N2
         LqJ7zhrfF5H1UbGN1qdRbc9XhumlBKA6qs5hJCJgG0GTCvVovJ1+FPcCb7ZzVX4DNg5+
         5Ezf4TyJhhEbEkt1YolqlSkTPdn2gnqFZXInRmQaj/XslTKL6R4rWExbb35fV4iBpx+s
         sS4mESxaSbwfjtxicW2gCJwAvJiQDIYiTVsEFRp7X6P59NZGuAqwogZSjbTgAu0KGmP0
         5sSA==
X-Gm-Message-State: AOJu0Yzjt5QbcWVghxEMtrWxP0iM5F992KAChH7aZL8pGbqKEmJreR0c
        EEVfJozvDeQYZFEdLaKs2cSTHxReyhcbA7CsvXY=
X-Google-Smtp-Source: AGHT+IH5kAoRyKQpRMqONNTgp7G1lcXCc8F0IYiMMwvgYRXd2AetNAdDkKS9m4vRbjni1lH7htGnSQ==
X-Received: by 2002:a5d:62c7:0:b0:32d:9d0e:7841 with SMTP id o7-20020a5d62c7000000b0032d9d0e7841mr6827228wrv.6.1698068384382;
        Mon, 23 Oct 2023 06:39:44 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id c17-20020a5d4151000000b0032d87b13240sm7885952wrq.73.2023.10.23.06.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 06:39:44 -0700 (PDT)
Date:   Mon, 23 Oct 2023 16:39:40 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Wenchao Hao <haowenchao22@gmail.com>
Cc:     Wenchao Hao <haowenchao2@huawei.com>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Vinod Koul <vkoul@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        dmaengine@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: scsi_debug: fix some bugs in
 sdebug_error_write()
Message-ID: <44b0eca3-57c1-4edd-ab35-c389dc976273@kadam.mountain>
References: <96d50cf7-afec-46af-9d98-08099f8dc76e@moroto.mountain>
 <CAOptpSMTgGwyFkn8o6qAEnUKXh+_mOr8dQKAZUWfM_4QEnxzxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOptpSMTgGwyFkn8o6qAEnUKXh+_mOr8dQKAZUWfM_4QEnxzxw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Oct 21, 2023 at 06:10:44PM +0800, Wenchao Hao wrote:
> On Fri, Oct 20, 2023 at 10:15 PM Dan Carpenter <dan.carpenter@linaro.org> wrote:
> >
> > There are two bug in this code:
> 
> Thanks for your fix, some different points of view as follows.
> 
> > 1) If count is zero, then it will lead to a NULL dereference.  The
> > kmalloc() will successfully allocate zero bytes and the test for
> > "if (buf[0] == '-')" will read beyond the end of the zero size buffer
> > and Oops.
> 
> This sysfs interface is usually used by cmdline, mostly, "echo" is used
> to write it and "echo" always writes with '\n' terminated, which would
> not cause a write with count=0.
> 

You are saying "sysfs" but this is debugfs.  Sysfs is completely
different.  Also saying that 'and "echo" always writes with '\n'
terminated' is not true either even in sysfs...

> While in terms of security, we should add a check for count==0
> condition and return EINVAL.

Checking for zero is a valid approach.  I considered that but my way
was cleaner.

> 
> > 2) The code does not ensure that the user's string is properly NUL
> > terminated which could lead to a read overflow.
> >
> 
> I don't think so, the copy_from_user() would limit the accessed length
> to count, so no read overflow would happen.
> 
> Userspace's write would allocate a buffer larger than it actually
> needed(usually 4K), but the buffer would not be cleared, so some
> dirty data would be passed to the kernel space.
> 
> We might have following pairs of parameters for sdebug_error_write:
> 
> ubuf: "0 -10 0x12\n0 0 0x2 0x6 0x4 0x2"
> count=11
> 
> the valid data in ubuf is "0 -10 -x12\n", others are dirty data.
> strndup_user() would return EINVAL for this pair which caused
> a correct write to fail.
> 
> You can recurrent the above error with my script attached.

You're looking for the buffer overflow in the wrong place.

drivers/scsi/scsi_debug.c
  1026          if (copy_from_user(buf, ubuf, count)) {
                                   ^^^
We copy data from the user but it is not NUL terminated.

  1027                  kfree(buf);
  1028                  return -EFAULT;
  1029          }
  1030  
  1031          if (buf[0] == '-')
  1032                  return sdebug_err_remove(sdev, buf, count);
  1033  
  1034          if (sscanf(buf, "%d", &inject_type) != 1) {
                           ^^^
This will read beyond the end of the buffer.  sscanf() relies on a NUL
terminator to know when then end of the string is.

  1035                  kfree(buf);
  1036                  return -EINVAL;
  1037          }

Obviously the user in this situation is like a hacker who wants to do
something bad, not a normal users.  For a normal user this code is fine
as you say.

You will need to test this with .c code instead of shell if you want to
see the bug.

regards,
dan carpenter

