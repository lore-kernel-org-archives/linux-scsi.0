From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH RFC] fcping: allow pings using FC_BSG_RPT_ELS
Date: Wed, 19 Oct 2016 19:20:59 +0200
Message-ID: <20161019172059.4931-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: jthumshirn-l3A5Bk7waGM@public.gmane.org
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

fcping uses FC-ELS to perform pings. FC ELS is a host as well as rport
service, so allow the rport version of the BSG ioctl() as well as the
host version.

Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
---
 fcping.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fcping.c b/fcping.c
index bf2bc0f..3bc7fe6 100644
--- a/fcping.c
+++ b/fcping.c
@@ -471,6 +471,7 @@ fp_find_hba(void)
 	char *endptr;
 	uint32_t fcid;
 	int hba_cnt;
+	int hostno, chan, num;
 
 	hba_cnt = get_number_of_adapters();
 	if (!hba_cnt)
@@ -495,6 +496,16 @@ fp_find_hba(void)
 		if (*endptr != '\0')
 			SA_LOG_EXIT("invalid hba name %s", fp_hba);
 		host = strdup(fp_hba);
+	} else if (sscanf(fp_hba, "rport-%d:%d-%d", &hostno, &chan, &num)) {
+		char *rport = strdup(fp_hba);
+		port_attrs = get_rport_attribs(rport);
+		if (!port_attrs) {
+			free(rport);
+			return 0;
+		}
+		strncpy(fp_dev, rport, sizeof(fp_dev));
+		free(rport);
+		return 1;
 	} else if (strstr(fp_hba, ":")) {
 		if (strlen(fp_hba) == strlen("xx:yy:aa:bb:cc:dd:ee:ff")) {
 			fc_wwn_t wwn1;
@@ -826,10 +837,16 @@ send_els_echo(int fp_fd, void *fp_buf, uint32_t fp_len,
 {
 	struct fc_bsg_request cdb;
 	char sense[MAX_SENSE_LEN];
+	char *rport;
 	struct sg_io_v4 sg_io;
 	int rc;
 
-	cdb.msgcode = FC_BSG_HST_ELS_NOLOGIN;
+	rport = get_rport_by_fcid(fp_did);
+	if (rport)
+		cdb.msgcode = FC_BSG_RPT_ELS;
+	else
+		cdb.msgcode = FC_BSG_HST_ELS_NOLOGIN;
+
 	cdb.rqst_data.h_els.command_code = ELS_ECHO;
 	hton24(cdb.rqst_data.h_els.port_id, fp_did);
 
-- 
2.10.0
