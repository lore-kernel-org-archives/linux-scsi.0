From: Olaf Hering <olaf@aepfle.de>
Subject: Re: mainline aic94xx firmware woes
Date: Mon, 25 Sep 2006 13:30:42 +0200
Message-ID: <20060925113042.GA18946@aepfle.de>
References: <20060925101124.GH6374@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natblert.rzone.de ([81.169.145.181]:5838 "EHLO
	natblert.rzone.de") by vger.kernel.org with ESMTP id S1751276AbWIYLa5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 07:30:57 -0400
Content-Disposition: inline
In-Reply-To: <20060925101124.GH6374@rhun.haifa.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-Kernel <linux-kernel@vger.kernel.org>

On Mon, Sep 25, Muli Ben-Yehuda wrote:

> The recently merged aic94xx in mainline requires external firmware
> support. This, in turn, necessitates an initrd/initramfs environment
> that includes firmware support to load the firmware. Will a patch to
> optionally include the firmware inline in the kernel and thus not
> having to use an initramfs be acceptable?

initramfs is always in use. Wether you pass in an additional image via
the bootloader is up to you.
Adding the firmware and required tools to your vmlinux binary is trivial
with CONFIG_INITRAMFS_SOURCE="/some/file"

> Also, aic94xx does not compile unless FW_LOADER is set in .config due
> to missing 'request_firmware'. What's the right thing to do here -
> aic94xx selecting it, depending on it, or FW_LOADER providing empty
> request_firmware() in case it's compiled out (the last one violates
> the principle of least surprise IMHO).

select FW_LOADER is likely the right fix.

