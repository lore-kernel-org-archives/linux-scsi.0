From: Alireza Haghdoost <alireza@cs.umn.edu>
Subject: Re: [SCSI] qla2xxx: Question about out-of-order SCSI command processing
Date: Tue, 3 Dec 2013 11:46:36 -0600
Message-ID: <CAB-428mPDKLKB_20jsUudU1OZ2rphYrjWx00ikAe1gK3_AnuPQ@mail.gmail.com>
References: <CAB-428kfuWWGDhciGTAy6OCZr8ACBh52_iebBd8U4gwN0S7GPA@mail.gmail.com>
 <1386027526.2014.2.camel@dabdike.int.hansenpartnership.com>
 <529DCDE5.6010304@acm.org> <1386077157.2166.16.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.201]:59576 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab3LCRrU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Dec 2013 12:47:20 -0500
Received: from mail-vc0-f171.google.com (mail-vc0-f171.google.com [209.85.220.171])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id E7F702AC2A3
	for <linux-scsi@vger.kernel.org>; Tue,  3 Dec 2013 11:47:17 -0600 (CST)
Received: by mail-vc0-f171.google.com with SMTP id ik5so9999904vcb.2
        for <linux-scsi@vger.kernel.org>; Tue, 03 Dec 2013 09:47:17 -0800 (PST)
In-Reply-To: <1386077157.2166.16.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, Jerry Fredin <jerry.fredin@netapp.com>

On Tue, Dec 3, 2013 at 7:25 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Well, no, we could have used Ordered instead of Simple tags ... that
> would preserve submission order according to spec.  This wouldn't really
> work for SATA because NCQ only has simple tags.

Thanks a lot James for your comments. Is it possible to configure TCQ
mode to the Ordered tag instead of Simple tags? I understand that NCQ
does not support Ordered tags but I think it would be nice to keep
this functionality as an option for other SCSI targets like qla2xxx.
I can see the discussion about TAG ordering in the mailing list.
However, I am not sure if it is functional right now or not.


> The point is that our
> granular unit of ordering is between two barriers, which is way above
> the request/tag level so we didn't bother to enforce tag ordering.

Does a barrier force flush all in_flight SCSI commands ? Based on my
understanding if we put a barrier between multiple requests, it wont
return until TCQ process all in_flight scsi commands. Which means we
can not keep a fixed load on TCQ and it would certainly reduce the
throughput of our application.

> However, handling
> strict ordering in the face of requeuing events like QUEUE FULL or BUSY
> is hard so we didn't bother.

We have a peace of code to monitor in_flight requests and avoid
QUEUE_FULL events. However, would you please let us know a case that
cause a BUSY events ? Does it means the scsi target is busy processing
other requests with-in the same host machine ?
