From: Klaus Muth <muth@hagos.de>
Subject: Re: [linux-usb-devel] Stoneridge Optac Download Tool
Date: Mon, 14 Aug 2006 07:10:59 +0200
Message-ID: <200608140710.59997.muth@hagos.de>
References: <Pine.LNX.4.44L0.0608111051560.6399-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chewbacca.hagos.de ([213.217.124.234]:57511 "EHLO
	tatooine.hagos.de") by vger.kernel.org with ESMTP id S1751854AbWHNFLI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 01:11:08 -0400
In-Reply-To: <Pine.LNX.4.44L0.0608111051560.6399-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

Am Freitag, 11. August 2006 17:16 schrieb Alan Stern:
> On Fri, 11 Aug 2006, Klaus Muth wrote:
> > Ok. I patched scsi_scan.c and scsi_ioctl.c, recompiled the modules and
> > replaced scsi_mod.ko; modprobe scsi_mod; cat "bla" >
> > /proc/scsi/device_info; plugged in. ----------------------------------
> > [...]
> > klaus scsi_get_device_flags: Vendor: >SRE<, Model: >OPTAC Tool      1.00<
>
> Look closely.  The Vendor string is only three characters long.  This
> means the device returned a NUL character in the fourth position.  That's
> an explicit violation of the SCSI-2 standard (and probably other versions
> of the SCSI standard as well).  However since the device doesn't claim to
> be SCSI-2 compliant, you can't really complain.

Yep, I noticed the missing spaces, that is the reason why I added those 
markers (>...<) in the kprint message. But I didn't know, that this is a 
violation of the SCSI standard.

> If the field had been properly padded with spaces to 8 characters, things
> would have worked.
>
> > klaus scsi_get_device_flags: devinfo->vendor: >SRE     OPTAC Tool      <
> > (8), devinfo->model: >OPTAC Tool      < (16) klaus scsi_probe_lun: bflags
> > = 0
> >   Vendor: SRE       Model: OPTAC Tool        Rev: 1.00
> >   Type:   Direct-Access                      ANSI SCSI revision: 00
> > usb-storage: queuecommand called
> > [...]
> > ---------------------------------
> > This is disappointing. I modified the else part of scsi_get_device_flags:
> >         else {
> > 			printk("klaus %s: Vendor: >%s<, Model: >%s<\n", __FUNCTION__, vendor,
> > model); printk("klaus %s: devinfo->vendor: >%s< (%u), devinfo->model:
> > >%s< (%u)\n", __FUNCTION__, devinfo->vendor, sizeof(devinfo->vendor),
> > devinfo->model, sizeof(devinfo->model)); if (!memcmp(devinfo->vendor,
> > vendor,
> > 				     sizeof(devinfo->vendor)) &&
> > 			     !memcmp(devinfo->model, model,
> > 				      sizeof(devinfo->model))) {
> > 				printk("klaus %s: devinfo->bflags=%x", __FUNCTION__, devinfo->flags);
> > 				return devinfo->flags;
> > 			}
> > 		}
> >
> > So it looks like the entries in /proc/scsi/devinfo are bad. GRRR. I'll
> > patch in the Vendor and Model into the static table and retry.
>
> No, it's the device's data that is bad.  The entry you added is correct --
> but since it doesn't match the device data, it doesn't help.
>
> > Ok, after stumbling over scsi_static_device_list[] __initdata in
> > drivers/scsi/scsi_devinfo.c I just added the line
> > 	{"SRE", "OPTAC Tool", NULL, BLIST_NOT_LOCKABLE},
> > to it and - pooof - this thin magically works.
> >
> > This leads to my next question: Adding the entry dynamically yields
> > # echo 'SRE:OPTAC Tool:0x80000' >/proc/scsi/device_info
> > # cat /proc/scsi/device_info | grep OPTAC
> > 'SRE     ' 'OPTAC Tool      ' 0x80000
> >
> > Adding it to the static list via patching scsi_devinfo.c (I don't want to
> > do that on production servers) yields:
> > # cat /proc/scsi/device_info | grep OPTAC
> > 'SRE' 'OPTAC Tool' 0x80000
> >
> > which is quite a difference! How do I get the SRE-entry
> > into /proc/scsi/device_info without those )%$!(##'!-spaces?
>
> You can't, at least not through the usual methods.  You'll see why if you
> read scsi_dev_info_list_add_str(), scsi_dev_info_list_add(), and
> scsi_strcpy_devinfo().  The "compatible" flag is always set to 0 and hence
> short strings are always padded with spaces.
>
> In your case it would help to change the code in scsi_scan.c:
> scsi_probe_lun() to make it replace unprintable characters in the Vendor,
> Model, and Revision strings with spaces.  But doing this might cause
> problems for other devices or programs.
>
> Maybe someone on the SCSI development mailing list can suggest other
> approaches.
>
> By the way, after you added the entry to the static table, were you then
> able to use the device?

Yes, it did mount and I was able to read the data on it and it was possible to 
create and delete files on the device. (see above, I said "this thin 
magically works", forgetting the 'g' at "thing"). Adding the OPTAC Tool to 
the static table may be the best fix at the moment, since my servers depend 
heavily on SCSI, changing something more complicated than adding something to 
a list will render me sleepless...

I'm not really happy with this solution, since
1. the static table is obsolete and may vanish some day as a comment says
2. I have to compile and test a new kernel for my 10 production servers
3. the device firmware may change in near future, it seems not to be finished
   according to the facts you found out.

Thank you very much for your help. I'm working now for over 10 years with 
linux and I'm constantly astonished, how nice and helpful all those community 
members are, when problems arise :).

klaus
-- 
Klaus Muth
HAGOS eG                      Industriestr. 62      fon: (+49) 711 78805-86
EDV-Programmierung            70565  Stuttgart      fax: (+49) 711 78805-35
http://www.hagos.de               Germany              mailto:muth@hagos.de
