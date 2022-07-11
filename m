Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D14C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 23:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiGKXL7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiGKXL5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 19:11:57 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B495509DD
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657581115; x=1689117115;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q/BHNYS/eghqzUdxGfwmQ8R0OiQM6sNYHPDg0AUAd/8=;
  b=gvaGpRQ3KhFcWxpIze85zvZ9CljTVooXaDl45OJtEOf9K0haTsnVGPOv
   qtLPLvVHhvd/fB5zZW3sDseDumc/fKx+uqR0DIx6tENGvwjIGAJDpZ7xo
   jXR+09ywIOV/tzpUoUVjzv0T5cZl7URdugB+fW9hvdQ/sPTCa0lOqqA/P
   jfzQgTs5ARrdiyE7iTyaUQVwmf2I9YSH9HrGE7Gy5MkPSuIX0AFynSVmj
   QkhnofBDSU7kPnk36ApBmK1Hgy9XhOLzt8pgjI+tgcBnyVMyCqukZnsw3
   joN3R5h0skeKjZZ/iOc8Hva0MSxUFHnmqf5ExS1F2XxIA95WAMRDhceKN
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,263,1650902400"; 
   d="scan'208";a="210366153"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2022 07:11:55 +0800
IronPort-SDR: Wra2v3hrbJbKWzjj0Jxx1k6skFNzzobVaNQrE3/3AFc+KSXME6lrj8LsbXP505OADe1blK3WjY
 +tMZraGogh528fN/7zeYEV+InHKkUrA3QnfAcJMWvo5r4Eb8hjesDtlEBemdgSSfMY7KJoDLzR
 E3LJTyitVQI90guyvIzd+J9YnHsIW5s1wIlqfos4A2X6bzgzXviuMDxl+IN8odYzJ8Ckm3jBLi
 l+HKFgOCRwyqRlqGlZaTDIFFlTKtIg37rT92DOjcZ4pImxuqYFlmamnCQZnu+KPZUJ9CwFDjOA
 gbbWmIpBqJcEN93WzIV4g08M
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 15:28:54 -0700
IronPort-SDR: 92zQJTYhbO2e18vwg/NXkdz3BkodnZHzCA90OSQ5nmGFolK9pTd1eghWj7q/5aLleVYHlTxlUQ
 49RclQCEaxvj42te0qr0WZ2OqrKeYDlJBK0mFTC4Jg9ro4/uRALrerW31B2uBac0/wEmFeDy2O
 5LSSpT6lE0QSeTW7i1BzO9MRWYVBXno9QNBT9TveMjA68J9mAABAe1Vnagf1+pEffYPyIyJjYE
 JXP0nxfLKFofKLdIUU6Ne/N3jPJxmLiD2r5OKCZ/Gr+79RTgTCYj0yEPGCAkdbp3sRq9kT83PV
 jXA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 16:11:57 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Lhflv5Bjmz1Rwnl
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:11:55 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1657581114; x=1660173115; bh=q/BHNYS/eghqzUdxGfwmQ8R0OiQM6sNYHPD
        g0AUAd/8=; b=ldP6MfMT0ZZvJZxEqT78Eb8XuKq+cYvhTS94bUwcuYiY6mlJvqG
        dAw3iMAFP/8nKBJZ82bonSscUPXW/IuZD2SaHC9o6ATf8QaFBfJ5EIc2zq64TOAE
        gKnWuz0q+wwLj6EFlGKkPtdm3wb9w4iclLfOVWIdkdjbWPFF7kQ5rKIhzsIfAVdi
        UhsLZp09NGnWX/KvY9GhI/tibDb4dVovaEL6ZA5BQnTv/JZzSkrZYzEF/QKcOqvG
        H+rIBnUv00AOvx/tblrvo/6F1TrnJ9yHLXw9ZRQRsLj7TYk1dsvB68ejfph47b3q
        /NgT7sVD43xqXdO0qtlrKzD5bLNiGCl4k1A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9ysgTcb14Eh2 for <linux-scsi@vger.kernel.org>;
        Mon, 11 Jul 2022 16:11:54 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Lhfls65TPz1RtVk;
        Mon, 11 Jul 2022 16:11:53 -0700 (PDT)
Message-ID: <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
Date:   Tue, 12 Jul 2022 08:11:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] scsi: sd_zbc: Fix handling of RC BASIS
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-4-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220711230051.15372-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/22 08:00, Bart Van Assche wrote:
> Using the RETURNED LOGICAL BLOCK ADDRESS field + 1 as the capacity (largest
> addressable LBA) if RC BASIS = 0 is wrong if there are sequential write
> required zones. Hence only use the RC BASIS = 0 capacity if there are no
> sequential write required zones.

This does not make sense to me: RC BASIS == 0 is defined like this:

The RETURNED LOGICAL BLOCK ADDRESS field indicates the highest LBA of a
contiguous range of zones that are not sequential write required zones
starting with the first zone.

Do you have these cases:
1) host-managed disks:
SWR zones are *mandatory* so there is at least one. Thus read capacity
will return either 0 if there are no conventional zones (they are
optional) or the total capacity of the set of contiguous conventional
zones starting at lba 0. In either case, read capacity does not give you
the actual total capacity and you have to look at the report zones reply
max lba field.
2) host-aware disks:
There are no SWR zones, there cannot be any. You can only have
conventional zones (optionally) and sequential write preferred zones. So
"the highest LBA of a contiguous range of zones that are not sequential
write required zones starting with the first zone" necessarily is always
the total capacity. RC BASIS = 0 is non-sensical for host-aware drives.

So I do not understand your change.

Note that anyway, there are no drives out there that use RC BASIS = 0. I
had to hack a drive FW to implement it to test this code...

> 
> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Fixes: d2e428e49eec ("scsi: sd_zbc: Reduce boot device scan and revalidate time")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/sd_zbc.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 6acc4f406eb8..41ff1c0fd04b 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -699,7 +699,7 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
>   *
>   * Get the device zone size and check that the device capacity as reported
>   * by READ CAPACITY matches the max_lba value (plus one) of the report zones
> - * command reply for devices with RC_BASIS == 0.
> + * command reply.
>   *
>   * Returns 0 upon success or an error code upon failure.
>   */
> @@ -709,6 +709,7 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
>  	u64 zone_blocks;
>  	sector_t max_lba;
>  	unsigned char *rec;
> +	u8 same;
>  	int ret;
>  
>  	/* Do a report zone to get max_lba and the size of the first zone */
> @@ -716,9 +717,26 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
>  	if (ret)
>  		return ret;
>  
> -	if (sdkp->rc_basis == 0) {
> -		/* The max_lba field is the capacity of this device */
> -		max_lba = get_unaligned_be64(&buf[8]);
> +	/*
> +	 * From ZBC-1: "If the ZONE LIST LENGTH field is zero then the SAME
> +	 * field is invalid and should be ignored by the application client."
> +	 */
> +	if (get_unaligned_be32(&buf[0]) == 0) {
> +		sd_printk(KERN_INFO, sdkp, "No zones have been reported\n");
> +		return -EIO;
> +	}
> +
> +	same = buf[4] & 0xf;
> +	max_lba = get_unaligned_be64(&buf[8]);
> +	/*
> +	 * The max_lba field is the largest addressable LBA of the disk if:
> +	 * - Either RC BASIS == 1.
> +	 * - Or RC BASIS == 0, there is at least one zone in the response
> +	 *   (max_lba != 0) and all zones have the same type (same == 1 ||
> +	 *   same == 2).
> +	 */
> +	if ((sdkp->rc_basis == 0 && max_lba && (same == 1 || same == 2)) ||
> +	    sdkp->rc_basis == 1) {
>  		if (sdkp->capacity != max_lba + 1) {
>  			if (sdkp->first_scan)
>  				sd_printk(KERN_WARNING, sdkp,


-- 
Damien Le Moal
Western Digital Research
