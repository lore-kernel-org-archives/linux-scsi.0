From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Thu, 23 May 2002 08:44:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205231244.g4NCiY001769@localhost.localdomain>
References: <ARZEH@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id FAA32413
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2002 05:44:37 -0700
In-Reply-To: Message from "Aron Zeh" <ARZEH@de.ibm.com>
   of "Thu, 23 May 2002 11:18:54 +0200." <OFD184E35E.964CC6B1-ONC1256BC2.003294BC@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Aron Zeh <ARZEH@de.ibm.com>
Cc: Doug Ledford <dledford@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, patman@beaverton.ibm.com, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

> Alas, there does not seem to be a timeout handler to restart IO when
> queuecommand returned non 0. The only way to retrigger IO seems to be
> a completion of an outstanding command. I have seen a lot of hangs in
> the FCP driver I am contributing to because of this. We finally
> decided never to let queuecommand fail and queue failed requests
> internally while there might still be a chance to send them. This is
> not too nice though, so it would probably be a good idea to use a
> timeout as an alternative trigger to resend commands in the mlqueue.
> Maybe a function to be called by the low-level driver would also be an
> option. 

I've seen it too occasionally, but I can't reproduce it consistently enough.  
I think the culprit may be our use of _elv_add_request with a no-plug 
argument.  Can you just change the last argument from 0 to 1 and see if this 
helps (in scsi_lib.c:__scsi_insert_special at about line 90)?

James


