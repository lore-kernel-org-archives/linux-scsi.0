From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi/ibmvscsi: /sys/class/scsi_host/hostX/config doesn't
 show any information
Date: Fri, 7 Sep 2012 11:33:12 -0500
Message-ID: <CALAi6Fcj1Np-Hm3UiJFM4FMEhMNQ=MMiVQDv6T0mEZGVmJq33A@mail.gmail.com>
References: <1342630157-16468-1-git-send-email-olaf@aepfle.de>
	<1343611985.21647.25.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60997 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2IGQdN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Sep 2012 12:33:13 -0400
Received: by ieje11 with SMTP id e11so5353696iej.19
        for <linux-scsi@vger.kernel.org>; Fri, 07 Sep 2012 09:33:12 -0700 (PDT)
In-Reply-To: <1343611985.21647.25.camel@pasglop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian J King <bjking1@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Linda Xie <lxiep@us.ibm.com>, olaf@aepfle.de

On Sun, Jul 29, 2012 at 8:33 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> scsi/ibmvscsi: Fix host config length field overflow
>
> The length field in the host config packet is only 16-bit long, so
> passing it 0x10000 (64K which is our standard PAGE_SIZE) doesn't
> work and result in an empty config from the server.
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: <stable@vger.kernel.org>

James, can this be added to your for-next branch so that we can
also get this to the stable trees?  Thanks.

Acked-by: Robert Jennings <rcj@linux.vnet.ibm.com>

> ---
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 3a6c474..337e8b3 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -1541,6 +1541,9 @@ static int ibmvscsi_do_host_config(struct ibmvscsi_host_data *hostdata,
>
>         host_config = &evt_struct->iu.mad.host_config;
>
> +       /* The transport length field is only 16-bit */
> +       length = min(0xffff, length);
> +
>         /* Set up a lun reset SRP command */
>         memset(host_config, 0x00, sizeof(*host_config));
>         host_config->common.type = VIOSRP_HOST_CONFIG_TYPE;
>
>
