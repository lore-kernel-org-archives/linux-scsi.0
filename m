From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: mptsas hangs caused by ATA pass-through explained
Date: Sat, 5 Jun 2010 00:01:52 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249029006CA56@inbmail02.lsi.com>
References: <4C080B88.205@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:32964 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab0FDTTK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jun 2010 15:19:10 -0400
In-Reply-To: <4C080B88.205@sauce.co.nz>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Richard,

I remember that default dma boundary was 512 byte earlier sometime 2.6.30 kernel version.
Later kernel has introduced 4 byte dma boundary in scsi_lib.c....
 

As I have mentioned we have limitation of single sgl for ATA PIO commands. So making 512  byte dma boundary will solve all functional issue, but 
As mentioned in bugzilla #25, people are seeing performance degradation (may due to bounce buffer usage). I need to debug that part.

In my opinion if setting "dma boundary to 512 byte is a solution only if there is no performance degradation"
Can I have data how user at bugzilla is testing performance?

Thanks,
Kashyap


> -----Original Message-----
> From: Richard Scobie [mailto:richard@sauce.co.nz]
> Sent: Friday, June 04, 2010 1:38 AM
> To: linux-scsi@vger.kernel.org
> Cc: Desai, Kashyap
> Subject: RE: mptsas hangs caused by ATA pass-through explained
> 
> Kashyap wrote:
> 
> I have also verified this patch + also done code review with our
> developers including Eric Moore. Please consider this patch as an ACKed
> patch and schedule it for next upstream release.
> 
> ----------------------
> 
> Hi,
> 
> In comment #20 of this bug entry:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=14831
> 
> you state:
> 
> "Patch for setting dma boundary is mere avoiding condition which is
> causing this
> issue. LSI Gen-1 controller does not have 512byte dma boundary
> limitation. I
> have started internal chat with our Firmware engineer. I will update
> you
> findings as and when some imp stuffs are found."
> 
> Is this still the case, or is the patch the final fix?
> 
> Also, comment #25 in the same thread notes a significant negative write
> performance impact.
> 
> Are you seeing this?
> 
> I have several machines in production I would like to update, but not
> if
> there is a better solution to this on it's way.
> 
> Regards,
> 
> Richard
