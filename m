From: "Lee Xing" <lxing@Crossroads.com>
Subject: Help - how to prevent mid-layer from scanning un-exist disks?
Date: Wed, 16 Jun 2004 15:26:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FF034@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:32353 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S264733AbUFPU0y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 16:26:54 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Can some one please take a look at this and see how to do it.  My question is how to prevent mid-layer from scanning un-exist disks.

- Scenario 1
If actualNumOfDisks < =16, then the following code lets mid-layer scan (channel : target) 0:0, 0:1, ... 0:(actualNumOfDisks - 1).  This is good so far.

- Scenario 2
If actualNumOfDisks = 18, then the following code lets mid-layer scan 0:0, 0:1, ... 0:15, 1:0, 1:1, ... 1:15.  This is not good since it's not necessary for mid-layer to spend time to scan un-exist disks 1:2 - 1:15.  How can I let mid-layer scan just 18 disks in this case?


static int detect(Scsi_Host_Template * tpnt)
{
	struct Scsi_Host

	...
	pSH = scsi_register(tpnt, 0);

	pSH->max_channel = ((actualNumOfDisks -1) >> 4) & 0x1F;
	pSH->max_id = (actualNumOfDisks > 16) ? 16:actualNumOfDisks;
	...
}


Thanks,


Lee

