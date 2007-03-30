From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 14:18:30 -0400
Message-ID: <d120d5000703301118j7db6813dt441ffd2ec36fb6cc@mail.gmail.com>
References: <460CDBA6.5030608@gmail.com>
	 <1175257751.3760.19.camel@mulgrave.il.steeleye.com>
	 <d120d5000703300615y7b367d82hb42f1c58ca8a6328@mail.gmail.com>
	 <1175277501.3760.32.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1175277501.3760.32.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Tejun Heo <htejun@gmail.com>, gregkh@suse.de, hugh@veritas.com, cornelia.huck@de.ibm.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 3/30/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Fri, 2007-03-30 at 09:15 -0400, Dmitry Torokhov wrote:
> > If you want to manage lifetime rules independently you might want to
> > not embed struct device into you subsystems objects but attach them
> > via pointers and use device_create(). Now that we orphan sysfs access
> > upon unregistering device this will severe all ties from driver core
> > to your system once you start teardown of a device and you should be
> > in clear.
>
> But that wouldn't really help ... all objects have lifetimes.  What
> Tejun is pointing out is that we have two different lifetime
> requirements:  driver internal (and subsystem) objects and sysfs
> objects ...

Exactly. If driver-private data structures have different lifetime
than device abstractions (like they seem to have with scsi and ide)
then you split them and refcount separately. We are just arguing where
to put the line. You want to split devices and kobjects and rework
infrastructure and I am saying that we already have infrastructure we
need and that split shoud be between generic device structure and
driver-managed device structure.

-- 
Dmitry
