From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 20:22:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015002252.GE1274@redhat.com>
References: <200210142107.g9EL7IX04354@localhost.localdomain> <200210150019.53689.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210150019.53689.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: James Bottomley <James.Bottomley@steeleye.com>, andersen@codepoet.org, linux-scsi@vger.kernel.org

On Tue, Oct 15, 2002 at 12:19:53AM +0200, Oliver Neukum wrote:
> Am Montag, 14. Oktober 2002 23:07 schrieb James Bottomley:
> > andersen@codepoet.org said:
> > > If the user space interface were perfectly adequate, I would not have
> > > written this patch.  User space does not have sufficient information
> > > to know _which_ devices must to be added or removed. The best we can
> > > do from user space is a full rescan of _all_ scsi host adaptors (http:/
> > > /www.garloff.de/kurt/linux/rescan-scsi-bus.sh)  using something like
> >
> > The API you expose has identical inputs to the user space one.
> >
> > Therefore it seems to me that your spb2 driver must already know the values
> > to fill in to use the API.  So what's wrong with triggering a hotplug event
> > from this driver that causes the add/remove single device to be done from
> > user level?
> 
> It's harder than doing it the simple way. User space really can do nothing but
> do the call.

Not true, see my last email.  User space can do a *lot* more than just 
make the call to add the device, and as a matter of fact it already does.

> Plus, you can use such a kernel API to really free the device's
> memory, because you cannot know when user space, or indeed if, has
> freed the device.

Not true at all.  Define a revoke/slave_detach entry point to your driver 
and you get called when the device is removed so that you can free up any 
of your resources.

> Doing it in kernel is the only sane thing.

Read source first, post sanity comments later.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
