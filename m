From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Bugs in multipath scsi in 4.3-rc2
Date: Mon, 12 Oct 2015 15:29:45 -0400
Message-ID: <CAMM=eLdLh4VGapGH2WcEUY2Biwx-ZojQ0HELCFYvQwW9zzpQ1A@mail.gmail.com>
References: <1443202278.2188.13.camel@HansenPartnership.com>
 <20150930151449.GC26299@lst.de> <20150930215303.GI2627@mtj.duckdns.org>
 <1443652494.2185.57.camel@HansenPartnership.com> <20151002125608.GB14899@lst.de>
 <1443792301.2209.4.camel@HansenPartnership.com> <20151002133423.GA15867@lst.de>
 <1443793497.2209.10.camel@HansenPartnership.com> <20151004074556.GA13932@lst.de>
 <561BAB72.1070205@suse.de> <20151012143927.GA24770@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37949 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbbJLTaG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 15:30:06 -0400
Received: by igkz10 with SMTP id z10so53948308igk.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2015 12:30:05 -0700 (PDT)
In-Reply-To: <20151012143927.GA24770@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Paul Mackerras <paulus@ozlabs.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Oct 12, 2015 at 10:39 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Oct 12, 2015 at 02:45:38PM +0200, Hannes Reinecke wrote:
>> You cannot easily use the driver model here as the scsi_device is
>> already (potentially) bound to the ULDs.
>> If you were to go with the driver model you'd have to introduce
>> another sub device between scsi_target and scsi_device.
>
> You can have two struct devices in struct scsi_device, while it's
> not pretty there are plenty of example all over the kernel with
> multiple devices in a single containing structure.
>
>> Actually I have been thinking that, as it might make my life for the
>> ALUA handler easier. However, this would be quite a largish redesign
>> of the current handler infrastructure, pushing out my ALUA handler
>> update even more.
>> So I'd like to have the ALUA changes ironed out first and merged,
>> and then work on a redesigned device handler infrastructure.
>
> Fine with me.  As mentioned before we've never supported autoloading
> the device handler modules at boot time - we only ever loaded them when
> explicitly attaching them through device mapper.  Waiting another
> release or maybe two to finally get there isn't the end of the world.

What may be getting lost during this discussion is that historically
it has been important to be able to attach the scsi_dh during the SCSI
scan.  As the scsi_dh alters the SCSI midlayer's sense code processing
(via callout to the attached scsi_dh).  And this altered SCSI sense
code handling amounts to the difference between a successful/quick
boot versus hugely delayed and ultimately error-prone boot on systems
with many LUNs that have multiple paths.

So that is why either of these solutions were deployed:
1) in RHEL6 we'd require dracut to preload the scsi_dh modules early
in loading the initramfs
2) in RHEL7 all scsi_dh modules _are_ builtin

Both achieve the goal of having all required scsi_dh available during SCSI scan.

Mike
