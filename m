From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: Re: [PATCH] zfcp: kfree patch
Date: Mon, 10 Jan 2005 10:27:06 +0100
Message-ID: <OF19A85831.9D000076-ONC1256F85.00312F55-C1256F85.0033E6D5@de.ibm.com>
References: <20050110081815.GA13612@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:652 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S262167AbVAJJ0p
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 04:26:45 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j0A9QhbP188322
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 09:26:43 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0A9RaFq152038
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 10:27:36 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j0A9QhxW030062
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 10:26:43 +0100
In-Reply-To: <20050110081815.GA13612@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> As I don't know the scsi subsystem, I can only rely on the fact that
> kfree should never be used as a release call.  So fix that, and I'm
> happy :)

The code in question has nothing to do with the scsi subsystem at all.
It's just a module which is doing a device_register() call and which
has the release function in the module code as well. The issue still
is that there might be referenced kobjects created by the module while
the module is already unloaded. When the reference count of these
kobjects drop to zero the release function of the already unloaded
module will be called.

> I understand the "generic" issue, however no other subsystem needs to
> use kfree as a release call.  Now either everyone else is broken or...

Hmm.. then maybe you could explain to me how e.g.
drivers/usb/serial/usb-serial.c does this right and keeps the release
function from being called after usb-serial.ko got unloaded?
Sorry, I don't want to be offensive, just looking for a solution :)

Heiko

