From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [SCSI] tcm_fc: Adding FC_FC4 provider (tcm_fc) for FCoE target
 (TCM - target core) support
Date: Wed, 8 Jun 2011 22:10:14 +0200
Message-ID: <BANLkTimLbj1FHy9j56ScRGwc2t6Ci+QhAw@mail.gmail.com>
References: <201105202102.p4KL28Io025077@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33100 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1FHUKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2011 16:10:15 -0400
In-Reply-To: <201105202102.p4KL28Io025077@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>, Kiran Patil <kiran.patil@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>

> =C2=A0 =C2=A0[SCSI] tcm_fc: Adding FC_FC4 provider (tcm_fc) for FCoE =
target (TCM - target core) support
>
> =C2=A0 =C2=A0This is a comprehensive patch for FC-FC4 provider. tcm_f=
c is a FC-FC4
> =C2=A0 =C2=A0provider which glues target core (TCM) with Fiber channe=
l library
> =C2=A0 =C2=A0(libfc). tcm_fc uses existing FC4 provider hooks from Fi=
ber channel
> =C2=A0 =C2=A0library. This Fiber channel library is used by FCoE (tra=
nsport - FC
> =C2=A0 =C2=A0over Ethernet) protocol driver as well.

> --- /dev/null
> +++ b/drivers/target/tcm_fc/tfc_conf.c

> +static int __init ft_init(void)
> +{
> + =C2=A0 =C2=A0 =C2=A0 if (ft_register_configfs())
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> + =C2=A0 =C2=A0 =C2=A0 if (fc_fc4_register_provider(FC_TYPE_FCP, &ft_=
prov)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ft_deregister_conf=
igfs();
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 blocking_notifier_chain_register(&fc_lport_not=
ifier_head, &ft_notifier);
> + =C2=A0 =C2=A0 =C2=A0 fc_lport_iterate(ft_lport_add, NULL);
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +static void __exit ft_exit(void)
> +{
> + =C2=A0 =C2=A0 =C2=A0 blocking_notifier_chain_unregister(&fc_lport_n=
otifier_head,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0&ft_notifier);
> + =C2=A0 =C2=A0 =C2=A0 fc_fc4_deregister_provider(FC_TYPE_FCP, &ft_pr=
ov);
> + =C2=A0 =C2=A0 =C2=A0 fc_lport_iterate(ft_lport_del, NULL);
> + =C2=A0 =C2=A0 =C2=A0 ft_deregister_configfs();
> + =C2=A0 =C2=A0 =C2=A0 synchronize_rcu();
> +}
> +
> +#ifdef MODULE
> +MODULE_DESCRIPTION("FC TCM fabric driver " FT_VERSION);
> +MODULE_LICENSE("GPL");
> +module_init(ft_init);
> +module_exit(ft_exit);
> +#endif /* MODULE */

If CONFIG_TCM_FC=3Dy, this gives:

| drivers/target/tcm_fc/tfc_conf.c:642: warning: =E2=80=98ft_init=E2=80=
=99 defined but not used

Shouldn't the #ifdef MODULE and #endif just be removed?

Who else initializes this module if it's builtin?
E.g. ft_register_configfs() is global, but not used outside this source=
 file?

Gr{oetje,eeting}s,

=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
