From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Update WRITE_SAME timeout in sd_setup_discard_cmnd
Date: Thu, 11 Aug 2016 22:08:33 -0400
Message-ID: <yq1fuqapwm6.fsf@sermon.lab.mkp.net>
References: <1470946358-6744-1-git-send-email-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470946358-6744-1-git-send-email-shaun@tancheff.com> (Shaun
	Tancheff's message of "Thu, 11 Aug 2016 15:12:38 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Josh Bingaman <josh.bingaman@seagate.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Shaun" == Shaun Tancheff <shaun@tancheff.com> writes:

Shaun,

Shaun> In sd_setup_discard_cmnd() there are a some discard methods that
Shaun> fall back to using WRITE_SAME. It appears that those paths using
Shaun> WRITE_SAME should also use the SD_WRITE_SAME_TIMEOUT instead of
Shaun> the default SD_TIMEOUT.

The expectation is that the UNMAP variants update a translation table of
some sort in close to constant time. Potentially with some head and tail
zeroing on media. And should therefore easily fall within the 30s limit.

But you have a point wrt. SD_LBP_ZERO. It was used for one particular
type of array that did zero block detection (and thus didn't actually
write anything either). I don't think anybody is using this mode of
operation anymore since thin provisioning has been formalized in T10 for
quite a while. But I'd be OK with a patch that uses
SD_WRITE_SAME_TIMEOUT for that particular code path.

-- 
Martin K. Petersen	Oracle Linux Engineering
