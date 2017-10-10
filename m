From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 2/2] hpsa: destroy sas transport properties before
 scsi_host
Date: Tue, 10 Oct 2017 23:04:50 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1967210680@avsrvexchmbx2.microsemi.net>
References: <20161121140429.12788-1-mwilck@suse.de>
 <20161121140429.12788-3-mwilck@suse.de>
 <20161121141441.rljdubw2rcmrl43v@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:8016
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751402AbdJJXFC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Oct 2017 19:05:02 -0400
In-Reply-To: <20161121141441.rljdubw2rcmrl43v@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Martin Wilck <mwilck@suse.de>
Cc: dl-esc-Team ESD Storage Dev Support <esc-TeamESDStorageDevSupport@microsemi.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@odin.com" <JBottomley@odin.com>, "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn@suse.de]
> Sent: Monday, November 21, 2016 8:15 AM
> To: Martin Wilck <mwilck@suse.de>
> Cc: Don Brace <don.brace@microsemi.com>; dl-esc-Team ESD Storage Dev
> Support <esc-TeamESDStorageDevSupport@microsemi.com>;
> iss_storagedev@hp.com; linux-scsi@vger.kernel.org; JBottomley@odin.com;
> hch@lst.de; hare@suse.de
> Subject: Re: [PATCH 2/2] hpsa: destroy sas transport properties before
> scsi_host
>=20
> EXTERNAL EMAIL
>=20
>=20
> On Mon, Nov 21, 2016 at 03:04:29PM +0100, Martin Wilck wrote:
> > Unloading the hpsa driver causes warnings
> >
> > [ 1063.793652] WARNING: CPU: 1 PID: 4850 at ../fs/sysfs/group.c:237
> device_del+0x54/0x240()
> > [ 1063.793659] sysfs group ffffffff81cf21a0 not found for kobject 'port=
-2:0'
> >
> > with two different stacks:
> > 1)
> > [ 1063.793774]  [<ffffffff81448af4>] device_del+0x54/0x240
> > [ 1063.793780]  [<ffffffff8145178a>]
> transport_remove_classdev+0x4a/0x60
> > [ 1063.793784]  [<ffffffff81451216>]
> attribute_container_device_trigger+0xa6/0xb0
> > [ 1063.793802]  [<ffffffffa0105d46>] sas_port_delete+0x126/0x160
> [scsi_transport_sas]
> > [ 1063.793819]  [<ffffffffa036ebcc>] hpsa_free_sas_port+0x3c/0x70 [hpsa=
]
> >
> > 2)
> > [ 1063.797103]  [<ffffffff81448af4>] device_del+0x54/0x240
> > [ 1063.797118]  [<ffffffffa0105d4e>] sas_port_delete+0x12e/0x160
> [scsi_transport_sas]
> > [ 1063.797134]  [<ffffffffa036ebcc>] hpsa_free_sas_port+0x3c/0x70 [hpsa=
]
> >
> > This is caused by the fact that host device hostX is deleted before the
> > SAS transport devices hostX/port-a:b.
> >
> > This patch fixes this by reverting the order of device deletions.
> >
> > References: bsc#1010946
> > Signed-off-by: Martin Wilck <mwilck@suse.de>
> > ---
>=20
> With the References changed to the bug link like in patch 1/2
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Now that Hannes's patch  9441284fbc39610c0f9ec0ed118ff85d78352906
has been applied, this patch corrects the stack trace issue.

Would you like to re-submit this patch or would you like me to send it up?
I'll run some quick tests if you do decide to send it up.=20
If you want me to send it up, you will get the credit anyway.

Thanks for your help and attention to this issue.
And thanks again to Hannes.

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation


> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
