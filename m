From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the nfs tree
Date: Mon, 23 Jan 2012 11:39:49 +1100
Message-ID: <20120123113949.b8d1940bb60128c5c4efeece@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Jan_2012_11_39_49_+1100_SxY68HtSrrc+lFx5"
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Mon__23_Jan_2012_11_39_49_+1100_SxY68HtSrrc+lFx5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/target/iscsi/iscsi_target_configfs.c: In function 'lio_target_call_=
addnptotpg':
drivers/target/iscsi/iscsi_target_configfs.c:214:3: error: implicit declara=
tion of function 'in6_pton' [-Werror=3Dimplicit-function-declaration]
drivers/target/iscsi/iscsi_target_configfs.c:239:3: error: implicit declara=
tion of function 'in_aton' [-Werror=3Dimplicit-function-declaration]

Presumably caused by some include file cleanup in the nfs tree (probably
commit 0b5357cfc2e6 "NFS: Remove unnecessary includes from
linux/nfs_fs_i.h").

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 23 Jan 2012 11:35:02 +1100
Subject: [PATCH] iscsi: in_aton needs linux/inet.h

so include it directly.

Fixes this error after a recent nfs cleanup:

drivers/target/iscsi/iscsi_target_configfs.c: In function 'lio_target_call_=
addnptotpg':
drivers/target/iscsi/iscsi_target_configfs.c:214:3: error: implicit declara=
tion of function 'in6_pton' [-Werror=3Dimplicit-function-declaration]
drivers/target/iscsi/iscsi_target_configfs.c:239:3: error: implicit declara=
tion of function 'in_aton' [-Werror=3Dimplicit-function-declaration]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/target/iscsi/iscsi_target_configfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/=
iscsi/iscsi_target_configfs.c
index 3468caa..6b35b37 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -21,6 +21,7 @@
=20
 #include <linux/configfs.h>
 #include <linux/export.h>
+#include <linux/inet.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/target_core_fabric_configfs.h>
--=20
1.7.9.rc0.23.g7e521

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__23_Jan_2012_11_39_49_+1100_SxY68HtSrrc+lFx5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHKxVAAoJEECxmPOUX5FEvsAQAIPz+rftVIzKlFxU1U4OmRDg
1EnrXtD0kkaAsDPyzomCMfcRNS8S135CUrQcei6fUmcyH+JcMCNFdlwna1S2pGFm
bqbcvWLOD7puR/UGi2tX3EkGees22u6rudute9BRQy5+0iVmqBkczD822L0zht/A
eGQA0KbwnQeqitwppivNpeM0zzBYcJAk2/kWvhH16n0iDqnUD3Y0vpW3VDq/GBpJ
95gEsBKHFYYjBHAIufMsaBITI0MyJRajx7oA4nOAbttQxrjtInmTalD8VRd6Oavu
UUBRYB+Xnc6aPxjnOiEWonzW5oC06XnoSkSmvDzMeA4rtxB6fPbUiY4FsjSLtOWi
ewEY+nraZki5s1uJJ8MGWcLNdMPCI4lohCiczylmT2WOB8UhAGbBgc3Afzhaz+pT
NpBY++FnhlksGPZ6pUw+jlPC6sqe5SKH6mZNpyjfk8NkG1Z/K4c+yuB2ImVUiXi2
bjVVE+d3ai85tyBL1smA23dNcmlmA76exAYPkJeKEgFJJ+7RRd/cgkgeqiNYom1Q
mACsyYFFVYmIfjJBVbNjR2dj9OrlAFozWEv2kyFLH5rweX8O7MjgARUI80xJ2hGf
zwhT5G3TxO3vsRNNjoxrJslvKeiQS5Y8kmbnHZ2YN/LAo/RUn9jGHK9T7yZ3yKee
FMFf736wwwwaOrdzezhn
=gMy0
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Jan_2012_11_39_49_+1100_SxY68HtSrrc+lFx5--
