From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] iscsi-target: Add login_keys_workaround attribute for non
 RFC initiators
Date: Tue, 11 Jul 2017 23:38:37 +0000
Message-ID: <1499816315.2586.51.camel@wdc.com>
References: <1499466285-9907-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1499466285-9907-1-git-send-email-nab@linux-iscsi.org>
Content-Language: en-US
Content-ID: <43669E5FC4CBF2418B2F701BDCF08D8F@namprd04.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "robert@leblancnet.us" <robert@leblancnet.us>, "arun.easi@cavium.com" <arun.easi@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-07-07 at 22:24 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> This patch re-introduces part of a long standing login workaround that
> was recently dropped by:
>=20
>   commit 1c99de981f30b3e7868b8d20ce5479fa1c0fea46
>   Author: Nicholas Bellinger <nab@linux-iscsi.org>
>   Date:   Sun Apr 2 13:36:44 2017 -0700
>=20
>       iscsi-target: Drop work-around for legacy GlobalSAN initiator
>=20
> Namely, the workaround for FirstBurstLength ended up being required by
> Mellanox Flexboot PXE boot ROMs as reported by Robert.
>=20
> So this patch re-adds the work-around for FirstBurstLength within
> iscsi_check_proposer_for_optional_reply(), and makes the key optional
> to respond when the initiator does not propose, nor respond to it.
>=20
> Also as requested by Arun, this patch introduces a new TPG attribute
> named 'login_keys_workaround' that controls the use of both the
> FirstBurstLength workaround, as well as the two other existing
> workarounds for gPXE iSCSI boot client.
>=20
> By default, the workaround is enabled with login_keys_workaround=3D1,
> since Mellanox FlexBoot requires it, and Arun has verified the Qlogic
> MSFT initiator already proposes FirstBurstLength, so it's uneffected
> by this re-adding this part of the original work-around.

Hello Nick,

The new configfs attribute ("login_keys_workaround") may confuse users - fo=
r
someone who has not followed this e-mail thread it can take a long time
before they figure out that they need to set this configfs attribute. Have
you considered to let the iSCSI target driver figure out whether or not tha=
t
variable has to be set, e.g. by looking up the initiator IQN in a list?

Bart.=
