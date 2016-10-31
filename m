From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 1/4] hpsa: correct lockup detector pci_disable_device
Date: Mon, 31 Oct 2016 15:20:49 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D193B07FFC9@avsrvexchmbx1.microsemi.net>
References: <147752001094.813.10247306839794156732.stgit@brunhilda>
 <147752050626.813.15549750881571218281.stgit@brunhilda>
 <20161027151903.GA4602@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0070.outbound.protection.outlook.com ([104.47.33.70]:30020
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S943763AbcJaPVI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Oct 2016 11:21:08 -0400
In-Reply-To: <20161027151903.GA4602@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, John Hall <John.Hall@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, Viswas G <viswas.g@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "elliott@hpe.com" <elliott@hpe.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, October 27, 2016 10:19 AM
> To: Don Brace
> Cc: jejb@linux.vnet.ibm.com; John Hall; Kevin Barnett; Mahesh
> Rajashekhara; hch@infradead.org; Scott Teel; Viswas G; Justin Lindley; Sc=
ott
> Benesh; elliott@hpe.com; POSWALD@suse.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/4] hpsa: correct lockup detector pci_disable_device
>=20
> EXTERNAL EMAIL
>=20
>=20
> > -     pci_disable_device(h->pdev);
> > +     if (pci_is_enabled(h->pdev))
> > +             pci_disable_device(h->pdev);
> >       fail_all_outstanding_cmds(h);
>=20
> Humm.  How can this even happen when the device isn't enabled?

controller_lockup_detected can be called multiple times, especially when I =
am
exercising the reset handler and abort handler, so I wanted to avoid the ke=
rnel
warning messages.

fail_all_outstanding_commands is called with status CMD_CTLR_LOCKUP
and complete_scsi_command returns DID_NO_CONNECT.

