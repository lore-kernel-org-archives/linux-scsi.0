From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] sd: use async_probe cookie to avoid deadlocks
Date: Tue, 21 Mar 2017 13:42:20 +0000
Message-ID: <1490103725.2602.7.camel@sandisk.com>
References: <1490098475-21884-1-git-send-email-hare@suse.de>
         <1490101519.2412.13.camel@HansenPartnership.com>
         <1490103027.2602.5.camel@sandisk.com>
         <1490103238.2412.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:26359 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756517AbdCUNme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Mar 2017 09:42:34 -0400
In-Reply-To: <1490103238.2412.17.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <F48C90EAC9E8FE489EA82B51F8AE0211@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On Tue, 2017-03-21 at 09:33 -0400, James Bottomley wrote:
> On Tue, 2017-03-21 at 13:30 +0000, Bart Van Assche wrote:
> > On Tue, 2017-03-21 at 09:05 -0400, James Bottomley wrote:
> > > How does this preserve ordering?  It looks like you have one cookie=20
> > > per sdkp ... is there some sort of ordering guarantee I'm not
> > > seeing?
> >=20
> > Hello James,
> >=20
> > Since the probe order depends on the order in which __async_probe()=20
> > adds entries to the "pending" list, and since the order of the
> > __async_probe() calls is not changed by this patch, shouldn't the=20
> > probe order be preserved by this patch?
>=20
> I don't know: that's what I'm asking.  I believe they complete in order
> for a single domain.  I thought ordering isn't preserved between
> domains?  So moving to multiple domains loses us ordering of disk
> appearance.

Right, since sd_remove() doesn't wait any longer for completion of probes
from other domains the multi-domain probing behavior may change due to this
patch. However, the multi-domain probing order was already dependent on the
duration of individual probes so I don't think that it is guaranteed today
that multi-domain probing happens in the same order during every boot. I
hope that the change introduced by this patch will be considered acceptable=
.

Bart.=
