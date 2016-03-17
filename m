From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: fc: use get/put_unaligned64 for wwn access
Date: Thu, 17 Mar 2016 13:57:51 +0100
Message-ID: <56EAA9CF.4000309@suse.de>
References: <1458146385-278589-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030651AbcCQM5z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2016 08:57:55 -0400
In-Reply-To: <1458146385-278589-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <JBottomley@Odin.com>, James Smart <james.smart@emulex.com>, "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 03/16/2016 05:39 PM, Arnd Bergmann wrote:
> A bug in the gcc-6.0 prerelease version caused at least one
> driver (lpfc) to have excessive stack usage when dealing with
> wwn data, on the ARM architecture.
>=20
> lpfc_scsi.c: In function 'lpfc_find_next_oas_lun':
> lpfc_scsi.c:117:1: warning: the frame size of 1152 bytes is larger th=
an 1024 bytes [-Wframe-larger-than=3D]
>=20
> I have reported this as a gcc regression in
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D70232
>=20
> However, using a better implementation of wwn_to_u64() not only
> helps with the particular gcc problem but also leads to better
> object code for any version or architecture.
>=20
> The kernel already provides get_unaligned_be64() and
> put_unaligned_be64() helper functions that provide an
> optimized implementation with the desired semantics.
>=20
> The lpfc_find_next_oas_lun() function in the example that
> grew from 1146 bytes to 5144 bytes when moving from gcc-5.3
> to gcc-6.0 is now 804 bytes, as the optimized
> get_unaligned_be64() load can be done in three instructions.
> The stack usage is now down to 28 bytes from 128 bytes with
> gcc-5.3 before.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/scsi/scsi_transport_fc.h | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
