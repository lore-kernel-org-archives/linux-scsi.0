From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] scsi: lpfc: avoid harmless comparison warning
Date: Thu, 16 Jun 2016 09:39:10 +0200
Message-ID: <20160616073910.q6cw2j36uq5c4ngx@c203.arch.suse.de>
References: <20160615204231.3784044-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160615204231.3784044-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, Hannes Reinicke <hare@suse.de>, James Bottomley <JBottomley@Odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 15, 2016 at 10:42:17PM +0200, Arnd Bergmann wrote:
> When building with -Wextra, we get a lot of warnings for the lpfc dri=
ver
> concerning expressions that are always true, starting with:
>=20
> drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_enable_npiv_init':
> drivers/scsi/lpfc/lpfc_attr.c:2786:77: error: comparison of unsigned =
expression >=3D 0 is always true [-Werror=3Dtype-limits]
> drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_enable_rrq_init':
> drivers/scsi/lpfc/lpfc_attr.c:2802:76: error: comparison of unsigned =
expression >=3D 0 is always true [-Werror=3Dtype-limits]
> drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_suppress_link_up_ini=
t':
> drivers/scsi/lpfc/lpfc_attr.c:2812:2050: error: comparison of unsigne=
d expression >=3D 0 is always true [-Werror=3Dtype-limits]
> drivers/scsi/lpfc/lpfc_attr.c: In function 'lpfc_log_verbose_init':
> drivers/scsi/lpfc/lpfc_attr.c:3064:1930: error: comparison of unsigne=
d expression >=3D 0 is always true [-Werror=3Dtype-limits]
>=20
> The code works as intented, but it would be nice to shut up the
> warning so we don't clutter up build logs with this. Using a
> separate inline function for it makes it clear to the compiler
> that the comparison is necessary in the caller but still lets
> it do the constant-folding.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
