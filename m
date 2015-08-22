From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 7/8] scsi: ufs-qcom: add debug prints for test bus
Date: Sat, 22 Aug 2015 12:07:52 +0900
Message-ID: <CAC5umyhX0kD=v+3fsU+BYSbsfde6jAxuG4EgvvYTQc7hF8mW6g@mail.gmail.com>
References: <1440079144-26461-1-git-send-email-ygardi@codeaurora.org>
	<1440079144-26461-8-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:36802 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbbHVDHx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2015 23:07:53 -0400
In-Reply-To: <1440079144-26461-8-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>

2015-08-20 22:59 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:

> +static bool ufs_qcom_testbus_cfg_is_ok(struct ufs_qcom_host *host)
> +{
> +       if (host->testbus.select_major >= TSTBUS_MAX) {
> +               dev_err(host->hba->dev,
> +                       "%s: UFS_CFG1[TEST_BUS_SEL} may not equal 0x%05X\n",
> +                       __func__, host->testbus.select_major);
> +               return false;
> +       }
> +
> +       /*
> +        * Not performing check for each individual select_major
> +        * mappings of select_minor, since there is no harm in
> +        * configuring a non-existent select_minor
> +        */
> +       if (host->testbus.select_major > 0x1F) {

select_minor should be checked instead of select_major here?

> +               dev_err(host->hba->dev,
> +                       "%s: 0x%05X is not a legal testbus option\n",
> +                       __func__, host->testbus.select_minor);
> +               return false;
> +       }
> +
> +       return true;
> +}
