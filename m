From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] libata support for rotation speed
Date: Sun, 22 Jun 2008 15:41:56 +0300
Message-ID: <485E4894.7000508@panasas.com>
References: <20080619160216.GH4392@parisc-linux.org> <20080619175904.GK4392@parisc-linux.org> <1213899895.3501.45.camel@localhost.localdomain> <20080619183113.GM4392@parisc-linux.org> <485AAD0D.9000205@garzik.org> <20080619191337.GO4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:17029 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751583AbYFVMmZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jun 2008 08:42:25 -0400
In-Reply-To: <20080619191337.GO4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jun 19, 2008 at 03:01:33PM -0400, Jeff Garzik wrote:
>> Matthew Wilcox wrote:
>>> On Thu, Jun 19, 2008 at 01:24:55PM -0500, James Bottomley wrote:
>>>> This looks like it can be called for ATA_DEV_ATAPI as well, in which
>>>> case it's an illegal page to ask for.
>>> I was under the impression that this entire file is only used for
>>> non-atapi devices.
>> Correct.  That code path is not travelled by ATAPI.
> 
> Thanks, Jeff.  Here's version three, including the form factor from word
> 168:
> 
> 
> Add support for VPD page b1 to libata
> 
> SCSI VPD page b1 reports the nominal rotation speed and physical size
> of the device.  Devices that conform to ATA-8 can return this information
> in words 217 and 168 of the identify data.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2e6e162..c08c3b9 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1778,7 +1778,9 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
>  	const u8 pages[] = {
>  		0x00,	/* page 0x00, this page */
>  		0x80,	/* page 0x80, unit serial no page */
> -		0x83	/* page 0x83, device ident page */
> +		0x83,	/* page 0x83, device ident page */
> +		0x89,	/* page 0x89, ata info page */
> +		0xb1,	/* page 0xb1, block device characteristics page */
>  	};
>  
>  	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
> @@ -1899,6 +1901,19 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
>  	return 0;
>  }
>  
> +static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
> +{
> +	rbuf[1] = 0xb1;
> +	rbuf[3] = 0x3c;
> +	if (ata_id_major_version(args->id) > 7) {
> +		rbuf[4] = args->id[217] >> 8;
> +		rbuf[5] = args->id[217];

args->id of struct ata_scsi_args are defined as u16.
Are they actually SWABed at this point? Are they LE? BE?

if args->id are actually __be16 then above should be
 +		put_unaligned(args->id[217], &rbuf[4]);
else
 +		put_unaligned_be16(args->id[217], &rbuf[4]);

> +		rbuf[7] = args->id[168] & 0xf;
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   *	ata_scsiop_noop - Command handler that simply returns success.
>   *	@args: device IDENTIFY data / SCSI command of interest.
> @@ -2922,6 +2937,9 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
>  		case 0x89:
>  			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_89);
>  			break;
> +		case 0xb1:
> +			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b1);
> +			break;
>  		default:
>  			ata_scsi_invalid_field(cmd, done);
>  			break;
> 

Just my $0.017
Boaz
