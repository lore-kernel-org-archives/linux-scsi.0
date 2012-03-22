From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [isci PATCH v3 3/4] libsas: suspend / resume support
Date: Thu, 22 Mar 2012 15:44:33 +0800
Message-ID: <A9DB323E20454953A88CC43F4AE6CC68@usish.com.cn>
References: <CABE8wwvmCnVEhW8yKVua9Zt+jPCK6kzyjm7poE_7D4ihDhZrHg@mail.gmail.com><Pine.LNX.4.44L0.1203151544450.1366-100000@iolanthe.rowland.org><CABE8wwuuM8XoTUy_+1nXMt9WvieWgmt-NHS=ybN_ndOdwk+gjQ@mail.gmail.com><F0261F814D3E413599630A3442934059@usish.com.cn> <CABE8wwu=6Hco6kg_VGP0mtpgfHdF9Uxw1wMXLX5mcJ0J=i6u5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CABE8wwu=6Hco6kg_VGP0mtpgfHdF9Uxw1wMXLX5mcJ0J=i6u5g@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: "'Williams, Dan J'" <dan.j.williams@intel.com>
Cc: 'Alan Stern' <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, 'Jacek Danecki' <jacek.danecki@intel.com>, 'lindar_liu' <lindar_liu@usish.com>, =?UTF-8?B?J+S6jueIseWNjic=?= <crystal_yu@usish.com>
List-Id: linux-scsi@vger.kernel.org



> 
> 2012/3/16 Jack Wang <jack_wang@usish.com>:
> > Dan,
> >
> > I found problem about SATA error handle and this also led to panic when run
> suspend/resume test. Thanks again for your share debug method and patch of
> testing suspend/resume problem.
> >
> > The problem is:
> >
> > When probe libata probe sata will try to reset device and send IDENTIFY DEVICE..
> commands when 3 times fail will give up but never tell libsas and lldd to clean
> up the resource. And if some time later the device came up report BROADCAST
> CHANGE and libsas found device try to  tell lldd, but lldd is not forget the
> original one will reject this.
> > Should we export sas_unregister_devs_sas_addr let ata call this when give
> up.
> 
> Have a look at "libsas: fix ata_eh clobbering ex_phys via
> smp_ata_check_ready" [1], this fixed up cases where libsas failed to
> handle ata device unplug in our environment.
> 
> --
> Dan
> 
> [1]: http://marc.info/?l=linux-scsi&m=133239709603452&w=2
[Jack Wang] 
Thanks Dan, we are testing your new patchset in our test environment, will report back result.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

