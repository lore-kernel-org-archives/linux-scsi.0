From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [dm-devel] scsi_id output & multipath
Date: Tue, 20 Jul 2004 09:57:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040720165701.GA17883@beaverton.ibm.com>
References: <1090327690.40fd148a36b98@imp6-q.free.fr> <20040720145423.GA16591@beaverton.ibm.com> <1090341511.40fd4a879bc60@imp6-q.free.fr> <20040720165519.GA17811@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:43997 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266013AbUGTQ5g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2004 12:57:36 -0400
Content-Disposition: inline
In-Reply-To: <20040720165519.GA17811@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On Tue, Jul 20, 2004 at 09:55:19AM -0700, Patrick Mansfield wrote:
> [adding linux-scsi to cc]

Augh, with the correct linux-scsi address.

> On Tue, Jul 20, 2004 at 06:38:31PM +0200, christophe.varoqui@free.fr wrote:
> > Selon Patrick Mansfield <patmans@us.ibm.com>:
> > 
> > > Christophe -
> > >
> > > On Tue, Jul 20, 2004 at 02:48:10PM +0200, christophe.varoqui@free.fr wrote:
> > > > Hello,
> > > >
> > > > the multipath config tool names the devmaps after the uid fetch by scsi_id.
> > > > When such uid is a wwid, everything is well. But when this uid is a
> > > composite
> > > > aggregate of diverse info, like with JBODs or direct attached SCSI disks,
> > > the
> > > > spaces between uid components are problematic.
> > > >
> > > > devmap creation should be ok with these spaces, but common usage will be
> > > > compromised (ie mount "/dev/SSEAGATE ST336607LC     3JA7LHRB00007441H8FQ"
> > > /mnt)
> > > >
> > > > do you consider packing scsi_id output, or should I do this myself ?
> > >
> > > Don't pack it, as that could cause problems (unlikely but possible name
> > > collisions), just substitute underlines for spaces, either in your
> > > multipath program, or better send a patch for scsi_id.
> > >
> > 
> > is this ok with you ?
> 
> Yes, but add a new option, -u. Defaulting to the current behaviour (no
> underline), so we can get both and are backwards compatible.
> 
> > diff -urN scsi_id-0.5/scsi_id.c scsi_id-0.5-dense_id/scsi_id.c
> > --- scsi_id-0.5/scsi_id.c       2004-05-25 00:14:32.000000000 +0200
> > +++ scsi_id-0.5-dense_id/scsi_id.c      2004-07-20 18:35:49.000000000 +0200
> > @@ -573,6 +573,23 @@
> >  }
> > 
> >  /*
> > + * format_serial: replace to whitespaces by underscores for calling
> > + * programs that use the serial for device naming (multipath, Suse
> > + * naming, etc...)
> > + */
> > +static void format_serial(char *serial)
> > +{
> > +       char *p = serial;
> > +
> > +       while (*p != '\0') {
> > +               if (isspace(*p))
> > +                       *p = '_';
> > +               p++;
> > +       }
> > +       return;
> > +}
> > +
> > +/*
> >   * scsi_id: try to get an id, if one is found, printf it to stdout.
> >   * returns a value passed to exit() - 0 if printed an id, else 1. This
> >   * could be expanded, for example, if we want to report a failure like no
> > @@ -703,6 +720,7 @@
> >                 retval = 0;
> >         }
> >         if (!retval) {
> > +               format_serial(serial);
> >                 if (display_bus_id)
> >                         printf("%s: ", scsi_dev->name);
> >                 printf("%s", serial);
