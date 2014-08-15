From: Ewan Milne <emilne@redhat.com>
Subject: Re: [RFC PATCH 05/10] scsi/trace: Use macros for getting driver
 byte, host byte, msg byte, and status byte
Date: Fri, 15 Aug 2014 11:10:16 -0400
Message-ID: <1408115416.1223.149.camel@localhost.localdomain>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
	 <20140808115017.6768.74578.stgit@yuno-kbuild.novalocal>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140808115017.6768.74578.stgit@yuno-kbuild.novalocal>
Sender: linux-kernel-owner@vger.kernel.org
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-08-08 at 11:50 +0000, Yoshihiro YUNOMAE wrote:
> For getting driver byte, host byte, msg byte, and status byte, macros are
> implemented in scsi/scsi.h, so we use it.
> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  include/trace/events/scsi.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index db6c935..8aecdc2 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -328,10 +328,10 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		  show_opcode_name(__entry->opcode),
>  		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
>  		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
> -		  show_driverbyte_name(((__entry->result) >> 24) & 0xff),
> -		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
> -		  show_msgbyte_name(((__entry->result) >> 8) & 0xff),
> -		  show_statusbyte_name(__entry->result & 0xff))
> +		  show_driverbyte_name(driver_byte(__entry->result)),
> +		  show_hostbyte_name(host_byte(__entry->result)),
> +		  show_msgbyte_name(msg_byte(__entry->result)),
> +		  show_statusbyte_name(status_byte(__entry->result)))
>  );
>  
>  DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

(Based upon Hannes' logging tree...)

Hannes, you should probably just update your tree with this.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
