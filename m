From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] scsi: don't count non-failure CHECK_CONDITION as error
Date: Fri, 15 Jan 2016 13:42:52 -0500
Message-ID: <20160115184252.GJ3520@mtj.duckdns.org>
References: <20160114214602.GC3520@mtj.duckdns.org>
 <1452872774.2356.5.camel@HansenPartnership.com>
 <1452873302.2356.9.camel@HansenPartnership.com>
 <56992361.7030606@interlog.com>
 <1452882934.2356.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:34910 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbcAOSmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2016 13:42:55 -0500
Received: by mail-yk0-f178.google.com with SMTP id x67so554288485ykd.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jan 2016 10:42:54 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1452882934.2356.13.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dgilbert@interlog.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Dave Jones <dsj@fb.com>, kernel-team@fb.com

Hello, James.

On Fri, Jan 15, 2016 at 10:35:34AM -0800, James Bottomley wrote:
> Well, I can see sense in having an error count of everything that comes
> back that's not good status because it's easy and has a well defined
> meaning (calling it the "error count" is more debatable, agreed).  It
> appears that Dave and Tejun want the count to mean something else. 
>  Lets treat this as a feature exercise: Dave and Tejun, what do you
> want, then we can see if we could add an additional counter giving you
> that.

Well, currently, for libata devices, all passthrough commands bump it
up because the result taskfile is reported via sense data, which is
pretty misleading for something named ioerr_cnt.  Maybe we can ignore
CHECK_CONDITION for ATA passthrough commands but special casing them
can be confusing in other ways.

Thanks.

-- 
tejun
