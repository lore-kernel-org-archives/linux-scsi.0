From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patch 0/8] Change SG_ALL to mean "any size"
Date: Thu, 17 Jan 2008 18:37:09 +0200
Message-ID: <478F8435.5000907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:53961 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYAQQhZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 11:37:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


I have scanned through the scsi tree and checked all places that used
SG_ALL. Those drivers that where not ready for SG_ALL to mean "any size"
where changed to what ever is appropriate for this driver.
Mainly 3 groups.

Those that meant SG_ALL == 255:

  [PATCH 1/8] firewire: ieee1394: Move away from SG_ALL
  [PATCH 2/8] scsi-drivers Don't use SG_ALL as allocation size

Those who are not sg-chaining ready:

  [PATCH 3/8] NCR5380: Not sg-chain ready
  [PATCH 4/8] wd33c93: Not sg-chain ready
  [PATCH 5/8] arm/scsi: Not sg-chain ready
  [PATCH 6/8] scsi: Drivers not ready for sg-chaining

And those that just got confused:
  [PATCH 7/8] a100u2w: advansys: initio: Wrong use of SG_ALL


And finally the switch of SG_ALL to ~0, that is MAX_ what ever
type it is.
  [PATCH 8/8] Change SG_ALL to mean "any size"

Please request if you want any patches squashed or split.

These are based on the scsi-bidi git-tree and mainly on top
of the: "[SCSI] remove use_sg_chaining" patch. James do you
want that I reverse the dependency so your patch will be on 
top of these patches? (For bisect-ability)

Boaz

