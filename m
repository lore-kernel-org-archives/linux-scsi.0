Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771354C74
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 00:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714006623; cv=none; b=PRzKpcx1h9hWuL+a+SBPuRY3AVn4XV2pgMOvoSGUSGxoBeRV/ZuAGI0ZeBlEgwMIvxUMoLc95SQWYN3l3hFiRGeLvwuET1qypkwv/n4cvqDSINZ1YdRKzvmG5lEfqlkR7awsGVE/2aj+PpNBmzZpATedho8ZqVPsKQvrqSmxNIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714006623; c=relaxed/simple;
	bh=VjhoX67lXHaEvZ5plNqVGYNpg3kF6NW9yMZR35MeM0U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aRbv1+e8nWh3Ap0dhK9+ObhIJMQ8oVxoALuV+PiX+zsznbXNhKsnr8NtIJXpWwotD5ZY7tOafHeoH9Xa4M3UAHJ5Gn6iYaia5NZ/FYIJFZViyZ57OIrUe5f8Qi5V1bfE+UsYYjSp9atsXqI3KGnK5jb05gJX/v9nl06ipZ5ILRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
X-QQ-mid: bizesmtp79t1714006596tmhhz576
X-QQ-Originating-IP: 9MPUbJmb3pdI+reCQX49KwhZvOZfwoVZvxiYqA7MR/g=
Received: from winn-pc ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 25 Apr 2024 08:56:35 +0800 (CST)
X-QQ-SSF: 01400000000000I0I000000A0000000
X-QQ-FEAT: abxxcdK0JW6kPYqIWq0gNhxcU+3R+WEPRyE35wMvN5gusvwWu/MM304YWKl5V
	bo9hLFGxZ5Yz0SAPs2CdzIUBaMrz7gjVVJauMZ039EkNzzkW1mo8HbVTwQhAFVIx+Pdpr4Z
	jgxC8WPZazweolnUw+udBT044rdedPSob28Qq/Kp60N7y542Lpa+roPPSqL1xjhMdWvOdBl
	magsTCt4sFrcw/pyYak3QyQEjh6ItRefJW8jvBY9PDnJW7qxKDZkKFZ+UHUrvKPN9oPn8UM
	rZcGc0lhxVo89KlY7vVVNxYzxNp3k1N6i6dZxUBHjJSIU06HTJWvKX/F5BQQd+IGTA0xoN8
	ShSV7/c4euWv0ycMaNqhpAthDHPUSts++BJdfAAjGM02uIN1Rn2VwLcdoKbrMM6++AqbsI5
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12203184866180681449
Date: Thu, 25 Apr 2024 08:56:34 +0800
From: Winston Wen <wentao@uniontech.com>
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: unsafe shutdown during system restart
Message-ID: <2FA6AD2D5F670978+20240425085634.241b5616@winn-pc>
In-Reply-To: <134b44cec24e0480f8df4e9bc0f0c1e28df24887.camel@redhat.com>
References: <482E2895A2BA14A6+20240424154718.47b5976d@winn-pc>
	<134b44cec24e0480f8df4e9bc0f0c1e28df24887.camel@redhat.com>
Organization: Uniontech
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1

On Wed, 24 Apr 2024 12:52:35 -0400
Laurence Oberman <loberman@redhat.com> wrote:

> On Wed, 2024-04-24 at 15:47 +0800, Winston Wen wrote:
> > Hi,
> > 
> > I noticed that my hard drive had an unsafe shutdown during system
> > restart. I have done some related research and found that a stop
> > command will be sent to the hard drive during system shutdown, but
> > not during system restart. 
> > 
> > Is there a way to avoid the unsafe shutdown? Or is it the
> > responsibility of the firmware to send the stop command to the hard
> > drive before shutdown? 
> > 
> > And why doesn't the kernel send the stop command in system restart?
> > I am indeed curious about it, and I would greatly appreciate it if
> > anyone
> > could help me clarify it. :)
> > 
> > Thanks!
> >   
> Which Distro are you using, where you are seeing this.
> And what is the kernel version.
> 
> Regards
> Laurence
> 
> 

Hi Laurence,

Thank you for your reply!

I found it on Deepin 20, with a 4.19 kernel and a sata disk from a
Chinese manufacturer. 

After undergoing a disk stress test (fio), I found that the write
performance of the disk was poor for a period of time after rebooting. 

The disk manufacturer did some troubleshooting and tracing, and
told me that the disk did not receive the stop command during the
reboot process, so it will take some time to rebuild the internal data
structure after being powered on again. 

They showed me a list of commands they traced, and during the shutdown
process, they would receive a STANDBY IMMEDIATE command after FLUSH
CACHE EXT, but not during the restart process. 

Then I did some tests to confirm. I enabled dev.scsi.logging_level in
the debian12 virtual machine (with 6.6 kernel) and collected logs on
system reboot and shutdown. During the shutdown, the "Stopping disk"
log can be seen, but it is not present during the reboot. 

I also hope to do some comparative testing on other hard drives, but I
did not find the unsafe shutdown related field in the smart information
of the sata disk (maybe I just missed it), so I give up. 

I am not an expert in scsi, so I took a temporary look at the relevant
code and found sd_shutdown based on the "Stopping disk" log, and I also
browsed some related commits and discussions.

I feel that this may be a firmware implementation issue, but I'm not so
sure, so I come to the community to ask for some advice. 

Just now, I tested another machine (also Deepin system, but American
Megatrends firmware), the Seagate's sata disk does not increase
power_cycle_count during the reboot. I think maybe this is the
right behavior of the firmware. 

Welcome any suggestions and corrections, and thanks for all replies!


-- 
Thanks,
Winston

