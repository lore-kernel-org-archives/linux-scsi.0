From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: write cache and read ahead
Date: Wed, 24 Aug 2005 06:04:00 -0400
Message-ID: <430C4610.3080205@pobox.com>
References: <43085209.50405@torque.net> <430914C2.8030301@pobox.com> <43095EB3.2020202@torque.net> <430BAFD3.9000702@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:29586 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750849AbVHXKEP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 06:04:15 -0400
In-Reply-To: <430BAFD3.9000702@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

Luben Tuikov wrote:
> On 08/22/05 01:12, Douglas Gilbert wrote:
> 
>>I was surprised how much code needed changing.
>>With MODE SELECT's issues with libata addressed
>>various other SAT "extras" should be much easier
>>to implement. That should make libata more attractive
>>as a SAT layer for SAS LLDDs (that don't do it already
>>in firmware).
> 
> 
> Doug, how about never needing a SAT layer for SAS LLDDs
> for ATA/ATAPI devices.
> 
> Would you object if I "give" you a "domain device" to which
> you can send FISes (+ the packet if ATAPI) through
> a SAM-4 intefrace: Execute Task + TMFs?
> 
> Jeff?

SAT is the useful piece of libata that makes everything work.  You can't 
rip out it and still expect to do anything useful ;-)

libata relies on SCSI's device class drivers -- sd, sr, st, sg -- to 
manage devices and generate commands to service.  And in turn, we rely 
on SAT (libata-scsi.c) to translate device class commands into ATA commands.

If the SAT layer went away, then nothing would exist to generate 
commands for libata to service.

	Jeff



