Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFCDC352A2
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 20:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB606217F4
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 20:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580935635;
	bh=+ZS+NN3+LYtwsrpUFYDvOFcmW2Zu5fsUZcqSPkhg4lU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=kWfXL4xT5i0nTpEnnrKqQp5G1p1fcpEh4XduOktkhSr1SfpwIB216//5nwi/9wiG1
	 UTyYJ9pYMjP6P78gco3Cxm2KgIc34BIO1bfg3ej2/4nIbLrV+BGKyVbE9Jw0/JdDdb
	 FNzuuuYytyTYwtxQuzdDrDMxvp3P3/YAjFosHROQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgBEUrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Feb 2020 15:47:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgBEUrO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Feb 2020 15:47:14 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 294D02072B;
        Wed,  5 Feb 2020 20:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580935633;
        bh=+ZS+NN3+LYtwsrpUFYDvOFcmW2Zu5fsUZcqSPkhg4lU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gjvMPyIRhoMGBaCI7MUINX99uO8A+WSahEkQxe0NwqVase8Kt3OdsPyTgQdAddwpe
         sPqnpxP6yhP0i05boyaZUGSbzavu3uTCqEKyTBI1gAUbygv8J4fhmq4I+NrO1bIdbO
         3fvVcT2HL0T8TSI8+QzmXbu1arwf2m7l9btJBDKA=
Date:   Wed, 5 Feb 2020 12:47:11 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v6 6/9] scsi: ufs: Add inline encryption support to UFS
Message-ID: <20200205204711.GA112437@gmail.com>
References: <20191218145136.172774-1-satyat@google.com>
 <20191218145136.172774-7-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218145136.172774-7-satyat@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 18, 2019 at 06:51:33AM -0800, Satya Tangirala wrote:
> @@ -2472,6 +2492,13 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  	lrbp->task_tag = tag;
>  	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
>  	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
> +
> +	err = ufshcd_prepare_lrbp_crypto(hba, cmd, lrbp);
> +	if (err) {
> +		lrbp->cmd = NULL;
> +		clear_bit_unlock(tag, &hba->lrb_in_use);
> +		goto out;
> +	}

The error path here is missing a call to ufshcd_release().

- Eric
