From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: bloated workload of SCSI commands at attachment
Date: Thu, 14 Dec 2017 22:02:22 -0500
Message-ID: <yq17etoofr5.fsf@oracle.com>
References: <f5b7aceb-0ec0-7ad5-53e3-47ac476b41b4@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57226 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754775AbdLODC2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Dec 2017 22:02:28 -0500
In-Reply-To: <f5b7aceb-0ec0-7ad5-53e3-47ac476b41b4@interlog.com> (Douglas
        Gilbert's message of "Wed, 13 Dec 2017 09:21:14 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


Doug,

> What seems to be to be new is the three repeated sequence involving
> the "a3 0c" command. That is REPORT SUPPORTED OPERATION CODES.
> Why is the same sequence repeated 3 times?

One invocation is probably partition scanning.

sd_probe calls revalidate twice. It used to be a somewhat tricky dance
of doing it once to get basic device properties, then allocating the
gendisk, and finally doing another revalidate pass to fill out the
remaining fields that had a dependency on a gendisk being instantiated.

Given some of the recent block changes, I am not entirely sure two calls
are required. Would be interesting to test...

-- 
Martin K. Petersen	Oracle Linux Engineering
