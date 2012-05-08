From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v2 PATCH 3/4] bnx2fc: cleanup task management IO when it times
 out.
Date: Mon, 07 May 2012 19:27:50 -0500
Message-ID: <4FA86886.2060301@cs.wisc.edu>
References: <4FA85912.2030800@broadcom.com> <4FA85B43.2000909@broadcom.com> <4FA86579.5080603@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45124 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758002Ab2EHA14 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 May 2012 20:27:56 -0400
In-Reply-To: <4FA86579.5080603@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/07/2012 07:14 PM, Mike Christie wrote:
> On 05/07/2012 06:31 PM, Bhanu Prakash Gollapudi wrote:
>> On  05/04/2012 08:49 AM, Mike Christie wrote:
>>> On 04/24/2012 05:26 PM, Bhanu Prakash Gollapudi wrote:
>>>  > diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
>>> b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
>>>  > index d3ee231..082a25c 100644
>>>  > --- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
>>>  > +++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
>>>  > @@ -185,6 +185,16 @@ void bnx2fc_flush_active_ios(struct bnx2fc_rport
>>> *tgt)
>>>  > BUG_ON(rc);
>>>  > }
>>>  >
>>>  > + list_for_each_safe(list, tmp, &tgt->active_tm_queue) {
>>>  > + i++;
>>>  > + io_req = (struct bnx2fc_cmd *)list;
>>>
>>> Why didn't you use list_for_each_entry_safe()? Or, when using
>>> list_for_each_safe, instead of the cast are we supposed to be using
>>> list_entry()?
>>
>> Mike, the list is the first field in the structure, so the cast here is
>> right.
>>
> 
> I am saying that normally if there is a function that does the same
> thing we are supposed to use that instead.

I think though since it works and it used throughout the driver already
it is ok to do. But I think in a patch later it should be changed.
