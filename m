From: "Mahesh Rajashekhara" <Mahesh.Rajashekhara@pmcs.com>
Subject: Linux sg3_utils sg_map lists stale/dead device nodes
Date: Sun, 21 Apr 2013 22:47:28 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C83926671BDB8FB6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:51715 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532Ab3DVFrc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Apr 2013 01:47:32 -0400
Received: from bby1mta03.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca [127.0.0.1])
	by localhost (Postfix) with SMTP id F238210701D6
	for <linux-scsi@vger.kernel.org>; Sun, 21 Apr 2013 22:47:30 -0700 (PDT)
Received: from bby1exg02.pmc_nt.nt.pmc-sierra.bc.ca (bby1exg02 [216.241.231.167])
	by bby1mta03.pmc-sierra.bc.ca (Postfix) with SMTP id E57D510701D2
	for <linux-scsi@vger.kernel.org>; Sun, 21 Apr 2013 22:47:30 -0700 (PDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Achim Leubner <Achim.Leubner@pmcs.com>, Tony Ruiz <Tony.Ruiz@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

Hello,

Greetings...!

I am the Linux driver engineer for the PMC-Sierra driver team working on
aacraid drivers.

The Linux aacraid driver is connected with the SCSI upper layer driver
modules (sd, sg, ....). 

We are using Linux sg3_utils tool package `sg_map` command to list
mapping between sg and SCSI devices. When the enclosure cable is plugged
out, the scsi device entries /dev/sd* being disappeared as expected.
But, it still sees stale/dead sg device nodes. Did anybody seen this
issue with some other vendor drivers ? I hope you can shed some light on
the situation.

Please see the details of this issue below:

1. Expander is connected to the Adaptec RAID HBA controller and the
connected disk devices recognized by driver/OS. Executed sg_map command
and it displays device mappings as expected.

# sg_map
/dev/sg0  /dev/sr0
/dev/sg1  /dev/sda
/dev/sg2  /dev/sdb
/dev/sg3  /dev/sdc
/dev/sg4  /dev/sdd
/dev/sg5  /dev/sde
/dev/sg6  /dev/sdf
/dev/sg7  /dev/sdg
/dev/sg8

2. Plugged out SAS enclosure device cable

When the enclosure SAS cable is plugged out, driver marks the SCSI
device offline by setting SDV_OFFLINE to a OS SCSI upper layer
"scsi_device_set_state" function. Executed sg_map command. I could see
that SCSI device entries /dev/sd[b-g] being disappeared on executing
"sg_map" command. But, sg_map still sees stale/dead device nodes
/dev/sg[2-7]. 

# sg_map
/dev/sg0  /dev/sr0
/dev/sg1  /dev/sda
/dev/sg2
/dev/sg3
/dev/sg4
/dev/sg5
/dev/sg6
/dev/sg7
/dev/sg8

I am not sure if it's an expected behavior with this way of notifying OS
SCSI upper layers (setting SDV_OFFLINE to "scsi_device_set_state"
function).

Is there a recommend way to notify OS SCSI upper layers ?? 

Please help.

Sincerely,
Mahesh
