From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 07 Jan 2003 17:14:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E1B513B.2090409@splentec.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com> <3E1B2934.8060805@splentec.com> <20030107123301.A16378@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> Removing channel/target/lun from scsi_cmnd forces the LLDD to use the
> scsi_device (scmd->device-> channel/id/lun).

It forces them just as much as it forces them to use
cmd->{lun, target, channel}. I.e. none at all.

All LLDD have been converted to use cmd->device->{lun, id, channel}.

You must agree that the tuple (COMMAND, (lun, target, channel))
doesn't say as much as (COMMAND, DEVICE). Anywhich way you look at it,
this is a better abstraction. LUN is a property of a *SCSI* device,
and not of a SCSI command.

SCSI LLDD provide transport, this is their function and existence. We
need to represent the devices they provide and struct scsi_device is
good for it. Multipathing shouldn't be stuffed into it. More below.

> In order to allow selection of a path, we should abstract out the path
> information, not lump it into a single pointer reference (i.e. not
> scmd->device->lun) spread throughout the scsi mid and LLDD. If we had a
> single macro or function to access the host/channel/target/lun, the issue
> goes away, as there is only one point that we have to change for
> multi-path. But if they are hardcoded into scsi_device, I'll have to
> revert the changes for multi-path support.

Right, right, but this is the *first* step; let's get it out of scsi command
struct first. This opens up enough opportunities already. I.e. we're moving
the pertinent information *up* where it belongs.

BTW, in order to be able to do C::D::A(P) stuff as I mentioned in my previous
letter, you'd have to have the device being an *abstract* device, and
here we're dealing with SCSI devices which always have a LUN, for example.
This is in SAM-3 and is unavoidable.

For this reason you might consider the suggestions by Doug, or research moving
multipathing higher up into the char/block layer, or thereabouts.

SCSI Core is *SCSI*, it's function well defined in delivery/receipt of SCSI
commands and doing discovery of devices.

Somewhere between write(fd, buf, count) and scsi_request_fn(), multipathing
will have to have already occured (ideally).

> For scsi_device yes, but the LLDD does not have to look at scsi_device to
> send a command, it can currently use the values found in scsi_cmnd.

You see, by abstractizing this way, you get rid of redundancies,
which let's you do all those nice things which Doug mentioned.

Getting rid of redundancies in data design and code design is important.

> I don't see how 2) and 3) are tied into your changes. I can understand
> your changes leading to fewer changes for a common pool of all
> scsi_cmnd's.  But, we could also have a single pool if the
> host/channel/target/lun were set separtely from the allocation.

2 says that you can just grab the command and ``hook'' it
on the device via its list member. The mechanism is very
versatile -- take a look at it.

3 comes from discussions with ppl, some research and my own
implementation of a mini-scsi-core, but basically playing
with the list member. Putting command on different queues
depending on its status, etc.

> I haven't found any good research papers, if anyone knows of some please
> let me know (at least searching online, I should look in a real library).

A real library is your best bet. Papers are sometimes not available online,
but only in their respective periodicals due to copyright.

-- 
Luben



