From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 15 Aug 2005 11:33:54 -0400
Message-ID: <4300B5E2.9030000@adaptec.com>
References: <20050815135537.GB19426@lst.de> <4300B11A.2050006@adaptec.com> <20050815152131.GB20854@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:40658 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964793AbVHOPd7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 11:33:59 -0400
In-Reply-To: <20050815152131.GB20854@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On 08/15/05 11:21, Christoph Hellwig wrote:
> On Mon, Aug 15, 2005 at 11:13:30AM -0400, Luben Tuikov wrote:
> 
>>>+void sas_add_target(struct sas_port *port, struct sas_identify *attached,
>>>+		uint channel, uint target)
>>>+{
>>>+	if (attached->target_port_protocols &
>>>+	    (SAS_PROTOCOL_SSP|SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA))
>>>+		scsi_scan_target(&port->dev, channel, target, ~0, 0, attached);
>>>+}
>>
>>I've a few questions:
>>
>>1. What kind of device does the Fusion driver export?
>>   Is this a true end device, or is this the LU in the SSP end device?
>>   I.e. since the Fusion card firmware does everything about SAS there is,
>>   is also LU discovery done in the firmware, or does the firmware export
>>   only the SSP end devices and leave LU discovery to SCSI Core
>>   (as the code suggests)?
> 
> 
> It seems to give notification for the actual LU, but doing an LU scan
> works if you use the target ID from those reports.  Given that I prefer
> to do as much as possible in the transport class to have the same
> behaviour for different HBAs I'd prefer to not rely on the firmware's
> LU scan.

Yes, I see your point.

But you just said it: the FW exports actual LUs.  Thus, even if you do
a scan, you'll either get the "other" LUs, which the FW has already
told you about, or CHECK CONDITION depending on where you sent it and
if the device server supports it.

In effect, you can either leave it at LUs or do your own scan,
but not both.  An agreement is needed between the Firmware and SCSI Core.

>>2. Since I saw that (end) devices bind to ports, what is the maximum
>>   number of ports that the Fusion firmware export?
> 
> right now it reports the number of physical ports, that's four or eight
> for the cards I have.  But again I don't have the actual documentation
> yet.

So what is the maximum number of devices it can support?

>>3. Will control of SATA and STP devices be given to libata or will
>>   the Fision firmware make those look like SCSI devices?
> 
> Fusion makes them look like SCSI devices.  As I mentioned I tested this
> patch only with SATA disks.  But as the command translation for cards
> not doing thi in firmware would happen in the ->queuecommand path I
> don't think the transport class should be involved with it.

Yes, how can it...

	Luben

