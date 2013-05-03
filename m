From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] iscsi-target: Make buf param of iscsit_do_crypto_hash_buf()
 const void *
Date: Fri, 3 May 2013 23:22:34 +0200
Message-ID: <CAMuHMdUOXbPkJf0Y1hupmmeotO6teFL1xJubRY0nBsTVu7=hBw@mail.gmail.com>
References: <1367615757-1447-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1367615757-1447-1-git-send-email-geert@linux-m68k.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, May 3, 2013 at 11:15 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c

> @@ -3585,9 +3575,8 @@ static int iscsit_send_reject(
>         }
>
>         if (conn->conn_ops->DataDigest) {
> -               iscsit_do_crypto_hash_buf(&conn->conn_tx_hash,
> -                               (unsigned char *)cmd->buf_ptr, ISCSI_HDR_LEN,
> -                               0, NULL, (u8 *)&cmd->data_crc);
> +               iscsit_do_crypto_hash_buf(&conn->conn_tx_hash, cmd->buf_ptr,
> +                               ISCSI_HDR_LEN, 0, NULL, (u8 *)&cmd->data_crc);

BTW, there are serious issues with casting pointers to u32s to pointers to u8s
for the last two output parameters of iscsit_do_crypto_hash_buf() (pad_bytes
and data_crc):
  1. It's not endian-safe,
  2. In many cases, the original u32 was not initialized at all, so the other 24
      bits contain garbage. This will cause 32-bit comparisons like

        if (checksum != data_crc)

     to fail in unpredictable ways.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
