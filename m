From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Sun, 21 Sep 2008 17:03:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809211658310.4210-100000@netrider.rowland.org>
References: <1222027177.3152.121.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1222027177.3152.121.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 21 Sep 2008, James Bottomley wrote:

> > For example, suppose a buggy device (without removable media) always
> > replies with UNIT ATTENTION without making any forward progress.  
> > We'll just call scsi_requeue_command each time and get stuck.
> 
> That's a separate bug from the current one ... fortunately one I don't
> think we've actually seen manifest.

> > But I'm still concerned about the possibility of getting stuck doing
> > the same command or request over and over.  Both structures have a
> > "retries" field, but I'm not clear on how/where they get used.
> 
> Block relies on the lower layers for retry ... it just transmits the
> status, so we get to fix it.

Okay -- I'll keep it in the back of my mind for later...

> > To be honest, I don't know what sort of requests get marked as
> > non-retryable in the block layer.  Maybe you're right and we don't need 
> > to worry about them.
> 
> They tend to be device mapper ones.  Anything that wants a fast failure
> to do path switch over for instance.

If all the retry paths in scsi_io_completion jump to a common location, 
it will be easy to add the test there.

> > I tested your simple fix, and it does indeed solve the problem of tasks
> > hanging because of an uncompleted request.  In view of Boaz's concerns,
> > should this change be postponed until 2.6.27.stable so that it can get
> > wider testing?
> 
> We can ... I think it's safe enough though given it only affects
> multiple transaction commands.

The decision's yours.  Let me know when and in which tree it is merged,
so I can start writing some patches for a more-complete fix.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
