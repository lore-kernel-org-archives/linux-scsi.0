Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7470DC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 03:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F69C222BD
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 03:22:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d9Mks2c0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Tunb0nNN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfKMDWc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 22:22:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50278 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfKMDWb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 22:22:31 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6C24060DB8; Wed, 13 Nov 2019 03:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573615350;
        bh=4wayBfbLSFoI1QIEZSOXbyJu7tjEw32G4bge2B7Aor0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d9Mks2c03YiGBLg3XKvL7uU7l+FC6NlWUELP2M7ijzo2/JoqoC3tgfWIogPEBZyWF
         mVnR/zdjQDiFSUrQPjFTpIouN+a7RgzDjR1iOYOBKdbHkze3oA403SnQ1ubk5lZNCG
         ElWi+re6nNGJlXNNL4IzOIh71GcJTepkP+/njJl0=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 5E54660DD1;
        Wed, 13 Nov 2019 03:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573615345;
        bh=4wayBfbLSFoI1QIEZSOXbyJu7tjEw32G4bge2B7Aor0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tunb0nNNrNywyXXECv+o87H5UAZVRvUM9+9vqlFRuo8BRDXOBP8M2wBERtZ9eykFF
         XIOoVSfxVd0zYiRq/89hbKOze+DKb89eozLuzWP66xhxZUFEGS83HyPIsauPR9vlv5
         Sbr7N5Ji3IMTls+SKPHs67nzXvga415PD9DbNUGc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 13 Nov 2019 11:22:25 +0800
From:   cang@codeaurora.org
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH v3 1/5] scsi: Adjust DBD setting in mode sense for caching
 mode page per LLD
In-Reply-To: <yq1tv78pjdz.fsf@oracle.com>
References: <1572670898-750-1-git-send-email-cang@codeaurora.org>
 <1572670898-750-2-git-send-email-cang@codeaurora.org>
 <yq1tv78pjdz.fsf@oracle.com>
Message-ID: <a7e85a27f08d571b6c70421784d6fd05@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-13 11:03, Martin K. Petersen wrote:
> Can,
> 
>> Host sends MODE_SENSE_10 with caching mode page, to check if the
>> device supports the cache feature.  UFS JEDEC standards require DBD
>> field to be set to 1.
> 
> UFS requires DBD for all MODE SENSE(10) invocations, not just for
> accessing the caching mode page. I think the flag name needs to reflect
> this.
> 
> Also, I do not particularly like this being a scsi_host flag. All the
> other flags we have in this department are per scsi_device.
> 
> My recommendation would be to add a set_dbd_for_ms flag to struct
> scsi_device and then do:
> 
> 	sdev->set_dbd_for_ms = 1;
> 
> in ufshcd_slave_alloc() mirroring the existing:
> 
>         sdev->use_10_for_ms = 1;
> 
> This makes the MODE SENSE tweakery consistent.
> 
> Thanks!

Hi Martin,

Thank you, good idea. I will make the change in your way.

Best regards,
Can Guo.
