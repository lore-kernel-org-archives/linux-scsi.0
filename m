From: Robert Jennings <rcj@pochix.net>
Subject: Re: [PATCH] scsi/ibmvscsi: /sys/class/scsi_host/hostX/config doesn't
 show any information
Date: Thu, 16 Aug 2012 14:45:26 -0500
Message-ID: <CALAi6FeDD5UB+p1W5yf3qYehTQYUc4WASwBo4pbc54WM2crPeA@mail.gmail.com>
References: <1342630157-16468-1-git-send-email-olaf@aepfle.de>
	<1343611985.21647.25.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43081 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2HPTp1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Aug 2012 15:45:27 -0400
Received: by yhmm54 with SMTP id m54so3319584yhm.19
        for <linux-scsi@vger.kernel.org>; Thu, 16 Aug 2012 12:45:26 -0700 (PDT)
In-Reply-To: <1343611985.21647.25.camel@pasglop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian J King <bjking1@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Linda Xie <lxiep@us.ibm.com>, olaf@aepfle.de

On Sun, Jul 29, 2012 at 8:33 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> n Wed, 2012-07-18 at 18:49 +0200, olaf@aepfle.de wrote:
>> From: Linda Xie <lxiep@us.ibm.com>
>>
>> Expected result:
>> It should show something like this:
>> x1521p4:~ # cat /sys/class/scsi_host/host1/config
>> PARTITIONNAME='x1521p4'
>> NWSDNAME='X1521P4'
>> HOSTNAME='X1521P4'
>> DOMAINNAME='RCHLAND.IBM.COM'
>> NAMESERVERS='9.10.244.100 9.10.244.200'
>>
>> Actual result:
>> x1521p4:~ # cat /sys/class/scsi_host/host0/config
>> x1521p4:~ #
>>
>> This patch changes the size of the buffer used for transfering config
>> data to 4K. It was tested against 2.6.19-rc2 tree.
>>
>> Reported by IBM during SLES11 beta testing:
>
> So this patch just seems to blindly replace all occurrences of PAGE_SIZE
> with HOST_PAGE_SIZE which is utterly wrong. Only one of those needs to
> be changed, the one passed to ibmvscsi_do_host_config() which is what's
> visible to the server, all the rest is just sysfs attributes and should
> remain as-is.
>
> Additionally (not even mentioning that there is no explanation as to
> what the real problem is anywhere in the changeset) I don't like the
> fix. The root of the problem is that the MAD header has a 16-bit length
> field, so writing 0x10000 (64K PAGE_SIZE) into it doesn't quite work.
>
> So in addition to a better comment, I would suggest a fix more like
> this:
>
> scsi/ibmvscsi: Fix host config length field overflow
>
> The length field in the host config packet is only 16-bit long, so
> passing it 0x10000 (64K which is our standard PAGE_SIZE) doesn't
> work and result in an empty config from the server.
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: <stable@vger.kernel.org>

Acked-by: Robert Jennings <rcj@linux.vnet.ibm.com>

Tested with an IBM i host and confirmed the fix.

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
