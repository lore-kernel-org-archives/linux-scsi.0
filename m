From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 2/3] target: Add/check max_write_same_len device
 attribute + update block limits VPD
Date: Thu, 15 Nov 2012 12:38:06 -0800
Message-ID: <1353011886.11597.4.camel@haakon2.linux-iscsi.org>
References: <1353010439-4600-1-git-send-email-nab@linux-iscsi.org>
	 <1353010439-4600-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1353010439-4600-3-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliot <Elliott@hp.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-11-15 at 20:13 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a new max_write_same_len device attribute for use with
> WRITE_SAME w/ UNMAP=0 backend emulation.  This can be useful for
> lowering the default backend value (IBLOCK uses 0xFFFF).
> 
> Also, update block limits VPD emulation code in spc_emulate_evpd_b0() to
> report MAXIMUM WRITE SAME LENGTH, and enforce max_write_same_len during
> sbc_parse() -> sbc_setup_write_same() CDB sanity checking for all emulated
> WRITE_SAME w/ UNMAP=0 cases.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_configfs.c |    4 ++++
>  drivers/target/target_core_device.c   |   11 +++++++++++
>  drivers/target/target_core_internal.h |    1 +
>  drivers/target/target_core_sbc.c      |    8 ++++++++
>  drivers/target/target_core_spc.c      |    8 +++++++-
>  include/target/target_core_base.h     |    3 +++
>  6 files changed, 34 insertions(+), 1 deletions(-)
> 

<SNIP>

> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index a5a8f46..8dd8a802 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -238,6 +238,8 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
>  static sense_reason_t
>  sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *ops)
>  {
> +	unsigned int sectors = spc_get_write_same_sectors(cmd);
> +
>  	if ((flags[0] & 0x04) || (flags[0] & 0x02)) {
>  		pr_err("WRITE_SAME PBDATA and LBDATA"
>  			" bits not supported for Block Discard"
> @@ -258,6 +260,12 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
>  	if (!ops->execute_write_same)
>  		return TCM_UNSUPPORTED_SCSI_OPCODE;
>  
> +	if (sectors > cmd->se_dev->dev_attrib.max_write_same_len) {
> +		pr_warn("WRITE_SAME sectors: %u exceeds max_write_same_len: %u\n",
> +			sectors, cmd->se_dev->dev_attrib.max_write_same_len);
> +		return TCM_INVALID_CDB_FIELD;
> +	}
> +
>  	cmd->execute_cmd = ops->execute_write_same;
>  	return 0;
>  }

Now moving the max_write_same_len check above directly ahead of the
UNMAP conditional branch, so that both WRITE_SAME w/ UNMAP=[1,0] are
properly checked against this value as per hch's + Robert's input.

Thanks!

--nab
