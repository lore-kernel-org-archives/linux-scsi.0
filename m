From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] iscsi-target: Reject immediate data underflow larger than
 SCSI transfer length
Date: Thu, 13 Jul 2017 23:24:38 +0000
Message-ID: <1499988277.2740.28.camel@wdc.com>
References: <1496895685-18464-1-git-send-email-nab@linux-iscsi.org>
         <1496936253.3028.1.camel@wdc.com>
         <1496991302.28997.66.camel@haakon3.risingtidesystems.com>
         <1499757761.28145.45.camel@haakon3.daterainc.com>
         <1499789824.2586.16.camel@wdc.com>
         <1499974037.7987.24.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499974037.7987.24.camel@haakon3.daterainc.com>
Content-Language: en-US
Content-ID: <D0EFE688805FB948B85B12AB9340FDA2@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mchristi@redhat.com" <mchristi@redhat.com>, "roland@purestorage.com" <roland@purestorage.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-07-13 at 12:27 -0700, Nicholas A. Bellinger wrote:
> For the former, I've still never seen a host environment in the wild
> over the last 15 years that generates underflow/overflow for DATA CDBs
> with an LBA.  So I'm reluctant to randomly allow this for all cases and
> fabrics, considering no host environment actually requires it.
>=20
> That said, I do understand libiscsi generates this for WRITE_VERIFY, but
> I'm still undecided if that's a good enough a reason to enable it for
> all cases in upstream.
>=20
> For the latter item, it's fine to drop the legacy block_size !=3D 512
> check, and I'll take a patch for that separate from the other bit.

Hello Nic,

Thanks for considering to drop the block_size !=3D 512 check.

There is one side effect of the current code for handling WRITE underflows
that has not yet been mentioned in this e-mail thread. The current
implementation of the iSCSI target driver does not discard the entire
immediate data buffer if the size of that buffer is larger than the data
buffer size derived from the SCSI CDB (EDTL). Because of this the iSCSI
target driver will attempt to parse some of the immediate data as an iSCSI
PDU. This can cause very weird failures and error messages. I think we
should address this and also that we should make sure that any iSCSI PDUs
that follow a too large immediate data buffer are parsed correctly.

Bart.=
