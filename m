From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [scsi:fixes 16/18] warning: (SCSI_MPT2SAS) selects SCSI_MPT3SAS which has unmet direct dependencies (SCSI_LOWLEVEL && ..)
Date: Wed, 02 Dec 2015 16:56:46 -0500
Message-ID: <yq1lh9cbjkx.fsf@sermon.lab.mkp.net>
References: <201512030535.NePJi7kq%fengguang.wu@intel.com>
	<1449092218.2203.56.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26365 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbbLBV5W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2015 16:57:22 -0500
In-Reply-To: <1449092218.2203.56.camel@HansenPartnership.com> (James
	Bottomley's message of "Wed, 02 Dec 2015 13:36:58 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: kbuild test robot <fengguang.wu@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, kbuild-all@01.org, linux-scsi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

>> warning: (SCSI_MPT2SAS) selects SCSI_MPT3SAS which has unmet direct
>> dependencies (SCSI_LOWLEVEL && PCI && SCSI)

James> That's unfortunate.  The problem is that select and depend don't
James> interact because Kconfig doesn't have a SAT solver, so depend
James> picks up dependencies and select does onward selects, but select
James> doesn't pick up dependencies.  To fix this, we need to add the
James> correct dependencies to the MPT2SAS option like this.

Yeah, I was wondering about whether it would make sense to add the
dependency when I did the patch. I did test after unselecting SCSI but
didn't get any warnings. In retrospect I probably had something else
configured that pulled it back in.

In any case: Patch looks good to me.

I also asked Fengguang to add scsi.git to the kbuild test robot. It
looks like it's only been testing the SCSI branches I kept in my regular
git tree and they were a bit behind scsi.git.

-- 
Martin K. Petersen	Oracle Linux Engineering
