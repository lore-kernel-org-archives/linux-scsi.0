Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECD9CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 16:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC32720650
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 16:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439796AbfJXQWI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:22:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:40756 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733261AbfJXQWI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 12:22:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A720FB4E7;
        Thu, 24 Oct 2019 16:22:05 +0000 (UTC)
Date:   Thu, 24 Oct 2019 18:22:02 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH 01/32] elx: libefc_sli: SLI-4 register offsets and field
 definitions
Message-ID: <20191024162202.z3g5g4cwjbzotd5a@beryllium.lan>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-2-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023215557.12581-2-jsmart2021@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Wed, Oct 23, 2019 at 02:55:26PM -0700, James Smart wrote:
> +/*************************************************************************
> + * Common SLI-4 register offsets and field definitions
> + */
> +
> +/* SLI_INTF - SLI Interface Definition Register */
> +#define SLI4_INTF_REG		0x0058
> +enum {
> +	SLI4_INTF_REV_SHIFT = 4,
> +	SLI4_INTF_REV_MASK = 0x0F << SLI4_INTF_REV_SHIFT,
> +
> +	SLI4_INTF_REV_S3 = 3 << SLI4_INTF_REV_SHIFT,
> +	SLI4_INTF_REV_S4 = 4 << SLI4_INTF_REV_SHIFT,
> +
> +	SLI4_INTF_FAMILY_SHIFT = 8,
> +	SLI4_INTF_FAMILY_MASK  = 0x0F << SLI4_INTF_FAMILY_SHIFT,
> +
> +	SLI4_FAMILY_CHECK_ASIC_TYPE = 0xf << SLI4_INTF_FAMILY_SHIFT,
> +
> +	SLI4_INTF_IF_TYPE_SHIFT = 12,
> +	SLI4_INTF_IF_TYPE_MASK = 0x0F << SLI4_INTF_IF_TYPE_SHIFT,
> +
> +	SLI4_INTF_IF_TYPE_2 = 2 << SLI4_INTF_IF_TYPE_SHIFT,
> +	SLI4_INTF_IF_TYPE_6 = 6 << SLI4_INTF_IF_TYPE_SHIFT,
> +
> +	SLI4_INTF_VALID_SHIFT = 29,
> +	SLI4_INTF_VALID_MASK = 0x0F << SLI4_INTF_VALID_SHIFT,

Should this a 32 bit value? This overflows to 34 bits.

> +
> +	SLI4_INTF_VALID_VALUE = 6 << SLI4_INTF_VALID_SHIFT,
> +};

Just style question: what is the benefit using anonymous enums?  The
only reason I came up was that gdb could show the name of the
value. Though a quick test didn't work if the value is passed into a
function. Maybe I did something wrong.

I am asking because register number is a define and then the shift and
mask are enums.

> +
> +/* ASIC_ID - SLI ASIC Type and Revision Register */
> +#define SLI4_ASIC_ID_REG	0x009c
> +enum {
> +	SLI4_ASIC_GEN_SHIFT = 8,
> +	SLI4_ASIC_GEN_MASK = 0xFF << SLI4_ASIC_GEN_SHIFT,
> +	SLI4_ASIC_GEN_5 = 0x0b << SLI4_ASIC_GEN_SHIFT,
> +	SLI4_ASIC_GEN_6 = 0x0c << SLI4_ASIC_GEN_SHIFT,
> +	SLI4_ASIC_GEN_7 = 0x0d << SLI4_ASIC_GEN_SHIFT,
> +};
> +
> +enum {
> +	SLI4_ASIC_REV_A0 = 0x00,
> +	SLI4_ASIC_REV_A1 = 0x01,
> +	SLI4_ASIC_REV_A2 = 0x02,
> +	SLI4_ASIC_REV_A3 = 0x03,
> +	SLI4_ASIC_REV_B0 = 0x10,
> +	SLI4_ASIC_REV_B1 = 0x11,
> +	SLI4_ASIC_REV_B2 = 0x12,
> +	SLI4_ASIC_REV_C0 = 0x20,
> +	SLI4_ASIC_REV_C1 = 0x21,
> +	SLI4_ASIC_REV_C2 = 0x22,
> +	SLI4_ASIC_REV_D0 = 0x30,
> +};
> +
> +/* BMBX - Bootstrap Mailbox Register */
> +#define SLI4_BMBX_REG		0x0160
> +#define SLI4_BMBX_MASK_HI	0x3
> +#define SLI4_BMBX_MASK_LO	0xf
> +#define SLI4_BMBX_RDY		(1 << 0)
> +#define SLI4_BMBX_HI		(1 << 1)
> +#define SLI4_BMBX_WRITE_HI(r)	((upper_32_bits(r) & ~SLI4_BMBX_MASK_HI) | \
> +					SLI4_BMBX_HI)
> +#define SLI4_BMBX_WRITE_LO(r)	(((upper_32_bits(r) & SLI4_BMBX_MASK_HI) \
> +				<< 30) | (((r) & ~SLI4_BMBX_MASK_LO) >> 2))

Could you break the line differently so that the expression is a bit
simpler to read (there is a version below which does this
(SLI4_EQ_DOORBELL))?

> +#define SLI4_BMBX_SIZE				256
> +
> +/* SLIPORT_CONTROL - SLI Port Control Register */
> +#define SLI4_PORT_CTRL_REG		0x0408
> +#define SLI4_PORT_CTRL_IP		(1 << 27)
> +#define SLI4_PORT_CTRL_IDIS		(1 << 22)
> +#define SLI4_PORT_CTRL_FDD		(1 << 31)
> +
> +/* SLI4_SLIPORT_ERROR - SLI Port Error Register */
> +#define SLI4_PORT_ERROR1		0x040c
> +#define SLI4_PORT_ERROR2		0x0410
> +
> +/* EQCQ_DOORBELL - EQ and CQ Doorbell Register */
> +#define SLI4_EQCQ_DB_REG		0x120
> +enum {
> +	SLI4_EQ_ID_LO_MASK = 0x01FF,
> +
> +	SLI4_CQ_ID_LO_MASK = 0x03FF,
> +
> +	SLI4_EQCQ_CI_EQ = 0x0200,
> +
> +	SLI4_EQCQ_QT_EQ = 0x00000400,
> +	SLI4_EQCQ_QT_CQ = 0x00000000,
> +
> +	SLI4_EQCQ_ID_HI_SHIFT = 11,
> +	SLI4_EQCQ_ID_HI_MASK = 0xF800,
> +
> +	SLI4_EQCQ_NUM_SHIFT = 16,
> +	SLI4_EQCQ_NUM_MASK = 0x1FFF0000,
> +
> +	SLI4_EQCQ_ARM = 0x20000000,
> +	SLI4_EQCQ_UNARM = 0x00000000,
> +
> +};
> +
> +#define SLI4_EQ_DOORBELL(n, id, a)\
> +	((id & SLI4_EQ_ID_LO_MASK) | SLI4_EQCQ_QT_EQ |\
> +	(((id >> 9) << SLI4_EQCQ_ID_HI_SHIFT) & SLI4_EQCQ_ID_HI_MASK) | \
> +	((n << SLI4_EQCQ_NUM_SHIFT) & SLI4_EQCQ_NUM_MASK) | \
> +	a | SLI4_EQCQ_CI_EQ)
> +
> +#define SLI4_CQ_DOORBELL(n, id, a)\
> +	((id & SLI4_CQ_ID_LO_MASK) | SLI4_EQCQ_QT_CQ |\
> +	(((id >> 10) << SLI4_EQCQ_ID_HI_SHIFT) & SLI4_EQCQ_ID_HI_MASK) | \
> +	((n << SLI4_EQCQ_NUM_SHIFT) & SLI4_EQCQ_NUM_MASK) | a)
> +
> +/* EQ_DOORBELL - EQ Doorbell Register for IF_TYPE = 6*/
> +#define SLI4_IF6_EQ_DB_REG	0x120
> +enum {
> +	SLI4_IF6_EQ_ID_MASK = 0x0FFF,
> +
> +	SLI4_IF6_EQ_NUM_SHIFT = 16,
> +	SLI4_IF6_EQ_NUM_MASK = 0x1FFF0000,
> +};
> +
> +#define SLI4_IF6_EQ_DOORBELL(n, id, a)\
> +	((id & SLI4_IF6_EQ_ID_MASK) | \
> +	((n << SLI4_IF6_EQ_NUM_SHIFT) & SLI4_IF6_EQ_NUM_MASK) | a)
> +
> +/* CQ_DOORBELL - CQ Doorbell Register for IF_TYPE = 6*/
> +#define SLI4_IF6_CQ_DB_REG	0xC0
> +enum {
> +	SLI4_IF6_CQ_ID_MASK = 0xFFFF,
> +
> +	SLI4_IF6_CQ_NUM_SHIFT = 16,
> +	SLI4_IF6_CQ_NUM_MASK = 0x1FFF0000,
> +};
> +
> +#define SLI4_IF6_CQ_DOORBELL(n, id, a)\
> +	((id & SLI4_IF6_CQ_ID_MASK) | \
> +	((n << SLI4_IF6_CQ_NUM_SHIFT) & SLI4_IF6_CQ_NUM_MASK) | a)

There is sometimes a space before '\' and sometimes not. Just my OCD,
sorry...

> +/**
> + * @brief MQ_DOORBELL - MQ Doorbell Register
> + */
> +#define SLI4_MQ_DB_REG		0x0140	/* register offset */

Are the other registers defines also all offsets? Just wondering if
the comment is pointing out that these values are special or not.

Thanks,
Daniel
