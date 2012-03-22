From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [isci PATCH v3 3/4] libsas: suspend / resume support
Date: Wed, 21 Mar 2012 23:27:21 -0700
Message-ID: <CABE8wwu=6Hco6kg_VGP0mtpgfHdF9Uxw1wMXLX5mcJ0J=i6u5g@mail.gmail.com>
References: <CABE8wwvmCnVEhW8yKVua9Zt+jPCK6kzyjm7poE_7D4ihDhZrHg@mail.gmail.com>
	<Pine.LNX.4.44L0.1203151544450.1366-100000@iolanthe.rowland.org>
	<CABE8wwuuM8XoTUy_+1nXMt9WvieWgmt-NHS=ybN_ndOdwk+gjQ@mail.gmail.com>
	<F0261F814D3E413599630A3442934059@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <F0261F814D3E413599630A3442934059@usish.com.cn>
Sender: linux-ide-owner@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, lindar_liu <lindar_liu@usish.com>, =?UTF-8?B?5LqO54ix5Y2O?= <crystal_yu@usish.com>
List-Id: linux-scsi@vger.kernel.org

2012/3/16 Jack Wang <jack_wang@usish.com>:
> Dan,
>
> I found problem about SATA error handle and this also led to panic wh=
en run suspend/resume test. Thanks again for your share debug method an=
d patch of testing suspend/resume problem.
>
> The problem is:
>
> When probe libata probe sata will try to reset device and send IDENTI=
=46Y DEVICE.. commands when 3 times fail will give up but never tell li=
bsas and lldd to clean up the resource. And if some time later the devi=
ce came up report BROADCAST CHANGE and libsas found device try to =A0te=
ll lldd, but lldd is not forget the original one will reject this.
> Should we export sas_unregister_devs_sas_addr let ata call this when =
give up.

Have a look at "libsas: fix ata_eh clobbering ex_phys via
smp_ata_check_ready" [1], this fixed up cases where libsas failed to
handle ata device unplug in our environment.

--
Dan

[1]: http://marc.info/?l=3Dlinux-scsi&m=3D133239709603452&w=3D2
