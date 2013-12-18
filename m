From: Kees Cook <keescook@chromium.org>
Subject: Re: [RESEND][PATCH] scsi: esas2r: fix potential format string flaw
Date: Wed, 18 Dec 2013 10:01:00 -0800
Message-ID: <CAGXu5jLxVxKtXmrSvtChfApH+p4Ag--KygPNWZs3KEuw4XvZrA@mail.gmail.com>
References: <20131217182733.GA16202@www.outflux.net>
	<1387345370.13593.10.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1387345370.13593.10.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 17, 2013 at 9:42 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2013-12-17 at 10:27 -0800, Kees Cook wrote:
>> This makes sure format strings cannot leak into the printk call via the
>> constructed buffer.
> []
>> diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
> []
>> @@ -171,7 +171,7 @@ static int esas2r_log_master(const long level,
>>               if (strlen(event_buffer) < buflen)
>>                       strcat(buffer, "\n");
>>
>> -             printk(event_buffer);
>> +             printk("%s", event_buffer);
>
> It's probably better to remove the
>
>                 if (strlen(event_buffer) < buflen)
>                         strcat(buffer, "\n");
>
> and use
>
>         printk("%s\n", event_buffer);
>
> so that the output is always newline terminated.

Ah! Yes, good call.

-Kees

-- 
Kees Cook
Chrome OS Security
