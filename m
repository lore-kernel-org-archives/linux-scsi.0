From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Tue, 14 Feb 2017 14:39:14 +1100
Message-ID: <1487043554.23576.17.camel@kernel.crashing.org>
References: <20170212214920.28866-1-anton@ozlabs.org>
         <1486941294.3401.67.camel@kernel.crashing.org>
         <20170213104723.7741de0a@kryten> <87efz3hre6.fsf@xmission.com>
         <1486947669.3401.69.camel@kernel.crashing.org>
         <2fa7fc70-44d4-f536-befb-8a7849741fb7@linux.vnet.ibm.com>
         <874lzx32yd.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:40832 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750831AbdBNDjn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 22:39:43 -0500
In-Reply-To: <874lzx32yd.fsf@xmission.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: Anton Blanchard <anton@samba.org>, james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

On Tue, 2017-02-14 at 15:45 +1300, Eric W. Biederman wrote:
> The only difference ever that should exist between shutdown and remove
> is do you clean up kernel data structures.  The shutdown method is
> allowed to skip the cleanup up kernel data structures that the remove
> method needs to make.
> 
> Assuming the kernel does not have corrupted data structures I don't see
> any practical reason for distinguishing between the two.  There may be
> some real world gotchas we have to deal with but semantically I don't
> see any concerns.

We had historical additions to shutdown actually shutting things down,
like spinning platters down to park disk heads, switching devices
into D3 on some systems, etc... that remove never had (and we don't
want for kexec).

Cheers,
Ben.
