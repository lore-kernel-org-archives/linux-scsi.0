From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] - mpt fusion - resend negotiation parameters after
	host reset and resume
Date: Tue, 18 Apr 2006 18:22:48 -0500
Message-ID: <1145402568.3421.64.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D70081166@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:56032 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750780AbWDRXWw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 19:22:52 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70081166@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-04-18 at 17:08 -0600, Moore, Eric wrote:
> +static void
> +mptspi_renegotiate(struct scsi_target *starget)
> +{
> +       struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
> +       u32 nego;
> +
> +       nego = mptspi_getRP(starget);
> +
> +       pg1.RequestedParameters = cpu_to_le32(nego);
> +       pg1.Reserved = 0;
> +       pg1.Configuration = 0;
> +
> +       mptspi_write_spi_device_pg1(starget, &pg1);
> +}

You probably want to use spi_schedule_dv() here instead of this for all
cases, don't you?

James


