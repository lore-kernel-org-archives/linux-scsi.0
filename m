From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [mptscsi] endless Domain Validation loop with external RAID enclosure
Date: Tue, 14 Nov 2006 16:33:02 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D7041FE50@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56035 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S966062AbWKNXdR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Nov 2006 18:33:17 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Etienne.Vogt@obspm.fr, linux-scsi@vger.kernel.org

On Tuesday, November 14, 2006 7:42 AM,  Etienne Vogt wrote:


> I understand that the problem is probably caused by buggy firmware in
> the BR8600 RAID system, but we have 5 of those in production each with
> 1.75 Tb of online storage that used to work fine on servers running
> 2.4.x kernels. Replacing these RAID systems is not really an 
> affordable 
> option at the moment.
> 
> So, is there a way to tell the kernel scsi subsystem or the 
> mptspi module 
> not to bother about this domain validation failure ? Besides, souldn't
> this kind of endless loop be considered as a kernel bug, even 
> if triggered
> by buggy peripheral firmware (afterwards, it works on kernel 2.4.x
> or 2.6.8-2) ?
> 

I don't know how to disable domain validation.

What I do know is the problem. THis is due to domain validation commands
timeout out,
which results in a host reset.  From the mptspi host reset, the driver
starts 
spi transport domain validation all over again, and thus the infinite
loop.  We do need to 
renegotiate again after host reset, or all the devices are at slowest
speed,
asyn narrow.  I have proposed a patch on this mailing list a couple
months ago
to fix this problem, however that patch was rejected.  My fix was in the
mptspi host reset function, where I told firmware to negotaiate with the
last
parameters, thus avoiding having spi transport dv going into infinite
loop.
However a better fix is to have spi transport avoid sending a host reset
when the commands timeout. I'm not sure if James Bottomely is waiting
for a patch like that which would address the concerns off all drivers,
instead
of just addressing mptspi wooes. I'm not sure.  I could repost my mptspi
fix again?

Eric Moore
LSI Logic   
