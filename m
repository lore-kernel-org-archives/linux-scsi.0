Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D117AC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Feb 2022 06:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbiBGGDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Feb 2022 01:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350299AbiBGD0N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Feb 2022 22:26:13 -0500
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 19:26:13 PST
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E25BC061A73
        for <linux-scsi@vger.kernel.org>; Sun,  6 Feb 2022 19:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644204372; x=1675740372;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+PGiUz6IVsXwuo4TQYZtEFmfxDiduE4w2R5euJoD4k0=;
  b=UQZSNeNRIPNHMHgmFbFamqR822t0Zvhnidm1G94BaZH7Utl/QNdN/11S
   YDZ5Wg/tPg3TaIPOj2jmDwiyIBWSbLyaqReylWNxNhS64sHYvZmEWgjcA
   IMFsgpsshNG0E8kg3yBlcMsCg04yi5GmVYKk9TQSBZhB7iT5QYozR5nuB
   gH/XxHdA+ZvuCdRC5Jv+Wg8O4NcbQfjtxrpqWeCCfPWjaaaq0lHE7WT52
   qnhDj03CdFaTlzJF+xs3snoGJ7H3CjHt6sOoMuH6s6QZP5vUSbK66Xutv
   g2cxQ9+FTNJ00CXHdMI6iMW6knGzc4Nj+s68DziEoGI2y3VTTOc9/vTBV
   A==;
X-IronPort-AV: E=Sophos;i="5.88,348,1635177600"; 
   d="scan'208";a="296386955"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2022 11:25:08 +0800
IronPort-SDR: tdDtxMppDa5pGhLyG1VvUvlmQAAAzTU6JRzfy6igUFhvKhClMcM4xFiLUoTvxbYqOiSN4DwnJ2
 VklOnBrNp7Rd+pJhi0XLbMNgl9p9XOHOtuOoEG0CDgQKTgc42stDLqIBsum5fR/Tmm6fBbzTgW
 BQOSsAxUnbvyutGHz3v0dFu5NQTSHEXotjsCRlWXj0A1AfA9vcN4wuy/OZy0x2HRcnYpZTB5W+
 W6a2jywsYfnKIJQ3CqRAgzemvkPeCOF8B1BIlmQb5pStHWXP1K/FYErvJRczHMsJxwsxRcpMmT
 fiIDrYT5JnTBZk8b/puh1W1y
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2022 18:57:00 -0800
IronPort-SDR: zTTp9B35JA+doSo5ghcaKAiagnCakFX5O5b4nHx3KgvrVZuTGUCM9Bnik4QxmBuyZfOdI0vWM4
 Sb17YT+J5zeE82YH4JOey0MyD4jxtwavd2bTpqoX1tbHyo2CuWxuJtqCsMf3/K6fTVMvQmzKMh
 7CQ690DkkUmNtB9D727OK1lwh66z/O/OA1Z8B0kXkn2BOHwA7y4Eau/CiZAHU4pkt0BrVm0tWQ
 tAGvhmpn4pu15u6/YW1WvKTjmr4WTn14H197+1UJtIO4UzUr0wAL6xfckrQMKx8Zxpdae9wZch
 6Mw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2022 19:25:09 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JsWjc2CS0z1SVp0
        for <linux-scsi@vger.kernel.org>; Sun,  6 Feb 2022 19:25:08 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644204307; x=1646796308; bh=+PGiUz6IVsXwuo4TQYZtEFmfxDiduE4w2R5
        euJoD4k0=; b=KrPzH5YM1F6suctFze3AmkR4PflP5imhrAbhjevbNmzolGAMOs+
        SuqKb1bJhOQGsXk9IDhuoZPV5hhjzp7sdRmMsDHqbBl/jZD2UQEC1U2vXgWSn7uB
        Ygfsvt09X8yGvCkL0x6gOexLt7HMFW/bdXNjwu4CqGZzyuoe9kc6RX6ZyDgU9IV6
        V4Z55ZCvlsq7ghlBOc4GyGS8wurGNVBRrPzzSrYpAwepnzU+mijwYbh8JNwneyKA
        2F9mHLCghIiiOJOjRkmlcY4hvprdRQOAv1u7JCbla8N1+xSJFl0oT9et1EDXMMM4
        ghbr+dbmuts+8BAqXaQZw29rezcOxFbu+vQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Rif6cXUJvtl6 for <linux-scsi@vger.kernel.org>;
        Sun,  6 Feb 2022 19:25:07 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JsWjZ3jBZz1Rwrw;
        Sun,  6 Feb 2022 19:25:06 -0800 (PST)
Message-ID: <281475cc-a159-8e25-f5e7-cde343bc50c4@opensource.wdc.com>
Date:   Mon, 7 Feb 2022 12:25:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH -next] scsi: pm8001: clean up some inconsistent indenting
Content-Language: en-US
To:     Yang Li <yang.lee@linux.alibaba.com>, jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20220206125548.110945-1-yang.lee@linux.alibaba.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220206125548.110945-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/6/22 21:55, Yang Li wrote:
> Eliminate the follow smatch warning:
> drivers/scsi/pm8001/pm8001_ctl.c:760 pm8001_update_flash() warn:
> inconsistent indenting
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 65 +++++++++++++++++---------------
>  1 file changed, 35 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 41a63c9b719b..213ebf39261f 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -755,36 +755,41 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
>  			fwControl->retcode = 0;/* OUT */
>  			fwControl->offset = loopNumber * IOCTL_BUF_SIZE;/*OUT */
>  
> -		/* for the last chunk of data in case file size is not even with
> -		4k, load only the rest*/
> -		if (((loopcount-loopNumber) == 1) &&
> -			((partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE)) {
> -			fwControl->len =
> -				(partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE;
> -			memcpy((u8 *)fwControl->buffer,
> -				(u8 *)pm8001_ha->fw_image->data + sizeRead,
> -				(partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE);
> -			sizeRead +=
> -				(partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE;
> -		} else {
> -			memcpy((u8 *)fwControl->buffer,
> -				(u8 *)pm8001_ha->fw_image->data + sizeRead,
> -				IOCTL_BUF_SIZE);
> -			sizeRead += IOCTL_BUF_SIZE;
> -		}
> -
> -		pm8001_ha->nvmd_completion = &completion;
> -		ret = PM8001_CHIP_DISP->fw_flash_update_req(pm8001_ha, payload);
> -		if (ret) {
> -			pm8001_ha->fw_status = FAIL_OUT_MEMORY;
> -			goto out;
> -		}
> -		wait_for_completion(&completion);
> -		if (fwControl->retcode > FLASH_UPDATE_IN_PROGRESS) {
> -			pm8001_ha->fw_status = fwControl->retcode;
> -			ret = -EFAULT;
> -			goto out;
> -		}
> +			/* for the last chunk of data in case file
> +			 * size is not even with 4k, load only the rest
> +			 */

Please start multi-line comments with a line that has only "/*". It
would be good to add a blnak line before that too, for readability.

> +			if (((loopcount-loopNumber) == 1) &&
> +				((partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE)) {

While at it, align the conditions together to make this code more
readable. As is, it is really unpleasant to read :)

Also, "(partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE" is calculated way
too many times. Using a local variable for the value would be nice.

> +				fwControl->len =
> +					(partitionSize + HEADER_LEN) %
> +					IOCTL_BUF_SIZE;
> +				memcpy((u8 *)fwControl->buffer,
> +					(u8 *)pm8001_ha->fw_image->data + sizeRead,
> +					(partitionSize + HEADER_LEN) %
> +					IOCTL_BUF_SIZE);
> +				sizeRead +=
> +					(partitionSize + HEADER_LEN) %
> +					IOCTL_BUF_SIZE;
> +			} else {
> +				memcpy((u8 *)fwControl->buffer,
> +					(u8 *)pm8001_ha->fw_image->data + sizeRead,
> +					IOCTL_BUF_SIZE);
> +				sizeRead += IOCTL_BUF_SIZE;
> +			}
> +
> +			pm8001_ha->nvmd_completion = &completion;
> +			ret = PM8001_CHIP_DISP->fw_flash_update_req(pm8001_ha,
> +				payload);
> +			if (ret) {
> +				pm8001_ha->fw_status = FAIL_OUT_MEMORY;
> +				goto out;
> +			}
> +			wait_for_completion(&completion);
> +			if (fwControl->retcode > FLASH_UPDATE_IN_PROGRESS) {
> +				pm8001_ha->fw_status = fwControl->retcode;
> +				ret = -EFAULT;
> +				goto out;
> +			}
>  		}
>  	}
>  out:


-- 
Damien Le Moal
Western Digital Research
