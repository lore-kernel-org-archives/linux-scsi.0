From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ses: Fix out-of-bounds memory access in ses_enclosure_data_process()
Date: Tue, 21 May 2019 08:02:48 -0400
Message-ID: <yq1h89o6mmv.fsf@oracle.com>
References: <20190501180535.26718-1-longman@redhat.com>
        <1fd39969-4413-2f11-86b2-729787680efa@redhat.com>
        <1558363938.3742.1.camel@linux.ibm.com>
        <3385cf54-7b6c-3f28-e037-f0d4037368eb@redhat.com>
        <1558367212.3742.10.camel@linux.ibm.com> <yq1zhnh8625.fsf@oracle.com>
        <c14d427c-1d17-fc8f-672d-d612851abcc1@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c14d427c-1d17-fc8f-672d-d612851abcc1@interlog.com> (Douglas
        Gilbert's message of "Mon, 20 May 2019 17:53:08 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.ibm.com>, Waiman Long <longman@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Doug,

>> I am collecting "bad" SES pages from these devices. I have added
>> support for RECEIVE DIAGNOSTICS to scsi_debug and added a bunch of
>> deliberately broken SES pages so we could debug this
>
> Patches ??

I have included the plumbing below. However, I need to synthesize the
contents of the pages with problems. I can't share the ones I have
received from customers so I removed the arrays from the patch.

-- 
Martin K. Petersen	Oracle Linux Engineering

>From 968dfc5cd498d2ea6e77801cc9b9183a1a28b35d Mon Sep 17 00:00:00 2001
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 28 Mar 2019 22:29:13 -0400
Subject: [PATCH] scsi: scsi_debug: Implement support for Receive Diagnostics
 command

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2740a90501a0..db8745a7000e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -356,7 +356,8 @@ enum sdeb_opcode_index {
 	SDEB_I_WRITE_SAME = 26,		/* 10, 16 */
 	SDEB_I_SYNC_CACHE = 27,		/* 10, 16 */
 	SDEB_I_COMP_WRITE = 28,
-	SDEB_I_LAST_ELEMENT = 29,	/* keep this last (previous + 1) */
+	SDEB_I_RECV_DIAG = 29,
+	SDEB_I_LAST_ELEMENT = 30,	/* keep this last (previous + 1) */
 };
 
 
@@ -367,8 +368,8 @@ static const unsigned char opcode_ind_arr[256] = {
 	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, 0,
 	0, 0, SDEB_I_INQUIRY, 0, 0, SDEB_I_MODE_SELECT, SDEB_I_RESERVE,
 	    SDEB_I_RELEASE,
-	0, 0, SDEB_I_MODE_SENSE, SDEB_I_START_STOP, 0, SDEB_I_SEND_DIAG,
-	    SDEB_I_ALLOW_REMOVAL, 0,
+	0, 0, SDEB_I_MODE_SENSE, SDEB_I_START_STOP, SDEB_I_RECV_DIAG,
+	SDEB_I_SEND_DIAG, SDEB_I_ALLOW_REMOVAL, 0,
 /* 0x20; 0x20->0x3f: 10 byte cdbs */
 	0, 0, 0, 0, 0, SDEB_I_READ_CAPACITY, 0, 0,
 	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, SDEB_I_VERIFY,
@@ -433,6 +434,7 @@ static int resp_write_same_16(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_sync_cache(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_recv_diag(struct scsi_cmnd *, struct sdebug_dev_info *);
 
 /*
  * The following are overflow arrays for cdbs that "hit" the same index in
@@ -613,8 +615,9 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	{0, 0x89, 0, F_D_OUT | FF_MEDIA_IO, resp_comp_write, NULL,
 	    {16,  0xf8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0, 0,
 	     0, 0xff, 0x3f, 0xc7} },		/* COMPARE AND WRITE */
-
-/* 29 */
+	{0, 0x1c, 0, FF_RESPOND | F_D_IN, resp_recv_diag, NULL, /* RECV DIAG */
+	    {6,  0x1, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+/* 30 */
 	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 };
@@ -1516,7 +1519,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	arr[5] = (int)have_dif_prot;	/* PROTECT bit */
 	if (sdebug_vpd_use_hostno == 0)
 		arr[5] |= 0x10; /* claim: implicit TPGS */
-	arr[6] = 0x10; /* claim: MultiP */
+	arr[6] = 0x10 | 0x40; /* claim: MultiP */
 	/* arr[6] |= 0x40; ... claim: EncServ (enclosure services) */
 	arr[7] = 0xa; /* claim: LINKED + CMDQUE */
 	memcpy(&arr[8], sdebug_inq_vendor_id, 8);
@@ -3597,6 +3600,36 @@ static int resp_sync_cache(struct scsi_cmnd *scp,
 	return res;
 }
 
+static unsigned char diag0[] = {
+	0x00, 0x00, 0x00, 0x07, 0x00, 0x01, 0x02, 0x06, 0x07, 0x0a, 0xa0, 0x00,
+};
+#define DIAG0_LEN 12
+
+
+static int resp_recv_diag(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	unsigned char *cmd = scp->cmnd;
+
+	switch(cmd[2]) {
+	case 0:
+		return fill_from_dev_buffer(scp, diag0, DIAG0_LEN);
+	case 1:
+		return fill_from_dev_buffer(scp, diag1, DIAG1_LEN);
+	case 2:
+		return fill_from_dev_buffer(scp, diag2, DIAG2_LEN);
+	case 6:
+		return fill_from_dev_buffer(scp, diag6, DIAG6_LEN);
+	case 7:
+		return fill_from_dev_buffer(scp, diag7, DIAG7_LEN);
+	case 0xa:
+		return fill_from_dev_buffer(scp, diaga, DIAGA_LEN);
+	case 0xa0:
+		return fill_from_dev_buffer(scp, diaga0, DIAGA0_LEN);
+	}
+
+	return DID_ERROR << 16;
+}
+
 #define RL_BUCKET_ELEMS 8
 
 /* Even though each pseudo target has a REPORT LUNS "well known logical unit"
