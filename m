From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Move SG_GET_SCSI_ID from sg to scsi
Date: Sun, 26 Mar 2006 14:30:12 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603261424590.15714@g5.osdl.org>
References: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:12427 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751164AbWCZWaQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Mar 2006 17:30:16 -0500
In-Reply-To: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Eggert <7eggert@gmx.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



On Sun, 26 Mar 2006, Bodo Eggert wrote:
>
> Having a SCSI ID is a generic SCSI property

No it's not.

Havign a SCSI ID is a f*cking idiotic thing to do.

Only idiots like Joerg Schilling thinks that any such thing even _exists_. 
It does not, never has, and never will.

The way you reach a SCSI device is through the device filename, and trying 
to use controller/channel/id/lun naming IS INSANE!

Stop it now. We should kill that ioctl, not try to make it look like it is 
sensible. It's not a sensible way to look up SCSI devices, and the fact 
that some SCSI people think it is is doesn't make it so.

The fact is, you CANNOT ID a SCSI device that way. Look at how /sys does 
it, and realize that there's a damn good reason we do it that way. We ID 
the same device in many different ways, because different people want to 
ID it differently.

You can ask "what's the first device we enumerated", you can ask "what's 
the physical path to the device" or you can ask "what's the intrisic UUID 
of the device". But the controller/channel/id/lun thing is just stupid. 
You can look it up that way if you want to, but I refuse to have idiotic 
interfaces that somehow try to make that the "official" name, when it 
clearly is NOT.

		Linus
