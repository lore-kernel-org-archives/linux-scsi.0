From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: Remove usage of struct timeval
Date: Wed, 04 Feb 2015 15:56:27 +0100
Message-ID: <7352347.rDHNZrOBmc@wuerfel>
References: <20150204030954.GA3729@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:50063 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966016AbbBDO4l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2015 09:56:41 -0500
In-Reply-To: <20150204030954.GA3729@tinar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>

On Wednesday 04 February 2015 08:39:54 Tina Ruchandani wrote:
> struct timeval will have its tv_sec field overflow on 32-bit systems
> in year 2038 and beyond. This patch removes the usage of struct timeval
> and instead uses 64-bit ktime_t to get the current milliseconds
> to populate pmcraid_timestamp_data.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>

The change you did looks correct, but I see two problems:

- The subject line should mention the name of the driver you
  change, as you are not doing this for the entire scsi subsystem
  at once.

> @@ -5569,11 +5570,9 @@ static void pmcraid_set_timestamp(struct pmcraid_cmd *cmd)
>         __be32 time_stamp_len = cpu_to_be32(PMCRAID_TIMESTAMP_LEN);
>         struct pmcraid_ioadl_desc *ioadl = ioarcb->add_data.u.ioadl;
>  
> -       struct timeval tv;
>         __le64 timestamp;
>  
> -       do_gettimeofday(&tv);
> -       timestamp = tv.tv_sec * 1000;
> +       timestamp = ktime_to_ms(ktime_get_real());
>  
>         pinstance->timestamp_data->timestamp[0] = (__u8)(timestamp);
>         pinstance->timestamp_data->timestamp[1] = (__u8)((timestamp) >> 8);

It looks like a preexisting bug here, but it makes sense to fix
it at the same time and describe that change in the patch
changelog:

timestamp is declared as an __le64 type but gets set to a cpu-endian
value from tv.tv_sec or ktime_to_ms, which is wrong. The code indeed
gets the endianess right by copying the bytes individually, so I think
you should just use a u64 type here.

	Arnd
