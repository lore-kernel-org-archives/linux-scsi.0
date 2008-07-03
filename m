From: Arne Wiebalck <arne.wiebalck@cern.ch>
Subject: RE: SG_IO permissions
Date: Thu, 3 Jul 2008 11:15:05 +0200
Message-ID: <1215076505.5058.146.camel@pcitfio23.cern.ch>
References: <1215004850.5058.101.camel@pcitfio23.cern.ch>
	 <1215010262.3330.19.camel@localhost.localdomain>
	 <E7F3663B89B60B478C6997C0A0671F8B0D58A9@cernxchg45.cern.ch>
	 <E7F3663B89B60B478C6997C0A0671F8B0D58AB@cernxchg45.cern.ch>
	 <1215030534.3330.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cernmx11.cern.ch ([137.138.142.198]:51233 "EHLO
	cernmx11.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYGCLxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2008 07:53:45 -0400
In-Reply-To: <1215030534.3330.46.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-07-02 at 15:28 -0500, James Bottomley wrote:
> On Wed, 2008-07-02 at 20:40 +0200, Arne Wiebalck wrote:
> > >>> Hi all,
> > >>> 
> > >>> I am trying to replace some read/write calls in our application
> > >>> by SG_IO commands in order to have access to the sense bytes in 
> > >>> case of an error. The underlying devices are tape drives. 
> > >>> 
> > >>> Part of our application, such as positioning or reading labels
> > >>> from the tape, are run as root. This seems to work fine, I get 
> > >>> the data I expect and the sense bytes in case of an error. 
> > >>> 
> > >>> However, the actual data transfer from and to the device is run 
> > >>> under a user's ID. This part does not work anymore when switching
> > >>> from read/write to SG_IO: 'Operation not permitted'. 
> > >>> 
> > >>> Does a user need some special rights to issue SG_IO (read) commands
> > >>> (on a file descriptor that he opened for reading and that he 
> > >>> can use without problems for read() calls)? 
> > >>> 
> > >>> The device node that the processes are accessing is a char special
> > >>> file owned by the user and with all user bits set. This special file
> > >>> is created on a per tape request basis. I also tried to use /dev/nst0
> > >>> instead, but that made no difference. 
> > >>>
> > >>> I am running a relatively old kernel (2.6.9 based), could that cause
> > >>> any problem?
> > >>> 
> > >>> BTW, why does it say "except st" on the permission requirements table on
> > >>> http://sg.torque.net/sg/sg_io.html ? :)
> > >>> 
> > >>> 
> > >>> Any hints appreciated.
> > >>
> > >>SG_IO access requires CAP_SYS_RAWIO to defeat the command verifier.
> > >>
> > >
> > >Thanks for the quick reply, James.
> > >
> > >We're talking about this snippet of code from st.c, I guess?
> > >
> > >---
> > >switch (cmd_in) {
> > >    case SCSI_IOCTL_GET_IDLUN:
> > >    case SCSI_IOCTL_GET_BUS_NUMBER:
> > >        break;
> > >    default:
> > >        if ((cmd_in == SG_IO ||
> > >             cmd_in == SCSI_IOCTL_SEND_COMMAND ||
> > >             cmd_in == CDROM_SEND_PACKET) &&
> > >             !capable(CAP_SYS_RAWIO))
> > >            i = -EPERM;
> > >        else
> > >            i = scsi_cmd_ioctl(file, STp->disk->queue,
> > >                               STp->disk, cmd_in, p);
> > >            if (i != -ENOTTY)
> > >                return i;
> > >        break;
> > >}
> > >---
> > >
> > >Obviously. (I just found the discussion about this dating from 
> > >April '05).
> > >
> > >What's the way to go then in order to access a tape as a user, when 
> > >the user would like to get the sense bytes in case of problems? 
> > >
> > >Should the user process get CAP_SYS_RAWIO?
> > 
> > The user process in my case is forked by another process which runs
> > as root. But since this process does not have CAP_SETPCAP it cannot
> > set the child's capabilities (which is how I naively thought one could 
> > implement this).
> > 
> > What options are left? Running a patched kernel where the "SG_IO in st
> > requires CAP_SYS_RAWIO" is taken out?
> 
> Erm, well capabilities are designed to be malleable, especially with
> things like sucap and execap, which root should be able to use.

But you need to change and recompile your kernel to use that, as init
needs CAP_SETPCAP to be set, no?

Cheers,
 Arne


