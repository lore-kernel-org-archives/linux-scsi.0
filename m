From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Linux 2.6.23-rc3
Date: Tue, 14 Aug 2007 08:25:59 -0400
Message-ID: <46C19F57.3070801@emulex.com>
References: <alpine.LFD.0.999.0708122143240.30176@woody.linux-foundation.org> <46C1717E.3030908@linpro.no>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:57827 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265AbXHNM0Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 08:26:16 -0400
In-Reply-To: <46C1717E.3030908@linpro.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tore Anderson <tore@linpro.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Smart <James.Smart@Emulex.Com>

fyi....

I've seen these before (and they haven't been specific to the LLDD).

The "-EEXIST" error, was an issue of rescan-while-deleting, and where
refcounts held the old sdevs in place. They were ramant in 2.6.18/2.6.19.
Supposedly, we had patches from Hannes Reinecke. to resolve it, but that
was a while ago.  Additionally, the traps around the attribute containers
are similar. There are still some cases of data structures being freed
(and thus erroneously reused later) in the midlayer and transports
even though the refcounts on child-structures haven't finished.

If you believe these are related to the -rc3 lpfc mods, I recommend
retesting on an -rc2 or 2.6.22 to see how similar they are.

I'll pull in -rc3 and see if I can't see more on my end..

-- james s

Tore Anderson wrote:
>   I gave it a spin, and got quite a few troubles that appears related to
>  the lpfc driver.  I don't know if these problems happened due to the
>  recent update as the latest kernel I ran before was 2.6.20 (where I
>  never saw problems like these).  First I see that something failed when
>  the volumes on the SAN (on a Sun StorageTek 6140 / Engenio 3994) is
>  registered, causing two errors errors such as:
