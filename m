From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07 update
Date: Sat, 6 Nov 2004 23:03:14 +0000
Message-ID: <20041106230314.GA27491@infradead.org>
References: <91888D455306F94EBD4D168954A9457C2D18BA@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:31753 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261495AbUKFXDW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Nov 2004 18:03:22 -0500
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C2D18BA@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: " Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 05, 2004 at 05:21:06PM -0700,  Moore, Eric Dean wrote:
> We are pleased to announce the MPT Fusion release candidate for lk 2.=
6
>=20
> Highlights of this release:
> =B7	SAS Support - 1064, 1066, 1068
> =B7	mpi headers v1.5.2
>=20
> =B7	Also included are hch@ suggestions from previous 3.02.06 release
> - 	remove ioc->chip_type checks, using the new bus_type member
> -	removing SAS CSMI Ioctls
> -	using scsi_remove_device and scsi_add_device =3D> for hot swap supp=
ort
>=20
> This patch applied against bk://linux-scsi.bkbits.net/scsi-misc-2.6

It's still a big patch mixing various features and fixes and whitespace
changes.  Also:

 - ioc->sasDeviceList still exists although it's not actually traversed=
,
   and quite a lot od dead code to fill it
 - the mptctl_hba_pciinfo() ioctl call is vetoed, this information
   can be easily retrived from sysfs, and we aboslutely don't want this
   duplicated in every LLDD
 - please don't add TRUE/FALSE defines - Linux codingstyle prefers 0/1
 - what's that ->last_lun thing about?
 - your forgot to kill one MPTSCSIH_DBG_TIMEOUT in ->queuecommand
 - mptscsih_slave_destroy still has the vdev !=3D NULL check - if this
   case still happens now that the hotremoval is fixed you're in
   much deeper problems than this check could solve
 - if you already changed the boot parameter syntax please move to
   a module_param for each individual parameter

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
