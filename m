From: Ramya Desai <ramya.desai@gmail.com>
Subject: Re: Return of PENDING status to SCSI driver
Date: Mon, 15 Jun 2009 20:12:33 +0530
Message-ID: <3e7aae30906150742l18e74a8fua5f08686c2c76454@mail.gmail.com>
References: <4A363EB4.8000102@panasas.com>
	 <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>
	 <3e7aae30906150707we781237o366950971d748b6f@mail.gmail.com>
	 <4A365BBE.3010708@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f173.google.com ([209.85.221.173]:39305 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761113AbZFOOmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2009 10:42:33 -0400
In-Reply-To: <4A365BBE.3010708@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

On 6/15/09, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 06/15/2009 05:07 PM, Ramya Desai wrote:
>  > On 6/15/09, Alan Stern <stern@rowland.harvard.edu> wrote:
>  >> On Mon, 15 Jun 2009, Boaz Harrosh wrote:
>  >>
>  >>  > >> If you are using the existing USB mass storage infrastructure then
>  >>  > >>  it will not work. This is because all commands are issued from a
>  >>  > >>  thread per host, which does a synchronous execution of one command
>  >>  > >>  at a time. In fact it does not even have a Q, but a global one cmnd
>  >>  > >>  pointer per host. And therefor sets can_queue to 1.
>  >>  > >>
>  >>  > >>  Are you using the existing USB infrastructure?
>  >>  > >>
>  >>  > >>
>  >>  > >>  Boaz
>  >>  > >>
>  >>  > > I am replacing the default USB mass storage driver with the one I am
>  >>  > > developing. But I am using the default SCSI and USB stack provided by
>  >>  > > Linux.
>  >>  > >
>  >>  > > So is there any another way to make my driver asynchronous?
>  >>  > >
>  >>  > > -RD
>  >>  >
>  >>  > I was afraid so.
>  >>  >
>  >>  > There is a lot of code you will need to change in current USB storage stack
>  >>  > SCSI is built with native support for queuing, but not so USB-storage-stack.
>  >>
>  >>
>  >> Boaz:
>  >>
>  >>  It looks like you didn't read Ramya's reply to your last message.
>  >>  Ramya isn't keeping the USB storage "stack" -- it is being replaced by
>  >>  a new driver -- so there's no point talking about making changes to it.
>  >>
>  >>
>  >>  Alan Stern
>  >>
>  >>
>  >
>  > I already have an array length of 10 for the bellow members.
>  >        struct scsi_cmnd        *srb;            /* current srb         */
>  >        unsigned int            tag;              /* current dCBWTag     */
>  >
>
>
> That's good
>
>
>  > I am maintaining an internal queue for the commands.
>  > My main problem is , I am not getting the next command in my USB
>  > storage driver ( My custom) , until the first command is done.
>  > How can I get the next command, while processing the first command?
>  >
>  > -Ramya
>
>
> Post the code you have missed something, I'll have a look
>
> Boaz
>

I can not post the code in public because of some limitations I have.
But Still I am confused with return status (to SCSI layer) for the
command while it is in progress, to get the next command. Is it some
thing like PENDING?

-RD
