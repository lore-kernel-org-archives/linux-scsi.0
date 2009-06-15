From: Ramya Desai <ramya.desai@gmail.com>
Subject: Re: Return of PENDING status to SCSI driver
Date: Mon, 15 Jun 2009 19:37:38 +0530
Message-ID: <3e7aae30906150707we781237o366950971d748b6f@mail.gmail.com>
References: <4A363EB4.8000102@panasas.com>
	 <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:35594 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbZFOOHg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2009 10:07:36 -0400
In-Reply-To: <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

On 6/15/09, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 15 Jun 2009, Boaz Harrosh wrote:
>
>  > >> If you are using the existing USB mass storage infrastructure then
>  > >>  it will not work. This is because all commands are issued from a
>  > >>  thread per host, which does a synchronous execution of one command
>  > >>  at a time. In fact it does not even have a Q, but a global one cmnd
>  > >>  pointer per host. And therefor sets can_queue to 1.
>  > >>
>  > >>  Are you using the existing USB infrastructure?
>  > >>
>  > >>
>  > >>  Boaz
>  > >>
>  > > I am replacing the default USB mass storage driver with the one I am
>  > > developing. But I am using the default SCSI and USB stack provided by
>  > > Linux.
>  > >
>  > > So is there any another way to make my driver asynchronous?
>  > >
>  > > -RD
>  >
>  > I was afraid so.
>  >
>  > There is a lot of code you will need to change in current USB storage stack
>  > SCSI is built with native support for queuing, but not so USB-storage-stack.
>
>
> Boaz:
>
>  It looks like you didn't read Ramya's reply to your last message.
>  Ramya isn't keeping the USB storage "stack" -- it is being replaced by
>  a new driver -- so there's no point talking about making changes to it.
>
>
>  Alan Stern
>
>

I already have an array length of 10 for the bellow members.
       struct scsi_cmnd        *srb;            /* current srb         */
       unsigned int            tag;              /* current dCBWTag     */

I am maintaining an internal queue for the commands.
My main problem is , I am not getting the next command in my USB
storage driver ( My custom) , until the first command is done.
How can I get the next command, while processing the first command?

-Ramya
