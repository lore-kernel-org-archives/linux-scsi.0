From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: qla2300 & mptscsih refcount, or lack thereof
Date: Tue, 3 Jan 2006 11:17:40 -0800
Message-ID: <20060103191740.GA20527@us.ibm.com>
References: <20051230235030.GX18439@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33692 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751456AbWACTRu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2006 14:17:50 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k03JHnI9025726
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jan 2006 14:17:49 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k03JHnck103464
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jan 2006 14:17:49 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k03JHmMQ007708
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jan 2006 14:17:49 -0500
Content-Disposition: inline
In-Reply-To: <20051230235030.GX18439@ca-server1.us.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Fri, Dec 30, 2005 at 03:50:30PM -0800, Joel Becker wrote:
> Folks,
> 	I've run into an interesting problem.  The qla2300 and
> mptspi drivers don't get refcounted for active users, but they are
> absolutely required.  Thus, you can do, eg, "rmmod qla2300" with mounted
> filesystems, and your system happily removes all child devices.
> Hello, EIO!
> 	Now, I know we're well into "Doctor, it hurts when I do this,"
> territory here.  But we generally try not to allow this sort of mistake.
> You can't remove a network card while the interface is up, you can't
> remove sd_mod while a disk is in use, etc.
> 	Has this been seen before?  Is there any plan to make qla2300
> and mptspi respect the use count of the objects they present to the
> system?  Thoughts?

The qla driver increments the underlying qla2xxx module ref count rather
than the qla2n00 module. Look at qla_os.c setting of .module, and
scsi_device_get() code, and the complete lsmod output. qla_os.c code is
included in qla2xxx, so its THIS_MODULE references qla2xxx instead of
qla2n00.

The code would have to change to set the correct THIS_MODULE for use in
scsi_device_get(), the qla2n00 can't just override the template, else you
would get bad module ref counts if you had mixed qla hardware in your
system.

We probably need to duplicate the .module in struct scsi_host, set it
appropriately (by default copy struct scsi_host_template value), and then
use it in scsi_device_get().

I haven't looked at mptspi drivers.

-- Patrick Mansfield
