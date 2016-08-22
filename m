From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH 1/7] aacraid: Use memdup_user() rather than duplicating
 its implementation
Date: Mon, 22 Aug 2016 22:23:57 +0200
Message-ID: <b61d1eef-35c6-5e8c-a342-db312e27cb1f@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <40d8607f-3934-c31f-3791-ef6a67d65d45@users.sourceforge.net>
 <23c56a66-74a6-6033-f209-ac3e4ba83e61@users.sourceforge.net>
 <423FD6710FB8FB4F8728F93591889F9A15FA8E64@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <423FD6710FB8FB4F8728F93591889F9A15FA8E64@avsrvexchmbx1.microsemi.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Carroll <david.carroll@microsemi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

>> @@ -526,15 +526,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void
>> __user * arg)
>>                 goto cleanup;
>>         }
>>
>> -       user_srbcmd = kmalloc(fibsize, GFP_KERNEL);
>> -       if (!user_srbcmd) {
>> -               dprintk((KERN_DEBUG"aacraid: Could not make a copy of the srb\n"));
>> -               rcode = -ENOMEM;
>> -               goto cleanup;
>> -       }
>> -       if(copy_from_user(user_srbcmd, user_srb,fibsize)){
>> -               dprintk((KERN_DEBUG"aacraid: Could not copy srb from user\n"));
>> -               rcode = -EFAULT;
>> +       user_srbcmd = memdup_user(user_srb, fibsize);
>> +       if (IS_ERR(user_srbcmd)) {
>> +               rcode = PTR_ERR(user_srbcmd);
>>                 goto cleanup;
>>         }
>>
>> --
> 
> Hi Markus,
> 
> Patch 2/7 should precede Patch 1/7, as falling into kfree() would not look pretty.

Do you eventually prefer that this source code adjustment should be combined with
the update suggestion "[2/7] aacraid: One function call less in aac_send_raw_srb()
after error detection" in a single update step?

Regards,
Markus
