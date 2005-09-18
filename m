From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sun, 18 Sep 2005 10:46:33 -0500
Message-ID: <432D8BD9.2070300@cs.wisc.edu>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu> <1126974325.10413.5.camel@max> <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local> <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu> <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:29138 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932141AbVIRRqn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 13:46:43 -0400
In-Reply-To: <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai Makisara wrote:
> 
> init_command() is _not_ called. I added a printk to it and it did not 
> print anything. If you look at scsi_prep_fn(), init_command() is called 
> only if req->rq_disk is set. scsi_execute_async() does not set it.

oh yeah, sorry. I meant to add that back but would have had to add 
another argument to the scsi_execute* functions since I could not figure 
out how to go from scsi_device or request_queue to disk.

> 
> Setting command parameters through the separate init_command() function 
> seems like a horrible idea. You have to do hacks to pass the information.

This is how sd works :(

> The command triggering these problems is a 6-byte read of 10240 bytes. It 
> should not a this point return anything but finish with some sense data.
> 
> I am debugging the problem but it is going slowly because the system disk 
> is a SCSI disk. I have to be careful with the debugging output and changes 
> outside st.c require a reboot ;-) So far I have found out that 
> scsi_check_sense() is called correctly and returns SUCCESS as it should. 
> What happens after that is a mystery.
> 

ok
