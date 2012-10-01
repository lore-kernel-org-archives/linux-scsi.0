From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] [SCSI] virtio-scsi: Initialize scatterlist structure.
Date: Mon, 01 Oct 2012 15:21:03 +0200
Message-ID: <506998BF.8000909@redhat.com>
References: <1345471490-17289-1-git-send-email-rjones@redhat.com> <50324439.1000307@redhat.com> <506996DD.30300@redhat.com> <20121001131859.GC24071@rhmail.home.annexia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab2JANVH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Oct 2012 09:21:07 -0400
In-Reply-To: <20121001131859.GC24071@rhmail.home.annexia.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Il 01/10/2012 15:18, Richard W.M. Jones ha scritto:
> On Mon, Oct 01, 2012 at 03:13:01PM +0200, Paolo Bonzini wrote:
>> Il 20/08/2012 16:05, Paolo Bonzini ha scritto:
>>> Il 20/08/2012 16:04, Richard W.M. Jones ha scritto:
>>>> From: "Richard W.M. Jones" <rjones@redhat.com>
>>>>
>>>> The sg struct is used without being initialized.
>>>>
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=847548
>>>>
>>>> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
>>>> ---
>>>>  drivers/scsi/virtio_scsi.c |    2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>>>> index c7030fb..8a66f83 100644
>>>> --- a/drivers/scsi/virtio_scsi.c
>>>> +++ b/drivers/scsi/virtio_scsi.c
>>>> @@ -219,7 +219,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>>>>  	struct scatterlist sg;
>>>>  	unsigned long flags;
>>>>  
>>>> -	sg_set_buf(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
>>>> +	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
>>>>  
>>>>  	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
>>>>  
>>>>
>>>
>>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>>
>> Ping, is this patch going into 3.7?
> 
> I was a bit surprised to see this wasn't upstream since it's vital for
> using virtio-scsi reliably (as well as being a one line fix for a
> blatant bug).

Indeed I enclosed it in a submission named "[PATCH for 3.6] urgent
virtio-scsi fixes"
(http://permalink.gmane.org/gmane.linux.kernel/1350337)...

Paolo
