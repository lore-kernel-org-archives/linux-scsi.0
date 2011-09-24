From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] scsi: SCSI_ISCI needs to select SCSI_SAS_HOST_SMP, fixes
 build error
Date: Fri, 23 Sep 2011 17:23:33 -0700
Message-ID: <4E7D2305.8080408@xenotime.net>
References: <4E7D0BAA.3080900@xenotime.net> <CAA9_cmcJv_A4SgpGFMpwBYLJ8NEzHKw-LOnQwWKFZRTTLRCO5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:52307 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750802Ab1IXAXh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2011 20:23:37 -0400
In-Reply-To: <CAA9_cmcJv_A4SgpGFMpwBYLJ8NEzHKw-LOnQwWKFZRTTLRCO5Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Andrew Morton <akpm@linux-foundation.org>, intel-linux-scu@intel.com, Linus Torvalds <torvalds@linux-foundation.org>

On 09/23/2011 04:43 PM, Dan Williams wrote:
> On Fri, Sep 23, 2011 at 3:43 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> SCSI_ISCI needs to select SCSI_SAS_HOST_SMP to ensure that all
>> needed symbols are available to it.
>>
>> Fixes this build error:
>> ERROR: "try_test_sas_gpio_gp_bit" [drivers/scsi/isci/isci.ko] undefined!
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Thanks Randy!
> 
> Here's a replacement patch (also attached), that just stubs out that
> routine in the !SCSI_SAS_HOST_SMP case.

Yes, that works too.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> From 645ea60066251c2728197bf7a1048d885626936f Mon Sep 17 00:00:00 2001
> From: Dan Williams <dan.j.williams@intel.com>
> Date: Fri, 23 Sep 2011 16:28:53 -0700
> Subject: [PATCH] libsas: fix try_test_sas_gpio_gp_bit() build error
> 
> If the user has disabled CONFIG_SCSI_SAS_HOST_SMP then libsas drivers
> will not be receiving smp-gpio frames and do not need this lookup code.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  include/scsi/libsas.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 44f5634..0d78bfa 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -407,7 +407,14 @@ static inline unsigned int to_sas_gpio_od(int
> device, int bit)
>  	return 3 * device + bit;
>  }
> 
> +#ifdef CONFIG_SCSI_SAS_HOST_SMP
>  int try_test_sas_gpio_gp_bit(unsigned int od, u8 *data, u8 index, u8 count);
> +#else
> +static inline int try_test_sas_gpio_gp_bit(unsigned int od, u8 *data,
> u8 index, u8 count)
> +{
> +	return -1;
> +}
> +#endif
> 
>  /* ---------- Tasks ---------- */
>  /*


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
