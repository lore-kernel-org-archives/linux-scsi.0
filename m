From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: Why is (2 < 2) true? Is it a gcc bug?
Date: Fri, 17 Jan 2014 14:58:10 +0100
Message-ID: <CAFLxGvz3FKU4rgjF_uZsggjvw8TQw_Hcp42GC8Zr-wg5kiwc-w@mail.gmail.com>
References: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61585 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaAQN6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 08:58:12 -0500
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Jan 17, 2014 at 2:37 PM, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
> Hi
>
> My story is very simply...
> I applied the following patch:
>
> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -698,8 +698,11 @@ static int isci_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>         if (err)
>                 goto err_host_alloc;
>
> -       for_each_isci_host(i, isci_host, pdev)
> +       for_each_isci_host(i, isci_host, pdev) {
> +               pr_err("(%d < %d) == %d\n",\
> +                      i, SCI_MAX_CONTROLLERS, (i < SCI_MAX_CONTROLLERS));
>                 scsi_scan_host(to_shost(isci_host));
> +       }
>
>         return 0;
>
> --
> 1.8.3.1
>
> Then I issued the command 'modprobe isci' on platform with two SCU controllers (Patsburg D or T chipset)
> and received the following, very strange, output:
>
> (0 < 2) == 1
> (1 < 2) == 1
> (2 < 2) == 1
>
> Can anyone explain why (2 < 2) is true? Is it a gcc bug?
>
> (The kernel was compiled using gcc version 4.8.2.)
>

Can you reproduce this using a standalone test?
I.e:
#include <assert.h>

int main()
{
        assert(2 < 2 != 1);

        return 0;
}

-- 
Thanks,
//richard
