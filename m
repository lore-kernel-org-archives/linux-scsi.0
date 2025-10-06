Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACC72264CE
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 10:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759746121; cv=none; b=f95g7VDlPXFCgRjwdABLzlyDKRnQozKCkumvKQ5obOZxfjap8p0HOCW+QlEZV5yKvIE3N70vBlav6TiFe5ZdY9d4Ati5V1aAiLp3Nj3QqUHw8hyR58ELXYkVx1ORDNjf205YEynOhaw4E/WzUefAEY4z0BRz5dvoWv2IQNKSxB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759746121; c=relaxed/simple;
	bh=AJrCHogOFI5cKQaQS0F5R4X36lqcVoGB6kMJM/rOTkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a3Shg7agU5GCc2emkbizPeCqVu9X27TZq+94wkHg6YXXBPpkClO+7XNCwF9VXelvxN/KN9FFSgTf5BagOW8kms+t0jAJ83EBWzIB0grOZstRxHDbgsztc+MBDxTid/4bv+yEaHxKM4CEnwbgjhR6oktNQqLxE5zcqfqfmeTX7rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WXVJ62bX; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WXVJ62bX"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d60110772so48059457b3.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2025 03:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759746118; x=1760350918; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YHswFDCD4540V/T99FHqHZnQrWbNJSfM6DtDuneKmnY=;
        b=WXVJ62bXWTIxHv7/snRP2F1VHosC3KeYy3TBfnmBPIVXzKL2h24FcngY8/a3JD8g7A
         QgruRLDrR+bvYXUu//jM241mmdJuVPeOQ0O0qwXrhWjWHTrVlGzqvDCnp806QXNc8T5o
         r/I6eADyKnPAJxzJEaqp4wlSPBjzrP1E71qhTl1Ncm4fe8V8dU+PpCcBkiKdo5DK7fII
         mnA2DS+gDRTIkRFkYgaEx/fodLM6MlbgGTV4MZGkIg5g0IbvzEH3vux0eUxOMaY5pdJv
         rLacb2amccSJX9yGIXaIPu2dFmPtz1E4SPywy6x0Ch6YYIUe3CboDP0jBX0KJWqJMZZQ
         xhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759746118; x=1760350918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YHswFDCD4540V/T99FHqHZnQrWbNJSfM6DtDuneKmnY=;
        b=t2+GetLksLyTXvkRNqFBDibodC842ZBI5lzPmhCmo2gn9NzOGQZRrQcBNFfkuwwBrU
         HJLNfeRKYTpvt7h8jB0Sp3bSVl5TpUHcwP1XoW4jKWSFFQvXPIqTytv3ExAXKtSeWsy6
         LdlVTi5KBPMeCzZ6GJzMTWyc7j7f8poziSGL5jVvdIIo9+F0dneqHeY/fs4iYsFuQBan
         qG2iKk80iXvQ7NGQloSYIM3hefAJstxk/3MLKaO4SoAeZ+yXg7ni3VxQIZS23f4KxIF1
         SKMjD9gorlGnfA7TgwY7wgusCcyM1DTGozgEV/CjTwewEdanKout2ybNIYhWzUU9yvS2
         ToKw==
X-Forwarded-Encrypted: i=1; AJvYcCVKnsDcfvKXIAPOiKijp/Zizm0FDYY5kyp/NHKUMxbxy7q3F2ZF04ivG3N6M3xDQYoCjRvSubY7sCKA@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+FuChH7r7xyjOSl8Q3onK4Qi3Z6uTghSWuQqPk/VPzu0sf7ff
	9dmko8Tlve1SvA/tDbyq/JQQt1ZzLN+Ht5+BLZe2ZuRNvdUpMolJ23/1JAz+/slsOCq2Gis20Uf
	ka5qcZXA4GG73OsCrv8mwENYoBUJO9euLKXL0QKGKeQ==
X-Gm-Gg: ASbGnctF6hSDvLNiXbe/8BNc5UjTjX0+J2rdDDOZWDnUkNYkJznq5+OCSUNo4IChYHh
	xIGHXV2S9NhoxojAuAksQ7hwkjmRoAj6C9OG12p5uSq0usiURZSZgZDUrUKomJz5+5wiYO3vWMX
	qUCDnkS6EVB9KZla0PUudHp5V0839XLQFo4STr0Zee4V+oy5XRkhSGUzLEcbBn+li3+fOMvJzwv
	VU3SW0qEdt2jkhaZ2JImYWTrxPaWRxS0+re
X-Google-Smtp-Source: AGHT+IF77psB9K+vCNT5BqknfIdXI0+uekUjNxpVa2VL0PkfMCs3+TBiryz2Ck/k2rBVvaai4e1MlY1ofOfIlxeiR/c=
X-Received: by 2002:a05:690c:7403:b0:739:7377:fdcf with SMTP id
 00721157ae682-77f946d9ca3mr238701107b3.27.1759746117957; Mon, 06 Oct 2025
 03:21:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001060805.26462-1-beanhuo@iokpp.de> <20251001060805.26462-2-beanhuo@iokpp.de>
In-Reply-To: <20251001060805.26462-2-beanhuo@iokpp.de>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Mon, 6 Oct 2025 12:21:22 +0200
X-Gm-Features: AS18NWBgWnP4AaXTtJfAgW5wzsxvciI-aFmsX0xMwXAc3pjmjuiaNSmq0CyP-3U
Message-ID: <CAPDyKFpyh7Qag+ckCcPkr1RWh8YiST-4V2_Y7xvBU4LRLNC28A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] rpmb: move rpmb_frame struct and constants to
 common header
To: Bean Huo <beanhuo@iokpp.de>
Cc: avri.altman@wdc.com, bvanassche@acm.org, alim.akhtar@samsung.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, can.guo@oss.qualcomm.com, 
	beanhuo@micron.com, jens.wiklander@linaro.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Oct 2025 at 08:08, Bean Huo <beanhuo@iokpp.de> wrote:
>
> From: Bean Huo <beanhuo@micron.com>
>
> Move struct rpmb_frame and RPMB operation constants from MMC block
> driver to include/linux/rpmb.h for reuse across different RPMB
> implementations (UFS, NVMe, etc.).
>
> Signed-off-by: Bean Huo <beanhuo@micron.com>

I have queued this up via my mmc tree and plan to send a late
pull-request to Linus to get this included for 6.18-rc1.

That should help to land the remaining pieces for ufs in the second
step without having to care about the mmc parts.

Kind regards
Uffe

> ---
>  drivers/mmc/core/block.c | 42 --------------------------------------
>  include/linux/rpmb.h     | 44 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 42 deletions(-)
>
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index b32eefcca4b7..bd5f6fcb03af 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -79,48 +79,6 @@ MODULE_ALIAS("mmc:block");
>  #define MMC_EXTRACT_INDEX_FROM_ARG(x) ((x & 0x00FF0000) >> 16)
>  #define MMC_EXTRACT_VALUE_FROM_ARG(x) ((x & 0x0000FF00) >> 8)
>
> -/**
> - * struct rpmb_frame - rpmb frame as defined by eMMC 5.1 (JESD84-B51)
> - *
> - * @stuff        : stuff bytes
> - * @key_mac      : The authentication key or the message authentication
> - *                 code (MAC) depending on the request/response type.
> - *                 The MAC will be delivered in the last (or the only)
> - *                 block of data.
> - * @data         : Data to be written or read by signed access.
> - * @nonce        : Random number generated by the host for the requests
> - *                 and copied to the response by the RPMB engine.
> - * @write_counter: Counter value for the total amount of the successful
> - *                 authenticated data write requests made by the host.
> - * @addr         : Address of the data to be programmed to or read
> - *                 from the RPMB. Address is the serial number of
> - *                 the accessed block (half sector 256B).
> - * @block_count  : Number of blocks (half sectors, 256B) requested to be
> - *                 read/programmed.
> - * @result       : Includes information about the status of the write co=
unter
> - *                 (valid, expired) and result of the access made to the=
 RPMB.
> - * @req_resp     : Defines the type of request and response to/from the =
memory.
> - *
> - * The stuff bytes and big-endian properties are modeled to fit to the s=
pec.
> - */
> -struct rpmb_frame {
> -       u8     stuff[196];
> -       u8     key_mac[32];
> -       u8     data[256];
> -       u8     nonce[16];
> -       __be32 write_counter;
> -       __be16 addr;
> -       __be16 block_count;
> -       __be16 result;
> -       __be16 req_resp;
> -} __packed;
> -
> -#define RPMB_PROGRAM_KEY       0x1    /* Program RPMB Authentication Key=
 */
> -#define RPMB_GET_WRITE_COUNTER 0x2    /* Read RPMB write counter */
> -#define RPMB_WRITE_DATA        0x3    /* Write data to RPMB partition */
> -#define RPMB_READ_DATA         0x4    /* Read data from RPMB partition *=
/
> -#define RPMB_RESULT_READ       0x5    /* Read result request  (Internal)=
 */
> -
>  #define RPMB_FRAME_SIZE        sizeof(struct rpmb_frame)
>  #define CHECK_SIZE_NEQ(val) ((val) !=3D sizeof(struct rpmb_frame))
>  #define CHECK_SIZE_ALIGNED(val) IS_ALIGNED((val), sizeof(struct rpmb_fra=
me))
> diff --git a/include/linux/rpmb.h b/include/linux/rpmb.h
> index cccda73eea4d..ed3f8e431eff 100644
> --- a/include/linux/rpmb.h
> +++ b/include/linux/rpmb.h
> @@ -61,6 +61,50 @@ struct rpmb_dev {
>
>  #define to_rpmb_dev(x)         container_of((x), struct rpmb_dev, dev)
>
> +/**
> + * struct rpmb_frame - RPMB frame structure for authenticated access
> + *
> + * @stuff        : stuff bytes, a padding/reserved area of 196 bytes at =
the
> + *                 beginning of the RPMB frame. They don=E2=80=99t carry=
 meaningful
> + *                 data but are required to make the frame exactly 512 b=
ytes.
> + * @key_mac      : The authentication key or the message authentication
> + *                 code (MAC) depending on the request/response type.
> + *                 The MAC will be delivered in the last (or the only)
> + *                 block of data.
> + * @data         : Data to be written or read by signed access.
> + * @nonce        : Random number generated by the host for the requests
> + *                 and copied to the response by the RPMB engine.
> + * @write_counter: Counter value for the total amount of the successful
> + *                 authenticated data write requests made by the host.
> + * @addr         : Address of the data to be programmed to or read
> + *                 from the RPMB. Address is the serial number of
> + *                 the accessed block (half sector 256B).
> + * @block_count  : Number of blocks (half sectors, 256B) requested to be
> + *                 read/programmed.
> + * @result       : Includes information about the status of the write co=
unter
> + *                 (valid, expired) and result of the access made to the=
 RPMB.
> + * @req_resp     : Defines the type of request and response to/from the =
memory.
> + *
> + * The stuff bytes and big-endian properties are modeled to fit to the s=
pec.
> + */
> +struct rpmb_frame {
> +       u8     stuff[196];
> +       u8     key_mac[32];
> +       u8     data[256];
> +       u8     nonce[16];
> +       __be32 write_counter;
> +       __be16 addr;
> +       __be16 block_count;
> +       __be16 result;
> +       __be16 req_resp;
> +};
> +
> +#define RPMB_PROGRAM_KEY       0x1    /* Program RPMB Authentication Key=
 */
> +#define RPMB_GET_WRITE_COUNTER 0x2    /* Read RPMB write counter */
> +#define RPMB_WRITE_DATA        0x3    /* Write data to RPMB partition */
> +#define RPMB_READ_DATA         0x4    /* Read data from RPMB partition *=
/
> +#define RPMB_RESULT_READ       0x5    /* Read result request  (Internal)=
 */
> +
>  #if IS_ENABLED(CONFIG_RPMB)
>  struct rpmb_dev *rpmb_dev_get(struct rpmb_dev *rdev);
>  void rpmb_dev_put(struct rpmb_dev *rdev);
> --
> 2.34.1
>
