From: Eyal Ben David <bdeyal@gmail.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Fri, 25 Nov 2016 13:20:34 +0200
Message-ID: <CAPrnrPBcvBcNaZ5asJquRSp4Ann3xHVGSRbwLkvPF+YKJ6OpCw@mail.gmail.com>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
 <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
 <1479738275.19792.24.camel@localhost.localdomain> <1ca8515f-abd2-7428-8baa-dca879833be3@interlog.com>
 <1479752642.19792.43.camel@localhost.localdomain> <20161122083759.xeifuex3xxfimuwz@linux-x5ow.site>
 <1479839407.28416.21.camel@localhost.localdomain> <CAPrnrPAFSUL4C+N09-BUUm+7e84oxasaHb7-Ej-+8FuYOddRgA@mail.gmail.com>
 <2146476957.2165908.1479927335303.JavaMail.zimbra@redhat.com>
 <1479932524.28416.43.camel@localhost.localdomain> <20161125080758.5bh5jkcgvhw3xuvb@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34741 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbcKYLUg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2016 06:20:36 -0500
Received: by mail-io0-f193.google.com with SMTP id r94so8874228ioe.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 03:20:35 -0800 (PST)
In-Reply-To: <20161125080758.5bh5jkcgvhw3xuvb@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Laurence Oberman <loberman@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

Note that sg_mmap_read does not parse the SCSI sense, so the script
might fail for other reasons (some SCSI error) and think its a zero
byte corruption.


If you think an improved version could help (compare results within
the program + parse senses) I can help.


On Fri, Nov 25, 2016 at 10:07 AM, Johannes Thumshirn <jthumshirn@suse.de> w=
rote:
> On Wed, Nov 23, 2016 at 03:22:04PM -0500, Ewan Milne wrote:
>
> [...]
>
>> ---
>>
>> In other words, this commit made the bad behavior go away in 4.8.
>> Need to look at this in more detail, it doesn't appear as if this patch
>> was intended to fix such a problem.
>>
>> -Ewan
>
> Are you sure it did? I can repropduce copy_to_user() errors with 4.8 as w=
ell.
> Using the very same reproducer. On 4.8 it's just harder to trigger and
> doesn't trigger on AHCI as fas as I can telli (maybe I just haven't hit
> it hard enough). I can trigger it on QEMUs SCSI CDROM emulation and hpsa
> though. I cannot however trigger this with a minimal config inside an ini=
trd.
>
>
> Here's my test:
>
> --- 8< ---
> #!/bin/sh
>
> cleanup()
> {
>         rm -f expect.txt
>         rm -f test.txt
> }
>
> trap cleanup EXIT INT
>
> ./sg_mmap_read -d /dev/sg0 -l 0 | od -x > expect.txt
>
> for i in $(seq 1 5000); do
>         ./sg_mmap_read -d /dev/sg0 -l 0 | od -x > test.txt
>         diff expect.txt test.txt > /dev/null
>         if [ $? -ne 0 ]; then
>                 echo "FAIL"
>                 exit 1
>         fi
> done
>
> echo "PASS"
>
> --- >8 ---
>
> I added some trace_printk()s to sg.c and try to hunt it down. It'll be go=
od to
> know if anyone of you can reproduce it with the above script as well.
>
> Byte,
>         Johannes
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
