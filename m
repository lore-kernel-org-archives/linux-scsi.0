From: Patrick Mansfield <patmans@us.ibm.com>
Subject: udev naming of st devices [was Re: iSCSI device naming issues]
Date: Thu, 1 Jul 2004 10:29:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040701172900.GA21262@beaverton.ibm.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAXdSfMOoTnU6X86O4sbqWzAEAAAAA@cisco.com> <20040701155714.GA7172@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:36026 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266193AbUGAR36 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2004 13:29:58 -0400
Content-Disposition: inline
In-Reply-To: <20040701155714.GA7172@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, linux-hotplug-devel@lists.sourceforge.net

[adding linux-hotplug-devel]

On Thu, Jul 01, 2004 at 08:57:14AM -0700, Mike Anderson wrote:
> Surekha.PC [surekhap@cisco.com] wrote:
> > 3) Make use of scsi_id.
> > scsi_id can be used to get unique name instead of parsing sysfs
> > path for device name creation. However scsi_id is helpful only
> > for block devices, and there is no way to handle unique naming
> > for tape devices. So this will not make a complete solution.
> 
> Well you can still setup a udev rule to use scsi_id for you block
> devices and then use location naming for the tapes ( some newer
> generation tape drives also support serial numbers).

Yes, I had no problems running scsi_id on some older DLT drives (DLT
4000?).

There is a naming issue with st, in that unique tape names need to put an
identifier in the middle of the different names, or at least parse out a
middle portion of the kernel name.

That is, tape names are of the form:

 st13
 st13a
 st13l
 st13m
nst13
nst13a
nst13l
nst13m

So if you want a unique name in the above, you would generally want to
substitute the 13 with a value. 

You can't do this with a one line udev rule, using scsi_id with an eight
line rule (each one containing the same scsi_id value to match) is ugly,
and I'm not sure if it would work (udev wildcard pattern matching for
things like st[0-9]*l).

A script could be written to handle this, it would be passed a kernel
name, a scsi_id value to match and a name string. It would call scsi_id,
and if it matches the passed in value, return the name string for the
device wrapped with pre and post fixes.

Or maybe udev can be changed to better handle this, but I don't have
suggestions or patches.

Changing st default kernel names would simplify the problem, but is not
allowed.

-- Patrick Mansfield
