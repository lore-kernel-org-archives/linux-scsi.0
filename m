From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] [RFC] Advanced TCA SCSI Disk Hotswap
Date: Thu, 24 Oct 2002 19:52:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DB887D5.5080500@pobox.com>
References: <200210242342.g9ONgGT04819@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Steven Dake <sdake@mvista.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James Bottomley wrote:

>>n Advanced TCA (what spawned this work) a button is pressed to
>>indicate  hotswap removal which makes for easy detection of hotswap
>>events.  This is why there are  kernel interfaces for removal and
>>insertion (so a kernel driver can be written to detect  the button
>>press and remove the devices from the os data structures and then
>>light a blue  led indicating safe for removal). 
>>    
>>
>
>OK, I understand what's going on now.  It's no different from those hotplug 
>PCI busses where you press the button and a second or so later the LED goes 
>out and you can remove the card.  10ms sounds rather a short maximum time for 
>a technician to wait for a light to go out....I suppose Telco technicians are 
>rather impatient.
>
>I really think you need to lengthen this interval.  The kernel is moving 
>towards this type of hotplug infrastructure which you can easily leverage (or 
>even help build), but it's definitely going to be mainly in user space.
>  
>


Caveat coder -- you also have to handle the case where the device is 
already gone, by the time you are notified of the hot-unplug event. 
 Some ejections are less friendly than others...  though from a SCSI 
standpoint, hopefully that case is easier -- error out all I/Os in 
flight, and unregister the host and device structures associated with 
the recently-removed host.  The devil, of course, is in the details ;-)

    Jeff




