Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1A43859E6
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 03:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778644660; cv=none; b=Qh2UdBy9INBxJdHP/D6pKqc1TxaBb16/hbEw1kQyQGjkbMsZX6rhPyhp+7MX29oMSaiiZPbBbxRTeFHef4dAlCUtyv9HIDoW+I0IFQRelRI3uslQT3Bpw6e3EEhQGLJ3nsFOXJmH2uQ0T7dqQrmmCEbwaYXu/J/t992CzlEL7O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778644660; c=relaxed/simple;
	bh=S/18jstxGLku7AnB6d6xJJ/nJKtfUR371Hl7TxTz4Ew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q3/bTh8OagV/a0gIcbyJovy0yjgH7gr5gRTmz4HEBBSBBvMsOtRgK5Sm7yAVi2eN+rXEW4oEC6itsAEt+gdhemZMbUvpm6aiNVuUErck39SAb0faNHP+WkupdzDPlfVh35G7Y9E2kAY6cjEyiOxVGdvVAuNU54CfQOCGcYZkRj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MOSn0EI5; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MOSn0EI5"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2babfd18435so32225275ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 20:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778644657; x=1779249457; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=SMmA1p470K8kHm/RzIg3KMhBzTbF4IoaEYfJlifMsIQ=;
        b=MOSn0EI5z2HuWTU20ReCJgelxTn3yW3BiPoUv0+Eilq1AnQ5hgj8Enh09E0w5lbZ1t
         zE8E98jD9FSOEnnIX48pF5706aHYMY7keSbTiKF0Cq1r14tu6y2JOR6f+hIaEt/k4WNq
         VgmU7dQbwH1KCkInJpWDsOBE2dviYq8iqLMZY3g4ZdNcLL55TYzbECl+JnyK7luinPSS
         SdlnDfMuUjnvRAjsNRag4FrnSDyJRz1YOQxDK2KcbhafXVVwQx+K0BOR1rAL4SNcI08M
         lNKcew78YnVMfnbompDzXJTcabCuxoB/PNmJIVieaBCAOhedd1GqWrZPZ5I1ewLX67O3
         Cq/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778644657; x=1779249457;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SMmA1p470K8kHm/RzIg3KMhBzTbF4IoaEYfJlifMsIQ=;
        b=UmRz9eK7IQi4a0NqZYzprw2nHXlnahO2cB8XQfB1u7ma0reGohNRV3I/dUysTTAqvA
         UPiSgKoK2cKlarGsA0DspyMoOIDhsKGY9M0IWI4SLE9Kl8XMVNrxMai2WQanHu29CuMP
         0XQiogsgmtOY1VyUcQ0fol10TayE74/Xl/A9AFpa2qrcPjzMIJe5p2XJTLM+nFgt7K2D
         23G1SPn9Z5RBHWgPHmIrUUCgk7XbE8H4XsMCYmWcMPmJD9zxTZoR/lJyKdKgxRSlonHB
         NcEJ87mtH/lmavSYtSp+asZzM6bZvXSNwpQsxIKOUrBMIOenoBMQV+nKvCPbGsLndpbD
         81HA==
X-Forwarded-Encrypted: i=1; AFNElJ9Eyyn8faclX4tVE8AOFt46XTAB2H1JYdxgSHoBWILKBOD/FsR+nmkC60yWVd+rle53UJz1SH3Yjeh0@vger.kernel.org
X-Gm-Message-State: AOJu0YxsDs1q4cIjGw4Ap/qf+LmdPEYazc3i1ytyHRAY2LHMkmw5JlQP
	OlyvXBMmagtszUQZ5KzeZgpmeeypVsQbPCue/V7yiH54zlJLZgNE9UVQ4O9fIQ==
X-Gm-Gg: Acq92OGk5l2L53VQcImwfQfH0LYyh58L1mmE/pdSCTyF15BZtf7AXPjw2Idzs9+Gst+
	VXzJTHzuCQr1Hz/44Q43TKNXAM0z12yb+/LL5ZFEQRYhUhw0AyHwa2oH/ck8eCpnsltTuExYD6T
	v5c30nRe3Pn5ShfKl4n/oRjQE+QxwK4wTvFBzYN8k41lCaFxb63WkYOiluTQWzOEig9i4azOfxe
	7B1vrpopzc2UWtpZZj9qwKE2eIs6x/jY4+qaGc8x3mjMhxX2MxEmOQc16Sfkjeu/C23JADs/4aY
	vr9TFnuVvqeBLiuWwOKQS640zFfXKt8GDHhiL2CcjAr5/2k53hh5goFEVXAhO+NhManA4CHwyMb
	6ztsxP+wrCTwyGoM6dw7OKGmxNjQ0QqiqMH2+hbZdFbn+m1Smmiwb/TqxubcYiWXhN4pSx+Gzrt
	LsLyMCjsP9SdlQjWvY7MfQPlmeXVRppLjJaUFE7HdSTlazzoSQv77mSCNkOE3K80uVUwnES3+i
X-Received: by 2002:a17:903:44c8:b0:2b4:5e65:5d0e with SMTP id d9443c01a7336-2bd27156fe4mr12608565ad.10.1778644657042;
        Tue, 12 May 2026 20:57:37 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d52f27sm186309545ad.36.2026.05.12.20.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 20:57:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <934b475d-1d77-4670-af10-4f3f2ddad61d@roeck-us.net>
Date: Tue, 12 May 2026 20:57:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: mpt3sas: add hwmon support
To: Louis Sautier <sautier.louis@gmail.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260512214703.655633-1-sautier.louis@gmail.com>
 <20260512214703.655633-3-sautier.louis@gmail.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAmgrMyQFCSbODQkACgkQyx8mb86fmYGcWRAA
 oRwrk7V8fULqnGGpBIjp7pvR187Yzx+lhMGUHuM5H56TFEqeVwCMLWB2x1YRolYbY4MEFlQg
 VUFcfeW0OknSr1s6wtrtQm0gdkolM8OcCL9ptTHOg1mmXa4YpW8QJiL0AVtbpE9BroeWGl9v
 2TGILPm9mVp+GmMQgkNeCS7Jonq5f5pDUGumAMguWzMFEg+Imt9wr2YA7aGen7KPSqJeQPpj
 onPKhu7O/KJKkuC50ylxizHzmGx+IUSmOZxN950pZUFvVZH9CwhAAl+NYUtcF5ry/uSYG2U7
 DCvpzqOryJRemKN63qt1bjF6cltsXwxjKOw6CvdjJYA3n6xCWLuJ6yk6CAy1Ukh545NhgBAs
 rGGVkl6TUBi0ixL3EF3RWLa9IMDcHN32r7OBhw6vbul8HqyTFZWY2ksTvlTl+qG3zV6AJuzT
 WdXmbcKN+TdhO5XlxVlbZoCm7ViBj1+PvIFQZCnLAhqSd/DJlhaq8fFXx1dCUPgQDcD+wo65
 qulV/NijfU8bzFfEPgYP/3LP+BSAyFs33y/mdP8kbMxSCjnLEhimQMrSSo/To1Gxp5C97fw5
 3m1CaMILGKCmfI1B8iA8zd8ib7t1Rg0qCwcAnvsM36SkrID32GfFbv873bNskJCHAISK3Xkz
 qo7IYZmjk/IJGbsiGzxUhvicwkgKE9r7a1rOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAmgrMyQFCSbODQkACgkQyx8mb86fmYHlgg/9
 H5JeDmB4jsreE9Bn621wZk7NMzxy9STxiVKSh8Mq4pb+IDu1RU2iLyetCY1TiJlcxnE362kj
 njrfAdqyPteHM+LU59NtEbGwrfcXdQoh4XdMuPA5ADetPLma3YiRa3VsVkLwpnR7ilgwQw6u
 dycEaOxQ7LUXCs0JaGVVP25Z2hMkHBwx6BlW6EZLNgzGI2rswSZ7SKcsBd1IRHVf0miwIFYy
 j/UEfAFNW+tbtKPNn3xZTLs3quQN7GdYLh+J0XxITpBZaFOpwEKV+VS36pSLnNl0T5wm0E/y
 scPJ0OVY7ly5Vm1nnoH4licaU5Y1nSkFR/j2douI5P7Cj687WuNMC6CcFd6j72kRfxklOqXw
 zvy+2NEcXyziiLXp84130yxAKXfluax9sZhhrhKT6VrD45S6N3HxJpXQ/RY/EX35neH2/F7B
 RgSloce2+zWfpELyS1qRkCUTt1tlGV2p+y2BPfXzrHn2vxvbhEn1QpQ6t+85FKN8YEhJEygJ
 F0WaMvQMNrk9UAUziVcUkLU52NS9SXqpVg8vgrO0JKx97IXFPcNh0DWsSj/0Y8HO/RDkGXYn
 FDMj7fZSPKyPQPmEHg+W/KzxSSfdgWIHF2QaQ0b2q1wOSec4Rti52ohmNSY+KNIW/zODhugJ
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20260512214703.655633-3-sautier.louis@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/12/26 14:47, Louis Sautier wrote:
> Expose the IOC and board temperature sensors of LSI / Broadcom SAS
> HBAs through hwmon. Readings come from MPI IO Unit Page 7 via the
> accessor added in the preceding patch.
> 
> The same fields are exposed by Broadcom's userspace tooling
> through the /dev/mpt[23]ctl ioctl path (typically root-only):
> IOCTemperature and BoardTemperature in lsiutil; ROC and Controller
> in storcli. With this driver, sensors(1) shows them unprivileged:
> 
>    $ sensors mpt3sas-pci-0200
>    mpt3sas-pci-0200
>    Adapter: PCI adapter
>    IOC:          +42.0°C
> 
> Each channel is gated independently by its *TemperatureUnits field
> through is_visible(); cards that populate only one sensor expose
> only one input file, and cards that populate neither do not register
> an hwmon device.
> 
> Built into mpt3sas.ko under a new CONFIG_SCSI_MPT3SAS_HWMON Kconfig
> option.
> 
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Louis Sautier <sautier.louis@gmail.com>
> ---
>   Documentation/hwmon/index.rst        |   1 +
>   Documentation/hwmon/mpt3sas.rst      |  57 ++++++++

This is not appropriate. The description is wrong and misleading.
mpt3sas is _not_ a hwmon driver. It is a chip access driver which
happens to support hardware monitoring.

If this is part of the mpt3sas code and not a separate driver,
please keep it there.

Thanks,
Guenter

>   MAINTAINERS                          |   1 +
>   drivers/scsi/mpt3sas/Kconfig         |   9 ++
>   drivers/scsi/mpt3sas/Makefile        |   2 +
>   drivers/scsi/mpt3sas/mpt3sas_base.h  |  17 +++
>   drivers/scsi/mpt3sas/mpt3sas_hwmon.c | 200 +++++++++++++++++++++++++++
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c |   6 +
>   8 files changed, 293 insertions(+)
>   create mode 100644 Documentation/hwmon/mpt3sas.rst
>   create mode 100644 drivers/scsi/mpt3sas/mpt3sas_hwmon.c
> 
> diff --git a/Documentation/hwmon/index.rst b/Documentation/hwmon/index.rst
> index 8b655e5d6b68..106f87fa8b18 100644
> --- a/Documentation/hwmon/index.rst
> +++ b/Documentation/hwmon/index.rst
> @@ -193,6 +193,7 @@ Hardware Monitoring Kernel Drivers
>      mp9941
>      mp9945
>      mpq8785
> +   mpt3sas
>      nct6683
>      nct6775
>      nct7363
> diff --git a/Documentation/hwmon/mpt3sas.rst b/Documentation/hwmon/mpt3sas.rst
> new file mode 100644
> index 000000000000..3a260a389d6d
> --- /dev/null
> +++ b/Documentation/hwmon/mpt3sas.rst
> @@ -0,0 +1,57 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Kernel driver mpt3sas
> +=====================
> +
> +Supported chips:
> +
> +  * LSI / Broadcom / Avago SAS HBAs handled by the mpt3sas driver,
> +    such as the 9300, 9400, and 9500 series.
> +
> +    Prefix: ``mpt3sas``
> +
> +
> +Description
> +-----------
> +
> +The mpt3sas driver exposes the IOC and board temperature sensors of
> +LSI / Broadcom SAS HBAs through the hwmon interface.
> +Either or both sensors may be absent depending on the card; the
> +corresponding sysfs files only appear when the firmware reports the
> +sensor as present, and cards that report neither sensor do not
> +register an hwmon device at all.
> +
> +
> +Sysfs entries
> +-------------
> +
> +============  ======================
> +Name          Description
> +============  ======================
> +temp1_input   IOC temperature (mC)
> +temp1_label   "IOC"
> +temp2_input   Board temperature (mC)
> +temp2_label   "Board"
> +============  ======================
> +
> +
> +Cross-reference with vendor tooling
> +-----------------------------------
> +
> +The hwmon channels correspond to fields reported by Broadcom's
> +proprietary tools as follows:
> +
> +=================  ==========================  ===============================
> +hwmon label        lsiutil                     storcli
> +=================  ==========================  ===============================
> +``IOC`` (temp1)    ``IOCTemperature``          ``ROC temperature``
> +``Board`` (temp2)  ``BoardTemperature``        ``Controller temperature``
> +=================  ==========================  ===============================
> +
> +With lsiutil::
> +
> +    lsiutil -pN -a 25,2,0,0
> +
> +With storcli::
> +
> +    storcli /cN show temperature
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2040011a386..e084f710f436 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15154,6 +15154,7 @@ L:	MPT-FusionLinux.pdl@broadcom.com
>   L:	linux-scsi@vger.kernel.org
>   S:	Supported
>   W:	http://www.avagotech.com/support/
> +F:	Documentation/hwmon/mpt3sas.rst
>   F:	drivers/message/fusion/
>   F:	drivers/scsi/mpt3sas/
>   
> diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
> index c299f7e078fb..638acd2c6623 100644
> --- a/drivers/scsi/mpt3sas/Kconfig
> +++ b/drivers/scsi/mpt3sas/Kconfig
> @@ -73,6 +73,15 @@ config SCSI_MPT3SAS_MAX_SGE
>   	can be 256. However, it may decreased down to 16.  Decreasing this
>   	parameter will reduce memory requirements on a per controller instance.
>   
> +config SCSI_MPT3SAS_HWMON
> +	bool "LSI MPT Fusion SAS hwmon support"
> +	depends on SCSI_MPT3SAS && HWMON
> +	depends on !(SCSI_MPT3SAS=y && HWMON=m)
> +	help
> +	Say Y here to expose the IOC and board temperature sensors of
> +	LSI / Broadcom SAS HBAs (such as the 9300, 9400, and 9500 series)
> +	through hwmon. See Documentation/hwmon/mpt3sas.rst for details.
> +
>   config SCSI_MPT2SAS
>   	tristate "Legacy MPT2SAS config option"
>   	default n
> diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefile
> index e76d994dbed3..9a2f3ce4158a 100644
> --- a/drivers/scsi/mpt3sas/Makefile
> +++ b/drivers/scsi/mpt3sas/Makefile
> @@ -9,3 +9,5 @@ mpt3sas-y +=  mpt3sas_base.o     \
>   		mpt3sas_trigger_diag.o \
>   		mpt3sas_warpdrive.o \
>   		mpt3sas_debugfs.o \
> +
> +mpt3sas-$(CONFIG_SCSI_MPT3SAS_HWMON) += mpt3sas_hwmon.o
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index c655742d0dde..63252f30343b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -1629,6 +1629,7 @@ struct MPT3SAS_ADAPTER {
>   	u8		is_aero_ioc;
>   	struct dentry	*debugfs_root;
>   	struct dentry	*ioc_dump;
> +	struct mpt3sas_hwmon *hwmon;
>   	PUT_SMID_IO_FP_HIP put_smid_scsi_io;
>   	PUT_SMID_IO_FP_HIP put_smid_fast_path;
>   	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
> @@ -2049,6 +2050,22 @@ void mpt3sas_destroy_debugfs(struct MPT3SAS_ADAPTER *ioc);
>   void mpt3sas_init_debugfs(void);
>   void mpt3sas_exit_debugfs(void);
>   
> +#if IS_ENABLED(CONFIG_SCSI_MPT3SAS_HWMON)
> +int mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc);
> +void mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc);
> +#else
> +static inline int
> +mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	return 0;
> +}
> +
> +static inline void
> +mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc)
> +{
> +}
> +#endif
> +
>   /**
>    * _scsih_is_pcie_scsi_device - determines if device is an pcie scsi device
>    * @device_info: bitfield providing information about the device.
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_hwmon.c b/drivers/scsi/mpt3sas/mpt3sas_hwmon.c
> new file mode 100644
> index 000000000000..26227a992f35
> --- /dev/null
> +++ b/drivers/scsi/mpt3sas/mpt3sas_hwmon.c
> @@ -0,0 +1,200 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Hardware monitoring (hwmon) support for the LSI / Broadcom mpt3sas
> + * SAS HBA driver. Exposes the IOC and board temperature sensors by
> + * reading MPI IO Unit Page 7.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/hwmon.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +
> +#include "mpt3sas_base.h"
> +
> +struct mpt3sas_hwmon {
> +	struct MPT3SAS_ADAPTER *ioc;
> +	struct device *hwmon_dev;
> +	bool ioc_present;
> +	bool board_present;
> +};
> +
> +/*
> + * Convert a (raw, units) reading to millidegrees Celsius.
> + * Returns -ENODATA when the sensor reports "not present" or
> + * unknown units. Temperature values are interpreted as signed
> + * two's-complement integers.
> + *
> + * The MPI2_IOUNITPAGE7_IOC_TEMP_* and MPI2_IOUNITPAGE7_BOARD_TEMP_*
> + * defines in mpi2_cnfg.h share the same values; the IOC ones are
> + * used for both channels.
> + */
> +static int
> +_hwmon_to_mdegc(s16 raw, u8 units, long *out)
> +{
> +	switch (units) {
> +	case MPI2_IOUNITPAGE7_IOC_TEMP_CELSIUS:
> +		*out = (long)raw * 1000;
> +		return 0;
> +	case MPI2_IOUNITPAGE7_IOC_TEMP_FAHRENHEIT:
> +		/* (F - 32) * 5 / 9, expressed in milli-units */
> +		*out = ((long)raw - 32) * 5000 / 9;
> +		return 0;
> +	default:
> +		return -ENODATA;
> +	}
> +}
> +
> +static umode_t
> +_hwmon_is_visible(const void *drvdata, enum hwmon_sensor_types type,
> +		  u32 attr, int channel)
> +{
> +	const struct mpt3sas_hwmon *h = drvdata;
> +
> +	if (type != hwmon_temp)
> +		return 0;
> +	if (attr != hwmon_temp_input && attr != hwmon_temp_label)
> +		return 0;
> +	if (channel == 0 && h->ioc_present)
> +		return 0444;
> +	if (channel == 1 && h->board_present)
> +		return 0444;
> +	return 0;
> +}
> +
> +static int
> +_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
> +	    u32 attr, int channel, long *val)
> +{
> +	struct mpt3sas_hwmon *h = dev_get_drvdata(dev);
> +	Mpi2ConfigReply_t mpi_reply;
> +	Mpi2IOUnitPage7_t page;
> +	int r;
> +
> +	if (type != hwmon_temp || attr != hwmon_temp_input)
> +		return -EOPNOTSUPP;
> +
> +	r = mpt3sas_config_get_iounit_pg7(h->ioc, &mpi_reply, &page);
> +	if (r)
> +		return r;
> +
> +	if (channel == 0)
> +		return _hwmon_to_mdegc((s16)le16_to_cpu(page.IOCTemperature),
> +				       page.IOCTemperatureUnits, val);
> +	if (channel == 1)
> +		return _hwmon_to_mdegc((s16)le16_to_cpu(page.BoardTemperature),
> +				       page.BoardTemperatureUnits, val);
> +	return -EOPNOTSUPP;
> +}
> +
> +static const char * const mpt3sas_hwmon_temp_labels[] = {
> +	"IOC",
> +	"Board",
> +};
> +
> +static int
> +_hwmon_read_string(struct device *dev, enum hwmon_sensor_types type,
> +		   u32 attr, int channel, const char **str)
> +{
> +	if (type != hwmon_temp || attr != hwmon_temp_label)
> +		return -EOPNOTSUPP;
> +	*str = mpt3sas_hwmon_temp_labels[channel];
> +	return 0;
> +}
> +
> +static const struct hwmon_channel_info * const mpt3sas_hwmon_info[] = {
> +	HWMON_CHANNEL_INFO(temp,
> +			   HWMON_T_INPUT | HWMON_T_LABEL,
> +			   HWMON_T_INPUT | HWMON_T_LABEL),
> +	NULL,
> +};
> +
> +static const struct hwmon_ops mpt3sas_hwmon_ops = {
> +	.is_visible	= _hwmon_is_visible,
> +	.read		= _hwmon_read,
> +	.read_string	= _hwmon_read_string,
> +};
> +
> +static const struct hwmon_chip_info mpt3sas_hwmon_chip_info = {
> +	.ops	= &mpt3sas_hwmon_ops,
> +	.info	= mpt3sas_hwmon_info,
> +};
> +
> +/**
> + * mpt3sas_hwmon_register - register an hwmon device for the IOC
> + * @ioc: per adapter object
> + * Context: sleep.
> + *
> + * Succeeds without registering when no temperature sensors are present,
> + * so cards without thermal monitoring do not expose an empty hwmon node.
> + * Paired with mpt3sas_hwmon_unregister() from the driver's remove path.
> + *
> + * Return: 0 for success, non-zero for failure.
> + */
> +int
> +mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	struct device *parent = &ioc->pdev->dev;
> +	struct mpt3sas_hwmon *h;
> +	struct device *hwdev;
> +	Mpi2ConfigReply_t mpi_reply;
> +	Mpi2IOUnitPage7_t page;
> +	int r;
> +
> +	h = kzalloc_obj(*h);
> +	if (!h)
> +		return -ENOMEM;
> +
> +	h->ioc = ioc;
> +
> +	r = mpt3sas_config_get_iounit_pg7(ioc, &mpi_reply, &page);
> +	if (r) {
> +		kfree(h);
> +		return r;
> +	}
> +
> +	h->ioc_present = page.IOCTemperatureUnits != MPI2_IOUNITPAGE7_IOC_TEMP_NOT_PRESENT;
> +	h->board_present = page.BoardTemperatureUnits != MPI2_IOUNITPAGE7_BOARD_TEMP_NOT_PRESENT;
> +
> +	/*
> +	 * A page where both *TemperatureUnits are NOT_PRESENT covers
> +	 * two cases: cards that genuinely lack sensors, and firmware
> +	 * errors that left the page zero-filled (the accessor mirrors
> +	 * _config_request() behaviour). Either way: skip registration.
> +	 */
> +	if (!h->ioc_present && !h->board_present) {
> +		kfree(h);
> +		return 0;
> +	}
> +
> +	hwdev = hwmon_device_register_with_info(parent, "mpt3sas", h,
> +						&mpt3sas_hwmon_chip_info,
> +						NULL);
> +	if (IS_ERR(hwdev)) {
> +		kfree(h);
> +		return PTR_ERR(hwdev);
> +	}
> +
> +	h->hwmon_dev = hwdev;
> +	ioc->hwmon = h;
> +	return 0;
> +}
> +
> +/**
> + * mpt3sas_hwmon_unregister - tear down the hwmon device, if any
> + * @ioc: per adapter object
> + *
> + * Safe to call when registration was skipped (no sensors) or
> + * failed; in those cases ioc->hwmon is NULL and this is a no-op.
> + */
> +void
> +mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	struct mpt3sas_hwmon *h = ioc->hwmon;
> +
> +	if (!h)
> +		return;
> +	hwmon_device_unregister(h->hwmon_dev);
> +	kfree(h);
> +	ioc->hwmon = NULL;
> +}
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 12caffeed3a0..dea78688cc9b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -12562,6 +12562,7 @@ static void scsih_remove(struct pci_dev *pdev)
>   	/* release all the volumes */
>   	_scsih_ir_shutdown(ioc);
>   	mpt3sas_destroy_debugfs(ioc);
> +	mpt3sas_hwmon_unregister(ioc);
>   	sas_remove_host(shost);
>   	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
>   	    list) {
> @@ -13651,6 +13652,11 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	}
>   
>   	scsi_scan_host(shost);
> +
> +	if (mpt3sas_hwmon_register(ioc))
> +		ioc_warn(ioc,
> +			 "hwmon registration failed; temperatures not exposed\n");
> +
>   	mpt3sas_setup_debugfs(ioc);
>   	return 0;
>   out_add_shost_fail:

