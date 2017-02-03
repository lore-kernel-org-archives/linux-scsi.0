From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [REGRESSION v4.10-rc1] blkdev_issue_zeroout() returns -EREMOTEIO on the first call for SCSI device that doesn't support WRITE SAME
Date: Fri, 03 Feb 2017 17:45:25 -0500
Message-ID: <yq1wpd6vqpm.fsf@oracle.com>
References: <cc14c28a-0f0a-640a-b576-cdfbaee75dc5@ce.jp.nec.com>
        <d360a634-2c95-2de5-8647-4e740e92e10a@kernel.dk>
        <20170203161239.GA3880@lst.de>
        <1e819f0d-ecdc-e54a-bd3d-17de2f71c8a7@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32303 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752527AbdBCWpj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2017 17:45:39 -0500
In-Reply-To: <1e819f0d-ecdc-e54a-bd3d-17de2f71c8a7@kernel.dk> (Jens Axboe's
        message of "Fri, 3 Feb 2017 09:14:11 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Junichi Nomura <j-nomura@ce.jp.nec.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:

>> I think we should fix sd.c to only send WRITE SAME if either of the
>> variants are explicitly listed as supported through REPORT SUPPORTED
>> OPERATION CODES, or maybe through a whitelist if there are important
>> enough devices.

Jens> Yep

I hate it too. But the reason it's assumed on is that there is
essentially no heuristic that works. Just like we assume that READ
always works.

Out of the ~200 devices I have access to in the lab:

 - 100% of the SAS/FC disk drives and SSDs support WRITE SAME
 - Only 2 out of about 50 different drive models support RSOC
 - About half of the arrays support WRITE SAME(10/16)
 - None of the arrays I have support RSOC

So even if we were to entertain using RSOC for "enterprise" transport
classes (which I concur would be nice for other reasons), it wouldn't
solve the WRITE SAME problem...

-- 
Martin K. Petersen	Oracle Linux Engineering
