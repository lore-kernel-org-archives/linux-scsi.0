From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: kfree patch
Date: Wed, 12 Jan 2005 09:48:58 +0100
Message-ID: <OF79A72E0D.6A084E26-ONC1256F87.002F452C-C1256F87.00306E70@de.ibm.com>
References: <20050112064756.GC1928@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:25265 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S261245AbVALIsh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 03:48:37 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id j0C8mZvU136218
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 08:48:35 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0C8nTj9043952
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 09:49:29 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j0C8mZCE010351
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 09:48:35 +0100
In-Reply-To: <20050112064756.GC1928@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> > drivers/usb/serial/usb-serial.c does this right and keeps the release
> > function from being called after usb-serial.ko got unloaded?
> usb-serial can not get unloaded if there is a reference held on a sysfs
> file owned by it, or if a user has a port open.  This is due to the
> module reference counting logic in sysfs attributes, and in the module
> reference count stuff in the usb-serial core itself.

Makes sense. Just wondering if there isn't a race in fs/sysfs/file.c:
the function check_perm() first gets a reference to a kobject in
question and afterwards does a try_module_get(). Now if
sysfs_get_kobject() succeeds but try_module_get() fails, this means
you end up with a kobject where the corresponding module code is
missing and the kobject_put() at the end of check_perm() could
result in a release() call to already unloaded code.
Or not?

Heiko

