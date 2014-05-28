From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH, repost] mptfusion: fix msgContext in mptctl_hp_hostinfo
Date: Wed, 28 May 2014 18:04:20 +0200
Message-ID: <53860904.1090507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbaE1QE0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2014 12:04:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Desai, Kashyap" <Kashyap.Desai@avagotech.com>, David Jeffery <djeffery@redhat.com>

Hi,

without this patch the istwiRWRequest->MsgContext is always set to zero,
this patch saves the MsgContext in a msgcontext variable and then restores
the value.
Thanks to  David Jeffery who found the issue and did the analysis.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Desai, Kashyap <Kashyap.Desai@lsi.com>
---
 drivers/message/fusion/mptctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index dcc8385..8a050e8 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2432,9 +2432,9 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	int			rc, cim_rev;
 	ToolboxIstwiReadWriteRequest_t	*IstwiRWRequest;
 	MPT_FRAME_HDR		*mf = NULL;
-	MPIHeader_t		*mpi_hdr;
 	unsigned long		timeleft;
 	int			retval;
+	u32			msgcontext;
 
 	/* Reset long to int. Should affect IA64 and SPARC only
 	 */
@@ -2581,11 +2581,11 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	}
 
 	IstwiRWRequest = (ToolboxIstwiReadWriteRequest_t *)mf;
-	mpi_hdr = (MPIHeader_t *) mf;
+	msgcontext = IstwiRWRequest->MsgContext;
 	memset(IstwiRWRequest,0,sizeof(ToolboxIstwiReadWriteRequest_t));
+	IstwiRWRequest->MsgContext = msgcontext;
 	IstwiRWRequest->Function = MPI_FUNCTION_TOOLBOX;
 	IstwiRWRequest->Tool = MPI_TOOLBOX_ISTWI_READ_WRITE_TOOL;
-	IstwiRWRequest->MsgContext = mpi_hdr->MsgContext;
 	IstwiRWRequest->Flags = MPI_TB_ISTWI_FLAGS_READ;
 	IstwiRWRequest->NumAddressBytes = 0x01;
 	IstwiRWRequest->DataLength = cpu_to_le16(0x04);
-- 
1.8.3.1


