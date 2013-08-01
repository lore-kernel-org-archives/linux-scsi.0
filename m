From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [PATCH] scsi disk: Use its own buffer for the vpd request
Date: Thu, 01 Aug 2013 16:37:47 +0200
Message-ID: <51FA72BB.9000609@fastmail.fm>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm> <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm> <87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net> <51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net> <51F94E8D.5040908@fastmail.fm> <51F95A2E.60805@fastmail.fm> <51FA71E2.6010501@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <51FA71E2.6010501@fastmail.fm>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nix <nix@esperi.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw, stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Whoops, the title is wrong, it should have been:

[PATCH] scsi disk: Limit get_vpd_page buf size

On 08/01/2013 04:34 PM, Bernd Schubert wrote:
> Once I noticed that scsi_get_vpd_page() works fine from other function
> calls and that it is not 0x89, but already 0x0 that fails fixing it became
> easy.
>
> Nix, any chance you could verify it also works for you?
>
>
> From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
>
> Somehow older areca firmware versions have issues with
> scsi_get_vpd_page() and a large buffer.
> Even scsi_get_vpd_page(, page=0,)  failed in sd_read_write_same(),
> while a similar request from sd_read_block_limits() worked fine.
> Limiting the buf-size to 64-bytes fixes the issue with F/W V1.46.
>
> Fixes a regression with areca controllers and older firmware versions
> introduced by commit: 66c28f97120e8a621afd5aa7a31c4b85c547d33d
>
> Reported-by: Nix <nix@esperi.org.uk>
> Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> CC: stable@vger.kernel.org
> ---
>   drivers/scsi/sd.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 80f39b8..02e50ae 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2651,13 +2651,16 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
>   	struct scsi_device *sdev = sdkp->device;
>
>   	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
> +		/* too large values might cause issues with arcmsr */
> +		int vpd_buf_len = 64;
> +
>   		sdev->no_report_opcodes = 1;
>
>   		/* Disable WRITE SAME if REPORT SUPPORTED OPERATION
>   		 * CODES is unsupported and the device has an ATA
>   		 * Information VPD page (SAT).
>   		 */
> -		if (!scsi_get_vpd_page(sdev, 0x89, buffer, SD_BUF_SIZE))
> +		if (!scsi_get_vpd_page(sdev, 0x89, buffer, vpd_buf_len))
>   			sdev->no_write_same = 1;
>   	}
>
>
