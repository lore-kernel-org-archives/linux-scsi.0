From: christophe.varoqui@free.fr
Subject: Re: [dm-devel] scsi_id output & multipath
Date: Tue, 20 Jul 2004 19:42:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090345335.40fd5977b7dd2@imp6-q.free.fr>
References: <1090327690.40fd148a36b98@imp6-q.free.fr> <20040720145423.GA16591@beaverton.ibm.com> <1090341511.40fd4a879bc60@imp6-q.free.fr> <20040720165519.GA17811@beaverton.ibm.com> <20040720165701.GA17883@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-1.free.fr ([213.228.0.62]:33928 "EHLO
	postfix4-1.free.fr") by vger.kernel.org with ESMTP id S266038AbUGTRmR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2004 13:42:17 -0400
In-Reply-To: <20040720165701.GA17883@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

diff -urN scsi_id-0.5/ChangeLog scsi_id-0.5-dense_id/ChangeLog
--- scsi_id-0.5/ChangeLog       2004-06-23 20:58:56.000000000 +0200
+++ scsi_id-0.5-dense_id/ChangeLog      2004-07-20 19:05:12.000000000 +0200
@@ -1,3 +1,7 @@
+2004-jul-20:
+       * scsi_id.c: add a -u flag to reformat serial output in order
+         to let others use that as a device name
+
 2004-jun-23:
        * scsi_id.h: increase MAX_SERIAL_LEN from 128 to 256, as some
          devices (maybe broken ones) are giving really long id's.
diff -urN scsi_id-0.5/scsi_id.8 scsi_id-0.5-dense_id/scsi_id.8
--- scsi_id-0.5/scsi_id.8       2004-03-03 01:32:42.000000000 +0100
+++ scsi_id-0.5-dense_id/scsi_id.8      2004-07-20 19:39:27.000000000 +0200
@@ -95,6 +95,9 @@
 The sysfs mount point must not be included. For example, use /block/sd,
 not /sys/block/sd.
 .TP
+.BI \-u
+Reformat the output : replace all whitespaces by underscores
+.TP
 .BI \-v
 Generate verbose debugging output.
 .TP
diff -urN scsi_id-0.5/scsi_id.c scsi_id-0.5-dense_id/scsi_id.c
--- scsi_id-0.5/scsi_id.c       2004-05-25 00:14:32.000000000 +0200
+++ scsi_id-0.5-dense_id/scsi_id.c      2004-07-20 19:37:01.000000000 +0200
@@ -52,7 +52,7 @@
  * options are not supported, but other code is still left in place for
  * now.
  */
-static const char short_options[] = "bd:f:gip:s:vV";
+static const char short_options[] = "bd:f:gip:s:vVu";
 /*
  * Just duplicate per dev options.
  */
@@ -70,6 +70,7 @@
 static int use_stderr;
 static int debug;
 static int hotplug_mode;
+static int reformat_serial;

 void log_message (int level, const char *format, ...)
 {
@@ -469,6 +470,10 @@
                        strncat(target, optarg, MAX_NAME_LEN);
                        break;

+               case 'u':
+                       reformat_serial = 1;
+                       break;
+
                case 'v':
                        debug++;
                        break;
@@ -573,6 +578,23 @@
 }

 /*
+ * format_serial: replace to whitespaces by underscores for calling
+ * programs that use the serial for device naming (multipath, Suse
+ * naming, etc...)
+ */
+static void format_serial(char *serial)
+{
+       char *p = serial;
+
+       while (*p != '\0') {
+               if (isspace(*p))
+                       *p = '_';
+               p++;
+       }
+       return;
+}
+
+/*
  * scsi_id: try to get an id, if one is found, printf it to stdout.
  * returns a value passed to exit() - 0 if printed an id, else 1. This
  * could be expanded, for example, if we want to report a failure like no
@@ -703,6 +725,8 @@
                retval = 0;
        }
        if (!retval) {
+               if (reformat_serial)
+                       format_serial(serial);
                if (display_bus_id)
                        printf("%s: ", scsi_dev->name);
                printf("%s", serial);
diff -urN scsi_id-0.5/TODO scsi_id-0.5-dense_id/TODO
--- scsi_id-0.5/TODO    2004-05-24 23:55:39.000000000 +0200
+++ scsi_id-0.5-dense_id/TODO   2004-07-20 19:05:37.000000000 +0200
@@ -1,6 +1,3 @@
-- Add an option to replace blanks with spaces, so the generated id can be
-  more easily used as a /dev name.
-
 - Add a bus white/black list option. So for example, all scsi devices
   under USB could easily be blacklisted. This should allow multiple busses
   to be listed.


Selon Patrick Mansfield <patmans@us.ibm.com>:

> On Tue, Jul 20, 2004 at 09:55:19AM -0700, Patrick Mansfield wrote:
> > [adding linux-scsi to cc]
>
> Augh, with the correct linux-scsi address.
>
> > On Tue, Jul 20, 2004 at 06:38:31PM +0200, christophe.varoqui@free.fr wrote:
> > > Selon Patrick Mansfield <patmans@us.ibm.com>:
> > >
> > > > Christophe -
> > > >
> > > > On Tue, Jul 20, 2004 at 02:48:10PM +0200, christophe.varoqui@free.fr
> wrote:
> > > > > Hello,
> > > > >
> > > > > the multipath config tool names the devmaps after the uid fetch by
> scsi_id.
> > > > > When such uid is a wwid, everything is well. But when this uid is a
> > > > composite
> > > > > aggregate of diverse info, like with JBODs or direct attached SCSI
> disks,
> > > > the
> > > > > spaces between uid components are problematic.
> > > > >
> > > > > devmap creation should be ok with these spaces, but common usage will
> be
> > > > > compromised (ie mount "/dev/SSEAGATE ST336607LC
> 3JA7LHRB00007441H8FQ"
> > > > /mnt)
> > > > >
> > > > > do you consider packing scsi_id output, or should I do this myself ?
> > > >
> > > > Don't pack it, as that could cause problems (unlikely but possible name
> > > > collisions), just substitute underlines for spaces, either in your
> > > > multipath program, or better send a patch for scsi_id.
> > > >
> > >
> > > is this ok with you ?
> >
> > Yes, but add a new option, -u. Defaulting to the current behaviour (no
> > underline), so we can get both and are backwards compatible.
> >
> > > diff -urN scsi_id-0.5/scsi_id.c scsi_id-0.5-dense_id/scsi_id.c
> > > --- scsi_id-0.5/scsi_id.c       2004-05-25 00:14:32.000000000 +0200
> > > +++ scsi_id-0.5-dense_id/scsi_id.c      2004-07-20 18:35:49.000000000
> +0200
> > > @@ -573,6 +573,23 @@
> > >  }
> > >
> > >  /*
> > > + * format_serial: replace to whitespaces by underscores for calling
> > > + * programs that use the serial for device naming (multipath, Suse
> > > + * naming, etc...)
> > > + */
> > > +static void format_serial(char *serial)
> > > +{
> > > +       char *p = serial;
> > > +
> > > +       while (*p != '\0') {
> > > +               if (isspace(*p))
> > > +                       *p = '_';
> > > +               p++;
> > > +       }
> > > +       return;
> > > +}
> > > +
> > > +/*
> > >   * scsi_id: try to get an id, if one is found, printf it to stdout.
> > >   * returns a value passed to exit() - 0 if printed an id, else 1. This
> > >   * could be expanded, for example, if we want to report a failure like
> no
> > > @@ -703,6 +720,7 @@
> > >                 retval = 0;
> > >         }
> > >         if (!retval) {
> > > +               format_serial(serial);
> > >                 if (display_bus_id)
> > >                         printf("%s: ", scsi_dev->name);
> > >                 printf("%s", serial);
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>


--
