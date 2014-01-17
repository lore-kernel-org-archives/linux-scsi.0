From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: Why is (2 < 2) true? Is it a gcc bug?
Date: Fri, 17 Jan 2014 09:58:34 -0800
Message-ID: <CAADnVQLUP=7oxciVw97d76xtqs6_YjC6E2boPRO9y4m_sqjRCA@mail.gmail.com>
References: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:53633 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaAQR6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 12:58:36 -0500
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Jan 17, 2014 at 5:37 AM, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
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

gcc sees that i < array_size is the same as i < 2 as part of loop condition, so
it optimizes (i < sci_max_controllers) into constant 1.
and emits printk like:
  printk ("\13(%d < %d) == %d\n", i_382, 2, 1);

> (The kernel was compiled using gcc version 4.8.2.)

it actually looks to be gcc 4.8 bug.
Can you try gcc 4.7 ?

gcc 4.7 compiles your loop into the following:
<bb 74>:
  # i_382 = PHI <0(73), i_73(74)>
  # isci_host_148 = PHI <isci_host_63(73), isci_host_74(74)>
  printk ("\13(%d < %d) == %d\n", i_382, 2, 1);
  D.43295_70 = MEM[(struct isci_host *)isci_host_148 + 18632B];
  # DEBUG D#6 => isci_host_148
  # DEBUG ihost s=> ihost
  scsi_scan_host (D.43295_70);
  # DEBUG pdev => pdev_17(D)
  # DEBUG pdev => pdev_17(D)
  D.43629_353 = dev_get_drvdata (D.42809_20);
  i_73 = i_382 + 1;
  # DEBUG i => i_73
  isci_host_74 = MEM[(struct isci_pci_info *)D.43629_353].hosts[i_73];
  # DEBUG isci_host => isci_host_74
  # DEBUG isci_host => isci_host_74
  # DEBUG i => i_73
  i.9_79 = (unsigned int) i_73;
  D.42849_65 = i.9_79 <= 1;
  D.42850_66 = isci_host_74 != 0B;
  D.42851_67 = D.42850_66 & D.42849_65;
  if (D.42851_67 != 0)
    goto <bb 74>;
  else
    goto <bb 77>;

which looks correct to me.

while gcc 4.8.2 into:
  <bb 92>:
  # i_73 = PHI <i_82(93), 0(91)>
  # isci_host_274 = PHI <isci_host_83(93), isci_host_71(91)>
  # DEBUG isci_host => isci_host_274
  # DEBUG i => i_73
  printk ("\13(%d < %d) == %d\n", i_73, 2, 1);
  _79 = MEM[(struct isci_host *)isci_host_274 + 18632B];
  # DEBUG D#6 => isci_host_274
  # DEBUG ihost => D#6
  scsi_scan_host (_79);
  # DEBUG pdev => pdev_26(D)
  # DEBUG pdev => pdev_26(D)
  _97 = dev_get_drvdata (_29);
  i_82 = i_73 + 1;
  # DEBUG i => i_82
  isci_host_83 = MEM[(struct isci_pci_info *)_97].hosts[i_82];
  # DEBUG isci_host => isci_host_83
  # DEBUG isci_host => isci_host_83
  # DEBUG i => i_82
  if (isci_host_83 != 0B)
    goto <bb 93>;
  else
    goto <bb 90>;

  <bb 93>:
  goto <bb 92>;

in case of gcc4.8 the i<=1 comparison got optimized out and only
isci_host !=0 is left,
which looks incorrect.
