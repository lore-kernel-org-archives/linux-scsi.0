From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v3 02/16] scsi: don't use
 fc_bsg_job::request and fc_bsg_job::reply directly
Date: Fri, 14 Oct 2016 09:38:21 +0200
Message-ID: <20161014073821.qvkpjtwraqnwzzs3@linux-x5ow.site>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <bbc682928173d64848ab0cbff689b1ad3d715fb7.1476369687.git.jthumshirn@suse.de>
 <ebc46cfa-0bee-aa71-ba0b-d7c86628df0c@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ebc46cfa-0bee-aa71-ba0b-d7c86628df0c-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Steffen Maier <maier-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "open list:S390 ZFCP DRIVER" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dick Kennedy <dick.kennedy-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Anil Gurumurthy <anil.gurumurthy-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Sudarsana Kalluru <sudarsana.kalluru-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:FCOE SUBSYSTEM (libfc, libfcoe, fcoe)" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, James Smart <james.smart-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Johannes Thumshirn <jth>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 13, 2016 at 05:55:11PM +0200, Steffen Maier wrote:
> Hm, still behaves for me like I reported for v2:
> http://marc.info/?l=3Dlinux-scsi&m=3D147637177902937&w=3D2

Hi Steffen,

Can you please try the following on top of 2/16?

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport=
_fc.c
index 4149dac..baebaab 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3786,6 +3786,12 @@ enum fc_dispatch_result {
 	int cmdlen =3D sizeof(uint32_t);	/* start with length of msgcode */
 	int ret;
 =

+	/* check if we really have all the request data needed */
+	if (job->request_len < cmdlen) {
+		ret =3D -ENOMSG;
+		goto fail_host_msg;
+	}
+
 	/* Validate the host command */
 	switch (bsg_request->msgcode) {
 	case FC_BSG_HST_ADD_RPORT:
@@ -3831,12 +3837,6 @@ enum fc_dispatch_result {
 		goto fail_host_msg;
 	}
 =

-	/* check if we really have all the request data needed */
-	if (job->request_len < cmdlen) {
-		ret =3D -ENOMSG;
-		goto fail_host_msg;
-	}
-
 	ret =3D i->f->bsg_request(job);
 	if (!ret)
 		return FC_DISPATCH_UNLOCKED;
@@ -3887,6 +3887,12 @@ enum fc_dispatch_result {
 	int cmdlen =3D sizeof(uint32_t);	/* start with length of msgcode */
 	int ret;
 =

+	/* check if we really have all the request data needed */
+	if (job->request_len < cmdlen) {
+		ret =3D -ENOMSG;
+		goto fail_rport_msg;
+	}
+
 	/* Validate the rport command */
 	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:



The rational behind this is, in fc_req_to_bsgjob() we're assigning
job->request as req->cmd and job->request_len =3D req->cmd_len. But without
checkinf job->request_len we don't know whether we're save to touch
job->request (a.k.a. bsg_request).

In the meanwhile I try to reproduce your report here.

Thanks,
	Johannes
-- =

Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
