From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [REGRESSION v4.10-rc1] blkdev_issue_zeroout() returns -EREMOTEIO
 on the first call for SCSI device that doesn't support WRITE SAME
Date: Fri, 3 Feb 2017 20:17:10 -0700
Message-ID: <34e7f917-8fff-d8f9-c498-3431a27113ca@kernel.dk>
References: <cc14c28a-0f0a-640a-b576-cdfbaee75dc5@ce.jp.nec.com>
 <d360a634-2c95-2de5-8647-4e740e92e10a@kernel.dk>
 <20170203161239.GA3880@lst.de>
 <1e819f0d-ecdc-e54a-bd3d-17de2f71c8a7@kernel.dk> <yq1wpd6vqpm.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33181 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753393AbdBDDRr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2017 22:17:47 -0500
Received: by mail-pf0-f177.google.com with SMTP id y143so10089438pfb.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2017 19:17:14 -0800 (PST)
In-Reply-To: <yq1wpd6vqpm.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Junichi Nomura <j-nomura@ce.jp.nec.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>

On 02/03/2017 03:45 PM, Martin K. Petersen wrote:
>>>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:
> 
>>> I think we should fix sd.c to only send WRITE SAME if either of the
>>> variants are explicitly listed as supported through REPORT SUPPORTED
>>> OPERATION CODES, or maybe through a whitelist if there are important
>>> enough devices.
> 
> Jens> Yep
> 
> I hate it too. But the reason it's assumed on is that there is
> essentially no heuristic that works. Just like we assume that READ
> always works.
> 
> Out of the ~200 devices I have access to in the lab:
> 
>  - 100% of the SAS/FC disk drives and SSDs support WRITE SAME
>  - Only 2 out of about 50 different drive models support RSOC
>  - About half of the arrays support WRITE SAME(10/16)
>  - None of the arrays I have support RSOC
> 
> So even if we were to entertain using RSOC for "enterprise" transport
> classes (which I concur would be nice for other reasons), it wouldn't
> solve the WRITE SAME problem...

We're at (almost) -rc7 time, we have to do more than hand wave about
this. What's the plan for 4.10 final?


-- 
Jens Axboe
