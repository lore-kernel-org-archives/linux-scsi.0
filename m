From: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] fix mm overflow in FCP layer
Date: Fri, 3 Dec 2010 22:09:18 +0800
Message-ID: <AANLkTi=BJ4XXUnazJ4Jd-Q45wD_AQsXGQs8CXiFNuk3q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

When processing received frames, various checks should be issued to
make sure that the info carried is correct.

Here check for fcp_resp_rsp_info is added, or mm overflow could happen.

Computation for respl is also added, which looks like a beetle, but I
am not sure.

Signed-off-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---

--- a/drivers/scsi/libfc/fc_fcp.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/libfc/fc_fcp.c	2010-12-03 21:53:48.000000000 +0800
@@ -845,8 +845,12 @@ static void fc_fcp_resp(struct fc_fcp_pk
 			}
 			if (flags & FCP_SNS_LEN_VAL) {
 				snsl = ntohl(rp_ex->fr_sns_len);
+				respl = ntohl(rp_ex->fr_rsp_len);
 				if (snsl > SCSI_SENSE_BUFFERSIZE)
 					snsl = SCSI_SENSE_BUFFERSIZE;
+				if (plen < sizeof(*fc_rp) + sizeof(*rp_ex) +
+						respl + snsl);
+					goto len_err;
 				memcpy(fsp->cmd->sense_buffer,
 				       (char *)fc_rp_info + respl, snsl);
 			}
