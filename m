From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 07 Jan 2003 14:23:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E1B2934.8060805@splentec.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> For use with multi-path, it is very useful to have the path in the
> scsi_cmnd, and generally to not have the lldd's know about the scsi_device
> at all, such that we can pick a path, and send a scsi_cmnd to a lldd.

It shouldn't know about the path either. :-)
No one is forcing LLDD to peek into the device struct (but it will
have to, see below).

> Putting path information only in scsi_device makes it hard to do
> multi-path below (or even in) the block layer, and makes it hard to
> multi-path non block devices (like tape).
> 
> I would prefer we keep the current scsi_cmnd with its
> host/channel/target[id]/lun.

For multipathing there should be *no* distinction between
char and block devices sitting in fabric or on a SCSI Bus.

Conceptually you'd want to say SEND(C,D), where C is the
command and D is the device, or if the device D is a property
of the command C, you can do SEND(C), and the device is C::D.

A path or paths to a device is a property of the device D.
 From any point of view (user, kernel), a command C needs to
be sent to the device D, or simply the command C needs to
be sent, (where the device is C::D).  The SEND() will check
the paths which are property of the device and will
perform the desired action to send it (C) along the chosen
path P.  I.e. D::A is a collection of paths P, (0/1:N), and is a
property of the device, thus you get C::D::A.
This is object oriented design.

Currently, host/channel/target/lun *is* D::A all in *one*,
i.e. it is a device and a single path in one ugly lump
in the command struct. Thus, the more reason to get rid of
it (at least partially).

There are other advantages to these patches:
1. No redundant data (OOD).
2. Transparent command struct allocation/deallocaton
    via scsi_get_command() / scsi_put_command().
3. Improved queuing logic for SCSI Core, not yet ready,
    I'm just waiting for more input on this current stuff.

There must be enough research papers on multipathing, and
OS IO books should have a chapter on it. I just don't
have time to go to my alma mater's sci. library and do the
research since I do all this in my spare time.

-- 
Luben


