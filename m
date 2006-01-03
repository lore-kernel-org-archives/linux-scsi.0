From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2300 & mptscsih refcount, or lack thereof
Date: Tue, 3 Jan 2006 11:28:57 -0800
Message-ID: <20060103192857.GD6648@andrew-vasquezs-powerbook-g4-15.local>
References: <20051230235030.GX18439@ca-server1.us.oracle.com> <20060103191740.GA20527@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:58645 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S932496AbWACT27 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2006 14:28:59 -0500
Content-Disposition: inline
In-Reply-To: <20060103191740.GA20527@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org, Joel Becker <Joel.Becker@oracle.com>, James Bottomley <James.Bottomley@steeleye.com>

On Tue, 03 Jan 2006, Patrick Mansfield wrote:

> On Fri, Dec 30, 2005 at 03:50:30PM -0800, Joel Becker wrote:
> > Folks,
> > 	I've run into an interesting problem.  The qla2300 and
> > mptspi drivers don't get refcounted for active users, but they are
> > absolutely required.  Thus, you can do, eg, "rmmod qla2300" with mounted
> > filesystems, and your system happily removes all child devices.
> > Hello, EIO!
> > 	Now, I know we're well into "Doctor, it hurts when I do this,"
> > territory here.  But we generally try not to allow this sort of mistake.
> > You can't remove a network card while the interface is up, you can't
> > remove sd_mod while a disk is in use, etc.
> > 	Has this been seen before?  Is there any plan to make qla2300
> > and mptspi respect the use count of the objects they present to the
> > system?  Thoughts?
> 
> The qla driver increments the underlying qla2xxx module ref count rather
> than the qla2n00 module. Look at qla_os.c setting of .module, and
> scsi_device_get() code, and the complete lsmod output. qla_os.c code is
> included in qla2xxx, so its THIS_MODULE references qla2xxx instead of
> qla2n00.
> 
> The code would have to change to set the correct THIS_MODULE for use in
> scsi_device_get(), the qla2n00 can't just override the template, else you
> would get bad module ref counts if you had mixed qla hardware in your
> system.
> 
> We probably need to duplicate the .module in struct scsi_host, set it
> appropriately (by default copy struct scsi_host_template value), and then
> use it in scsi_device_get().

I had previously posted a patch:

[PATCH 10/12] qla2xxx: Correct fw-loader module-use referencing.
http://marc.theaimsgroup.com/?l=linux-scsi&m=112924546828936&w=2

which corrected this behaviour.  But considering the direction the
qla2xxx driver was heading with respect to 'firmware-loader modules',
the patch was back-burnered.

scsi-misc-2.6.git already has a set of patches which moves the qla2xxx
driver to a single-module driver where firmware is loaded via the
request-firmware APIs.

--
av
