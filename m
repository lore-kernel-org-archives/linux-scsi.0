From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: No I/O errors reported after SATA link hard reset
Date: Thu, 17 Aug 2017 16:23:59 +0200
Message-ID: <b3f6735d333aeee62410d5cfea852fd4@assyoma.it>
References: <fe5cc200a4cba71cb9e5e6a980699805@assyoma.it>
 <13561110-4e59-303a-8e3d-dd60c1bafba8@fastmail.fm>
 <20170817124821.GA3238792@devbig577.frc2.facebook.com>
 <559dc5fe-c162-41e6-7f14-0f3837b64585@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:59084 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750857AbdHQOYF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2017 10:24:05 -0400
In-Reply-To: <559dc5fe-c162-41e6-7f14-0f3837b64585@fastmail.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <"Bernd Schubert"@fastmail.fm>
Cc: Tejun Heo <tj@kernel.org>, Bernd Schubert <bernd.schubert@fastmail.fm>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Bernd,

Il 17-08-2017 15:18 Bernd Schubert ha scritto:
> 
> So for Gionatan the root cause was an instable power supply, but in my
> case there wasn't any power loss, there were just failed sata commands.

I tried many times to replicate the error by briefly 
disconnecting/reconnecting the SATA cable, but I had *no* corruption in 
this case. Sure, this was my experience, but a bad-behaving disk 
firmware can do all sort of bad things with the volatile cache, 
especially when renegotiating the host link.

I my case, I did *not* change the power supply, rather the SATA power 
cable: my theory is that, as the previous cable was shared between the 
two disks, somewhat low-voltage spiked find their ways and the second 
disk simply "rebooted". The new cable is dedicated to the SATA disk wich 
was previously failing.

What concern my is that, reading the linux-raid mailing list, many user 
have historycally reported high mismatch count in RAID1 arrays. These 
mismatches were generally discarded saying "RAID1 is prone to false 
positives" but, in my experience, these "false mismatches" are quite 
rare. What it means is that many users *are probably suffering* from my 
(and your) problem, without never realizing that...

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
