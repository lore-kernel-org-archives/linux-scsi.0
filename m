From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v3 2/3] megaraid_sas : use dev_printk when possible
Date: Wed, 8 Jul 2015 08:28:06 -0500
Message-ID: <CAErSpo6r8TH=262JYpUe4_RFdpEy6XA4LdGa8G5jN27pS0i4_A@mail.gmail.com>
References: <20150707204916.6218.37871.stgit@bhelgaas-glaptop2.roam.corp.google.com>
 <20150707205233.6218.13548.stgit@bhelgaas-glaptop2.roam.corp.google.com> <559CFFBE.80801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34481 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521AbbGHN21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 09:28:27 -0400
Received: by wifm2 with SMTP id m2so89596539wif.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2015 06:28:26 -0700 (PDT)
In-Reply-To: <559CFFBE.80801@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>, Christoph Hellwig <hch@lst.de>

On Wed, Jul 8, 2015 at 5:47 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 07/07/2015 10:52 PM, Bjorn Helgaas wrote:
>> Use dev_printk() when possible to make messages more useful.
>>
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas_base.c   |  304 +++++++++++++--------------
>>  drivers/scsi/megaraid/megaraid_sas_fusion.c |   95 ++++----
>>  2 files changed, 196 insertions(+), 203 deletions(-)
>>
> [ .. ]
>> @@ -1873,8 +1872,8 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
>>       cmd = megasas_get_cmd(instance);
>>
>>       if (!cmd) {
>> -             printk(KERN_DEBUG "megasas: megasas_get_ld_vf_affiliation_111:"
>> -                    "Failed to get cmd for scsi%d.\n",
>> +             dev_printk(KERN_DEBUG, &instance->pdev->dev, "megasas_get_ld_vf_affiliation_111:"
>> +                    "Failed to get cmd for scsi%d\n",
>>                       instance->host->host_no);
>>               return -ENOMEM;
>>       }
> Makes one wonder why we don't have a 'dev_debug'; dev_notice() and
> dev_warn() are there ...

There actually is a 'dev_dbg()' but when CONFIG_DYNAMIC_DEBUG is set,
I think dev_dbg() generates no output by default.  So to preserve the
previous behavior of "this message always appears in the dmesg log no
matter what the dynamic debug setting," I used dev_printk(KERN_DEBUG).

Somebody who maintains these drivers could probably go through and
convert these to either dev_info() or dev_dbg() depending on what they
need.  That would require more judgment than I wanted to get into :)

Thanks for taking a look at these!

Bjorn
