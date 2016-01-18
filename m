From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: fix potential integer signedness problem
Date: Mon, 18 Jan 2016 12:14:50 -0800
Message-ID: <1453148090.2363.13.camel@HansenPartnership.com>
References: <1453146909-28314-1-git-send-email-wuninsu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48512 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755979AbcARUOw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 15:14:52 -0500
In-Reply-To: <1453146909-28314-1-git-send-email-wuninsu@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Insu Yun <wuninsu@gmail.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu

On Mon, 2016-01-18 at 14:55 -0500, Insu Yun wrote:
> Since len is signed integer variable, it is better to check
> whether len is non-negative or not.
> If non-negative value len gives, it can cause heap overflow.

Hey, this patch is full of a ton of undocumented (and mostly spurious)
whitespace changes, which make it very hard to see the actual patch

> Signed-off-by: Insu Yun <wuninsu@gmail.com>
> ---
>  drivers/scsi/scsi_lib.c | 33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
[...]
Which is this, I think:

> @@ -2349,6 +2349,9 @@ scsi_mode_select(struct scsi_device *sdev, int
> pf, int sp, int modepage,
>  	unsigned char *real_buffer;
>  	int ret;
>  
> +	if (len < 0)
> +		return -EINVAL;
> +
>  	memset(cmd, 0, sizeof(cmd));
>  	cmd[1] = (pf ? 0x10 : 0) | (sp ? 0x01 : 0);

What's the actual problem here?  There's only one user of
scsi_mode_select: an internal one which always sends in a positive
length, so this check is entirely unnecessary.

James


