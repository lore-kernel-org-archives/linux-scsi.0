From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Sat, 21 Jul 2012 14:15:56 +0200
Message-ID: <500A9D7C.8080801@matthiasprager.de>
References: <4FE454CA.6080007@matthiasprager.de> <4FFAED4F.3080100@matthiasprager.de> <4FFB32E5.1050109@farcaster.org> <4FFB7354.8040809@matthiasprager.de> <4FFB8A86.7000009@farcaster.org> <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de> <4FFD8410.7050604@matthiasprager.de> <20120717180932.GB2878@google.com> <5005BF7D.2050703@matthiasprager.de> <20120717200136.GC24336@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:58762 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2GUMQK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Jul 2012 08:16:10 -0400
In-Reply-To: <20120717200136.GC24336@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Robert Trace <maillist@farcaster.org>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, Eric Moore <Eric.Moore@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>

Am 17.07.2012 22:01, schrieb Tejun Heo:
> On Tue, Jul 17, 2012 at 09:39:41PM +0200, Matthias Prager wrote:
>> I could not however reproduce the issue on any other device than a LSI
>> SAS controller (using SATA disks) - on a regular ICH10 using AHCI and a
>> SATA drive I don't see these i/o errors. But since I'm experiencing
>> these issues on two different systems (both with lsi controllers while
>> running vmware-guests on them) and Robert sees them on his
>> (non-virtualized) system with the same lsi controller (9211-8i), I'm
>> inclined to make the following assumptions:
>> Either it is an issue which is limited to this controller and possibly
>> sata disks hanging off it or it is a more general issue with sas
>> controllers and sata disks (again it could well affect sas disks too).
>> Lacking other controllers or sas disks I can't be sure.
> 
> So, nothing in the libata stack generates NOT_READY - "initializing
> command required".  I suppose it's LSI firmware / driver translating
> TUR to CHECK_POWER_MODE and generating NOT_READY.  I don't know what
> SAT says about this but this can't be correct.  An ATA device in
> standby mode is ready to process any commands.  It should be able to
> come back to full operation on demand as necessary and that's why it
> can be transparently enabled from device side.  Eric?
> 

While reading the linux-scsi mailing list I stumbled upon

'[Bug 16070] Fail to issue Start/Stop Unit'
<http://marc.info/?l=linux-scsi&m=134278835822649&w=2>
(bugtracker: <https://bugzilla.kernel.org/show_bug.cgi?id=16070>)

which lead me to trying to enable the 'allow_restart' flag for my disks.
With this workaround a vanilla kernel 3.4.5 does not exhibit the i/o
errors on sleeping sata disks hanging off sas controllers.


I'm currently running one of my systems with a

'echo 1 | tee /sys/block/sd?/device/scsi_disk/*/allow_restart >/dev/null'

line added to the init scripts. This way I can use the untouched kernel
sources and still get around the i/o errors. But I reckon this is no
solution.


I'm no expert on scsi/sas/ata internals, so please take the following
thoughts with a grain of salt:

As far as I can see (and Tejun confirmed that - I think) Tejun commit
85ef06d1d252f6a2e73b678591ab71caad4667bb somehow exposes a bug, which
lies deeper in the sas/ata code. The 'sas_slave_configure()' function in
'drivers/scsi/libsas/sas_scsi_host.c' sets the 'allow_restart' flag for
sas disks hanging off sas controllers. But if it encounters a sata disk
it calls 'ata_sas_slave_configure()' in 'drivers/ata/libata_scsi.c'
instead and returns without enabling the 'allow_restart' flag. A simple
fix would be to set allow_restart=1 after having called
'ata_sas_slave_configure()' but before returning (in
'sas_slave_configure()').

Now I'm not sure this isn't taping over another bug. Which leads me to
my question: What is the correct behavior?

#1 Issuing a separate spin-up command (START UNIT?) prior to sending i/o
by setting allow_restart=1 for sata disks on sas controllers

or

#2 Teaching the sas drivers they do not need spin-up commands and can
simply start issuing i/o to sata disks

--
Matthias
