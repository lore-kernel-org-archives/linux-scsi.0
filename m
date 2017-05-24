From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] qla2xxx: don't disable a not previously enabled PCI
 device
Date: Wed, 24 May 2017 15:47:14 +0000
Message-ID: <1495640832.2823.5.camel@sandisk.com>
References: <20170523145047.5020-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170523145047.5020-1-jthumshirn@suse.de>
Content-Language: en-US
Content-ID: <11CF7772D7D9AD4FB8A2E408B3240F7D@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-05-23 at 16:50 +0200, Johannes Thumshirn wrote:
> When pci_enable_device() or pci_enable_device_mem() fail in
> qla2x00_probe_one() we bail out but do a call to
> pci_disable_device(). This causes the dev_WARN_ON() in
> pci_disable_device() to trigger, as the device wasn't enabled
> previously.
>=20
> So instead of taking the 'probe_out' error path we can directly return
> *iff* one of the pci_enable_device() calls fails.
>=20
> Additionally rename the 'probe_out' goto label's name to the more
> descriptive 'disable_device'.
>=20
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: e315cd28b9ef ("[SCSI] qla2xxx: Code changes for qla data structure=
 refactoring")

Hello Johannes,

Please consider adding a Cc: stable tag to this patch. Since otherwise this
patch looks fine to me:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>=
