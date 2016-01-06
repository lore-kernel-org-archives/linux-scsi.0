From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] ipr: fix out-of-bounds null overwrite
Date: Wed, 6 Jan 2016 11:26:06 -0600
Message-ID: <85F2590B-6F13-4713-9D8A-440A332A993B@linux.vnet.ibm.com>
References: <1452088409-78304-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:58805 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbcAFR0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 12:26:13 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 6 Jan 2016 12:26:12 -0500
In-Reply-To: <1452088409-78304-1-git-send-email-wuninsu@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Insu Yun <wuninsu@gmail.com>
Cc: brking@us.ibm.com, JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu

On Jan 6, 2016, at 7:53 AM, Insu Yun <wuninsu@gmail.com> wrote:
> 
> Return value of snprintf is not bound by size value, 2nd argument.
> (https://www.kernel.org/doc/htmldocs/kernel-api/API-snprintf.html).
> Return value is number of printed chars, can be larger than 2nd argument.
> Therefore, it can write null byte out of bounds ofbuffer.
> Since snprintf puts null, it does not need to put additional null byte.
> 
> Signed-off-by: Insu Yun <wuninsu@gmail.com>
> ---
> drivers/scsi/ipr.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 536cd5a..caf63f9 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -4003,13 +4003,12 @@ static ssize_t ipr_store_update_fw(struct device *dev,
> 	struct ipr_sglist *sglist;
> 	char fname[100];
> 	char *src;
> -	int len, result, dnld_size;
> +	int result, dnld_size;
> 
> 	if (!capable(CAP_SYS_ADMIN))
> 		return -EACCES;
> 
> -	len = snprintf(fname, 99, "%s", buf);
> -	fname[len-1] = '\0';
> +	snprintf(fname, 99, "%s", buf);

Changing the 99 to sizeof(fname) as part of this change would also
make for cleaner code in my opinion. Will leave it up to you if you'd
like to do a v3.

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com> 
