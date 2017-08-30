From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH] storvsc: fix memory leak on ring buffer busy
Date: Wed, 30 Aug 2017 08:11:01 -0700
Message-ID: <20170830081101.5307095d@xeon-e3>
References: <20170829004359.28526-1-longli@exchange.microsoft.com>
        <yq18ti1265c.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:38477 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751382AbdH3PLH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 11:11:07 -0400
Received: by mail-pg0-f41.google.com with SMTP id b8so20685284pgn.5
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2017 08:11:07 -0700 (PDT)
In-Reply-To: <yq18ti1265c.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Long Li <longli@exchange.microsoft.com>, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org

On Tue, 29 Aug 2017 21:31:11 -0400
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> Long,
> 
> > When storvsc is sending I/O to Hyper-v, it may allocate a bigger
> > buffer descriptor for large data payload that can't fit into a
> > pre-allocated buffer descriptor. This bigger buffer is freed on return
> > path.
> >
> > If I/O request to Hyper-v fails due to ring buffer busy, the storvsc
> > allocated buffer descriptor should also be freed.  
> 
> Which kernel version is this patch aimed at?
> 

Looks like this an old issue. Probably should add

Fixes: be0cf6ca301c ("scsi: storvsc: Set the tablesize based on the information given by the host")
