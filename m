From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: SYNCHRONIZE_CACHE from sd_preppare_flush does not have retries.!
Date: Mon, 19 Apr 2010 17:02:43 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249021C7718FA@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:33677 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005Ab0DSLdI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2010 07:33:08 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

I am facing one issue with scsi stack.
Here is a background of my test.

Mount ext3 file system with journaling support with barrier=1, commit=5
Now, with this setup file system will do submit_bh with  WRITE_BARRIER flag set for interval of 5 seconds. (This is a part of journaling.)
Eventually it will call queue_flush() which will generate SCSI command of CDB: SYNCHRONIZE_CAHCE and insert it into the request queue.
I observed that creation of SYNCHRONIZE_CACHE is a part of sd_prepare_flush(). Here we have timeout set to SD_TIMEOUT but retries are not set.
Because of retries of the request is not set, there is no retries allowed for SYNCHRONIZE_CACHE at mid layer.

Because of zero retries for SYNCHRONIZE_CACHE command at mid-layer, it is creating trouble for file system.
In current situation, Even though LLD send back commands with DID_RESET, SYNCHRONIZE_CACHE will fail immediately without going for any retries, when HBA is in recovery state. Eventually this information goes to File system and it sees SYNCHRONIZE_CAHCE is failed and file system goes to Read only mode.

My question is "Can we add in sd_prepare_flush(), rq->retries = X" some reasonable retries value ?

Thanks,
Kashyap


