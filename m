From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 3/4] scsi_dh_alua: do not call BUG_ON when updating
 port group
Date: Mon, 15 May 2017 16:03:23 +0000
Message-ID: <1494864202.2567.1.camel@sandisk.com>
References: <20170512131508.3231-1-mwilck@suse.com>
         <20170512131508.3231-4-mwilck@suse.com>
         <1494606261.14477.3.camel@sandisk.com> <1494836189.4728.2.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:40594 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934249AbdEOQD1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2017 12:03:27 -0400
In-Reply-To: <1494836189.4728.2.camel@suse.com>
Content-Language: en-US
Content-ID: <289FDB0E85F95046B5E94081C5E8A886@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "mwilck@suse.com" <mwilck@suse.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "mauricfo@linux.vnet.ibm.com" <mauricfo@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2017-05-15 at 10:16 +0200, Martin Wilck wrote:
> On Fri, 2017-05-12 at 16:24 +0000, Bart Van Assche wrote:
> > Allowing races like the one this patch tries to address to exist
> > makes the ALUA code harder to maintain than necessary. Have you
> > considered to make alua_bus_detach() wait until ALUA work has
> > finished by using e.g. cancel_work_sync() or rcu_synchronize()?
>=20
> to be honest, no, I didn't consider this yet. The current kernel
> crashes with BUG() if an ALUA device is detached at an inopportune
> point in time (not just theoretically, we actually observed this). The
> goal of my patch was to fix this with minimum risk to introduce other
> problems. The addition in patch 4/4 was an attempt to address the
> concern you had expressed in your review of the v1 patch.
>=20
> I'm not opposed to try to find a better solution, but could we maybe
> get the fix for the BUG() (i.e. patch 3/4) applied in the first place?
> AFAICS it would not conflict with a solution like the one you
> suggested.

Hello Martin,

Sorry but I don't think it's a good idea to merge patch 3/4 in the upstream
kernel. Even with that patch applied there is nothing that prevents that
h->handler_data would be freed while alua_rtpg() is in progress and hence
that h->sdev is a completely random pointer if alua_rtpg() is executed
concurrently with alua_bus_detach(). Please do not try to paper over race
conditions but fix these properly.

Bart.=
