From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Good SAS adapters for 6 Gb/s SATA SSD's (with TRIM)?
Date: Fri, 12 Aug 2011 10:35:05 +0100
Message-ID: <4E44F3C9.4030708@gmail.com>
References: <4E43F2C3.9000808@computerix.info> <4E4434A4.7010808@interlog.com> <4E449BB1.3060300@interlog.com> <4E44DE8E.3070809@computerix.info> <4E44E13B.2050503@gmail.com> <4E44E8E5.4040707@computerix.info> <4E44EBF4.8050801@gmail.com> <4E44F14F.1020206@computerix.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54246 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1HLJfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2011 05:35:11 -0400
Received: by qyk34 with SMTP id 34so1684601qyk.19
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2011 02:35:10 -0700 (PDT)
In-Reply-To: <4E44F14F.1020206@computerix.info>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prof. Dr. Klaus Kusche" <klaus.kusche@computerix.info>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, Mark Lord <mlord@pobox.com>

On 08/12/2011 10:24 AM, Prof. Dr. Klaus Kusche wrote:
> On 2011-08-12 11:01, Ric Wheeler wrote:
>> Lukas has a more generic bulk tool that should do the job and has the
>> advantage that it does not have to fill the file system first (it can
>> lock regions and do its work).
>
> Any pointers to that?

I think that the easiest (and most natural way) to do this is through the 
updated fsck (-K) tool which will discard the unused block ranges when you fsck 
a file system.

Lukas can add in details about versions, etc :)

>
> Thanks!
>
>> Note that discard is not just for physical devices like SCSI or ATA, it
>> is also useful for "software" stacks like various device mapper targets,
>> virtual block devices, etc so we should be keeping the abstraction at a
>> high level for our tooling.
>
> I agree, but wiper.sh has been the first such tool and is widespread
> and well-known. I'm not aware of alternatives using the generic fstrim
> command (which is still missing on some major distributions)
> or FITRIM ioctl.
>

FITRIM is somewhat misnamed. It will end up issuing a discard to the storage 
stack, not an ATA specific TRIM command (invoking sb_issue_discard()).

Anything that uses FITRIM should work if I followed the code correctly,

Ric



