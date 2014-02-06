From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCH] scsi/isci/port_config: Fix a infinite loop.
Date: Thu, 6 Feb 2014 11:59:42 -0800
Message-ID: <CAA9_cmfJJVKrme1CG67GX31W5Sk+m+Xdqu5kJU8r9gKp-=nP1w@mail.gmail.com>
References: <1374029641-12649-1-git-send-email-yuxinghai@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:35083 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbaBFT7t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 14:59:49 -0500
Received: by mail-qc0-f175.google.com with SMTP id x13so4044798qcv.20
        for <linux-scsi@vger.kernel.org>; Thu, 06 Feb 2014 11:59:49 -0800 (PST)
In-Reply-To: <1374029641-12649-1-git-send-email-yuxinghai@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xinghai Yu <yuxinghai@cn.fujitsu.com>
Cc: Lukasz Dorau <lukasz.dorau@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "dave.jiang" <dave.jiang@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Jul 16, 2013 at 7:54 PM, Xinghai Yu <yuxinghai@cn.fujitsu.com> wrote:
> It seems the "phy_index++;" have been placed in wrong place, without it
> the while circle up will do a infinite loop.
>
> Signed-off-by: Xinghai Yu <yuxinghai@cn.fujitsu.com>
> ---
>  drivers/scsi/isci/port_config.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/isci/port_config.c b/drivers/scsi/isci/port_config.c
> index cd962da..85c77f6 100644
> --- a/drivers/scsi/isci/port_config.c
> +++ b/drivers/scsi/isci/port_config.c
> @@ -311,9 +311,9 @@ sci_mpc_agent_validate_phy_configuration(struct isci_host *ihost,
>                                               &ihost->phys[phy_index]);
>
>                         assigned_phy_mask |= (1 << phy_index);
> +                       phy_index++;
>                 }
>
> -               phy_index++;
>         }
>
>         return sci_port_configuration_agent_validate_ports(ihost, port_agent);

Hmm, I'm not aware of anyone using mpc mode.  Maybe we should just remove it?
