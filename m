From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] scsi: stex: Remove use of struct timeval
Date: Wed, 25 Feb 2015 11:44:12 +0100
Message-ID: <8604869.gMDOcjFu4A@wuerfel>
References: <20150225021136.GA2728@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:62965 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbbBYKo2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 05:44:28 -0500
In-Reply-To: <20150225021136.GA2728@tinar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On Wednesday 25 February 2015 07:41:36 Tina Ruchandani wrote:
> @@ -364,10 +365,7 @@ MODULE_VERSION(ST_DRIVER_VERSION);
>  
>  static void stex_gettime(__le64 *time)
>  {
> -       struct timeval tv;
> -
> -       do_gettimeofday(&tv);
> -       *time = cpu_to_le64(tv.tv_sec);
> +       *time = cpu_to_le64(ktime_get_real_seconds());
>  }
>  
>  static struct status_msg *stex_get_status(struct st_hba *hba)
> 

The patch looks correct to me, but upon second reading, I think it
would be nicer to eliminate the function entirely and open-code
the cpu_to_le64(ktime_get_real_seconds()) in the two callers.

	Arnd
