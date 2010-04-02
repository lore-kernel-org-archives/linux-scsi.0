From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: 2.6.34-rc3 : Badness at lib/dma-debug.c:820 during ibmvscsi init
Date: Fri, 2 Apr 2010 15:12:54 +0900
Message-ID: <20100402151229V.fujita.tomonori@lab.ntt.co.jp>
References: <4BB57E3F.3050502@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <4BB57E3F.3050502@in.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
To: sachinp@in.ibm.com
Cc: brking@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 02 Apr 2010 10:48:55 +0530
Sachin Sant <sachinp@in.ibm.com> wrote:

> 2.6.34-rc3 boot on a power5 box produces this badness message
> during ibmvscsi initialization.
> 
> ibmvscsi 30000003: Client reserve enabled
> ibmvscsi 30000003: sent SRP login
> ibmvscsi 30000003: SRP_LOGIN succeeded
> ibmvscsi 30000003: DMA-API: device driver frees DMA memory with wrong function [device address=0x0000000000011520] [size=36 bytes] [mapped as scather-gather] [unmapped as single]

ibmvscsi has been incompatible with the dma debug facility, I
guess. The driver uses dma_unmap_single for buffers mapped via
dma_map_sg. It works but it's the API violation.

Does this patch work?

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index dc1bcbe..0856436 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -322,16 +322,6 @@ static void set_srp_direction(struct scsi_cmnd *cmd,
 		srp_cmd->buf_fmt = fmt;
 }
 
-static void unmap_sg_list(int num_entries,
-		struct device *dev,
-		struct srp_direct_buf *md)
-{
-	int i;
-
-	for (i = 0; i < num_entries; ++i)
-		dma_unmap_single(dev, md[i].va, md[i].len, DMA_BIDIRECTIONAL);
-}
-
 /**
  * unmap_cmd_data: - Unmap data pointed in srp_cmd based on the format
  * @cmd:	srp_cmd whose additional_data member will be unmapped
@@ -349,24 +339,9 @@ static void unmap_cmd_data(struct srp_cmd *cmd,
 
 	if (out_fmt == SRP_NO_DATA_DESC && in_fmt == SRP_NO_DATA_DESC)
 		return;
-	else if (out_fmt == SRP_DATA_DESC_DIRECT ||
-		 in_fmt == SRP_DATA_DESC_DIRECT) {
-		struct srp_direct_buf *data =
-			(struct srp_direct_buf *) cmd->add_data;
-		dma_unmap_single(dev, data->va, data->len, DMA_BIDIRECTIONAL);
-	} else {
-		struct srp_indirect_buf *indirect =
-			(struct srp_indirect_buf *) cmd->add_data;
-		int num_mapped = indirect->table_desc.len /
-			sizeof(struct srp_direct_buf);
 
-		if (num_mapped <= MAX_INDIRECT_BUFS) {
-			unmap_sg_list(num_mapped, dev, &indirect->desc_list[0]);
-			return;
-		}
-
-		unmap_sg_list(num_mapped, dev, evt_struct->ext_list);
-	}
+	if (evt_struct->cmnd)
+		scsi_dma_unmap(evt_struct->cmnd);
 }
 
 static int map_sg_list(struct scsi_cmnd *cmd, int nseg,
