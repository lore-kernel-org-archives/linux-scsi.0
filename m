From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Return of PENDING status to SCSI driver
Date: Mon, 15 Jun 2009 19:31:40 +0300
Message-ID: <4A36776C.5010208@panasas.com>
References: <4A363EB4.8000102@panasas.com>	 <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>	 <3e7aae30906150707we781237o366950971d748b6f@mail.gmail.com>	 <4A365BBE.3010708@panasas.com> <3e7aae30906150742l18e74a8fua5f08686c2c76454@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3e7aae30906150742l18e74a8fua5f08686c2c76454-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 06/15/2009 05:42 PM, Ramya Desai wrote:
> On 6/15/09, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org> wrote:
>> On 06/15/2009 05:07 PM, Ramya Desai wrote:
>>  > On 6/15/09, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
>>  >> On Mon, 15 Jun 2009, Boaz Harrosh wrote:
>>  >>
>>  >>  > >> If you are using the existing USB mass storage infrastructure then
>>  >>  > >>  it will not work. This is because all commands are issued from a
>>  >>  > >>  thread per host, which does a synchronous execution of one command
>>  >>  > >>  at a time. In fact it does not even have a Q, but a global one cmnd
>>  >>  > >>  pointer per host. And therefor sets can_queue to 1.
>>  >>  > >>
>>  >>  > >>  Are you using the existing USB infrastructure?
>>  >>  > >>
>>  >>  > >>
>>  >>  > >>  Boaz
>>  >>  > >>
>>  >>  > > I am replacing the default USB mass storage driver with the one I am
>>  >>  > > developing. But I am using the default SCSI and USB stack provided by
>>  >>  > > Linux.
>>  >>  > >
>>  >>  > > So is there any another way to make my driver asynchronous?
>>  >>  > >
>>  >>  > > -RD
>>  >>  >
>>  >>  > I was afraid so.
>>  >>  >
>>  >>  > There is a lot of code you will need to change in current USB storage stack
>>  >>  > SCSI is built with native support for queuing, but not so USB-storage-stack.
>>  >>
>>  >>
>>  >> Boaz:
>>  >>
>>  >>  It looks like you didn't read Ramya's reply to your last message.
>>  >>  Ramya isn't keeping the USB storage "stack" -- it is being replaced by
>>  >>  a new driver -- so there's no point talking about making changes to it.
>>  >>
>>  >>
>>  >>  Alan Stern
>>  >>
>>  >>
>>  >
>>  > I already have an array length of 10 for the bellow members.
>>  >        struct scsi_cmnd        *srb;            /* current srb         */
>>  >        unsigned int            tag;              /* current dCBWTag     */
>>  >
>>
>>
>> That's good
>>
>>
>>  > I am maintaining an internal queue for the commands.
>>  > My main problem is , I am not getting the next command in my USB
>>  > storage driver ( My custom) , until the first command is done.
>>  > How can I get the next command, while processing the first command?
>>  >
>>  > -Ramya
>>
>>
>> Post the code you have missed something, I'll have a look
>>
>> Boaz
>>
> 
> I can not post the code in public because of some limitations I have.

This is bulshit. Get your act together babe. You are hacking and deriving from
GPLed code. You are legally bind by that.

But you are welcome to remove any lowlevel rocket science from your driver
and just post the Linux relevant things. Infact why don't you start with a
demo driver that just emulates in SW IO transfers close to what your driver
will do. scsi_debug is a good place to look.

> But Still I am confused with return status (to SCSI layer) for the
> command while it is in progress, to get the next command. Is it some
> thing like PENDING?
> 

Look in scsi_debug enable some prints. It queues and completes cmnds
asynchronously. Look in Alan's other mail I think you are hit with the
usb queue_command posting the commands to a thread. This is unique to
usb.

> -RD

Boaz
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
