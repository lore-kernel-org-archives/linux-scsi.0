From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Apparent MPT ata pass-through bug SAS1068 and SAS1068E - WAS
 SMART causes disks to go offline on an LSI SAS1068 controller - Dell SAS
 5/iR
Date: Wed, 28 Oct 2009 17:10:53 -0400
Message-ID: <4AE8B35D.2070609@interlog.com>
References: <20090914142939.GE14072@boogie.lpds.sztaki.hu> <4AE72E40.2000903@seoss.co.uk> <4AE8448C.6070709@seoss.co.uk> <0D1E8821739E724A86F4D16902CE275C1C93A02A34@inbmail01.lsi.com> <4AE877D3.4040300@seoss.co.uk>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53597 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbZJ1VKy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Oct 2009 17:10:54 -0400
In-Reply-To: <4AE877D3.4040300@seoss.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "smartmontools-support@lists.sourceforge.net" <smartmontools-support@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Linux-PowerEdge@dell.com" <Linux-PowerEdge@dell.com>, Gabor Gombas <gombasg@sztaki.hu>

Tim Small wrote:
> Desai, Kashyap wrote:
>> Can you try doing the same test upgrading our driver to 3.04.13?
>> You can find relevant patches at
>> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-misc-2.6.git&a=search&h=993340e8ab4e856bf0fc7818cdca1a92f6e8ed38&st=commit&s=kashyap 
>>
>>   
> 
> Have just compiled a kernel package from James' tree directly, rather 
> than attempting to back-port and manually patch, so I'm now running 
> 2.6.32-rc4 with mptsas 3.04.13.  I'm running the smartctl -a in a loop 
> at the moment and will leave it running over-night, but with this kernel 
> I get a pair of messages like this:
> 
> [ 1045.130560] scsi 2:0:0:0: [sg1] Sense Key : Recovered Error [current] 
> [descriptor]
> [ 1045.145751] Descriptor sense data with sense descriptors (in hex):
> [ 1045.158107]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [ 1045.171010]         00 4f 00 c2 00 50
> [ 1045.178585] scsi 2:0:0:0: [sg1] Add. Sense: ATA pass through 
> information available
> [ 1045.280318] scsi 2:0:0:0: [sg1] Sense Key : Recovered Error [current] 
> [descriptor]
> [ 1045.284311] Descriptor sense data with sense descriptors (in hex):
> [ 1045.284311]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [ 1045.284311]         00 4f 00 c2 00 50
> [ 1045.284311] scsi 2:0:0:0: [sg1] Add. Sense: ATA pass through 
> information available
> 
> for every 'smartctl -a /dev/sg1' command which is run.

Tim,
This is _not_ an error. If the CK_COND bit is set in the SCSI
ATA PASS-THROUGH (12 or 16 byte) cdb and the ATA command
succeeds then what is shown above is correct.

The whole point is to get the ATA registers after the command
is complete. The register values are placed in a ATA (status)
return descriptor encapsulated in sense data with that sense key
and those additional sense codes. The ATA return descriptor
starts with the "09" value in the sense buffer shown above.

smartmontools needs to set CK_COND on some ATA commands (e.g.
to get the SMART status) because the result can only be found
in the ATA registers after completion.

Now it is annoying, distracting and wasteful to log the sense
data in this particular situation. Perhaps the SCSI mid level
error reporting should filter out that particular combination:
   Sense key: RECOVERED ERROR
   Additional sense: ATA PASS THROUGH INFORMATION AVAILABLE (0x0,0x1d)

References: sat-r09.pdf sat2r09.pdf


Doug Gilbert
