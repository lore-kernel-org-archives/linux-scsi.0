From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention
 conditions
Date: Mon, 16 Jul 2012 17:18:23 +0100
Message-ID: <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-07-16 at 18:06 +0200, Paolo Bonzini wrote:
> Right now, I/O will fail as soon as a unit attention condition is
> detected on a unit with removable media.  However, this is not
> always necessary.  There are some cases (such as "Capacity data
> has changed") where no particular action is needed.  On the
> other hand, all problematic cases have to report at least one
> of "No medium" and/or a "Medium may have changed", so restrict
> our attention to those.
> 
> This patch fixes resizing a removable medium with virtio-scsi.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b583277..6d8ca08 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -843,8 +843,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	} else if (sense_valid && !sense_deferred) {
>  		switch (sshdr.sense_key) {
>  		case UNIT_ATTENTION:
> -			if (cmd->device->removable) {
> -				/* Detected disc change.  Set a bit
> +			if (cmd->device->removable &&
> +			    (sshdr.asc == 0x3a ||
> +			     (sshdr.asc == 0x28 && sshdr.ascq == 0x00))) {
> +				/* "No medium" or "Medium may have changed."
> +				 * This means a disc change.  Set a bit

This type of change would likely cause a huge cascade of errors in real
removable media devices.  Under the MMC standards, which a lot of the
older removable discs seem to follow, UNIT ATTENTION indicates either
medium change or device reset (which we check for and eat lower down);
we can't rely on them giving proper SBC-2 sense codes.  If you want to
pretend to be removable media, you have to conform to its standards.

James
