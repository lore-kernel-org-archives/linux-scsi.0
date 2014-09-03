From: Alfredo Dal Ava Junior <alfredo.junior@eldorado.org.br>
Subject: RES: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Wed, 3 Sep 2014 19:17:45 +0000
Message-ID: <0dd1959994514ab098456600a312237e@serv031.corp.eldorado.org.br>
References: <CAA6KcBCnns-nuE4LA4EqWGhEbisueBNwAjN7vtYcfBdKm2WyUA@mail.gmail.com>
 <Pine.LNX.4.44L0.1408301710120.4299-100000@netrider.rowland.org>
 <CAA6KcBBYbwxrCD3-W_frS5TLBVixMr-tBjhLp0HmoaDSRT==Cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.eldorado.org.br ([200.148.226.10]:8409 "EHLO
	smtp1.eldorado.org.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaICTRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 15:17:52 -0400
In-Reply-To: <CAA6KcBBYbwxrCD3-W_frS5TLBVixMr-tBjhLp0HmoaDSRT==Cw@mail.gmail.com>
Content-Language: pt-BR
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Alan Stern <stern@rowland.harvard.edu>
Cc: "Dale R. Worley" <worley@alum.mit.edu>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Sat, 30 Aug 2014, Matthew Dharm wrote 
> I was thinking of something that could notice a USB device which is formatted
> NTFS and has a partition table and filesystem that indicates a much bigger
> capacity than what the drive reports.  Under this circumstances, you could do
> something like pop-up a dialog box saying "this drive is confused -- is it 2TB or
> 3TB?"
> 
> Well, maybe that would say "Drive capacity is not consistent with partition
> table.  This can happen with certain USB drives designed for use with
> Windows.  Override drive capacity (emulating Windows)?"
> 
> You could imagine increasing complex heuristics to try to detect this scenario.
> Even without an automated helper program to do it, if there was a sysfs
> interface then when we got the periodic e-mails reporting this same type of
> problem, we could offer a quick-and-clean solution.


Hi Matt,

I did small hack to skip is_pte_valid() on efi.c  and now I have sdc1 partition listed on /proc/partition, but I hit other issue: ntfs-3g mount userspace tool that comes with Fedora now fails with "Failed to read last sector (7814037100): Invalid argument".  I also tried to override disk capacity, but SD driver fails with "Invalid command failure" and "Illegal Request" (I'll investigate it later)

Many places rely on disk capacity value, I think emulate Windows behavior for these HDD docks will not be an easy task.... 

[]'s
Alfredo
