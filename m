From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] iscsi-target: Make buf param of iscsit_do_crypto_hash_buf()
 const void *
Date: Sun, 5 May 2013 11:35:19 +0200
Message-ID: <CAMuHMdUjyv2QghELUxgnqz_a3TKpChcvr9ObuM0GjHQVyuDvOg@mail.gmail.com>
References: <1367615757-1447-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdUOXbPkJf0Y1hupmmeotO6teFL1xJubRY0nBsTVu7=hBw@mail.gmail.com>
	<1367626605.21785.10.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1367626605.21785.10.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, May 4, 2013 at 2:16 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>> BTW, there are serious issues with casting pointers to u32s to pointers to u8s
>> for the last two output parameters of iscsit_do_crypto_hash_buf() (pad_bytes
>> and data_crc):
>>   1. It's not endian-safe,
>>   2. In many cases, the original u32 was not initialized at all, so the other 24
>>       bits contain garbage. This will cause 32-bit comparisons like
>>
>>         if (checksum != data_crc)
>>
>>      to fail in unpredictable ways.

Upon closer look, this issue is moot. But the code is confusing for the casual
reader, due to the casts
Changing the "u8 *pad_bytes" parameters to "const void *pad_bytes"
(which is what sg_init_one() takes anyway) should allow you to get rid of the
casts for pad_bytes.
For data_crc, the issue is that crypto_hash_final() takes a "u8 *out",
instead of a "void *out". Still, it's better to move the cast inside
iscsit_do_crypto_hash_buf(), so it's in one place only.

> Ugh, I can see how that would be problematic for BE..
>
> Changing these to use u8 data_crc[ISCSI_DIGEST_SIZE] and
> pad_bytes[ISCSI_PAD_LEN] now, and will post a patch soon.

That's another good idea.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
