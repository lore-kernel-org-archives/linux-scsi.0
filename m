From: arvindY <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] scsi: scsi_transport_iscsi: use put_device() instead of
 kfree()
Date: Sat, 17 Mar 2018 15:07:52 +0530
Message-ID: <5AACE1F0.1080109@gmail.com>
References: <a77739e256b044c2e125e106165efc751ce4a0f6.1520422535.git.arvind.yadav.cs@gmail.com>
 <20180315174448.GB32176@straylight.hirudinean.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Return-path: <open-iscsi+bncBD76TE7NVICBB56DWPKQKGQEPWKU3OQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20180315174448.GB32176-r8IHplWLGbA5tHQWs+pTeqPFFGjUI2lm2LY78lusg7I@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lduncan-IBi9RG/b67k@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org



On Thursday 15 March 2018 11:14 PM, Chris Leech wrote:
> On Wed, Mar 07, 2018 at 05:07:33PM +0530, Arvind Yadav wrote:
>> Never directly free @dev after calling device_register(), even
>> if it returned an error! Always use put_device() to give up the
>> reference initialized.
>>
>> Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>   drivers/scsi/scsi_transport_iscsi.c | 27 +++++++++++++--------------
>>   1 file changed, 13 insertions(+), 14 deletions(-)
>>
>> @@ -783,7 +781,7 @@ struct iscsi_iface *
>>   
>>   free_iface:
>>   	put_device(iface->dev.parent);
>> -	kfree(iface);
>> +	put_device(&iface->dev);
>>   	return NULL;
>>   }
>>   EXPORT_SYMBOL_GPL(iscsi_create_iface);
> Am I reading the device code correctly that the parent reference is only
> released in the unregister path (device_unregister calls device_del) and
> so the manual put_device on the parent here is still correct?
>
> Just want to make sure that's still needed with the call to put_device.
The manual put_device on the parent is not correct.
This should be removed for here. we should call
put_device(&iface->dev) only and It'll released
parent reference.

> Other than that question, I this all looks good.
> Thanks.
>
> Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

~arvind

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
