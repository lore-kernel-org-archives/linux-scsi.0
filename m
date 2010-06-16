From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH 3/5]pci:bus.c Fix variable 'retval' set but not used
Date: Wed, 16 Jun 2010 15:42:02 +1000
Message-ID: <AANLkTik27fbCY0pMJdcbuCaEXr-902WiqiFPkju4Bet0@mail.gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
	<1276666434-11227-4-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53284 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab0FPFmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 01:42:23 -0400
In-Reply-To: <1276666434-11227-4-git-send-email-justinmattock@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jun 16, 2010 at 15:33, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> The patch below fixes the warning message I am seeing with gcc 4.6.0
> =A0CC =A0 =A0 =A0drivers/pci/bus.o
> drivers/pci/bus.c: In function 'pci_enable_bridges':
> drivers/pci/bus.c:237:6: warning: variable 'retval' set but not used
>
> =A0Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> ---
> =A0drivers/pci/bus.c | =A0 =A02 --
> =A01 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 628ea20..84bdb48 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -234,12 +234,10 @@ void pci_bus_add_devices(const struct pci_bus *=
bus)
> =A0void pci_enable_bridges(struct pci_bus *bus)
> =A0{
> =A0 =A0 =A0 =A0struct pci_dev *dev;
> - =A0 =A0 =A0 int retval;
>
> =A0 =A0 =A0 =A0list_for_each_entry(dev, &bus->devices, bus_list) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (dev->subordinate) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!pci_is_enabled(de=
v)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =
=3D pci_enable_device(dev);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pci_se=
t_master(dev);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pci_enable_bridges(dev=
->subordinate);

Er, this appears to be bogus: I'm only guessing, but I'd expect that
the pci_enable_device() call is actually doing something useful, and
removing it is going to break *something* - Have you booted a kernel
with this code enabled and these patches applied?

As for this warning, I think that there is a better solution.

Thanks,

--=20

Julian Calaby

Email: julian.calaby@gmail.com
=2EPlan: http://sites.google.com/site/juliancalaby/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
