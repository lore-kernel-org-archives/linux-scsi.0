From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 37/41] scsi: st: mark expected switch fall-throughs
Date: Tue, 27 Nov 2018 22:33:54 -0600
Message-ID: <e0f4aa25970996146427e633bbf92be3eeee2e35.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114994 ("Missing break in switch")
Addresses-Coverity-ID: 114995 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/st.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 7ff22d3f03e3..7c7a742a5ef7 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -337,12 +337,14 @@ static void st_analyze_sense(struct st_request *SRpnt, struct st_cmdstatus *s)
 		switch (sense[0] & 0x7f) {
 		case 0x71:
 			s->deferred = 1;
+			/* fall through */
 		case 0x70:
 			s->fixed_format = 1;
 			s->flags = sense[2] & 0xe0;
 			break;
 		case 0x73:
 			s->deferred = 1;
+			/* fall through */
 		case 0x72:
 			s->fixed_format = 0;
 			ucp = scsi_sense_desc_find(sense, SCSI_SENSE_BUFFERSIZE, 4);
@@ -2721,6 +2723,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 	switch (cmd_in) {
 	case MTFSFM:
 		chg_eof = 0;	/* Changed from the FSF after this */
+		/* fall through */
 	case MTFSF:
 		cmd[0] = SPACE;
 		cmd[1] = 0x01;	/* Space FileMarks */
@@ -2735,6 +2738,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		break;
 	case MTBSFM:
 		chg_eof = 0;	/* Changed from the FSF after this */
+		/* fall through */
 	case MTBSF:
 		cmd[0] = SPACE;
 		cmd[1] = 0x01;	/* Space FileMarks */
-- 
2.17.1
