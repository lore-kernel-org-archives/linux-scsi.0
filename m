From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Mon, 14 Oct 2002 10:39:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210141739.g9EHdYX03416@localhost.localdomain>
References: <mdharm-scsi@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA31550
	for <linux-scsi@vger.kernel.org>; Mon, 14 Oct 2002 10:39:37 -0700
In-Reply-To: Message from Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
   of "Mon, 14 Oct 2002 10:30:59 PDT." <20021014103059.C9725@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: andersen@codepoet.org, linux-scsi@vger.kernel.org

mdharm-scsi@one-eyed-alien.net said:
> In userspace, something should get a new device notification and
> decide what to do with the new device. Format?  Mount?  Ignore?  But,
> it needs a /dev node to be able to handle the device, therefore the
> kernel must do the work up to that point. 

SCSI was designed with this in mind.  The add/remove-single-device API works 
before a dev node exists.  It expects four numeric parameters 
(host,channel,pun and lun), and will do the inquiry and attach the correct 
SCSI upper layer drivers.

Thus I still contend there's nothing you can get out of in-kernel exposure of 
these APIs that you couldn't do from a hotplug event.

I agree that we don't have the correct SCSI hot plugging in place today, but 
exposing in-kernel add/remove won't help with that.

James


