From: Andre Tomt <andre@tomt.net>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
Date: Wed, 04 Nov 2009 02:05:06 +0100
Message-ID: <4AF0D342.3090904@tomt.net>
References: <200909090414.41274.tfjellstrom@shaw.ca> <200909091030.13147.tfjellstrom@shaw.ca> <4AA7F965.6020408@garzik.org> <4AF0CFE1.8050407@tomt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4AF0CFE1.8050407@tomt.net>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: tfjellstrom@shaw.ca, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Andre Tomt wrote:
> Jeff Garzik wrote:
>> On 09/09/2009 12:30 PM, Thomas Fjellstrom wrote:
>>> No errors on that disk. Other than the one above, and its more of a 
>>> warning.
>>> However, I just rebooted to add some extra drives, thinking 
>>> everything was
>>> working a little better now that I've updated to 2.6.31-rc9, I'm 
>>> treated to
>>> the following two messages right after boot (and a system lockup to 
>>> boot):
> 
> Jeff & Co,
> 
> Just chiming in with a "me too" comment.
> 
> Identical issues with the AOC-SASLP-MV8 card with 8 Seagate Barracuda 
> 7200.11 1.5TB drives using the mvsas driver. Creating a md raid array 
> seems to trigger it nearly instantly, however other loads do not trigger 
> it as fast (if at all, only tested briefly with paralell dd).
> 
> Not sure if its related in any way, but I also noticed that with 
> parallell dd read on all ports, the card/driver tops out at 600MB/s even 
> though the card is in a northbridge connected slot running in x4 mode. 
> Only the first 4-5 ports run at nearly full speed, while the rest barely 
> gets to read any data at all. To illustrate, it looks sort of like this 
> in iostat -m:
> sda 122
> sdb 122
> sbc 120
> sdd 121
> sde 100
> sdf 10
> sdg 5
> sdh 5
> 
> Starting to think this driver has some issues with concurrency.. The 
> other controllers have no issues saturating all their ports, even if 
> they are on a south bridge connected slot.

Err, saturating all the disks. I'm not expecting 300MB/s*8, even though 
it would be very cool 8)

> 
> Same disks/setup works just fine on AHCI and sata_mv controllers on the 
> same computer, easily pushes 8-900MB/s with md software raid5/6 (Yipes!)
> 
