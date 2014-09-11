From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [REGRESSION 3.17] scsi (uas) disks no longer using tagged command
 queuing
Date: Thu, 11 Sep 2014 12:01:13 +0200
Message-ID: <541172E9.8070309@redhat.com>
References: <540EC52C.3000804@redhat.com> <20140909152730.GA17882@infradead.org> <540FFBF4.9090001@redhat.com> <20140910154535.GA5102@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140910154535.GA5102-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 09/10/2014 05:45 PM, Christoph Hellwig wrote:
> On Wed, Sep 10, 2014 at 09:21:24AM +0200, Hans de Goede wrote:
>> I've applied the patch, this results in the following new dmesg output
>> when using uas:
>>
>> [  120.602632] initialized host-wide tag map!
>>
>> Thank you for looking into this.
> 
> So we're initializing the tag map, but scsi_activate_tcq doesn't pick it
> up.  I can't really come up with a good explanation for it, but there
> even without that there is an elephant in the room:  as part of the
> scsi-mq series I moved the bqt field used for this into a union with the
> new blk_mq_tag_set.  Below is a patch to get rid of that union, can you
> try if that fixes it?

Unfortunately that does not fix it :|

Regards,

Hans

> 
> 
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index d0f69a3..bcffff2 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -584,10 +584,8 @@ struct Scsi_Host {
>  	 * Area to keep a shared tag map (if needed, will be
>  	 * NULL if not).
>  	 */
> -	union {
> -		struct blk_queue_tag	*bqt;
> -		struct blk_mq_tag_set	tag_set;
> -	};
> +	struct blk_queue_tag	*bqt;
> +	struct blk_mq_tag_set	tag_set;
>  
>  	atomic_t host_busy;		   /* commands actually active on low-level */
>  	atomic_t host_blocked;
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
