From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 1/2] libata-scsi: improve TRIM translation
Date: Tue, 5 Jul 2016 14:04:39 +0300
Message-ID: <6f5400ce-58c8-d52c-9ce5-a1450b52599e@cogentembedded.com>
References: <577b57b0.5b4c620a.37648.6c8d@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:35077 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792AbcGELEm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2016 07:04:42 -0400
Received: by mail-lf0-f48.google.com with SMTP id l188so132202576lfe.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jul 2016 04:04:41 -0700 (PDT)
In-Reply-To: <577b57b0.5b4c620a.37648.6c8d@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com, tj@kernel.org, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello.

On 7/5/2016 9:45 AM, tom.ty89@gmail.com wrote:

> From: Tom Yan <tom.ty89@gmail.com>
>
> Define TRIM_RANGE_SIZE and TRIM_RANGE_NUM so that the corresponding
> functions can be more generalized. Also, conform to SBC by rejecting
> WRITE SAME (16) commands with number of blocks that exceeds the limit
> that is defined in the SATL.
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

[...]

> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index 99346be..0971c3f 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -1071,7 +1071,7 @@ static inline unsigned ata_set_lba_range_entries(void *_buffer,
>  	__le64 *buffer = _buffer;
>  	unsigned i = 0, used_bytes;
>
> -	while (i < buf_size / 8 ) { /* 6-byte LBA + 2-byte range per entry */
> +	while (i < buf_size) {

    BTW, this change doesn't seem to be documented in the patch description?

[...]

MBR, Sergei

