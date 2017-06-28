From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Re: Permanently change thin provisioning method from user space?
Date: Wed, 28 Jun 2017 07:06:27 +0300
Message-ID: <7958058d-a649-e149-bf6e-efe2b0b5432f@gmail.com>
References: <CAA91j0VCH06Xfk2Hx6ooDnd4+9+Sv1Z+2TY7MmQmgKLoiB0=+A@mail.gmail.com>
 <1498597291.10198.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:33253 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdF1EGa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 00:06:30 -0400
Received: by mail-lf0-f44.google.com with SMTP id m77so27785797lfe.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2017 21:06:30 -0700 (PDT)
In-Reply-To: <1498597291.10198.21.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: linux-scsi@vger.kernel.org

28.06.2017 00:01, Ewan D. Milne пишет:
> On Tue, 2017-06-27 at 14:02 +0300, Andrei Borzenkov wrote:
>> I'm facing storage system that while generally advertising support for
>> WRITE_SAME_16 with UNMAP in reality fails this request depending on
>> exact volume configuration. This configuration is done on storage side
>> and may happen after host initially discovered LUN.
>>
>> I though about simply overriding kernel auto-detect with UNMAP using
>> sysfs scsi_disk/.../provisioning_mode attribute, but it appears kernel
>> may re-evaluate it in some cases, so changes do not stick. Is it
>> possible to permanently restrict it per-device (or per-vendor/device)?
>>
>> TIA
>>
>> -andrei
> 
> sd_fops->revalidate_disk() will cause the properties that cause the
> provisioning_mode to be evaluated to be re-read, and sd_config_discard()
> to set the determined mode.  We might want to re-think this, since the
> user overrode what was probed earlier.  However, we might also want to
> automatically handle the storage capabilities changing, so I'm not sure.
> 

Will revalidate_disk() emit "change" event? If yes, it can be handled by
udev rule (although small race window probably will still exist).

> I think we should figure out how best to handle devices/arrays that aren't
> correctly handling WRITE SAME(16) w/UNMAP,


In this case it caused total multipath outage because it tried DISCARD
on every path and failed all of them in turn.
