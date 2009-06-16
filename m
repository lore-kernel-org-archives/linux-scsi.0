From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Return of PENDING status to SCSI driver
Date: Tue, 16 Jun 2009 11:22:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906161119210.4970-100000@iolanthe.rowland.org>
References: <3e7aae30906160809y32f0c8f6j3352cd1ec2bfe34a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55122 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754243AbZFPPWU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 11:22:20 -0400
In-Reply-To: <3e7aae30906160809y32f0c8f6j3352cd1ec2bfe34a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

On Tue, 16 Jun 2009, Ramya Desai wrote:

> static int queuecommand(struct scsi_cmnd *srb,
> 			void (*done)(struct scsi_cmnd *))
> {
> 		int res = 0;
> 	struct uas_task *task;
> 	struct us_data *us = host_to_us(srb->device->host);
> 	
> 	US_DEBUG(usb_stor_show_command(srb));
> 
> 	/* check for state-transition errors */
> 	if (us->srb != NULL) {

This test is your problem.  It will succeed as soon as you have 
accepted one command.  You need to remove it.

Alan Stern

