From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] scsi: scsi_devinfo.c:  Cleaning up unnecessarily
 complicated in conjunction with strncpy
Date: Sun, 14 Sep 2014 21:34:51 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C7A75B@G9W0745.americas.hpqcorp.net>
References: <1410727738-17430-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:28933 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaINVht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Sep 2014 17:37:49 -0400
In-Reply-To: <1410727738-17430-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Rickard Strandqvist
...
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
...
>  static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
>  				char *from, int compatible)
>  {
> -	size_t from_length;
> -
> -	from_length = strlen(from);
> -	strncpy(to, from, min(to_length, from_length));
> -	if (from_length < to_length) {
> -		if (compatible) {
> -			/*
> -			 * NUL terminate the string if it is short.
> -			 */
> -			to[from_length] = '\0';
> -		} else {
> -			/*
> -			 * space pad the string if it is short.
> -			 */
> -			strncpy(&to[from_length], spaces,
> -				to_length - from_length);
> -		}
> -	}
> -	if (from_length > to_length)
> -		 printk(KERN_WARNING "%s: %s string '%s' is too long\n",
> +	strncpy(to, from, to_length);
> +	if (to[to_length - 1] != '\0') {
> +		to[to_length - 1] = '\0';
> +		printk(KERN_WARNING "%s: %s string '%s' is too long\n",
>  			__func__, name, from);
> +	}

The caller of this function, scsi_dev_info_list_add_keyed, created
the "to" destination buffer, devinfo, with kmalloc, so it's not
guaranteed to be full of zeros.

If from_length is shorter than to_length, then this code will
be inspecting an uninitialized character that strncpy didn't
touch.

---
Rob Elliott    HP Server Storage





