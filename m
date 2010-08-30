From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: 2.6.36-rc3: EIP is at scsi_init_io+...
Date: Mon, 30 Aug 2010 21:46:20 +0300
Message-ID: <20100830184620.GA4818@core2.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Not much of a calltrace, it scrolled away because of hardlockup detector.
On the bright side, radeon KMS worked correctly and actually showed it.

$ addr2line -e vmlinux ffffffff812d207b 
drivers/scsi/scsi_lib.c:1015 


   969	int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
   970	{
   971		int error = scsi_init_sgtable(cmd->request, &cmd->sdb, gfp_mask);
   972		if (error)
   973			goto err_exit;
   974	
   975		if (blk_bidi_rq(cmd->request)) {
   976			struct scsi_data_buffer *bidi_sdb = kmem_cache_zalloc(
   977				scsi_sdb_cache, GFP_ATOMIC);
   978			if (!bidi_sdb) {
   979				error = BLKPREP_DEFER;
   980				goto err_exit;
   981			}
   982	
   983			cmd->request->next_rq->special = bidi_sdb;
   984			error = scsi_init_sgtable(cmd->request->next_rq, bidi_sdb,
   985									    GFP_ATOMIC);
   986			if (error)
   987				goto err_exit;
   988		}
   989	
   990		if (blk_integrity_rq(cmd->request)) {
   991			struct scsi_data_buffer *prot_sdb = cmd->prot_sdb;
   992			int ivecs, count;
   993	
   994			BUG_ON(prot_sdb == NULL);
   995			ivecs = blk_rq_count_integrity_sg(cmd->request);
   996	
   997			if (scsi_alloc_sgtable(prot_sdb, ivecs, gfp_mask)) {
   998				error = BLKPREP_DEFER;
   999				goto err_exit;
  1000			}
  1001	
  1002			count = blk_rq_map_integrity_sg(cmd->request,
  1003							prot_sdb->table.sgl);
  1004			BUG_ON(unlikely(count > ivecs));
  1005	
  1006			cmd->prot_sdb = prot_sdb;
  1007			cmd->prot_sdb->table.nents = count;
  1008		}
  1009	
  1010		return BLKPREP_OK ;
  1011	
  1012	err_exit:
  1013		scsi_release_buffers(cmd);
  1014		scsi_put_command(cmd);
  1015	===>	cmd->request->special = NULL; <===
  1016		return error;
  1017	}
  1018	EXPORT_SYMBOL(scsi_init_io);
