From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH as470] Add a NOREPORTLUN blacklist flag
Date: Mon, 28 Feb 2005 17:27:14 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502281703450.1332-100000@ida.rowland.org>
References: <1109611602.5330.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from ida.rowland.org ([192.131.102.52]:33028 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261798AbVB1W1Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 17:27:16 -0500
In-Reply-To: <1109611602.5330.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Radovan Garabik <garabik@kassiopeia.juls.savba.sk>, Sergey Vlasov <vsu@altlinux.ru>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Samuel Colin <Samuel.Colin3@wanadoo.fr>, SCSI Mailing List <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Mon, 28 Feb 2005, James Bottomley wrote:

> On Sun, 2005-02-20 at 22:44 -0500, Alan Stern wrote:
> > James, please withdraw the patch above.
> 
> Actually, I already have this in the tree.  Could you just do an
> incremental to remove the blacklist line since I think the IBM people
> still want their shark fix?

You have confused two different patches.  The one I asked you to withdraw 
(labelled as470) does nothing but add a single line to the scsi_devinfo.c 
blacklist.  The reversal patch for it is below.

The other patch, the one you're thinking of, is the one that adds retries
for Hardware Error sense keys; it's labelled as468.  In addition to the
IBM Shark stuff it contains a blacklist entry for a USB mass storage
device with vendor name ST650211 (marketed as an "HS200").  Although I'm
not certain, I think this device is not a USB-IDE converter -- perhaps
Radovan can clear this up for us.  Anyway, there's no easy way to get the
same effect as the blacklist entry by modifying usb-storage, since the
code only looks at the blacklist setting and not anything in the
scsi_device.  So I think patch as468 should remain as it stands.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== drivers/scsi/scsi_devinfo.c 1.14 vs edited =====
--- 1.14/drivers/scsi/scsi_devinfo.c	2004-12-10 11:54:56 -05:00
+++ edited/drivers/scsi/scsi_devinfo.c	2005-02-16 11:30:56 -05:00
@@ -201,7 +201,6 @@
 	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 1300", "02.4", BLIST_SELECT_NO_ATN},
-	{"WDC WD25", "00JB-00FUA0", NULL, BLIST_NOREPORTLUN},
 	{"XYRATEX", "RS", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"Zzyzx", "RocketStor 500S", NULL, BLIST_SPARSELUN},
 	{"Zzyzx", "RocketStor 2000", NULL, BLIST_SPARSELUN},

