From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH / RFC] osst, st, sg sysfs removes
Date: Sat, 11 Jan 2003 10:48:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111154802.GS1378@linnie.riede.org>
References: <20030109222107.GA5041@beaverton.ibm.com> <Pine.LNX.4.50.0301111416510.2294-100000@kai.makisara.local>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.50.0301111416510.2294-100000@kai.makisara.local>; from Kai.Makisara@kolumbus.fi on Sat, Jan 11, 2003 at 07:25:25 -0500
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org, Matt_Domsch@Dell.com, Douglas Gilbert <dougg@torque.net>, mochel@osdl.org

On 2003.01.11 07:25 Kai Makisara wrote:
> On Thu, 9 Jan 2003, Mike Anderson wrote:
> 
> > This patch is against 2.5.55
> >
> > This patch is in response to the mail I sent the other day on the use of
> > to_scsi_device with our sysfs bus/scsi/devices directory containing more
> > than struct scsi_device objects. A link to the thread is below.
> >
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=104198504307087&w=2
> >
> > This patch is just a removal of osst, st, and sg's sysfs nodes in the
> > devices directory. Current I do not have a place to replicate this
> > capability. It was unclear if osst and st entries where being used. The
> > correct place for osst and st is to have a char tree like the block tree
> > and have a pointer from the scsi device to the char entry. I do not know
> 
> Looks OK to me (at least the st part). I have been planning to export some
> settings in the directories this patch removes but it has to wait until
> corresponding entries can be created into the (currently non-existent)
> char tree.
> 
> While looking at the sysfs/bus/scsi tree after this patch, I noticed that
> all devices currently get linked to the sd driver:
> 
> 14:20:59> ll /devices/bus/scsi/drivers/sd
> total 0
> lrwxrwxrwx    1 root     root           40 2003-01-11 00:14 0:0:0:0 ->
> ../../../../devices/pci0/00:0e.1/0:0:0:0/
> lrwxrwxrwx    1 root     root           40 2003-01-11 00:14 1:0:5:0 ->
> ../../../../devices/pci0/00:0e.0/1:0:5:0/
> lrwxrwxrwx    1 root     root           40 2003-01-11 00:14 1:0:5:1 ->
> ../../../../devices/pci0/00:0e.0/1:0:5:1/
> lrwxrwxrwx    1 root     root           36 2003-01-11 00:14 2:0:0:0 ->
> ../../../../devices/ide-scsi/2:0:0:0/
> 
> (0:0:0:0 is a disk, 1:0:5:0 a tape, 1:0:5:1 a changer (not attached to any
> high-level driver!), 2:0:0:0 a cdrom)
> 
> The entries for sr and st do exist but are empty. sg is populated.
> 
On my system -- osst testing -- I see the following files (before 
applying the above patch):

/sysfs/bus/scsi/drivers/sd/2:0:1:0:ota
/sysfs/bus/scsi/drivers/sd/0:0:3:0:ota
/sysfs/bus/scsi/devices/2:0:1:0:ota
/sysfs/bus/scsi/devices/0:0:3:0:ota
/sysfs/devices/ide-scsi/2:0:1:0/2:0:1:0:ota
/sysfs/devices/pci0/00:0e.0/0:0:3:0/0:0:3:0:ota

I have two osst devices active, one scsi = 0:0:3:0, one ide = 2:0:1:0.
USB and Ieee1394 drives exist, but weren't active.

Actually each line above exists for {ot|ota|otl|otm|otn|otan|otln|otmn},
four modes, rewinding and non-rewinding.

The entries under bus/scsi/drivers/sd and bus/scsi/devices are symlinks,
the devices/ide-scsi and devices/pci0 are directories.

Now that Kai mentions it, why should drivers/sd have an entry for tapes at 
all? Shouldn't that be in drivers/st in his case, drivers/osst for me, and 
drivers/sg for Doug? drivers/osst does exist on my system.

Now, if I understand Mike correctly, the entires under /devices should
move to /char -- which doesn't exist, but should be modeled after /block.

That directory contains on my system: fd[01] hda loop[0-7] ram[0-15] sda sdb
where hda is a cdrom and sd[ab] hard disks.

So from that analogy, I take it, that /char should contain st[0-N], osst[0-M]
and sg[0-L], with the mode and {non}rewind variants for tapes as appropriate,
agreed?

Each directory should then have the old files kdev, name, power and type that
existed before? Plus whatever extra files Kai, Doug and I feel the user might
be interested in and that in 2.4 one might find in /proc somewehere?

Thanks for your guidance. Willem Riede.


