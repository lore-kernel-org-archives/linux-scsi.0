From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: RE: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()
Date: Mon, 3 Jan 2011 10:35:40 +0800
Message-ID: <9ACDAD741D6D425FA95546BDA34DBAD0@arecaaebe11fae>
References: <4D1F5A17.4010807@gmail.com> <20110101170854.GB32652@parisc-linux.org> <4D1F7517.7080803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D1F7517.7080803@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: 'roel kluin' <roel.kluin@gmail.com>
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, 'LKML' <linux-kernel@vger.kernel.org>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, 'Matthew Wilcox' <matthew@wil.cx>, just.for.lkml@googlemail.com
List-Id: linux-scsi@vger.kernel.org

Hi Roel,
Thanks for your reminding.
I agree with you.
This patch is absolutely correct.
-----Original Message-----
From: roel kluin [mailto:roel.kluin@gmail.com] 
Sent: Sunday, January 02, 2011 2:40 AM
To: Matthew Wilcox; just.for.lkml@googlemail.com
Cc: nick.cheng@areca.com.tw; Andrew Morton; LKML; James.Bottomley@suse.de;
linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [SCSI] arcmsr: &/| confusion in arcmsr_build_ccb()

Make sure no other command which does a write, such as UNMAP and WRITE_32,
is missed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

If you agree this is the right fix, please ack.

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
b/drivers/scsi/arcmsr/arcmsr_hba.c
index 17e3df4..a5acedc 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1171,7 +1171,7 @@ static int arcmsr_build_ccb(struct AdapterControlBlock
*acb,
 	arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 :
0);
 	if ( arccdbsize > 256)
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
-	if (pcmd->cmnd[0]|WRITE_6 || pcmd->cmnd[0]|WRITE_10 ||
pcmd->cmnd[0]|WRITE_12 ){
+	if (pcmd->sc_data_direction == DMA_TO_DEVICE)
 		arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_WRITE;
 	}
 	ccb->arc_cdb_size = arccdbsize;
