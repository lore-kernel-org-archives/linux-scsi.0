From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Fri, 14 Nov 2003 12:02:05 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FB4379D.3060708@torque.net>
References: <20031112155029.A20986@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:29192 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264500AbTKNCkY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 21:40:24 -0500
In-Reply-To: <20031112155029.A20986@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

Patrick Mansfield wrote:
> James - can you please apply? This should not affect other devices since
> we are not changing the requested length, just the size of the receive
> buffer.
> 
> This patch against a recent 2.6 bk fixes problems with Sony USB mass
> storage devices: they are sending back 10 bytes even when we ask for 8
> bytes (USB babble).
> 
> Just use a larger receive buffer for MODE SENSE even though we are
> requesting 8 bytes.
> 
> Tested by Ronald Kuetemei with his Sony camera, also tested with a USB CF
> card reader.
> 
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_lib.c modesense-bufflen-bk-2.5/drivers/scsi/scsi_lib.c
> --- bl-25/drivers/scsi/scsi_lib.c	Mon Sep 29 12:21:09 2003
> +++ modesense-bufflen-bk-2.5/drivers/scsi/scsi_lib.c	Mon Nov 10 15:42:03 2003

<snip>

>  
> +	WARN_ON((buf_len < 8) || (buf_len < len));
> +	if (buf_len > 255)
> +		buf_len = 255;
> +	if (len > 255)
> +		len = 255;

Patrick,
SPC-3 section 6.25 (REQUEST SENSE command) [spc3r15.pdf]
says the maximum allocation length should be 252 (not
255). They are steering alway from odd numbers and preferring
the next lower modulo 4 number.

<snip>

>  	if (!scsi_status_is_good(res))
> -		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);
> +		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, buf_len,
> +				       &data);

dito


Doug Gilbert


