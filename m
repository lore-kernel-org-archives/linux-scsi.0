From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patch 0/4] aha152x.c - Cleanup, need help in testing and auditing
Date: Thu, 12 Jul 2007 12:42:07 +0300
Message-ID: <4695F76F.5000305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13184 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755711AbXGLJmb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 05:42:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, =?ISO-8859-1?Q?=22J=FCrgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

In motivation for the !use_sg cleanup and use of accessors
I needed to do some restructuring of the aha152x.c driver.

I have tried to be as careful as I could, but with out
the hardware for testing, it is hard. Christoph and James
You are signed on a couple of the last patches to this driver
So you are probably somewhat familiar with the code. Could
you please review the patchset to see that nothing is broken.

If any one has an Hardware that uses aha152x.c, please help me
with testing this patchset. If it does not work could you please
do a short bisect of which patch breaks out of the 4.

The problematic parts were that the driver writes all over the
scsi_cmnd members in couple of places. To untangle that I divided
the work to stages for easier review and testing. I was very 
verbose at each patch explanation, mainly for myself to try and
prove that the changes are sound. 

[patch 1/4] aha152x.c - Preliminary fixes and comments
 Some weird typos and some hard coded numbers made the code
 very hard to understand.

[patch 2/4]  aha152x.c - Clean Reset path
 On the Reset code path the driver would save, write, than 
 restore scsi_cmnd members. Here I propose a solution that
 does not need to do that.

[patch 3/4] aha152x.c - Fix check_condition code-path
  In case of a Status return from a target. The driver
  would re-queue the command with a REQUEST_SENSE read.
  Again save, write, restore. I cleaned that up to a stage
  I can be happy with. Also while at it I fixed a BUG with
  "resid".

[patch 4/4] aha152x.c - use data accessors and !use_sg cleanup
  And now everything is ready for this one.

Thanks for any help
Boaz
