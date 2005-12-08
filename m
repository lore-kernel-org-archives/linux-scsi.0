From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Thu, 08 Dec 2005 20:27:42 +0100
Message-ID: <4398892E.10403@s5r6.in-berlin.de>
References: <200512072358.15398.adq_dvb@lidskialf.net> <200512080209.17757.adq_dvb@lidskialf.net> <43979E1A.30801@s5r6.in-berlin.de> <200512080319.19434.adq_dvb@lidskialf.net> <4397E643.8040307@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:21431 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932276AbVLHTaA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 14:30:00 -0500
In-Reply-To: <4397E643.8040307@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew de Quincey <adq_dvb@lidskialf.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

I wrote:
> Andrew de Quincey wrote:
>> USB storage devices still work with the CDROMEJECT ioctl and this 
>> change as well.
> 
> I'll check if they have a safeguard which sbp2 should have too.

I browsed a bit through usb/storage/ but did not spot an obvious sanity 
check of this kind. AFAIU, slightly differently arranged case 
discriminations let usb-storage avoid this pitfall.

Your patch to sbp2_create_command_orb() is basically the right thing to 
do --- not as an actual fix of the bogus transfer direction passed to 
sbp2 but rather as a protection against catastrophic failure. I'd like 
to integrate your check in marginally different form though. Patch 
follows shortly.

Thanks again.
-- 
Stefan Richter
-=====-=-=-= ==-- -=---
http://arcgraph.de/sr/
