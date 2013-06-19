From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v3 2/6] [SCSI] Rename scsi_evt_xxx to sdev_evt_xxx and
 scsi_event to sdev_event
Date: Wed, 19 Jun 2013 18:36:11 +0000
Message-ID: <1371666971.2409.74.camel@dabdike>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com>
	 <1371663761-22481-3-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:54756 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab3FSSgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jun 2013 14:36:13 -0400
In-Reply-To: <1371663761-22481-3-git-send-email-emilne@redhat.com>
Content-Language: en-US
Content-ID: <FFC7BFE07DF8E04E90BB323B6E1FF18A@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Wed, 2013-06-19 at 13:42 -0400, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> The names of the struct and some of the functions for scsi_device
> events are too generic and do not match the comments in the source.
> Changed all of the names to begin with sdev_ in order to avoid
> naming issues and confusion with scsi_target events to be added.
> Also changed name of sdev_evt_thread() to sdev_evt_work().

I don't really understand the rationale here.  Our usual namespace
prefix is scsi_ although we don't obey it universally, of course.  sdev_
isn't one of our namespace prefixes.  we might use scsi_device_ instead,
but I really don't see the need.  Plus all the name changes makes code
really difficult to review.

The two different event structures you introduce are actually identical
except for the values of the enums, so I don't see a need to have them
as separate.  Since the event hangs off a list in the scsi_device, it
can do the same for a scsi_target.  Events actually fire on generic
devices, so that's probably where we should start: change scsi_evt_emit
to take a generic device.  Then you can actually do a static translation
array between the enumerated event and the environment string.  I think
this unification will drastically reduce the number of lines in this
patch, since most of the infrastructure is now reused instead of being
duplicated.

The only other design point I'd add is that we probably need an internal
way to listen for events (I can see dm wanting this), so probably the
scsi_evt_emit should also send the event down a notifier chain, since
kernel internal stuff can't listen for a kobject uevent.  I cc'd the
dm-devel list to see what their opinion is of this.

For them, you should probably also summarise what events we're actually
proposing to send

scsi_target: 

REPORTED LUNS DATA HAS CHANGED

scsi_device:

MODE PARAMETERS CHANGED
CAPACITY DATA HAS CHANGED
THIN PROVISIONING SOFT THRESHOLD REACHED

James

