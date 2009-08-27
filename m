From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: DIF/DIX updates for 2.6.32
Date: Thu, 27 Aug 2009 12:49:42 +0300
Message-ID: <4A9656B6.5060100@panasas.com>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>	<4A95226E.8030504@panasas.com> <yq1my5l934u.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-67.z220-152-67.customer.algx.net ([67.152.220.67]:4373
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752002AbZH0Jtl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 05:49:41 -0400
In-Reply-To: <yq1my5l934u.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org

On 08/27/2009 09:34 AM, Martin K. Petersen wrote:
>>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> 
> Boaz> I know that we also have the above problem with iscsi and
> Boaz> data-digest such that when we come to sign the data it might
> Boaz> change on us before the target receives it.
> 
> Yep, I have the same problem.  I talked to Andrew Morton a couple of
> months ago and he said that modifying pages in flight is "a feature" as
> far as ext[234] is concerned.
> 

As you might know, I have a filesystem copied from the ext2 code base.
I'm experimenting with altering the behavior so that pages written to
while been IOed will page fault, then sleep, until IO is done.
Clearly this is a good "feature" until such systems like mirror or signed-
data that are forced to reallocate-copy all IO do to the 2% optimization
that thing gives you.

At the final outcome I hope for a VFS support on a flip of a flag or
something. So under laying device can turn that "feature" off when it
means grate performance gains in it's operations.

If any one has thought about that problem, and as some preliminary strategies,
please I'm all hears. I've just started on this subject and currently I do not
have a clue.

Thanks
Boaz
