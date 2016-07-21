From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH resend 3/5] libata-scsi: fix overflow in mode page copy
Date: Fri, 22 Jul 2016 05:39:27 +0800
Message-ID: <CAGnHSEkj2kXNUyQa=MxmLsTJT3P9xrQjpjoMLYiz6xKPB896EA@mail.gmail.com>
References: <af84a796696f2f366d330595d1a818e8daeb86d8.1469126217.git.tom.ty89@gmail.com>
 <b2ae6752649bc02641d38fee75ee35a59e8466d8.1469126217.git.tom.ty89@gmail.com>
 <fc2946598c92137f65636b0fd7e50dc71a089fa1.1469126217.git.tom.ty89@gmail.com> <20160721211714.GE23759@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20160721211714.GE23759@htj.duckdns.org>
Sender: linux-next-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Well, I mean this is happening when ata_mselect_*() calls ata_msense_*():

[tom@localhost ~]$ cat test.c
#include <stdio.h>
#include <string.h>

typedef unsigned char u8;

int main() {
  u8 a[2] = { 0xff, 0xff };
  char b[2];
  memcpy(b, a, 2);

  for (int i=0; i<2; i++) {
    printf("%d\n", a[i]);
  }

  for (int i=0; i<2; i++) {
    printf("%d\n", b[i]);
  }
}

[tom@localhost ~]$ cc test.c

[tom@localhost ~]$ ./a.out
255
255
-1
-1

Let me know how I should polish the description for this.

On 22 July 2016 at 05:17, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Jul 22, 2016 at 02:41:52AM +0800, tom.ty89@gmail.com wrote:
>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> ata_mselect_*() would initialize a char array for storing a copy of
>> the current mode page. However, if char was actually signed char,
>> overflow could occur.
>
> Do you mean sign extension?
>
>> For example, `0xff` from def_control_mpage[] would be "truncated"
>> to `-1`. This prevented ata_mselect_control() from working at all,
>> since when it did the read-only bits check, there would always be
>> a mismatch.
>
> Heh, the description doesn't really make sense.  Are you talking about
> something like the following?
>
>         char ar[N];
>         int i;
>
>         i = ar[x];
>         if (i == 0xff)
>                 asdf;
>
> If so, the description isn't quite right.
>
> Thanks.
>
> --
> tejun
