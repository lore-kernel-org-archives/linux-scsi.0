From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 2/2] tcm_qla2xxx: Handle malformed wwn strings properly
Date: Mon, 11 Jun 2012 18:31:31 -0700
Message-ID: <1339464691-25829-2-git-send-email-roland@kernel.org>
References: <1339464691-25829-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:52845 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753158Ab2FLBbi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jun 2012 21:31:38 -0400
Received: by dadz8 with SMTP id z8so7733853dad.35
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jun 2012 18:31:36 -0700 (PDT)
In-Reply-To: <1339464691-25829-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arun Easi <arun.easi@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

=46rom: Roland Dreier <roland@purestorage.com>

If we make a variable an unsigned int and then expect it to be < 0 on
a bad character, we're going to have a bad time.  Fix the tcm_qla2xxx
code to actually notice if hex_to_bin() returns a negative variable.

This was detected by the compiler warning:

    scsi/qla2xxx/tcm_qla2xxx.c: In function =E2=80=98tcm_qla2xxx_npiv_e=
xtract_wwn=E2=80=99:
    scsi/qla2xxx/tcm_qla2xxx.c:148:3: warning: comparison of unsigned e=
xpression >=3D 0 is always true [-Wtype-limits]

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/=
tcm_qla2xxx.c
index 446297a..ccef32b 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -137,13 +137,15 @@ static char *tcm_qla2xxx_get_fabric_name(void)
  */
 static int tcm_qla2xxx_npiv_extract_wwn(const char *ns, u64 *nm)
 {
-	unsigned int i, j, value;
+	unsigned int i, j;
 	u8 wwn[8];
=20
 	memset(wwn, 0, sizeof(wwn));
=20
 	/* Validate and store the new name */
 	for (i =3D 0, j =3D 0; i < 16; i++) {
+		int value;
+
 		value =3D hex_to_bin(*ns++);
 		if (value >=3D 0)
 			j =3D (j << 4) | value;
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
