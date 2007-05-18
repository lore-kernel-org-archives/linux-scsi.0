From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Problems with SCST and QLA 2432 FC Cards
Date: Fri, 18 May 2007 11:06:28 +0400
Message-ID: <464D5074.3080601@vlnb.net>
References: <88044fc70705171348l64913b26r742718986632f3ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([85.249.135.242]:33310 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbXERHHI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 May 2007 03:07:08 -0400
In-Reply-To: <88044fc70705171348l64913b26r742718986632f3ca@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sandip shete <sandipshete@gmail.com>
Cc: scst-devel@lists.sourceforge.net, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

sandip shete wrote:
> Hi,
> 
> I am working with the SCST 0.9.4 version on linux-2.6.15 with the
> linux-2.6-qla2xxx-target.patch patch applied.
> I was using a QLA2312 card on this setup and things were just fine when
> i used this system as a Target.
> 
> Now I have switched to a qla2432 card and even though i do enable
> "Target Mode" (echo "1" >
> /sys/class/scsi_host/host../target_mode_enabled) on the corresponding
> port, this port fails to work as a target, and none of the Fileio Luns
> are exported to the initiator.
> Also, on the initiator side the "/sys/class/fc_remote_port/..../role"
> file should show as "FC Target", which it used to with QLA 2312, but
> with QLA 2432 the initiator side shows the role of the remote port as
> "FC Initiator"
> 
> The initiator has 2312 cards and 2.6.15 kernel compiled on it.
> 
> Also note that, i have the corresponding ql2400_fw.bin firmware binary
> at the right location and it gets loaded when i load the modules.
> To check if the qla2432 card was working fine, i connected this to a
> different 2312 based target system and had it work as a Initiator, this
> worked fine and i could see all the luns exported on this box.
> 
> Now the only problem that i can think of in target mode is, maybe, scst
> doesn't support the qla 24xx series.

Yes, that's correct. Unfortunately, 24xx+ series are not supported yet.

> But i fail to see any part of the code pointing towards that.

You can see in the README for the driver that only 22xx and 23xx series 
are currently supported.

> When i  did some debugging on the initiator side i see that the
> "qla2x00_get_port_database" does return the status
> of the remote port as FCT_INITIATOR, i couldn't actually figure out the
> code wherein the target returns the response to these mbox_commands. I
> was wondering if SCST plays a part here and sends a different response
> when 24xx cards are used.

Unfortunately, 24xx+ cards have very different interface, so add support 
for them is almost the same as write another driver.

> I saw some posts regarding the problems that people were facing with qla24xx
> series. If this has been fixed in a different verison of Linux/SCST 
> that what i am using, please let me know.
> 
> Thanks and Regards.
> Sandip S
