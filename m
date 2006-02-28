From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: Re: problems with scsi_transport_fc and qla2xxx
Date: Tue, 28 Feb 2006 19:54:36 +0300
Message-ID: <735056370.20060228195436@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxout5.netvision.net.il ([194.90.9.29]:32479 "EHLO
	mxout5.netvision.net.il") by vger.kernel.org with ESMTP
	id S932298AbWB1Ryl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 12:54:41 -0500
Received: from CBL217-132-247-11.bb.netvision.net.il ([217.132.247.11])
 by mxout5.netvision.net.il
 (Sun Java System Messaging Server 6.1 HotFix 0.11 (built Jan 28 2005))
 with ESMTP id <0IVE00KYFSF05O00@mxout5.netvision.net.il> for
 linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:54:40 +0200 (IST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!
Most of the problem seems to be a QLogic driver problem.
HBAs are connected to target via FC switch.

1. If I have several LUNs on each HBA, with QLogic only 1 directory
per adapter (for LUN 0) is created in /sys/class/fc_remote_ports,
while with Emulex a directory for every LUN is created.

2. The situation I described occurs with QLogic only if the cable
connecting between HBA and switch is pulled out/in. If I
connect/disconnect the cable between switch and target, disks come
back.

3. With Emulex in both cases disks come back.

However, both with Emulex and QLogic stale directories in
/sys/classfc_remote_ports are left.
For example, with Emulex if I had in the beginning
rport-6:0-0  rport-6:0-1  rport-6:0-2  rport-7:0-0  rport-7:0-1  rport-7:0-2
then disconnected adapter 7, got
rport-6:0-0  rport-6:0-1  rport-6:0-2  rport-7:0-0  rport-7:0-2
(7-0-0 and 7-0-2 didn't disappear while 7-0-1 did)
connected 7 back
rport-6:0-0  rport-6:0-1  rport-6:0-2  rport-7:0-2  rport-7:0-4
rport-7:0-5 rport-7:0-6
(7-0-0 disappeared, but 7-0-2 is still here).

Thanks,

Maxim.

MK> Hi!
MK> I'm checking 2.6.16-rc5 with 2 QLogic 2312 adapters using qla2xxx
MK> driver from 2.6.16-rc5.
MK> As with earlier kernels, I think > 2.6.12 (since scsi_transport_fc
MK> gained functionality) I have the following problem.
MK> 2 scsi hosts available, 4 and 5 (for QLogic).
MK> I disconnect the cable from one of QLogic cards. After timeout I have
MK> the message
MK> rport-4:0-0: blocked FC remote port time out: removing target and saving binding
MK> and appropriate SCSI devices that came from adapter 4 disappear from
MK> /proc/scsi/scsi.
MK> So far, so good.
MK> I reconnect the cable, the directory
MK> /sys/class/fc_remote_ports/rport-4:0-1 appears along with the old
MK> ones rport-4:0-0 and rport-5:0-0, so currently I have 3.
MK> However, no automatic rescan appears on adapter 4.
MK> What's worse, if I try echo "0 1 0" > /sys/class/scsi_host/host4/scan
MK> the process is stuck.
MK> Please advise.

MK> Thanks,

MK> Maxim.

