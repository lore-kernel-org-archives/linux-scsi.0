From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Wed, 09 Jan 2008 22:41:59 +0100
Message-ID: <47853FA7.9050506@s5r6.in-berlin.de>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com> <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain> <20080109174945.GB15346@one.firstfloor.org> <4785138A.4000809@s5r6.in-berlin.de> <4785304A.60109@gmail.com> <20080109205850.GU16309@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52343 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYAIVmN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 16:42:13 -0500
In-Reply-To: <20080109205850.GU16309@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jon Watte <jwatte@gmail.com>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> OK, how about this?
>=20
> config BLK_DEV_ATA_SD
> 	tristate "ATA disc support"
> 	select BLK_DEV_SD
>=20
> config BLK_DEV_ATA_SR
> 	tristate "ATA CDROM support"
> 	select BLK_DEV_SR

It's probably OK for many uses.

However, this further obfuscates the fact that libata uses Linux' SCSI
midlayer and highlevel.  Which is a bad thing.  For example, there are
further configuration options in the SCSI menu which influence the SCSI
midlayer and highlevel, and therefore influence the software stack whic=
h
drives the ATA disks and ATA CD-ROMs.  Hence this change does not make
the configuration menu more logical.

> Help text left as an exercise for the reader.

A pro pos, the help texts and prompts for the SCSI midlayer and
highlevel options are... suboptimal.  At least as long as these help
texts and prompts aren't changed=B9 to say what they really do, your
BLK_DEV_ATA_SD and BLK_DEV_ATA_SR are actually very nice to have.

-------
=B9)  No patch attached.  I posted something a while ago.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D--- ---=3D -=3D--=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
