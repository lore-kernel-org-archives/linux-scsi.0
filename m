From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Mon, 04 Feb 2008 18:41:05 -0600
Message-ID: <1202172065.3096.154.camel@localhost.localdomain>
References: <50030.21278.qm@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <50030.21278.qm@web31808.mail.mud.yahoo.com>
Sender: linux-ide-owner@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-02-04 at 16:32 -0800, Luben Tuikov wrote:
> --- On Sun, 2/3/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > The enclosure misc device is really just a library providing
> > sysfs
> > support for physical enclosure devices and their
> > components.
> 
> Who is the target audience/user of those facilities?
> a) The kernel itself needing to read/write SES pages?

That depends on the enclosure integration, but right at the moment, it
doesn't

> b) A user space application using sysfs to read/write
>    SES pages?

Not an application so much as a user.  The idea of sysfs is to allow
users to get and set the information in addition to applications.

> At the moment SES device management is done via
> an application (user-space) and a user-space library
> used by the application and /dev/sgX to send SCSI
> commands to the SES device.

I must have missed that when I was looking for implementations; what's
the URL?

But, if we have non-scsi enclosures to integrate, that makes it harder
for a user application because it has to know all the implementations.
A sysfs framework on the other hand is a universal known thing for the
user applications.

> One could have a very good argument to not bloat
> the kernel with this but leave it to a user-space
> application and a library to do all this and
> communicate with the SES device via the kernel's /dev/sgX.

The same thing goes for other esoteric SCSI infrastructure pieces like
cd changers.  On the whole, given that ATA is asking for enclosure
management in kernel, it makes sense to consolidate the infrastructure
and a ses ULD is a very good test bed.

James


