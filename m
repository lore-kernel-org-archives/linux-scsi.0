From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Tue, 5 May 2015 11:21:50 +0200
Message-ID: <55488BAE.7070006@sandisk.com>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
 <1430410094.102408.71.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430410094.102408.71.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/30/15 18:08, Doug Ledford wrote:
> On Thu, 2015-04-30 at 10:58 +0200, Bart Van Assche wrote:
>> @@ -2367,7 +2368,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
>>   	case IB_CM_DREQ_RECEIVED:
>>   		shost_printk(KERN_WARNING, target->scsi_host,
>>   			     PFX "DREQ received - connection closed\n");
>> -		srp_change_conn_state(target, false);
>> +		ch->connected = false;
>
> So, in this patch, you modify disconnect to set srp_change_conn_state()
> to false for the target, then loop through all the channels sending
> cm_dreq's, and on the receiving side, you modify the cm_dreq handler to
> set each channel to false.  However, once you get to 0 channels open,
> shouldn't you then set the target state to false too just to keep things
> consistent?

Hello Doug,

What is not visible in this patch but only in the ib_srp.c source code 
is that the first received DREQ initiates a reconnect (the queue_work() 
call below):

	case IB_CM_DREQ_RECEIVED:
		shost_printk(KERN_WARNING, target->scsi_host,
			     PFX "DREQ received - connection closed\n");
		ch->connected = false;
		if (ib_send_cm_drep(cm_id, NULL, 0))
			shost_printk(KERN_ERR, target->scsi_host,
				     PFX "Sending CM DREP failed\n");
		queue_work(system_long_wq, &target->tl_err_work);
		break;

That should be sufficient to restore communication after a DREQ has been 
received.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
