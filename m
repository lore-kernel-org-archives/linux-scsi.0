From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 08 Aug 2005 14:24:04 -0400
Message-ID: <42F7A344.8070905@adaptec.com>
References: <Pine.LNX.4.44L0.0508071408370.32668-100000@netrider.rowland.org> <1123451837.5020.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:25570 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932175AbVHHSYH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 14:24:07 -0400
In-Reply-To: <1123451837.5020.22.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 08/07/05 17:57, James Bottomley wrote:
> Alan Stern wrote:
>>The only resource that matters for this discussion is associated with the
>>LLD itself, not with any of its hosts: the host template.  Once the SCSI
>>core has released all references to the template, it can't call the LLD
>>any more.  The problem is that the LLD has no way to know when all the
>>references have been dropped.  This suggests that the entire problem could
>>be solved by adding a kref to struct scsi_host_template.
>>
>>Would you agree to a patch adding such a kref?
> 
> 
> Well, not really.  The host template usually exists as a variable in the
> module, so its lifetime is tied to the lifetime of the module.  Adding a
> kref wouldn't help because it will still be freed when the module is
> removed.  If there's a case where the template is being freed
> prematurely because the module is being removed, then we have the module
> refcounting wrong somewhere.  Have you run across such a case?

Hmm, I think Alan has a point.

>From object point of view, who is the parent and who is the child
when talking about LLDD/module and the host template?

The reason is that the host template could be simulated on behalf
of the underlying transport (as is the case for USB).

So, it could be the case that the host template _should_ be
removed but the entity which removed it should stay, and that
entity wants to know when the host template is to be removed.

(Actually it doesn't, but setting the release method in the
kobj_ktype would do wonders. ;-) )

In which case, it does make sense to include a kset to the
host template (since it has many children), and anyone
using/manipulating it does kset_get().  When that entity
is done with the host template it does a kset_put().

Such entities could be the managing layer above, error
handling, etc.

Another solution, just as good, is to use the template
_only_ for the registration call, as a _template_, and
as soon as the registration call has returned, the
caller (LLDD/module) can free the template.  After all,
it is only a template.

Then the managing layer allocates the actual host struct
and "gives" it to the LLDD.  The LLDD goes a kset_get()
on it while it lives, and when it is to die, it does a
kset_put().  And if it gets a method call, it would
error it out, after the put...

Either way, event relationship must be very well defined.

	Luben





