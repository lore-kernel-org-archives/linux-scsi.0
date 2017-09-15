From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] sg: fixup infoleak when using SG_GET_REQUEST_TABLE
Date: Fri, 15 Sep 2017 11:49:29 -0700
Message-ID: <CA+55aFzC44UpPGc1aWkjjDkeRHV4ssVFmjYQ1hHHbTG23uRavA@mail.gmail.com>
References: <1505477116-75013-1-git-send-email-hare@suse.de> <1505477116-75013-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35671 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751516AbdIOSta (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 14:49:30 -0400
Received: by mail-io0-f196.google.com with SMTP id d16so4856808ioj.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2017 11:49:30 -0700 (PDT)
In-Reply-To: <1505477116-75013-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, "security@kernel.org" <security@kernel.org>, Hannes Reinecke <hare@suse.com>

Looks good.

James, I expect I'll be getting this through the normal SCSI pulls..

            Linus

On Fri, Sep 15, 2017 at 5:05 AM, Hannes Reinecke <hare@suse.de> wrote:
> When calling SG_GET_REQUEST_TABLE ioctl that only a half-filled
> table is returned; the remaining part will then contain stale
> kernel memory information.
> This patch zeroes out the entire table to avoid this issue.
