From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] zfcp: kfree patch
Date: Tue, 11 Jan 2005 22:47:56 -0800
Message-ID: <20050112064756.GC1928@kroah.com>
References: <20050110081815.GA13612@kroah.com> <OF19A85831.9D000076-ONC1256F85.00312F55-C1256F85.0033E6D5@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:40369 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S261262AbVALGsm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 01:48:42 -0500
Content-Disposition: inline
In-Reply-To: <OF19A85831.9D000076-ONC1256F85.00312F55-C1256F85.0033E6D5@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 10, 2005 at 10:27:06AM +0100, Heiko Carstens wrote:
> Hmm.. then maybe you could explain to me how e.g.
> drivers/usb/serial/usb-serial.c does this right and keeps the release
> function from being called after usb-serial.ko got unloaded?

usb-serial can not get unloaded if there is a reference held on a sysfs
file owned by it, or if a user has a port open.  This is due to the
module reference counting logic in sysfs attributes, and in the module
reference count stuff in the usb-serial core itself.

Unless I'm missing something, and if so, please let me know and I'll go
fix it up.

thanks,

greg k-h
