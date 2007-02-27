From: "Shirron, Stephen" <Stephen.Shirron@lsi.com>
Subject: RE: LSI Logic 40919o fibre channel: scsi works ip not
Date: Tue, 27 Feb 2007 06:02:43 -0700
Message-ID: <F6F6225F9738D94FB5B5876E3707A91901170D5D@NAMAIL2.ad.lsil.com>
References: <200702152306.25374.mgiammarco-ml@4warding.com> <F6F6225F9738D94FB5B5876E3707A9190112A445@NAMAIL2.ad.lsil.com> <45D83554.1080309@4warding.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34376 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbXB0NC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Feb 2007 08:02:56 -0500
Content-class: urn:content-classes:message
In-Reply-To: <45D83554.1080309@4warding.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mario Giammarco <mgiammarco-ml@4warding.com>, linux-scsi@vger.kernel.org
Cc: "Hickerson, Roger" <Roger.Hickerson@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>

Mario,

There appears to be a bug in the driver.

Go to mpt_lan_post_receive_buckets(), in mptlan.c.  Find:

		mf = mpt_get_msg_frame(LanCtx, mpt_dev);

Later find:

		pRecvReq = (LANReceivePostRequest_t *) mf;

Below that, should be:

		i = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
		mpt_dev->RequestNB[i] = 0;

The above two lines of code are present in some versions of mptctl.c
(the 2.06.xx versions and 3.02.xx versions) but are missing from some
others (3.03.xx, 3.04.xx, and 4.00.xx).

If you can add those two lines of code, rebuild mptctl.ko, and retest,
I believe that should take care of your reported problems.

Let me know, please.

stephen

-----Original Message-----
From: Mario Giammarco [mailto:mgiammarco-ml@4warding.com] 
Sent: Sunday, February 18, 2007 6:16 AM
To: Shirron, Stephen; linux-scsi@vger.kernel.org
Cc: Hickerson, Roger
Subject: Re: LSI Logic 40919o fibre channel: scsi works ip not

Shirron, Stephen ha scritto:
> Hi Mario,
> 
> Can you tell me what firmware version you have on your 40919
> card(s)?  The easiest way is to "cat /proc/mpt/summary".

This is summary:
ioc0: LSIFC919, FwRev=02000f00h, Ports=1, 
MaxQ=1023,LanAddr=00:06:2B:07:FA:10, IRQ=209


> 
> How often do the errors occur?  dmesg provides no timestamps,
> while /var/log/messages does.
> 
Sorry but in messagese there is not this error. I can say you that the 
frequency of the error is proportional to data transferred. If I start a

n ftp dmesg output goes crazy.

I have seen this in /var/log/messages (sorry no timestamps again):


Fusion MPT LAN driver 3.04.01
mptlan: ioc0: PortNum=0, ProtocolFlags=0Fh (ITLB)
mptlan: ioc0: Fusion MPT LAN device registered as 'fc0'
mptlan: ioc0/fc0: LanAddr = 00:06:2B:07:FA:10
mptlan: ioc0/fc0: interface up & active
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003
mptbase: ioc0: LogInfo(0x22000002): SubCl={LAN}
mptlan: ioc0/fc0: ERROR - Got a non-TURBO ReceivePostReply w/ 
PacketLength zero!
mptlan: MsgFlags = 80, IOCStatus = 8003




