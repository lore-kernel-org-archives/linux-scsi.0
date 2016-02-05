From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block/sd: Return -EREMOTEIO when WRITE SAME and DISCARD are disabled
Date: Thu, 04 Feb 2016 22:13:53 -0500
Message-ID: <yq14mdnhmry.fsf@sermon.lab.mkp.net>
References: <20160204042528.GA15599@redhat.com>
	<1454568483-11298-1-git-send-email-martin.petersen@oracle.com>
	<56B316EA.9090803@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26872 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbcBEDOD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 22:14:03 -0500
In-Reply-To: <56B316EA.9090803@huawei.com> (jiangyiwen@huawei.com's message of
	"Thu, 4 Feb 2016 17:16:26 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jiangyiwen <jiangyiwen@huawei.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, snitzer@redhat.com

>>>>> "Yiwen" == jiangyiwen  <jiangyiwen@huawei.com> writes:

Yiwen,

Yiwen> First, I don't understand why blk_peek_request() return
Yiwen> EREMOTEIO, as I know, in this situation we only prepare scsi
Yiwen> command without sending to device, and I think EREMOTEIO should
Yiwen> be returned only when IO has already sent to device, maybe I
Yiwen> don't understand definition of EREMOTEIO.  So, Why don't return
Yiwen> the errno with EOPNOTSUPP?

DM currently has special handling for EREMOTEIO failures (because that's
what we'd return when a device responds with ILLEGAL REQUEST).

I am not opposed to returning EOPNOTSUPP but it would require more
changes and since this is a bugfix for stable I want to keep it as small
as possible.

Yiwen> In addition, I still worried with whether there has other
Yiwen> situations which will return EIO or other error. In this way,
Yiwen> MD/DM still can happen this type of problem, so I think may be in
Yiwen> multipath we still needs a protection to avoid it.

There are various error scenarios where we can end up bailing with a
BLKPREP_KILL. But the general rule of thumb is that these conditions all
demand a retry. The optional commands like WRITE SAME and UNMAP are
special in that they are irrecoverable.

Yiwen> At last, I have a additional problem, I remember that you
Yiwen> previously send a series of patches about XCOPY, why don't have
Yiwen> any news latter later? I very much expect that I can see these
Yiwen> patches which are merged into kernel.

I am working on a refresh of the series that includes token-based copy
offload support in addition to EXTENDED COPY. The patches depend on Mike
Christie's request flag patch series which has yet to be merged.

-- 
Martin K. Petersen	Oracle Linux Engineering
