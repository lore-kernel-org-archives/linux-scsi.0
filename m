From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] scsi: allow persistent reservations without CAP_SYS_RAWIO
Date: Tue, 12 Jun 2012 13:08:58 -0400
Message-ID: <20439.30634.460606.215696@quad.stoffel.home>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, jbottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org


Paolo> Persistent reservations commands cannot be issued right now
Paolo> without giving CAP_SYS_RAWIO to the process who wishes to send
Paolo> them.  This is a bit heavy-handed, allow these two commands.

This seems like a bad idea, now anyone can just put in a SCSI
reservation on a system and then you have to hunt around trying to
figure it out.  

What's the motivation here?  What's the use case this solves?  

John



Paolo> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Paolo> ---
Paolo>         Ok for 3.5 as well?

Paolo>  block/scsi_ioctl.c |    2 ++
Paolo>  1 files changed, 2 insertions(+), 0 deletions(-)

Paolo> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
Paolo> index 260fa80..5d6c9c1 100644
Paolo> --- a/block/scsi_ioctl.c
Paolo> +++ b/block/scsi_ioctl.c
Paolo> @@ -137,6 +137,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
Paolo>  	__set_bit(SERVICE_ACTION_IN, filter->read_ok);
Paolo>  	__set_bit(RECEIVE_DIAGNOSTIC, filter->read_ok);
Paolo>  	__set_bit(MAINTENANCE_IN, filter->read_ok);
Paolo> +	__set_bit(PERSISTENT_RESERVE_IN, filter->read_ok);
Paolo>  	__set_bit(GPCMD_READ_BUFFER_CAPACITY, filter->read_ok);
 
Paolo>  	/* Audio CD commands */
Paolo> @@ -178,6 +179,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
Paolo>  	__set_bit(GPCMD_MODE_SELECT_10, filter->write_ok);
Paolo>  	__set_bit(MODE_SELECT, filter->write_ok);
Paolo>  	__set_bit(LOG_SELECT, filter->write_ok);
Paolo> +	__set_bit(PERSISTENT_RESERVE_OUT, filter->write_ok);
Paolo>  	__set_bit(GPCMD_BLANK, filter->write_ok);
Paolo>  	__set_bit(GPCMD_CLOSE_TRACK, filter->write_ok);
Paolo>  	__set_bit(GPCMD_FLUSH_CACHE, filter->write_ok);
Paolo> -- 
Paolo> 1.7.1

Paolo> --
Paolo> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Paolo> the body of a message to majordomo@vger.kernel.org
Paolo> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Paolo> Please read the FAQ at  http://www.tux.org/lkml/
