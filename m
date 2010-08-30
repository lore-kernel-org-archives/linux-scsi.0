From: Nathan Wan <nlw@andrew.cmu.edu>
Subject: Re: ssd's and iops testing
Date: Mon, 30 Aug 2010 17:21:54 -0400
Message-ID: <AANLkTi=XMndNRm5awJMkY-kwF7dFXvVJ5Nk7nDfhZh68@mail.gmail.com>
References: <AANLkTi=TUG_nH7oNDNHBkmtGaJHgBwtC6Y-KRWrRfgD9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=TUG_nH7oNDNHBkmtGaJHgBwtC6Y-KRWrRfgD9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Nathan Wan <nlw@andrew.cmu.edu>
List-Id: linux-scsi@vger.kernel.org

Hello,

This is a first post for me on a linux list so please forgive if I am
doing it wrong.

I'm looking for some advice about the scsi subsystem and the linux
kernel.  I am writing a module to test the capabilities of particular
i/o hardware configurations. Specifically, I am trying to bypass the
block io system to identify bottlenecks for less powerful cpu's paired
with solid state drives (e.g. an Intel Atom processor with an SSD
capable of 60K iops).

My goal is to make a module that will saturate the ncq of the drive
and see if it is possible for the cpu keep up with the drive.  I am
doing this by creating scsi commands that read random sectors off the
disk.  Essentially the module mimics the role of the block layer,
performing operations similar to the request function
(scsi_request_fn) and the sd_prep_fn, and uses the Scsi_Host,
scsi_device and scsi_target structs to insert my own scsi commands.
scsi_cmnd structs are taken from the scsi_device through
scsi_get_command and dispatched to the ahci host by the queuecommand
function.

The drives are supported by the ahci driver in libata, and are already
mounted on the machine as scsi drives (e.g. /dev/sda and /dev/sdb).

My problem now is that when I run the module, asking to issue too many
read commands can cause the kernel to hang.  I would like to run the
thread for about ten seconds (60K iops * 10 sec = 600K read requests),
but I'm not sure if it is a problem running it from the insmod
application thread, i.e. my module's init thread is issuing all the
commands.  Also, I am not sure what I need to do to ensure I am not
ruining something in the i/o hierarchy, e.g. messing up something in
the block layer, or breaking the sd or ahci driver.  Any advice would
be greatly appreciated.

Is ten seconds too long for an insmod thread to run?

I have tried to use blk_{start, stop}_queue while my thread is issuing
commands; is this appropriate?

What else can I do to see how my module changed the kernel?

Thanks in advance

Nathan

PS I'm not signed up for the list yet, so please cc me on the responses
