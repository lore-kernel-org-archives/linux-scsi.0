From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: An oops will occur while SCSI core is being used in 3.4-rc1
Date: Wed, 11 Apr 2012 20:01:22 +0000
Message-ID: <4F85E312.6070205@acm.org>
References: <CAAxnys5O7PfWYv0q+BvhK2CP7X-_pNRa4j-Z1gSWHqLm8D8XmA@mail.gmail.com> <4F83EC71.90904@acm.org> <4F8461E3.3050808@cs.wisc.edu> <4F846398.5030609@cs.wisc.edu> <4F846506.4060801@cs.wisc.edu> <yq18vi2ckrj.fsf@sermon.lab.mkp.net> <4F85B3E8.7040704@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F85B3E8.7040704-HInyCGIudOg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Elric Fu <elricfu1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Bottomley <JBottomley-MU7nAjRaF3makBO8gow8eQ@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>, Alex He <alex.he-5C7GfCeVMHo@public.gmane.org>, Andiry Xu <andiry.xu-5C7GfCeVMHo@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux USB Mailing List <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/11/12 16:40, Bart Van Assche wrote:

> On 04/11/12 16:10, Martin K. Petersen wrote:
>> index 377df4a..1e11985 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
>> @@ -134,6 +134,9 @@ struct scsi_cmnd {
>>  
>>  static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
>>  {
>> +	if (!cmd->request->rq_disk)
>> +		return NULL;
>> +
>>  	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
>>  }
> 
> What if the rq_disk pointer is cleared by another kernel thread after it
> has been checked but before it is used ?


(replying to my own e-mail)

That comment didn't make sense - request.rq_disk is not modified after
it has been initialized. Yet it would make me more happy if
scsi_send_eh_cmnd() could be modified such that it doesn't have to
access struct scsi_driver.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
