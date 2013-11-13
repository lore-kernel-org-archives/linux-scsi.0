From: David Decotigny <decot@googlers.com>
Subject: Re: [PATCH] scsi: avoid use of reclaimed reference
Date: Tue, 12 Nov 2013 18:09:16 -0800
Message-ID: <CAG88wWZyodGU7AmTX=wYWn5igr-ySm_HLs0uA1iO+Fxq3msRnA@mail.gmail.com>
References: <cover.1384304973.git.decot@googlers.com> <643cda2192c25962f37c8bba65e22f70a57167d0.1384304973.git.decot@googlers.com>
 <1384307830.2248.17.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:47618 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab3KMCJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 21:09:36 -0500
Received: by mail-ie0-f175.google.com with SMTP id u16so7983023iet.34
        for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2013 18:09:36 -0800 (PST)
In-Reply-To: <1384307830.2248.17.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

I was considering the following scenario wherein the "if
(scsi_device_created(sdev))" test at the end would test garbage at
best (or unmapped data):

       if (!(sdev = scsi_device_lookup_by_target(starget, 0))) {  // not found
               sdev = scsi_alloc_sdev(starget, 0, NULL);    // -> ref cnt = 2
               ...
               if (scsi_device_get(sdev)) {  // -> ref cnt = 3
                 ...
               }
               ...
       }
      ...
                       res = scsi_probe_and_add_lun(starget,    // ->
ref cnt = 1
      ...
       scsi_device_put(sdev);  // -> reclaimed
       if (scsi_device_created(sdev))  // test on garbage or unmapped data (#PF)
          ...


On Tue, Nov 12, 2013 at 5:57 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2013-11-12 at 17:10 -0800, David Decotigny wrote:
>> This patch avoids to use an object after it was potentially reclaimed
>> by scsi_device_put().
>
> The analysis is wrong, I'm afraid.  __scsi_remove_device() does the
> final put for devices that are being destroyed.  If the device isn't in
> the created state, then it's long lived and nothing in the report lun
> scan does the final put.
>
> James
>
>
