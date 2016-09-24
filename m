From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3] add u64 number parser
Date: Sat, 24 Sep 2016 11:31:11 -0700
Message-ID: <CAADWXX9cJLw2y61rOe0Bd2usCUcPOPrjFcvPXfhKXyk9vDTRHQ@mail.gmail.com>
References: <57e69b53.MIvVzLk8rJW7sEVb%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33142 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758949AbcIXSbN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Sep 2016 14:31:13 -0400
Received: by mail-io0-f174.google.com with SMTP id r145so147940159ior.0
        for <linux-scsi@vger.kernel.org>; Sat, 24 Sep 2016 11:31:12 -0700 (PDT)
In-Reply-To: <57e69b53.MIvVzLk8rJW7sEVb%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Sat, Sep 24, 2016 at 8:27 AM, James Smart <james.smart@broadcom.com> wrote:
>
> add u64 number parser
>
> Prior patch revised to use kasprintf.
> Modified match_number to use kasprintf as well

Why would you do this? It's insane. kasprintf() is not the right thing
at all to use for anything like this. It appears that you want to use
strncpy() or something. Or you could just avoid the extra copy
entirely in 99% of all cases and just use simple_strtol() and check
that the end didn't overflow the substring, which it presumably never
does anyway.

Yes, the stupid code is already disgustingly bad. But let's not make
it *worse*, for chrissake!

               Linus
