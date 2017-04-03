From: Chet L <chetanloke@gmail.com>
Subject: Re: [PATCH] libiscsi: use vzalloc for large allocations in iscsi_pool_init
Date: Mon, 3 Apr 2017 12:46:43 -0700
Message-ID: <CAHnHxtyP=OGgCePeb9bde1GR_-nk1QdG7Ou9ndMSpatxH=oomQ@mail.gmail.com>
References: <1491226221-24621-1-git-send-email-kyle.fortin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:36203 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752402AbdDCTqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 15:46:44 -0400
Received: by mail-it0-f44.google.com with SMTP id e75so52984795itd.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Apr 2017 12:46:44 -0700 (PDT)
In-Reply-To: <1491226221-24621-1-git-send-email-kyle.fortin@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: lduncan@suse.com, cleech@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Kyle Fortin <kyle.fortin@oracle.com>

On Mon, Apr 3, 2017 at 6:30 AM, Kyle Fortin <kyle.fortin@oracle.com> wrote:

>
>         for (i = 0; i < q->max; i++)
>                 kfree(q->pool[i]);
> -       kfree(q->pool);
> +       if (q->is_pool_vmalloc)

you could do something like:

if (is_vmalloc_addr(q->pool))
    vfree(...);
else
    kfree(..);

And then remove the bool.


Chetan
