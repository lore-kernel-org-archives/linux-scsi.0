From: Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: [PATCH as470] Add a NOREPORTLUN blacklist flag
Date: Sun, 20 Feb 2005 19:59:27 +0300
Message-ID: <20050220195927.398c57e4.vsu@altlinux.ru>
References: <20050217221803.091fd840@hebus>
	<Pine.LNX.4.44L0.0502171728080.627-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="pgp-sha1";
 boundary="Signature=_Sun__20_Feb_2005_19_59_27_+0300_8vFxEbVBjh.rWgor"
Received: from mail.murom.net ([213.177.124.17]:63161 "EHLO ns1.murom.ru")
	by vger.kernel.org with ESMTP id S261876AbVBTQ7l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 11:59:41 -0500
In-Reply-To: <Pine.LNX.4.44L0.0502171728080.627-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Samuel Colin <Samuel.Colin3@wanadoo.fr>, SCSI development list <linux-scsi@vger.kernel.org>

--Signature=_Sun__20_Feb_2005_19_59_27_+0300_8vFxEbVBjh.rWgor
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Thu, 17 Feb 2005 17:31:04 -0500 (EST) Alan Stern wrote:

> James:
> 
> This patch adds a NOREPORTLUN blacklist flag for a disk made by "WDC" 
> (Winchester?).  The drive's firmware crashes when it receives
> REPORT_LUNS,  even though it claims to be SCSI rev 04.
> 
> Alan Stern
> 
> 
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ===== drivers/scsi/scsi_devinfo.c 1.14 vs edited =====
> --- 1.14/drivers/scsi/scsi_devinfo.c	2004-12-10 11:54:56 -05:00
> +++ edited/drivers/scsi/scsi_devinfo.c	2005-02-16 11:30:56 -05:00
> @@ -201,6 +201,7 @@
>  	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
>  	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
>  	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
> +	{"WDC WD25", "00JB-00FUA0", NULL, BLIST_NOREPORTLUN},

This does not look like a right solution.  WD2500JB is an IDE disk made
by Western Digital:

http://www.wdc.com/en/products/Products.asp?DriveID=42

Therefore the problematic LaCie device is really an USB/Firewire-to-IDE
adapter with the WD2500JB drive in a box.  And it is the USB-IDE part
which fails on the REPORT_LUNS command, not the IDE disk.  Probably
there are other LaCie devices with the same adapter but different disks
inside; adding all such IDE disks to the SCSI blacklist does not seem
like a good solution.  The usb-storage blacklist seems like a better
place for such entry.

--Signature=_Sun__20_Feb_2005_19_59_27_+0300_8vFxEbVBjh.rWgor
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCGMHyW82GfkQfsqIRAuXoAJ9lG2vWIiIxOQnDFJ5ODIhhzMqGDgCeK9x2
dLV411jfMZkxWMMpIsxbJvQ=
=K4Jg
-----END PGP SIGNATURE-----

--Signature=_Sun__20_Feb_2005_19_59_27_+0300_8vFxEbVBjh.rWgor--
