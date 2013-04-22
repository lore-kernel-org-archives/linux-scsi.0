From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Linux sg3_utils sg_map lists stale/dead device nodes
Date: Mon, 22 Apr 2013 10:22:16 -0400
Message-ID: <51754798.1030008@interlog.com>
References: <340C71CD25A7EB49BFA81AE8C83926671BDB8FB6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59038 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3DVOXc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Apr 2013 10:23:32 -0400
In-Reply-To: <340C71CD25A7EB49BFA81AE8C83926671BDB8FB6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: linux-scsi@vger.kernel.org, Achim Leubner <Achim.Leubner@pmcs.com>, Tony Ruiz <Tony.Ruiz@pmcs.com>

On 13-04-22 01:47 AM, Mahesh Rajashekhara wrote:
> Hello,
>
> Greetings...!
>
> I am the Linux driver engineer for the PMC-Sierra driver team working on
> aacraid drivers.
>
> The Linux aacraid driver is connected with the SCSI upper layer driver
> modules (sd, sg, ....).
>
> We are using Linux sg3_utils tool package `sg_map` command to list
> mapping between sg and SCSI devices. When the enclosure cable is plugged
> out, the scsi device entries /dev/sd* being disappeared as expected.
> But, it still sees stale/dead sg device nodes. Did anybody seen this
> issue with some other vendor drivers ? I hope you can shed some light on
> the situation.
>
> Please see the details of this issue below:
>
> 1. Expander is connected to the Adaptec RAID HBA controller and the
> connected disk devices recognized by driver/OS. Executed sg_map command
> and it displays device mappings as expected.
>
> # sg_map
> /dev/sg0  /dev/sr0
> /dev/sg1  /dev/sda
> /dev/sg2  /dev/sdb
> /dev/sg3  /dev/sdc
> /dev/sg4  /dev/sdd
> /dev/sg5  /dev/sde
> /dev/sg6  /dev/sdf
> /dev/sg7  /dev/sdg
> /dev/sg8
>
> 2. Plugged out SAS enclosure device cable
>
> When the enclosure SAS cable is plugged out, driver marks the SCSI
> device offline by setting SDV_OFFLINE to a OS SCSI upper layer
> "scsi_device_set_state" function. Executed sg_map command. I could see
> that SCSI device entries /dev/sd[b-g] being disappeared on executing
> "sg_map" command. But, sg_map still sees stale/dead device nodes
> /dev/sg[2-7].
>
> # sg_map
> /dev/sg0  /dev/sr0
> /dev/sg1  /dev/sda
> /dev/sg2
> /dev/sg3
> /dev/sg4
> /dev/sg5
> /dev/sg6
> /dev/sg7
> /dev/sg8
>
> I am not sure if it's an expected behavior with this way of notifying OS
> SCSI upper layers (setting SDV_OFFLINE to "scsi_device_set_state"
> function).
>
> Is there a recommend way to notify OS SCSI upper layers ??

Quick answer: don't use sg_map for device discovery. When it was
written lk 2.4 was current (hence no sysfs and perhaps prior
to devfs as well). At that time there was no good way of discovering
devices and the relationship between various device nodes that
represented the same Logical Unit (e.g. /dev/sdc being the same LU
as /dev/sg3). Since then I added sg_map26 which took advantage
of some of facilities added in lk 2.6 and lsscsi which does data
mining in sysfs. So unless you are working with very old Linux
kernels I would recommend that you use lsscsi.

Strangely I have also recently received bug reports for "sginfo -l",
which is another device discovery mechanism inherited from Eric
Youngdale. That is even older, from the last millennium.

So I will look at these reports and fix any obvious bugs. I will also
be adding the word "deprecated" liberally in the man pages of those
utilities.

Doug Gilbert



