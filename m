Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5818C3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 18:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B513C2072A
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 18:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgCBSnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 13:43:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:39964 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727414AbgCBSnO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 13:43:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 656C7B2C9;
        Mon,  2 Mar 2020 18:43:12 +0000 (UTC)
Date:   Mon, 2 Mar 2020 19:43:12 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 4/4] qla2xxx: Fix the code that reads from mailbox
 registers
Message-ID: <20200302184312.6uunsrgpxqjznsdz@beryllium.lan>
References: <20200302033023.27718-1-bvanassche@acm.org>
 <20200302033023.27718-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302033023.27718-5-bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Sun, Mar 01, 2020 at 07:30:23PM -0800, Bart Van Assche wrote:
> Make the MMIO accessors stronly typed such that the compiler checks whether
> the accessor function is used that matches the register width. Fix those
> MMIO reads where another number of bits was read or written than the size
> of the register.
> 
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_def.h  | 53 +++++++++++++++++++++++++++------
>  drivers/scsi/qla2xxx/qla_init.c |  6 ++--
>  drivers/scsi/qla2xxx/qla_iocb.c |  2 +-
>  drivers/scsi/qla2xxx/qla_isr.c  |  4 +--
>  drivers/scsi/qla2xxx/qla_mbx.c  |  2 +-
>  drivers/scsi/qla2xxx/qla_mr.c   | 26 ++++++++--------
>  drivers/scsi/qla2xxx/qla_nx.c   |  4 +--
>  drivers/scsi/qla2xxx/qla_os.c   |  2 +-
>  8 files changed, 67 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index ebb22c1a9df7..7e5677c69bed 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -128,15 +128,50 @@ static inline uint32_t make_handle(uint16_t x, uint16_t y)
>   * I/O register
>  */
>  
> -#define RD_REG_BYTE(addr)		readb(addr)
> -#define RD_REG_WORD(addr)		readw(addr)
> -#define RD_REG_DWORD(addr)		readl(addr)
> -#define RD_REG_BYTE_RELAXED(addr)	readb_relaxed(addr)
> -#define RD_REG_WORD_RELAXED(addr)	readw_relaxed(addr)
> -#define RD_REG_DWORD_RELAXED(addr)	readl_relaxed(addr)
> -#define WRT_REG_BYTE(addr, data)	writeb(data, addr)
> -#define WRT_REG_WORD(addr, data)	writew(data, addr)
> -#define WRT_REG_DWORD(addr, data)	writel(data, addr)
> +static inline u8 RD_REG_BYTE(const volatile u8 __iomem *addr)
> +{
> +	return readb(addr);
> +}

I would prefer lower case for the inline function names.

Thanks,
Daniel
