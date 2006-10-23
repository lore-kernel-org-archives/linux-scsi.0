From: Steven Hayter <steven@hayter.me.uk>
Subject: Re: Mid-layer API?
Date: Mon, 23 Oct 2006 23:53:29 +0100
Message-ID: <453D47E9.8000606@hayter.me.uk>
References: <861B5CF71BC70C478DFEB9EAFE98F699ACB0DD@G3W0068.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 85.189.5.98 ([85.189.5.98]:16580 "EHLO zombie.undead")
	by vger.kernel.org with ESMTP id S1751993AbWJWWzs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Oct 2006 18:55:48 -0400
In-Reply-To: <861B5CF71BC70C478DFEB9EAFE98F699ACB0DD@G3W0068.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
Cc: ltuikov@yahoo.com, linux-scsi@vger.kernel.org

Haefliger, Juerg wrote:
 > Hi Luben,
 >
 > I did but I still don't get it :-) In fact I'm more confused now. Why
 > host_template? Isn't that function used to register an LLD with the
 > mid-layer? I'm trying to tap into the other side of the mid-layer.

On the driver side (HBA) you've got the host template, and queue_command().

On the other side (the interface used by sg/sd/st) used to live 
scsi_do_req() (gone in 2.6.18) which is now scsi_execute_async() and 
friends.

The header files/function templates should be fairly self-explanatory 
apart from the confusing use of old-style names, the 'void *buffer' is 
the scatter gather list, the 'unsigned buflen' is the total amount of 
data you want to transfer, and use_sg is the number of scatter-gather 
elements.

Hope that gives you some place to start with, if you just want to send 
SCSI commands into the kernel.

Regards,
Steve
