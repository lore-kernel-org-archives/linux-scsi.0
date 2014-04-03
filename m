From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg3_utils: Strip spaces at the end of various fields
 in INQUIRY response
Date: Thu, 03 Apr 2014 14:50:03 -0400
Message-ID: <533DAD5B.6050903@interlog.com>
References: <1396544835-5912-1-git-send-email-spargaonkar@suse.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57951 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbaDCSuM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Apr 2014 14:50:12 -0400
In-Reply-To: <1396544835-5912-1-git-send-email-spargaonkar@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: shirishpargaonkar@gmail.com
Cc: linux-scsi@vger.kernel.org, hare@suse.com, Shirish Pargaonkar <spargaonkar@suse.com>

Hi,
scsiinfo:
 >>> Eric Youngdale ** - 11/1/93.  Version 1.0.

Version 1.81 was ported to sginfo in 1998 and placed in the
sg_utils package. For more than 10 years I have been trying
to discourage people from using it. It contains next to no
modern VPD or mode pages and many of the standard INQUIRY
response fields it lists are now obsolete.

Curious about what sginfo and sysfs have in common. Oh well,
looks like I have my first patch for sg3_utils version 1.39 .

Doug Gilbert

** Did Eric wear bow ties?

On 14-04-03 01:07 PM, shirishpargaonkar@gmail.com wrote:
> From: Shirish Pargaonkar <spargaonkar@suse.com>
>
> sginfo <device> prints out various fields such as Vendor and Product in
> INQUIRY response with spaces (0x20) characters.
> This can confuse scripts some users have.
>
> A change to sysfs attributes such that it now includes spaces caused
> this problem.
>
> Strip out those trailing spaces (if any).
>
>
> Signed-off-by: Shirish Pargaonkar <spargaonkar@suse.com>
> ---
> Index: src/sginfo.c
> ===================================================================
> --- src.orig/sginfo.c	2014-04-02 22:36:13.779692431 -0500
> +++ src/sginfo.c	2014-04-02 22:51:36.028265615 -0500
> @@ -155,6 +155,7 @@
>   #define MAX_BUFFER_SIZE MAX_RESP10_SIZE
>
>   #define INQUIRY_RESP_INITIAL_LEN 36
> +#define MAX_INQFIELD_LEN 17
>
>   #define MAX_HEADS 127
>   #define HEAD_SORT_TOKEN 0x55
> @@ -3139,11 +3140,23 @@
>       return status;
>   }
>
> +static void
> +inqfieldname(unsigned char *deststr, const unsigned char *srcbuf, int maxlen)
> +{
> +	int i;
> +
> +	memset(deststr, '\0', MAX_INQFIELD_LEN);
> +	for (i = maxlen - 1; i >= 0 && isspace(srcbuf[i]); --i)
> +		;
> +	memcpy(deststr, srcbuf, i + 1);
> +}
> +
>   static int
>   do_inquiry(int * peri_type, int * resp_byte6, int inquiry_verbosity)
>   {
>       int status;
>       unsigned char cmd[6];
> +    unsigned char fieldname[MAX_INQFIELD_LEN];
>       unsigned char *pagestart;
>       struct scsi_cmnd_io sci;
>
> @@ -3214,14 +3227,18 @@
>       }
>       if (x_interface)
>           printf("\n");
> -    printf("%s%.8s\n", (!x_interface ? "Vendor:                    " : ""),
> -           pagestart + 8);
> -
> -    printf("%s%.16s\n", (!x_interface ? "Product:                   " : ""),
> -           pagestart + 16);
>
> -    printf("%s%.4s\n", (!x_interface ? "Revision level:            " : ""),
> -           pagestart + 32);
> +    inqfieldname(fieldname, pagestart + 8, 8);
> +    printf("%s%s\n", (!x_interface ? "Vendor:                    " : ""),
> +           fieldname);
> +
> +    inqfieldname(fieldname, pagestart + 16, 16);
> +    printf("%s%s\n", (!x_interface ? "Product:                   " : ""),
> +           fieldname);
> +
> +    inqfieldname(fieldname, pagestart + 32, 4);
> +    printf("%s%s\n", (!x_interface ? "Revision level:            " : ""),
> +           fieldname);
>
>       printf("\n");
>       return status;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

