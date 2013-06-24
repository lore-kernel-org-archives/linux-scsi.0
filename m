From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Mon, 24 Jun 2013 17:50:12 +0200
Message-ID: <51C86AB4.1000906@acm.org>
References: <51C84E39.80806@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C84E39.80806-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 06/24/13 15:48, Jack Wang wrote:
>> I'm not sure it's possible to avoid such a race without introducing
>> a new mutex. How about something like the (untested) SCSI core patch
>> below, and invoking scsi_block_eh() and scsi_unblock_eh() around any
>> reconnect activity not initiated from the SCSI EH thread ?
>>
>> [PATCH] Add scsi_block_eh() and scsi_unblock_eh()
>>
> Hi Bart,
>
> The description doesn't match the code at all, do you mean try to
> serialize the reconnect activity with this new block_eh_mutex?

In case it wasn't clear, the actual scsi_block_eh() and 
scsi_unblock_eh() calls aren't present in the patch I posted, only their 
implementation.

P.S.: please fix your e-mail client such that it does not break e-mail 
threading. There are no "In-Reply-To:" tags in the header of your e-mails.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
