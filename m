From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
Date: Fri, 27 Aug 2010 13:10:40 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.1008271306100.24692@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan> <AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Fri, 27 Aug 2010, adam radford wrote:

> Justin,
>
> This just means the firmware didn't complete an ioctl in 60 seconds.
>
> Can try changing this define in 3w-9xxx.h:
>
> #define TW_IOCTL_CHRDEV_TIMEOUT               60 /* 60 seconds */
>
> to 90 or 120 seconds to see if that fixes your issue?
>
> Thanks,
>
> -Adam
>

Hi Adam,

Thanks for responding!

LSI just got back to me on a second case, their latest beta firmware:
http://www.lsi.com/DistributionSystem/AssetDocument/readme.txt

SCR 2196:  Unexpected controller soft resets
Fixed an issue with regards to  deferral of write and read commands to 
help eliminate unexpected soft resets.

Well well!

Plan of action:

1. See if the error recurs without 'nobarrier' - only because there are 
some threads about problems when this is enabled on 3ware controllers.

2. LSI recommended I disconnect/replace my BBU module, I already did once 
before, ~$120, so the next step I will apply their latest Beta firmware.

3. If it STILL does it, I can increase the timeout, HOWEVER, when I see 
this, I/O on the system, everything locks up for 60-120-180-360 seconds 
and then it comes back after it resets the controller.  The weird thing is 
this controller is only for a /data volume and not the root filesystem. 
The root filesystem is on a separate RAID-1 4 port card (also w/BBU).

If you google that exact error, there is very little information, if I 
find something that works, I'll update the list so others have something 
to point to when they see this problem.

Justin.
