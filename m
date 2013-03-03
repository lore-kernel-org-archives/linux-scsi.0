From: Chris Boot <bootc@bootc.net>
Subject: qla2xxx: issues when creating a new target port
Date: Sun, 3 Mar 2013 13:49:07 +0000
Message-ID: <B1C4F02B-5252-49BC-9FF9-7FB0A74872D8@bootc.net>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kamaji.grokhost.net ([87.117.218.43]:35096 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab3CCNzo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Mar 2013 08:55:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, linux-driver@qlogic.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

Hi all,

When creating a new target port in targetcli (/qla2xxx create 21:0x:...), and I have nothing plugged-in to the port, the creation process takes quite some time. After a few seconds, the kernel prints a message saying "Cable is unplugged...". So far so good.

It seems that when the target is created, it comes up in the 'enabled' state, regardless of me having set 'auto_enable_tpgt=false'. Running 'disable' from targetcli seems to try to bring the link up again ("Performing ISP error recovery" then "Cable is unplugged...") and the target remains in the enabled state.

If I then add LUNs and ACLs to the target, everything appears OK, but plugging the target port into an initiator gives odd behaviour. The initiator spends a very long time scanning the target and eventually times out and finds no LUNs. The only way to get the port working again is to save the configuration and reboot the target server, which is very frustrating.

I'm using targetcli as found in Debian wheezy with kernel 3.8.0, though I have had this problem for a little while now...

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net

