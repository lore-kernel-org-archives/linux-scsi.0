Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B9FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 10:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbiGGKSG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 06:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235391AbiGGKR6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 06:17:58 -0400
X-Greylist: delayed 366 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Jul 2022 03:17:56 PDT
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D63350739;
        Thu,  7 Jul 2022 03:17:56 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4A03E41255;
        Thu,  7 Jul 2022 10:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received
        :received; s=mta-01; t=1657188708; x=1659003109; bh=Cm5oYM0j2avm
        1cv/2MMA7utZ0Xk4TbOjhwCW9dIdoKk=; b=ZaJyJC5qy7NXBHEIfU+m6ZpKOVMP
        mlYVqbMpD9TuIht+DyX1A5M+6ymfAcYqC3MSONvbdITQY05bjIaaG0svQPFVe4Su
        oXiiAUF9RZaOXFWnJGJwlY72nB50LBofTl/1kwe2pmY1hpofuywL/CjiEKUxQMpT
        KT/5tvTTkpDirBY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M-j5Z8M0AQqG; Thu,  7 Jul 2022 13:11:48 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 3BB0B4124A;
        Thu,  7 Jul 2022 13:11:47 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 13:11:47 +0300
Received: from yadro.com (10.199.20.241) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 13:11:45 +0300
Date:   Thu, 7 Jul 2022 13:11:45 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 15/36] target: Include INQUIRY length
Message-ID: <YsaxYW6Q661qoaar@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <2557ef61dddba5056b9d89d73248bf4140e92f19.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2557ef61dddba5056b9d89d73248bf4140e92f19.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.199.20.241]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 06, 2022 at 04:35:57PM -0700, Thinh Nguyen wrote:
> «Внимание! Данное письмо от внешнего адресата!»
> 
> The INQUIRY data length is minimum 36 bytes plus additional length
> jindicated in the descriptor. See SPC4-r37 section 6.6.2. The "len" here
> is the total length of the INQUIRY data. Make sure to include the 36
> initial bytes.

I think you're wrong, because Standard INQUIRY data format clearly
defines ADDITIONAL LENGTH as (n - 4), where n is the total length of the
INQUIRY data including the the mandatory bytes.
 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/target/target_core_spc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index dd799158609d..1801e10cd575 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -756,7 +756,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
>                 }
> 
>                 ret = spc_emulate_inquiry_std(cmd, buf);
> -               len = buf[4] + 5;
> +               len = buf[4] + 5 + INQUIRY_LEN;
>                 goto out;
>         }
> 
> --
> 2.28.0
> 
