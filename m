From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: WWID / SerialNo in sysfs?
Date: Mon, 9 Feb 2004 09:04:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209090421.B1568@beaverton.ibm.com>
References: <20040209160856.GS3944@tpkurt.garloff.de> <1076343628.1804.19.camel@mulgrave> <20040209162906.GV3944@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:9673 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S265303AbUBIREy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 12:04:54 -0500
Content-Disposition: inline
In-Reply-To: <20040209162906.GV3944@tpkurt.garloff.de>; from garloff@suse.de on Mon, Feb 09, 2004 at 05:29:06PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, Feb 09, 2004 at 05:29:06PM +0100, Kurt Garloff wrote:
> Hi,
> 
> On Mon, Feb 09, 2004 at 11:20:26AM -0500, James Bottomley wrote:
> > The SCSI part of udev already has most of this implemented at the user
> > level, so you should just be able to reuse that code.
> 
> As you know I have everything in scsidev as well already since long ;-)
> Nice code duplication though ...

Yes ;-) 

I was hoping you were supporting scsidev as backward compatible with 2.6,
and you could get users to migrate to udev + scsi_id.

I made scsi_id as an only functional with sysfs (only 2.6), and it must be
disconnected from the naming done by udev. Plus, disconnecting it from the
naming means it can be used by multipath configuration code.

Also it gets model + vendor via sysfs, mainly to avoid potential issues
avoided in scsi_scan.c when sending a standard INQUIRY (well, AFAICT no
one is using BLIST_INQUIRY_36 or BLIST_INQUIRY_58, but if they did, it
avoids those issue). This still saves an extra INQUIRY command from being
sent to the device.

Being able to store the serial number in the udev database would be nice,
since we potentially have multiple users: standard interface (upper level
driver sd/sr/st/osst), sg, and multipath. We could store it into a sysfs
scsi_device attribute, but I am not pushing for that, and for now would
rather have the same commands sent multiple times.

Also has these items that could be done in scsidev:

- a white/black list text file, so we don't need to rebuild a kernel or
  recompile the user binary to add or remove devices from the lists

- page 0x80 support

- supports page 0x83 types 0 (vendor specific) and 1 (T10 vendor
  identification).

> The nontrivial thing was always to make the relation sg/sd/... device
> to C:B:T:U tuple. With sysfs it's at least possible to do that in
> a reliable way.

As James said we can send SG_IO commands to sd, plus all of the upper
level drivers, the only one not yet completed is osst.

-- Patrick Mansfield
