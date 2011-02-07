From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Why using configfs as the only interface is wrong for a storage target
Date: Mon, 7 Feb 2011 13:08:16 +0100
Message-ID: <AANLkTi=3dgDJmGKHZCJFBYUw=GLqbmNgt8WDAFQCTFaS@mail.gmail.com>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com> <20110207115347.GA7503@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42215 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1BGMIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 07:08:37 -0500
Received: by iwn9 with SMTP id 9so4497495iwn.19
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2011 04:08:37 -0800 (PST)
In-Reply-To: <20110207115347.GA7503@noexit>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Boaz

On Mon, Feb 7, 2011 at 12:53 PM, Joel Becker <jlbec@evilplan.org> wrote=
:
>
> On Mon, Feb 07, 2011 at 12:41:18PM +0100, Bart Van Assche wrote:
> > On Fri, Feb 4, 2011 at 7:45 AM, Nicholas A. Bellinger
> > <nab@linux-iscsi.org> wrote:
> > > Please consider the following patch series for mainline target co=
de.
> > > It consists of predominately configfs bugfixes uncovered with rec=
ent SLUB
> > > poison testing, and proper removal of legacy procfs target_core_m=
ib.c code.
> > > Note that the complete set of fabric independent statistics (SCSI=
 MIBs) and
> > > fabric dependent statistics will be included as native configfs g=
roup context
> > > 'per value' attribute series during the .39 time frame.
> >
> > I'm still not convinced that using configfs in a storage target as =
the
> > only interface between kernel space and user space is a good idea.
> > While configfs may satisfy all the needs of an iSCSI target, the us=
e
> > of configfs in combination with hot-pluggable HCAs is really awkwar=
d.
> > Whenever a HCA is plugged in, the user has to issue mkdir commands =
to
> > make these interfaces appear in configfs. And whenever a HCA is
> > removed, stale information will remain present in configfs until th=
e
> > user issues an rmdir command. As we all know, it is not possible fo=
r a
> > storage target to make these directories appear / disappear
> > automatically in configfs because of basic configfs design choices.
>
> =A0 =A0 =A0 =A0Any configuration would have to be handled. =A0We have=
 plenty of
> stuff that is handled by userspace hooks out of udev, etc. =A0That's =
a
> normal hotplug process.
> =A0 =A0 =A0 =A0Essentially, you're not challenging Nick's use of conf=
igfs here,
> you're challenging his environment of setting up the target stack fro=
m
> userspace.

Hello Joel,

While I'm fine with using configfs where appropriate, I do not agree
with the choice of configfs as the only interface between user space
and kernel for a storage target. It seems overkill to me to depend on
user space software to make sure that the user space visible
information about HCAs is up to date while the target core could
easily ensure itself that such information would be up to date if it
would be using sysfs instead of configfs.

=46urthermore, there is currently no mechanism present in the target
code to inform user space about HCA list updates. Even more: no
mechanism has been implemented yet to allow user space to find out
which HCAs are controlled by a target driver nor which names have been
assigned by a target driver to the HCAs it controls. This seems like
an oversight to me.

Regarding udev: no udev events are generated for HCAs controlled by
target drivers since the objects created by target drivers are not
regular devices.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
