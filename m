Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E30E936EC
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 22:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbjJDWiu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 18:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244194AbjJDWi2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 18:38:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E82B124
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 15:37:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5B9C433C7;
        Wed,  4 Oct 2023 22:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696459071;
        bh=FzRR5RaVpm2f7JtY3dlR1oKj4qm61Vs6PZ2RUOp2QNI=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=gxhlMJyNH/qAJoUVsCXX7MH66cX6xP1WSZ04d04AjWvmkGoWYPJCZNlzK4bn/gJrN
         PHV+E8Onluypz6pSh/YqxIlAhhAgbSfA+UORALXksPuiNhnw3gq7/NR1KLPJrP7Wnj
         9Hx/YCGb2NoiTg2QVJHYj8smCT56fFfuAZ2f0qPQ1r0/g6HNEQ3oLP0jn0I0G17hVh
         ziFaFJadPnTpOU+pL0cgwYR6H4L+lrN+HGsX7Vs63WzAhp3PHHcoBasJIG7m6gspU1
         Y2Zp6yojxyD1Dq0szGgbrMPHyLd+iWlxjSjbfVfXO7+zo2WHg+g+tM24XU7AH0Tngo
         2w4JlbCL4ZceA==
Message-ID: <3e87f523-5e5e-dd67-26f3-8187b44b23b0@kernel.org>
Date:   Thu, 5 Oct 2023 07:37:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 08/12] scsi: sd: Fix scsi_mode_sense caller's sshdr use
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20231004210013.5601-1-michael.christie@oracle.com>
 <20231004210013.5601-9-michael.christie@oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231004210013.5601-9-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/23 06:00, Mike Christie wrote:
> The sshdr passed into scsi_execute_cmd is only initialized if
> scsi_execute_cmd returns >= 0, and scsi_mode_sense will convert all non
> good statuses like check conditions to -EIO. This has scsi_mode_sense
> callers that were possibly accessing an uninitialized sshdrs to only
> access it if we got -EIO.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/sd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 6d4787ff6e96..538ebdf42c69 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2942,7 +2942,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>  	}
>  
>  bad_sense:
> -	if (scsi_sense_valid(&sshdr) &&
> +	if (res == -EIO && scsi_sense_valid(&sshdr) &&

	if (ret < 0 && ...

would be safer and avoid any issue if we ever change scsi_execute_cmd() to
return other error codes than -EIO, no ?

>  	    sshdr.sense_key == ILLEGAL_REQUEST &&
>  	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
>  		/* Invalid field in CDB */
> @@ -2990,7 +2990,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
>  		sd_first_printk(KERN_WARNING, sdkp,
>  			  "getting Control mode page failed, assume no ATO\n");
>  
> -		if (scsi_sense_valid(&sshdr))
> +		if (res == -EIO && scsi_sense_valid(&sshdr))
>  			sd_print_sense_hdr(sdkp, &sshdr);
>  
>  		return;

-- 
Damien Le Moal
Western Digital Research

