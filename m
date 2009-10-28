From: Tim Small <tim@seoss.co.uk>
Subject: Re: Apparent MPT ata pass-through bug SAS1068 and SAS1068E - WAS
 SMART causes disks to go offline on an LSI SAS1068 controller - Dell SAS
 5/iR
Date: Wed, 28 Oct 2009 16:56:51 +0000
Message-ID: <4AE877D3.4040300@seoss.co.uk>
References: <20090914142939.GE14072@boogie.lpds.sztaki.hu> <4AE72E40.2000903@seoss.co.uk> <4AE8448C.6070709@seoss.co.uk> <0D1E8821739E724A86F4D16902CE275C1C93A02A34@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.allsecurenet.com ([63.246.152.102]:38342 "EHLO
	relay1.allsecurenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbZJ1Q5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2009 12:57:08 -0400
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C93A02A34@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "smartmontools-support@lists.sourceforge.net" <smartmontools-support@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Linux-PowerEdge@dell.com" <Linux-PowerEdge@dell.com>, Gabor Gombas <gombasg@sztaki.hu>

Desai, Kashyap wrote:
> Can you try doing the same test upgrading our driver to 3.04.13?
> You can find relevant patches at 
>
> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-misc-2.6.git&a=search&h=993340e8ab4e856bf0fc7818cdca1a92f6e8ed38&st=commit&s=kashyap
>   

Have just compiled a kernel package from James' tree directly, rather 
than attempting to back-port and manually patch, so I'm now running 
2.6.32-rc4 with mptsas 3.04.13.  I'm running the smartctl -a in a loop 
at the moment and will leave it running over-night, but with this kernel 
I get a pair of messages like this:

[ 1045.130560] scsi 2:0:0:0: [sg1] Sense Key : Recovered Error [current] 
[descriptor]
[ 1045.145751] Descriptor sense data with sense descriptors (in hex):
[ 1045.158107]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
[ 1045.171010]         00 4f 00 c2 00 50
[ 1045.178585] scsi 2:0:0:0: [sg1] Add. Sense: ATA pass through 
information available
[ 1045.280318] scsi 2:0:0:0: [sg1] Sense Key : Recovered Error [current] 
[descriptor]
[ 1045.284311] Descriptor sense data with sense descriptors (in hex):
[ 1045.284311]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
[ 1045.284311]         00 4f 00 c2 00 50
[ 1045.284311] scsi 2:0:0:0: [sg1] Add. Sense: ATA pass through 
information available

for every 'smartctl -a /dev/sg1' command which is run.

Cheers,

Tim.
