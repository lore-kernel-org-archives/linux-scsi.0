From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: Re: [Patch] scsi_dh_rdac: retry IO for 06/3f/03 in
 rdac_check_sense fn
Date: Wed, 29 Sep 2010 22:09:08 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED704B593B6@inbmail01.lsi.com>
References: <1281404858.23351.6.camel@chandra-lucid.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1281404858.23351.6.camel@chandra-lucid.beaverton.ibm.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "sekharan@us.ibm.com" <sekharan@us.ibm.com>, James Bottomley <James.Bottomley@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi James,

For 06/3f/03 scsi sense, SUCCESS status is returned by scsi_check_sense. scsi_io_completion fn should have retried this check condition but some how it is not happening. IMO, command should be either retried by scsi or scsi dh rather than failing it (for this check condition). Can you please comment on this patch.  

Thanks,
Vijay

-----Original Message-----
From: Chandra Seetharaman [mailto:sekharan@us.ibm.com] 
Sent: Tuesday, August 10, 2010 7:18 AM
To: Chauhan, Vijay; James Bottomley
Cc: device-mapper development; linux-scsi@vger.kernel.org
Subject: Re: [Patch] scsi_dh_rdac: retry IO for 06/3f/03 in 
rdac_check_sense fn

Vijay,

Since it has to be handled at SCSI (and it is a SCSI sense), shouldn't
we be retrying it at SCSI level. James, what is your opinion ?

It looks good to me as the effect is local to LSI rdac storage.

chandra

On Mon, 2010-08-02 at 13:07 +0530, Chauhan, Vijay wrote:
> Hi,
> 
> This patch adds retry for the IO returned with 
06/3f/03((INQUIRY_DATA_CHANGED)) sense code  in 
rdac_check_sense(). IO returned with 06/3f/03 from controller 
are currently failed by scsi mid layer, as a reason momentarily 
path failure is noticed by DM multipath. 
> 
> Signed-off-by: Vijay Chauhan<vijay.chauhan@lsi.com>
> Reviewed-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> ---
> 
> diff -uprN 
linux-2.6.35-rc6-orig/drivers/scsi/device_handler/scsi_dh_rdac.c
 linux-2.6.35-rc6/drivers/scsi/device_handler/scsi_dh_rdac.c
> --- 
linux-2.6.35-rc6-orig/drivers/scsi/device_handler/scsi_dh
_rdac.c	2010-07-22 15:13:38.000000000 -0400
> +++ 
linux-2.6.35-rc6/drivers/scsi/device_handler/scsi_dh_rdac.c	
2010-07-27 12:13:58.000000000 -0400
> @@ -738,6 +738,11 @@ static int rdac_check_sense(struct scsi_
>  			 * Quiescence in progress , just retry.
>  			 */
>  			return ADD_TO_MLQUEUE;
> +		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
> +			/*
> +			 * INQUIRY DATA has changed, retry again.
> +			 */
> +			return ADD_TO_MLQUEUE;
>  		break;
>  	}
>  	/* success just means we do not care what scsi-ml does */
> 
> --
