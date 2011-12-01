From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: dm-mpath: Clear map_context pointer when requeuing
Date: Thu, 01 Dec 2011 09:12:42 +0900
Message-ID: <4ED6C67A.3060305@ce.jp.nec.com>
References: <1322663118-53387-1-git-send-email-hare@suse.de> <20111130144951.GA13775@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58293 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab1LAAOU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2011 19:14:20 -0500
In-Reply-To: <20111130144951.GA13775@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com

Hi Hannes,

On 11/30/11 23:49, Mike Snitzer wrote:
> On Wed, Nov 30 2011 at  9:25am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
> 
>> When requeing a request we should be clearing the map_context
>> pointer, otherwise we might access an invalid memory location.

Could you elaborate on the mechanism how the map_context->ptr
(= mpio) is accessed after freeing it?

mpio is known to be non-NULL where it is used. So clearing the pointer
should not make any difference in logic.

If this is a preventive change so that we can see NULL dereference
instead of random invalid access if anything happens, it should be
noted in the patch description and in the code.
Otherwise, somebody looking at the code/change in future might be
confused: "why we have to clear this pointer?"

And there are other places where mpio is freed.
(E.g. in dispatch_queued_ios() in dm-mpath.c)
Don't we need the same change there?

>> Cc: Mike Snitzer <snitzer@redhat.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> 
> Should Cc: stable too.
> 
> (I was thinking Alasdair would pick this up for 3.2 seeing as it is a
> change to dm-mpath.c.  Alasdair, James.. I'll let you guys decide)

-- 
Jun'ichi Nomura, NEC Corporation
