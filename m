From: Gwendal Grignou <gwendal@google.com>
Subject: Re: [PATCH 0/3] Insert ATA transport objects in SCSI syfs topology.
Date: Thu, 4 Oct 2012 09:56:25 -0700
Message-ID: <CAMHSBOV8ghAV_RCRMPMHW0Gk8ugX6zWTp+aNnWUJ9tmiFeN8pg@mail.gmail.com>
References: <20120928062709.GA2091@mint-spring.sh.intel.com>
	<1349115776-17569-1-git-send-email-gwendal@google.com>
	<CAA9_cmdWHRLBru6hN1ibGK75rw3ZQbQ9TULRe-bU=3q4-fb+qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmdWHRLBru6hN1ibGK75rw3ZQbQ9TULRe-bU=3q4-fb+qw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: aaron.lu@intel.com, minggr@gmail.com, tj@kernel.org, jgarzik@pobox.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 1, 2012 at 12:14 PM, Dan Williams <djbw@fb.com> wrote:
> On Mon, Oct 1, 2012 at 11:22 AM, Gwendal Grignou <gwendal@google.com> wrote:
>> This set of patches improve ATA transport classes integration with SCSI
>> objects.
>>
>> Before [2.6.x]
>>
>> Ata and scsi transport class where separated:
>> `--0000:09:00.0
>> |  `--ata1
>> |  |  `--port_port
>> |  |  `--link1
>> |  |  |  `--dev1.0
>> |  |  |  `--dev1.1
>> |  `--ata2
>> |  ...
>> |  `--host0
>> |  |  `--scsi_host
>> |  |  |  `--host0
>> |  |  `--target0:0:0
>> |  |  |  `--0:0:0:0
>> |  |  |  |  `--block
>> |  |  |  |  |  `--sda
>> |  |  |  |  |  |  `--sda1
>>
>> In 3.2, Lin - in commit 9a6d6a2ddabbd32c07f6a38b659e5f3db319fa5a - addressed
>> the issue of linking the ata port with the scsi host object by placing the
>> scsi_host object under ata port objects.
>>
>> However to be more consistent with other transport, this patch does the opposite:
>>
>> For instance, with SAS transport, We have
>> `--0000:0b:00.0
>> |  `--host6
>> |  |  `--phy-6:0
>> |  |  `--phy-6:1
>> ...
>> |  |  `--port-6:0
>> |  |  |  `--end_device-6:0
>> |  |  |  |  `--sas_device
>> |  |  |  |  |  `--end_device-6:0
>> |  |  |  |  `--sas_end_device
>> |  |  |  |  |  `--end_device-6:0
>> |  |  |  |  `--target6:0:0
>> |  |  |  |  |  `--6:0:0:0
>> |  |  |  |  |  |  `--block
>> |  |  |  |  |  |  |  `--sdb
>> ...
>> |  |  `--port-6:1
>> |  |  |  `--end_device-6:1
>> ...
>> phy and port have to be separated, sas_port are created dynamically.
>>
>> For ata, all objects are created at initialization time, so the layout is:
>> `--0000:09:00.0
>> |  `--host0
>> |  |  `--port1
>> |  |  |  `--link1
>> |  |  |  |  `--dev1.0
>> |  |  |  |  |  `--target0:0:0
>> |  |  |  |  |  |  `--0:0:0:0
>> |  |  |  |  |  |  |  `--block
>> |  |  |  |  |  |  |  |  `--sda
>>
>> If we have a port multiplier, more links are created.
>> `--0000:09:00.0
>> ...
>> |  `--host4
>> |  |  `--port5
>> |  |  |  `--link5
>> |  |  |  |  `--dev5.0
>> [device for the port multiplier]
>> |  |  |  `--link5.0
>> |  |  |  |  `--dev5.0.0
>> |  |  |  |  |  `--target4:0:0
>> |  |  |  |  |  |  `--4:0:0:0
>> |  |  |  |  |  |  |  `--block
>> |  |  |  |  |  |  |  |  `--sdc
>> [disk in port 0 of the port multiplier]
>> ...
>> |  |  |  `--link5.2
>> |  |  |  |  `--dev5.2.0
>> |  |  |  |  |  `--target4:2:0
>> |  |  |  |  |  |  `--4:2:0:0
>> |  |  |  |  |  |  |  `--block
>> |  |  |  |  |  |  |  |  `--sde
>> [disk in port 2 of the port multiplier]
>>
>> In consequence, the path of a scsi device becomes:
>> .../0000:00:1f.2/host0/port1/link1/dev1.0/target0:0:0/0:0:0:0
>> dev1.0 indicates the master device [0] in ata port 1.
>> ata1 being under host0, we know the reliationships between the scsi_host id and
>> ata port id.
>>
>> or when a port multiplier is present: for instance the device in port 4 of the
>> port multiplier:
>> .../0000:00:06.0/0000:09:00.0/host5/port6/link6.4/dev6.4.0/target5:4:0/5:4:0:0
>
> What's the benefit of this?
+ To unify ata transport sysfs topology with other scsi transport.
+ To easily map a ata_port with its associated scsi_host structure.

> From a PM perspective now it seems we'll
> have the parent hardware port suspended before all the scsi_hosts on
> that port,
There is a one to one mapping between ata port and scsi-host, so it works.
All ata ports must be suspended before the parent hardware is.

Gwendal.
> which defeats the original purpose of putting the ata_port
> in the PM hierarchy.
>
> --
> Dan
