From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 7/7] scsi_debug: resp_request: remove unused variable
Date: Tue, 28 Jul 2015 16:54:26 +0300
Message-ID: <1438091666-18113-7-git-send-email-tomas.winkler@intel.com>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

=46ixes the following warning

In function =E2=80=98resp_requests=E2=80=99:
drivers/scsi//scsi_debug.c:1432:15: warning: variable =E2=80=98want_dse=
nse=E2=80=99 set
but not used [-Wunused-but-set-variable]
  bool dsense, want_dsense;

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/scsi_debug.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2e0b3d7dc40f..dfcc45bb03b1 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1429,12 +1429,11 @@ static int resp_requests(struct scsi_cmnd * scp=
,
 	unsigned char * sbuff;
 	unsigned char *cmd =3D scp->cmnd;
 	unsigned char arr[SCSI_SENSE_BUFFERSIZE];
-	bool dsense, want_dsense;
+	bool dsense;
 	int len =3D 18;
=20
 	memset(arr, 0, sizeof(arr));
 	dsense =3D !!(cmd[1] & 1);
-	want_dsense =3D dsense || scsi_debug_dsense;
 	sbuff =3D scp->sense_buffer;
 	if ((iec_m_pg[2] & 0x4) && (6 =3D=3D (iec_m_pg[3] & 0xf))) {
 		if (dsense) {
--=20
2.4.3
