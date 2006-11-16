From: Etienne.Vogt@obspm.fr
Subject: RE: [mptscsi] endless Domain Validation loop with external RAID
 enclosure
Date: Thu, 16 Nov 2006 10:55:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611161047150.10103@siolinb.obspm.fr>
References: <664A4EBB07F29743873A87CF62C26D7041FE50@NAMAIL4.ad.lsil.com>
Reply-To: Etienne.Vogt@obspm.fr
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from siolinb.obspm.fr ([145.238.2.18]:11498 "EHLO siolinb.obspm.fr")
	by vger.kernel.org with ESMTP id S1422864AbWKPJzp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 04:55:45 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7041FE50@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org



On Tue, 14 Nov 2006, Moore, Eric wrote:

> I don't know how to disable domain validation.
>
> What I do know is the problem. THis is due to domain validation commands
> timeout out,
> which results in a host reset.  From the mptspi host reset, the driver
> starts
> spi transport domain validation all over again, and thus the infinite
> loop.  We do need to
> renegotiate again after host reset, or all the devices are at slowest
> speed,
> asyn narrow.  I have proposed a patch on this mailing list a couple
> months ago
> to fix this problem, however that patch was rejected.  My fix was in the
> mptspi host reset function, where I told firmware to negotaiate with the
> last
> parameters, thus avoiding having spi transport dv going into infinite
> loop.
> However a better fix is to have spi transport avoid sending a host reset
> when the commands timeout. I'm not sure if James Bottomely is waiting
> for a patch like that which would address the concerns off all drivers,
> instead
> of just addressing mptspi wooes. I'm not sure.  I could repost my mptspi
> fix again?

Well, an unofficial fix is better than nothing, so feel free to post
your patch (just give me also some instructions to apply it as I'm not
familiar to kernel patching).
As to the problem itself, I can confirm it's not specific to mptspi,
I've observed the same behaviour with the aic79xx driver under kernel
2.6.17.4 :-(

-- 
 		Etienne Vogt (Etienne.Vogt@obspm.fr)
 		Observatoire de Paris-Meudon, France.
