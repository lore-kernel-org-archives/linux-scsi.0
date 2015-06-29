From: "Dov Levenglick" <dovl@codeaurora.org>
Subject: [RFC] implementaion of ufs variant
Date: Mon, 29 Jun 2015 12:38:07 -0000
Message-ID: <6634186b2777982ffb7944222d7ce1ad.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51925 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbbF2MiJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2015 08:38:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Rob Herring <robherring2@gmail.com>

Hi James et. al,
We had a lively discussion in the thread titled "Re: [PATCH v2 4/4] scsi:
ufs: probe and init of variant driver from the platform device" regarding
the proper implementation of a UFS controller variant.
After further consideration, we propose to go with what Rob initially
suggested - i.e. "you should do like many other common *HCIs do and make
the base UFS driver a set of library functions that drivers can use or
call".

The implementation of such a change would incur the following changes:
1. Moving a few generic functions from ufs/ufshcd-pltfrm.c to ufs/ufshcd.c
2. Having a ufs/ufshcd-pltfrm.c file per implementation (e.g.
ufs/ufs-qcom.c) and removing the existing generic file from the code base
3. Externalizing multiple functions from the ufs/ufshcd.c file to be used
by multiple variants

The initialization flow would be:
1. The variant probe is called
2. The variant would call the necessary initialization functions from the
generic ufs/ufshcd.c file
3. Since the event-driven mechanism is implemented in the generic
implementation - during runtime ufs/ufshcd.c would call upon variant
operations (vops) in the variant implementation using a set of callback
provided during the probe/init phase.

The pros of such an approach are:
1. A generic set of library functions that implement the UFS standard to
be called by each variant
2. Will be easy to add other UFS hosts in the future
3. Similar approach to other memory solutions such as the mmc driver
4. Keeps the runtime code centralized and therefore maintainable

The con to such an approach:
1. It is not backward compatible to existing (deployed) code

Our feeling is that, since UFS does not have great market penetration yet,
now would be the time to introduce a change such as we are proposing.

As a side-effect to this solution, we are considering removing
ufs/ufshcd-pci.c from the community's code. Our understanding is that this
was used for initial bring ups on emulation platforms. Since each
controller would have to generate its own variant implementation - should
a pci based solution be required in the future, it could be reimplemented
based on the new paradigm.

Please let us know whether you agree with this approach.


QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

