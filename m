From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] SCSI, SAS, MPT: memset all of struct sas_identify, not just
 size of a pointer bytes
Date: Sat, 29 Jan 2011 01:53:09 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1101290147120.6465@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

I have a hard time believing that the intention of this code in 
drivers/scsi/mpt2sas/mpt2sas_transport.c
    static int
    _transport_set_identify(struct MPT2SAS_ADAPTER *ioc, u16 handle,
        struct sas_identify *identify)
    {
    ...
    	memset(identify, 0, sizeof(identify));
    ...
really is to just memset() the first few bytes (size of the pointer) of 
the struct.

I believe what is intended is to memset() the entire struct.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mpt2sas_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

  compile tested only

diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index cb1cdec..9e86708 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -163,7 +163,7 @@ _transport_set_identify(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 		return -EIO;
 	}
 
-	memset(identify, 0, sizeof(identify));
+	memset(identify, 0, sizeof(*identify));
 	device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
 
 	/* sas_address */


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.
