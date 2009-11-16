From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: FC bus questions
Date: Mon, 16 Nov 2009 11:04:54 -0800
Message-ID: <F8639D79-7430-4A95-8B07-225D8BB54708@qlogic.com>
References: <1258397053.3331.10149.camel@fritz>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45546 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZKPTEt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2009 14:04:49 -0500
In-Reply-To: <1258397053.3331.10149.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: "James.Smart@Emulex.Com" <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>


On Nov 16, 2009, at 10:44 AM, Robert Love wrote:

> Hi James (and everyone else),
>
>   I wanted to continue the discussion on FCoE statistics and a  
> possible
> device tree reorganization. The original thread has been expired  
> from my
> mail system, so I have to start this new thread. The main theme was  
> that
> we might want to convert FC to be a bus.
>
>   For reference here is your proposed sysfs layout-
>
> /sys/.../fcportX/fcfportY/fcfabricZ/fcvportA/fcrportB
>                                            /fcpinitC/hostD/ 
> target<H:C:T>/<H:C:T>
>
>   I can see a benefit to extending the FC device tree. Assuming that
> each of these devices is created as they're discovered by the FC HBA
> then it's giving a more accurate description of the system's state.  
> For
> example, in FCoE if you were to succeed with FIP and discover a FCF,  
> but
> the FLOGI failed then user space could clearly see that devices were
> only created up to the fcfabric. I also think that it simply makes  
> more
> room for new attributes. With FCFs and FCoE attributes it would be  
> nice
> to have them better organized instead of just grouping them all under
> the fc_host.

Yes. I feel treating FC as bus make better understanding then host.  
This clearly has advantages.

Various FCoE attributes which are basically NIC specific but belongs  
to FCoE from protocol perspective can be grouped under FCoE directory  
to start with.

>
>
>   Aside from a sysfs reorganization, which could be done without  
> making
> FC a bus, the main benefit seems to be that other FC4 protocols could
> use a FC HBA. Is there other goodness that I'm overlooking?
>

Adding different FC4 protocols under FC HBA was not giving right sense  
from complete system perspective. For ex: adding FCoE specific
information in FC HBA. I feel the other approach will give much clarity.


>   Also, buses usually have devices and drivers. I'm not sure what the
> FC drivers would be since SCSI would ultimately provide the drivers  
> for
> SCSI-FCP. Would a FC bus only have devices and no drivers?
>
> Thanks, //Rob
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

