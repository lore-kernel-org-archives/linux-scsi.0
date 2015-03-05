From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [libsas] Kernel Crash in smp_execute_task
Date: Wed, 04 Mar 2015 17:04:52 -0800
Message-ID: <1425517492.7581.55.camel@HansenPartnership.com>
References: <154a8ccd0622409b84859abb1c3259f3@EX01.lg.local>
	 <68a5e8f0ce4f4630bafe5f3505334f3e@EX01.lg.local>
	,<1425514713.7581.46.camel@HansenPartnership.com>
	 <6e045e99401a48139dea1d4f4c745e2b@EX01.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58567 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258AbbCEBEy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 20:04:54 -0500
In-Reply-To: <6e045e99401a48139dea1d4f4c745e2b@EX01.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Praveen Murali <pmurali@logicube.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>

On Thu, 2015-03-05 at 00:44 +0000, Praveen Murali wrote:
> ________________________________________
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Sent: Wednesday, March 4, 2015 4:18 PM
> To: Praveen Murali
> Cc: linux-scsi@vger.kernel.org; dan.j.williams@intel.com
> Subject: Re: [libsas] Kernel Crash in smp_execute_task
> 
> On Wed, 2015-03-04 at 23:29 +0000, Praveen Murali wrote:
> >> On second thoughts, should we even let smp commands/requests thru for
> >> sas end devices (dev->dev_type == SAS_END_DEV) ? if so, wont the
> >> following patch more sense? (also, in my last mail the kernel logs
> >> were all messed up; sorry dint realize that when I sent the mail.
> >> Trying to fix it here)
> 
> >I think the bug is deeper than this: we shouldn't be trying expander
> >revalidation on non-expander devices.  If the device changes from end to
> >expander via hotplug, we'll see the remove and add (via the identify
> >frame) so the device type should be correct by the time we do the
> >revalidation.
> 
> >Does this fix the problem?
> 
> Yes, that fixes the issue. So if my understanding is correct, what you
> are saying is we need to do something like
[the patch]
> instead of putting the exclusion in smp_execute_task; is that right?

Right.  There's more than just the SMP problem that will happen if you
try to discover an end device as an expander.  The expander discovery
routines are going to try to cast to a non-existent expander device and
do all sorts of unfortunate things with what it thinks are a list of
expander phys.  Effectively revalidation only needs to probe expanders
because all the other devices were fully discovered via the IDENTIFY
frames they already sent.  The code is slighly obscure and it does look
like the intent was to call sas_ex_discover with any device type since
SMP to a device that doesn't have an SMP port will just fail.  However,
it's safer just not to do it because half the code assumes that any
device passed into the sas_ex_.. routines can be treated as an expander.

James


