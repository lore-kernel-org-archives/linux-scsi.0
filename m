From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 7 Jan 2003 12:33:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030107123301.A16378@beaverton.ibm.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com> <3E1B2934.8060805@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E1B2934.8060805@splentec.com>; from luben@splentec.com on Tue, Jan 07, 2003 at 02:23:32PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 07, 2003 at 02:23:32PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> > 
> > For use with multi-path, it is very useful to have the path in the
> > scsi_cmnd, and generally to not have the lldd's know about the scsi_device
> > at all, such that we can pick a path, and send a scsi_cmnd to a lldd.
> 
> It shouldn't know about the path either. :-)
> No one is forcing LLDD to peek into the device struct (but it will
> have to, see below).

Removing channel/target/lun from scsi_cmnd forces the LLDD to use the
scsi_device (scmd->device-> channel/id/lun).

> > Putting path information only in scsi_device makes it hard to do
> > multi-path below (or even in) the block layer, and makes it hard to
> > multi-path non block devices (like tape).
> > 
> > I would prefer we keep the current scsi_cmnd with its
> > host/channel/target[id]/lun.
> 
> For multipathing there should be *no* distinction between
> char and block devices sitting in fabric or on a SCSI Bus.

Agreed. Although retries must be handled differently for sequential and
direct-access devices.

> Conceptually you'd want to say SEND(C,D), where C is the
> command and D is the device, or if the device D is a property
> of the command C, you can do SEND(C), and the device is C::D.
> 
> A path or paths to a device is a property of the device D.
>  From any point of view (user, kernel), a command C needs to
> be sent to the device D, or simply the command C needs to
> be sent, (where the device is C::D).  The SEND() will check
> the paths which are property of the device and will
> perform the desired action to send it (C) along the chosen
> path P.  I.e. D::A is a collection of paths P, (0/1:N), and is a
> property of the device, thus you get C::D::A.
> This is object oriented design.

In order to allow selection of a path, we should abstract out the path
information, not lump it into a single pointer reference (i.e. not
scmd->device->lun) spread throughout the scsi mid and LLDD. If we had a
single macro or function to access the host/channel/target/lun, the issue
goes away, as there is only one point that we have to change for
multi-path. But if they are hardcoded into scsi_device, I'll have to
revert the changes for multi-path support.

Again, this is true whether we have multi-path support in the scsi
mid-level code or in the block layer.

> Currently, host/channel/target/lun *is* D::A all in *one*,
> i.e. it is a device and a single path in one ugly lump
> in the command struct. Thus, the more reason to get rid of
> it (at least partially).

For scsi_device yes, but the LLDD does not have to look at scsi_device to
send a command, it can currently use the values found in scsi_cmnd.

> There are other advantages to these patches:
> 1. No redundant data (OOD).
> 2. Transparent command struct allocation/deallocaton
>     via scsi_get_command() / scsi_put_command().
> 3. Improved queuing logic for SCSI Core, not yet ready,
>     I'm just waiting for more input on this current stuff.

I don't see how 2) and 3) are tied into your changes. I can understand
your changes leading to fewer changes for a common pool of all
scsi_cmnd's.  But, we could also have a single pool if the
host/channel/target/lun were set separtely from the allocation.

> There must be enough research papers on multipathing, and
> OS IO books should have a chapter on it. I just don't
> have time to go to my alma mater's sci. library and do the
> research since I do all this in my spare time.

I haven't found any good research papers, if anyone knows of some please
let me know (at least searching online, I should look in a real library).

-- Patrick Mansfield
