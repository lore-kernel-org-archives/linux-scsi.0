From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/6] scsi_debug: add translation functions between LBA
 and index of provisioning map
Date: Thu, 02 May 2013 15:50:21 -0700
Message-ID: <1367535021.3133.24.camel@dabdike>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
	 <1366117920-11740-5-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53137 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760561Ab3EBWuX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 18:50:23 -0400
In-Reply-To: <1366117920-11740-5-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Tue, 2013-04-16 at 22:11 +0900, Akinobu Mita wrote:
> The translation from LBA to index of provisioning map (map_storep) is=
 used
> in various places (map_state(), map_region(), and unmap_region()).  B=
ut it
> is not correctly calculated if scsi_debug_unmap_alignment is zero.
>=20
> This introduces correct translation functions between LBA and index
> of  provisioning map:
>=20
>         static unsigned long lba_to_map_index(sector_t lba);
>         static sector_t map_index_to_lba(unsigned long index);
>=20
> Actual bug fixes with using these functions will be done by forthcomi=
ng
> patches.

That's not the correct way to split patches, because it leads to untidy
things like this:

drivers/scsi/scsi_debug.c:2000:22: warning: =E2=80=98lba_to_map_index=E2=
=80=99 defined
but not used [-Wunused-function]
drivers/scsi/scsi_debug.c:2011:17: warning: =E2=80=98map_index_to_lba=E2=
=80=99 defined
but not used [-Wunused-function]

I fixed this just by rolling the last three patches together, but in
future, just put the static function in with whatever is calling it.

This is also good commit history practise regardless of the static
warning because it adds the function and the callers of that function i=
n
the same commit meaning people who look later don't have to rummage
around for both commits.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
