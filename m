From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH] qla4xxx: Fix build on some architectures lacking 64-bit I/O
Date: Fri, 1 Oct 2010 17:56:33 +0530
Message-ID: <CE8118C7-79A1-4778-A691-A3EA047FE4E1@qlogic.com>
References: <1285902667.3916.62.camel@localhost>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:52168 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0JAM0l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2010 08:26:41 -0400
In-Reply-To: <1285902667.3916.62.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Ravi Anand <ravi.anand@qlogic.com>, Dept_iscsi_driver <iscsi-driver@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, "598503@bugs.debian.org" <598503@bugs.debian.org>


On Oct 1, 2010, at 8:41 AM, Ben Hutchings wrote:

> readq() and writeq() are not defined on all archictectures.  Where
> they are missing, define fallback implementations (copied from
> qla2xxx).
>
> Reference: http://bugs.debian.org/598503
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> This is a regression from 2.6.35, so please include this fix in  
> 2.6.36.
>
> Ben.
>
> drivers/scsi/qla4xxx/ql4_nx.h |   15 +++++++++++++++
> 1 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ 
> ql4_nx.h
> index 931ad3f..85fe6cf 100644
> --- a/drivers/scsi/qla4xxx/ql4_nx.h
> +++ b/drivers/scsi/qla4xxx/ql4_nx.h
> @@ -776,4 +776,19 @@ struct crb_addr_pair {
> #define MIU_TEST_AGT_WRDATA_UPPER_LO	(0x0b0)
> #define	MIU_TEST_AGT_WRDATA_UPPER_HI	(0x0b4)
>
> +#ifndef readq
> +static inline u64 readq(void __iomem *addr)
> +{
> +	return readl(addr) | (((u64) readl(addr + 4)) << 32LL);
> +}
> +#endif
> +
> +#ifndef writeq
> +static inline void writeq(u64 val, void __iomem *addr)
> +{
> +	writel(((u32) (val)), (addr));
> +	writel(((u32) (val >> 32)), (addr + 4));
> +}
> +#endif
> +
> #endif
> -- 
> 1.7.1
>

Ack-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
