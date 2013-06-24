From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH v3 2/6] [SCSI] Rename scsi_evt_xxx to
 sdev_evt_xxx and scsi_event to sdev_event
Date: Mon, 24 Jun 2013 09:49:14 -0400
Message-ID: <1372081754.3871.9.camel@localhost.localdomain>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com>
	<1371663761-22481-3-git-send-email-emilne@redhat.com>
	<1371666971.2409.74.camel@dabdike>
Reply-To: emilne@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1371666971.2409.74.camel@dabdike>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <jbottomley@parallels.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "rwheeler@redhat.com" <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-06-19 at 18:36 +0000, James Bottomley wrote:
> On Wed, 2013-06-19 at 13:42 -0400, Ewan D. Milne wrote:
> > From: "Ewan D. Milne" <emilne@redhat.com>
> > 
> > The names of the struct and some of the functions for scsi_device
> > events are too generic and do not match the comments in the source.
> > Changed all of the names to begin with sdev_ in order to avoid
> > naming issues and confusion with scsi_target events to be added.
> > Also changed name of sdev_evt_thread() to sdev_evt_work().
> 
> I don't really understand the rationale here.  Our usual namespace
> prefix is scsi_ although we don't obey it universally, of course.  sdev_
> isn't one of our namespace prefixes.  we might use scsi_device_ instead,
> but I really don't see the need.  Plus all the name changes makes code
> really difficult to review.
> 
> The two different event structures you introduce are actually identical
> except for the values of the enums, so I don't see a need to have them
> as separate.  Since the event hangs off a list in the scsi_device, it
> can do the same for a scsi_target.  Events actually fire on generic
> devices, so that's probably where we should start: change scsi_evt_emit
> to take a generic device.  Then you can actually do a static translation
> array between the enumerated event and the environment string.  I think
> this unification will drastically reduce the number of lines in this
> patch, since most of the infrastructure is now reused instead of being
> duplicated.

OK.

> 
> The only other design point I'd add is that we probably need an internal
> way to listen for events (I can see dm wanting this), so probably the
> scsi_evt_emit should also send the event down a notifier chain, since
> kernel internal stuff can't listen for a kobject uevent.  I cc'd the
> dm-devel list to see what their opinion is of this.

Sure.  I thought of doing this, but didn't because I wasn't planning
to change anything else to listen for it.  The other thing is that the
UA typically indicates that something has changed, but another command
is needed to find out exactly *what*, e.g. with the WCE bit that is used
to control flush behavior, a MODE SENSE command is needed.  A rescan of
the device in response to the UA would do that.

> 
> For them, you should probably also summarise what events we're actually
> proposing to send
> 
> scsi_target: 
> 
> REPORTED LUNS DATA HAS CHANGED
> 
> scsi_device:
> 
> MODE PARAMETERS CHANGED
> CAPACITY DATA HAS CHANGED
> THIN PROVISIONING SOFT THRESHOLD REACHED
> 
> James
> 
