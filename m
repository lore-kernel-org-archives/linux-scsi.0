From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Why using configfs as the only interface is wrong for a
	storage target
Date: Mon, 07 Feb 2011 11:57:38 -0800
Message-ID: <1297108658.13752.236.camel@haakon2.linux-iscsi.org>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
	 <20110207115347.GA7503@noexit>
	 <AANLkTi=3dgDJmGKHZCJFBYUw=GLqbmNgt8WDAFQCTFaS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35350 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1BGT5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 14:57:45 -0500
In-Reply-To: <AANLkTi=3dgDJmGKHZCJFBYUw=GLqbmNgt8WDAFQCTFaS@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, 2011-02-07 at 13:08 +0100, Bart Van Assche wrote:
> On Mon, Feb 7, 2011 at 12:53 PM, Joel Becker <jlbec@evilplan.org> wrote:
> >
> > On Mon, Feb 07, 2011 at 12:41:18PM +0100, Bart Van Assche wrote:
> > > On Fri, Feb 4, 2011 at 7:45 AM, Nicholas A. Bellinger
> > > <nab@linux-iscsi.org> wrote:
> > > > Please consider the following patch series for mainline target code.
> > > > It consists of predominately configfs bugfixes uncovered with recent SLUB
> > > > poison testing, and proper removal of legacy procfs target_core_mib.c code.
> > > > Note that the complete set of fabric independent statistics (SCSI MIBs) and
> > > > fabric dependent statistics will be included as native configfs group context
> > > > 'per value' attribute series during the .39 time frame.
> > >
> > > I'm still not convinced that using configfs in a storage target as the
> > > only interface between kernel space and user space is a good idea.
> > > While configfs may satisfy all the needs of an iSCSI target, the use
> > > of configfs in combination with hot-pluggable HCAs is really awkward.
> > > Whenever a HCA is plugged in, the user has to issue mkdir commands to
> > > make these interfaces appear in configfs. And whenever a HCA is
> > > removed, stale information will remain present in configfs until the
> > > user issues an rmdir command. As we all know, it is not possible for a
> > > storage target to make these directories appear / disappear
> > > automatically in configfs because of basic configfs design choices.
> >
> >        Any configuration would have to be handled.  We have plenty of
> > stuff that is handled by userspace hooks out of udev, etc.  That's a
> > normal hotplug process.
> >        Essentially, you're not challenging Nick's use of configfs here,
> > you're challenging his environment of setting up the target stack from
> > userspace.
> 
> Hello Joel,
> 
> While I'm fine with using configfs where appropriate, I do not agree
> with the choice of configfs as the only interface between user space
> and kernel for a storage target. It seems overkill to me to depend on
> user space software to make sure that the user space visible
> information about HCAs is up to date while the target core could
> easily ensure itself that such information would be up to date if it
> would be using sysfs instead of configfs.
> 

I am not sure why you think someone absoulutely has to do a struct
configfs_group_operations->make_group() just to see if HW exists that is
target mode operation..  What about providing
a /sys/kernel/config/target/$FABRIC_MODE/available_targets attribute
with a list of which HW is accessable by userspace code driving creation
of struct config_group..?  What able reading existing sysfs
supported_modes information from /sys/class/scsi_host/ and determine HW
target mode specific port WWN information and using python code to drive
creation of /sys/kernel/config/target/$FABRIC_MOD/$FABRIC_WWPN..?

> Furthermore, there is currently no mechanism present in the target
> code to inform user space about HCA list updates. Even more: no
> mechanism has been implemented yet to allow user space to find out
> which HCAs are controlled by a target driver nor which names have been
> assigned by a target driver to the HCAs it controls. This seems like
> an oversight to me.
> 

Again, we use userspace code to *drive* the configfs layout, and create
explict parent/child relationships between kernel data structures
containing struct config_group members.  This allows the vast majority
of our data structure reference counting to be done using configfs/VFS
level protection instead of with stupid and clumsly ad-hoc structure
referencing code.

Just to refresh your memory, the main reasons why we are using configfs
for target mode are:

*) configfs represents the individual target data structures who's
creation/deletion are driven from enterily userspace.

*) The parent/child relationships of dependant data structures is
handled transparently to the configfs consumer (eg: no hard requirement
internal reference counting)

*) The module reference counting of target core -> fabric module is
handled transparently to configfs consumers *and* TCM fabric modules

*) The current implementation of TCM/ConfigFS contains no global locks.
Each /sys/kernel/config/target/$FABRIC_1 operates independently of
/sys/kernel/config/target/$FABRIC_2

If you think there is a geninue issue then I suggest you send out a
thread with git-format-patch'ed output for discussion instead of
high-jacking a patch series thread with your preconceived notions of how
user shell interfaction and userspace code should work with kernel level
configfs layout for HW target mode.  That would certainly be a more
effective method of getting me (or anyone) to address what you consider
to be shortcomings with code for kernel-level configfs/sysfs target code
than a mashup of items from your current TODO List.

--nab


