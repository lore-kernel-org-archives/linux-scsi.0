From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 17/20] [SCSI] mpt3sas: Use alloc_ordered_workqueue() API
 instead of create_singlethread_workqueue() API
Date: Mon, 15 Jun 2015 14:05:00 -0700
Message-ID: <1434402300.2170.84.camel@HansenPartnership.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	 <1434102153-38581-18-git-send-email-Sreekanth.Reddy@avagotech.com>
	 <557B4923.1020608@stratus.com>
	 <CAK=zhgrUh-Xcz2kqJRsdxmTKXE-hdLE52ya+5PDTTuNqN_Pwjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40804 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbbFOVFC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2015 17:05:02 -0400
In-Reply-To: <CAK=zhgrUh-Xcz2kqJRsdxmTKXE-hdLE52ya+5PDTTuNqN_Pwjw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, 2015-06-15 at 16:26 +0530, Sreekanth Reddy wrote:
> On Sat, Jun 13, 2015 at 2:33 AM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> > On 06/12/2015 05:42 AM, Sreekanth Reddy wrote:
> > ...
> >> +#if defined(alloc_ordered_workqueue)
> >> +     ioc->firmware_event_thread = alloc_ordered_workqueue(
> >> +             ioc->firmware_event_name, WQ_MEM_RECLAIM);
> >> +#else
> >> +             ioc->firmware_event_thread = create_singlethread_workqueue(
> >>           ioc->firmware_event_name);
> >> +#endif
> >
> > Hi Sreekanth,
> >
> > I think the upstream version of this code can safely assume
> > alloc_ordered_workqueue is defined, no?
> 
> yes, upstream version of this code can safely assume that
> alloc_ordered_workqueue is defined.
> 
> While working in-house, I observed that some of the older kernels
> doesn't defined this macro, so I have added this else section.

The driver has to be defined for the current kernel.  If you maintain a
backport, that's fine, but not in the upstream driver.  The reasons are
fairly pragmatic: this code in the #else clause can't be compiled so
it's just junk to the upstream driver and the static checkers will find
it and you'll attract a flock of patches removing dead code.

James


