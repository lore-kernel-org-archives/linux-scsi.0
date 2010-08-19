From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/6] libata: Signal that our SATL supports WRITE
 SAME(16) with UNMAP
Date: Thu, 19 Aug 2010 11:15:51 -0500
Message-ID: <1282234551.8139.25.camel@mulgrave.site>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
	 <1282232941-9910-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282232941-9910-2-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-08-19 at 11:48 -0400, Martin K. Petersen wrote:
> Until now identifying that a device supports WRITE SAME(16) with the
> UNMAP bit set has been black magic.  Implement support for the new (SBC3
> r24) Thin Provisioning VPD page and the TPWS bit.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/ata/libata-scsi.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index a54273d..e280ae6 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2001,6 +2001,7 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
>  		0x89,	/* page 0x89, ata info page */
>  		0xb0,	/* page 0xb0, block limits page */
>  		0xb1,	/* page 0xb1, block device characteristics page */
> +		0xb2,	/* page 0xb2, thin provisioning page */

Should this be unconditional?  Shouldn't it be conditioned on the
current supported trim indicator (which is word 169 being non-zero
unless they've changed it yet again)?

James


