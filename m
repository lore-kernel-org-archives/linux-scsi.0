From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] mptfusion: fix msgContext in mptctl_hp_hostinfo
Date: Tue, 08 Mar 2011 15:12:04 +0100
Message-ID: <4D763934.2050901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab1CHOMI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2011 09:12:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: djeffery@redhat.com, Kashyap.Desai@lsi.com

Hi,

without this patch the istwiRWRequest->MsgContext is always set to zero,
this patch saves the MsgContext in a msgcontext variable and then restores 
the value.
Thanks to  <mailto:djeffery@redhat.com>David Jeffery who found the issue and did the analysis.


Signed-off-by: Tomas Henzl <thenzl@redhat.com>

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 4dbe546..43c0749 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2423,9 +2423,9 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	int			rc, cim_rev;
 	ToolboxIstwiReadWriteRequest_t	*IstwiRWRequest;
 	MPT_FRAME_HDR		*mf = NULL;
-	MPIHeader_t		*mpi_hdr;
 	unsigned long		timeleft;
 	int			retval;
+	u32			msgcontext;
 
 	/* Reset long to int. Should affect IA64 and SPARC only
 	 */
@@ -2572,11 +2572,11 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
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




