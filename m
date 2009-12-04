From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
Date: Fri, 4 Dec 2009 20:00:15 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0912041952370.23464@uplift.swm.pp.se>
References: <200909090414.41274.tfjellstrom@shaw.ca> <200909091030.13147.tfjellstrom@shaw.ca>  <4AA7F965.6020408@garzik.org> <4AF0CFE1.8050407@tomt.net>  <alpine.DEB.1.10.0912032214040.23464@uplift.swm.pp.se>
 <73e903670912031336n749c0bb4l5f2e46d5347e5875@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1125956565-1259953215=:23464"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:54882 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbZLDTAJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Dec 2009 14:00:09 -0500
In-Reply-To: <73e903670912031336n749c0bb4l5f2e46d5347e5875@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-15?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1125956565-1259953215=:23464
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 3 Dec 2009, Kristleifur Daðason wrote:

> On Thu, Dec 3, 2009 at 9:17 PM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>>
>> On Wed, 4 Nov 2009, Andre Tomt wrote:
>>
>>> Identical issues with the AOC-SASLP-MV8 card with 8 Seagate Barracuda
>>> 7200.11 1.5TB drives using the mvsas driver. Creating a md raid array seems
>>> to trigger it nearly instantly, however other loads do not trigger it
>>> as fast (if at all, only tested briefly with paralell dd).
>>
>> Would just like to chime in with a "me too" on this. I've tried both ubuntu
>> 9.10 kernel (2.6.31) and their 10.04 pre-alpha (guess it's 2.6.32-rc8) and
>> mvsas + AOC-SASLP-MV8 is pretty much unusable. If I start md creation it
>> stalls immediately and gets nowhere, last time I tried it md claimed it had
>> written 160 blocks then it stalled (all drive LEDs on the controller is
>> constantly lit).
>>
>> If I boot without drives and then hot-plug the drives, it immediately
>> oops:es.
>>
>> Any code/fixes I can try, this is a lab machine so I can easily do whatever
>> needed with it...
>>
>
> Hi,
>
> I had a bit of trouble finding some patches that were released by Andy Yan at
> Marvell on November 9th, so here is a link:
>
> 1/7: http://kerneltrap.org/mailarchive/linux-scsi/2009/11/9/6558753

They applied cleanly to the ubuntu 10.04 2.6.32 kernel source package but 
when compiling I received an error about "sas_change_queue_depth" having 
wrong amount of arguments:

-		sas_change_queue_depth(sdev, MVS_QUEUE_SIZE);
+		sas_change_queue_depth(sdev, MVS_QUEUE_SIZE, SCSI_QDEPTH_DEFAULT);

So I removed that change and then things compiled, booted properly, but 
just froze when I plugged in the disks (including some garbled graphics on 
my X screen). That patch set doesn't seem to be ok.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1125956565-1259953215=:23464--
