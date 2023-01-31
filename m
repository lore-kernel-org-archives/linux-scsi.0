Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D26C38142
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Jan 2023 21:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjAaVA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Jan 2023 16:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbjAaVAy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2023 16:00:54 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C625B97
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2023 13:00:43 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id a184so11144324pfa.9
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2023 13:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOx35qU7oVJlmpizaQVDcsgLOpINwy8MK8o0Mz7zPvY=;
        b=Cz8Q0V7phi/nLeqNZJAdw2MudVdKaNn7rnP1cf0R4olwPdCP475aH3gSSaUxU/45va
         nGGJbF2RC1Vg3f2rsNkvxCIXzLOibuqti6To2z+FqVWw5XN/Fuk0NrhvDXZyALA/x8ZF
         4mHbMp0zAD4Nux6pokRd+mwkRmuy+0IQbwCeAH3QST+0iuycLoE34yBxvh5NYMS5GHFp
         Gvi/CPC4n+BgrZABihnWnkMpK5zWQaHq4s95YPA18/td2PO0qvSC5jepsKvVkCBsDFU2
         k8aV160l1HI62u2gnZFFn6kHN24n/Hv3Rbjxll2ocA7RdBa4axNIcG+YyEUn70pdB1oF
         zljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XOx35qU7oVJlmpizaQVDcsgLOpINwy8MK8o0Mz7zPvY=;
        b=vSyGV60HVn8HpvuwyhZJIPZ5aWdxD0Z2RG5CDDhrRilg9h/gwopIFue7ahLKJcPu9e
         KtMhVJjblZO5Jp6CYu3YdAIQnAeaNu3t4UYwl8UhPARQPpEuAqf2t0os3Ox8jBUOKAsx
         pCfXFhUY+AHrHPHFSMSjFh0a+Qxd/kO3Cy9XfqVcz5iMw0tpaFeyj7ea9J+eblV2GNp0
         B2r0NDU0lfOsGvoitg6K+dn1CCPSs8ZUTShFPj+pgrqyWoeHTuQfoWb4sg3fj0cJnzPA
         Ei8hmkvmoL4WL2ycoV5FLSaM/4uxW2jRRjmMXZBhKFz3JSTxG8rrRRDnBGCIuKG94YA5
         qvlg==
X-Gm-Message-State: AO0yUKUwMTqEPOxfq7qnc9TyNS6vWRLCxTjtnmJRxr2wPH6Mf44TGYmg
        8oGpSe+8Jz+Rw6aybwemWvwXXbguOWP8gQ65NPls3E1csjpjwW2OQQ0nx7D0PFnLhT7WZszzbje
        kLtc5Vu3l62lNjF8VtA3SAPgpIepnYHt7czqs5ghEBV/diRjzLnDhxJupTPKbtbjOzCv6OZSiqO
        wC57Y=
X-Google-Smtp-Source: AK7set8DFQo2+gLzaJhnj1qd1kbvzKCfE76h9RrbBBthaHciH1Wj++sl4NMXUzimwpFEAlE/dV7bsw==
X-Received: by 2002:aa7:98cf:0:b0:593:9620:360 with SMTP id e15-20020aa798cf000000b0059396200360mr12313405pfm.7.1675198841736;
        Tue, 31 Jan 2023 13:00:41 -0800 (PST)
Received: from smtpclient.apple ([136.226.78.245])
        by smtp.gmail.com with ESMTPSA id ay7-20020a056a00300700b00592547db086sm9328909pfb.209.2023.01.31.13.00.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Jan 2023 13:00:41 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: The PQ=1 saga
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <083141cd-3b79-7c54-9464-df36c06cc59a@suse.de>
Date:   Tue, 31 Jan 2023 13:00:29 -0800
Cc:     Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AE26D869-2E6A-45A9-8739-CFB65C6C0750@purestorage.com>
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
 <4f9794d2-00ed-22da-2b4b-e8afa424bf17@acm.org>
 <d0ac216445c33e9bf98e8c850f4d900acf0787bd.camel@suse.com>
 <9545766a-298d-1358-46f0-64ccfaf30ca0@suse.de>
 <6A8AA317-32B0-48F4-82DC-82B65A221A9F@purestorage.com>
 <083141cd-3b79-7c54-9464-df36c06cc59a@suse.de>
To:     linux-scsi@vger.kernel.org
X-Mailer: Apple Mail (2.3731.400.51.1.1)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On Jan 30, 2023, at 5:35 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 1/27/23 20:57, Brian Bunker wrote:
>> I was doing some more testing of this since it has been a while since =
I
>> ran these tests. It looks like reverting this will make the =
particular situation
>> that I am worried about even worse. I will put the detail in.
>> With this in place (before you revert it). When SCSI devices are =
discovered
>> and some have a PQ=3D1 because they are in an unavailable ALUA state:
>> Jan 27 12:05:29 localhost kernel: scsi 7:0:0:1: scsi scan: peripheral =
device type of 31, no device added
>> I don=E2=80=99t know if this intentional with the patch or not but =
any devices with PQ=3D1
>> will not create SCSI devices. The logging is deceptive too since the =
device type
>> Is 0 and not 31. In my case I have two paths to LUN 1. One is ALUA AO =
and the
>> other in ALUA unavailable.
>> With this patch in I only get an sd device and an sg device for the =
AO path.
>> The other path to LUN 1 gets no devices created because it is caught =
in the
>> If condition logged above.
>> Because there are no SCSI devices created, when the ALUA state =
returns
>> to an active state, a SCSI rescan, which I can trigger from the =
target will result
>> in the devices getting created since the initial scan never created =
devices.
>> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY =
pass 1 length 36
>> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY =
successful with code 0x0
>> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY =
pass 2 length 96
>> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: scsi scan: INQUIRY =
successful with code 0x0
>> Jan 27 12:26:04 localhost kernel: scsi 7:0:0:1: Direct-Access     =
PURE     FlashArray       8888 PQ: 0 ANSI: 6
>> Things are good with both paths to LUN 1 showing up. It is not =
optimal since the
>> target has to trigger a LUN scan on the initiator affecting all paths =
to those target
>> ports.
>> With the revert of this, things are a little different, but the way =
they had been in
>> the past.
>> Jan 27 13:41:19 localhost kernel: sd 7:0:1:1: Asymmetric access state =
changed
>> Jan 27 13:41:56 localhost kernel: scsi 7:0:1:1: alua: Detached
>> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY =
pass 1 length 36
>> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY =
successful with code 0x0
>> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY =
pass 2 length 96
>> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: scsi scan: INQUIRY =
successful with code 0x0
>> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: Direct-Access     =
PURE     FlashArray       8888 PQ: 1 ANSI: 6
>> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: alua: supports =
implicit TPGS
>> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: alua: device =
naa.624a9370acc31b042de141460001141c port group 0 rel port a
>> Jan 27 13:42:22 localhost kernel: scsi 7:0:1:1: Attached scsi generic =
sg7 type 0
>> Now an sg device is created but not an sd device. This means that =
there will be
>> no way for this device to get an sd device created once the ALUA =
state goes into
>> an active state.
>> The same thing done on the target that worked above no longer does:
>> Jan 27 13:47:48 localhost kernel: scsi 7:0:1:1: scsi scan: device =
exists on 7:0:1:1
>> To get around this, the existing disk must be deleted so it is not =
caught in the rescan
>> check. This cannot be controlled on the target, but it will require =
manual intervention
>> on the initiator.
>> So the question becomes how should initial scan work when a LUN has a =
PQ=3D1 set.
>> It is a valid, by spec with ALUA state unavailable but doesn=E2=80=99t =
seem to be
>> handled. Why allow an sg device but not an sd one on initial scan in =
this case? There
>> are probably many ways to fix this. I think the simplest is to allow =
sd device creation
>> on LUNs were PQ=3D1, and only restrict PQ=3D3. I am not sure the side =
effect of this on other
>> targets. The other approach which will no longer work after the =
revert is to trigger a
>> rescan from the target. This is sub-optimal since it is disruptive. =
Any approach involving
>> the ALUA device handler will not help since there is no device to =
transition if it is
>> discovered with PQ=3D1.
> Sheesh.
>=20
> There _is_ an easy solution for this, and that is to not use PQ=3D1 in =
conjunction with ALUA unavailable :-)
>=20
> Hiding PQ=3D1 devices did serve the purpose for linux as we still =
cannot to a 'real' rescan of a SCSI device; the 'vendor' and 'model' =
string is pretty much fixed for the lifetime of the device, alongside =
with the entire standard inquiry data. So if anything changes here we =
have to delete the device before we can properly read it.
>=20
> (which also means that I'll have to retract my earlier comment about =
this being a good idea ...)
>=20
> And in the absence of that hiding PQ=3D1 devices is the best we can =
do.
> The alternative would be to implement a 'real' device rescan; but that =
was too daunting a challenge to be undertaken until now.
> Things did change in the meantime, so maybe it's time to revisit that.
>=20
> But really, we should ask vendors to _not_ use PQ=3D1 when using ALUA. =
I fail to see the benefit of this as both have roughly the same meaning; =
if you have ALUA unavailable you can't access the device, hence it's =
completely irrelevant what PQ says. And same for the other way round: if =
PQ=3D1 is set really the only ALUA state which makes sense is =
'unavailable'.
>=20
> Sadly it's not so easy to fix things up in the SCSI stack, as the PQ =
setting is evaluated during scanning, and the ALUA state way back later.
>=20
> Cheers,
>=20
> Hannes
What about something like this? This will remove the device if the PQ=3D1 =
and re-discover it. If the TPG
remains unavailable, it will just be created in the same way. If the TPG =
has moved to an active state
the newly created device will be an available sd device. This way at =
least target vendors can cause
the initiator to rescan and get the devices from unavailable to an =
active state without the manual
Intervention on each host having to remove the devices with the PQ=3D1 =
set and rescan manually.
If the manual removal of devices is required, it does make ALUA =
unavailable unrealistic.

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f9b18fdc7b3c..9ff9ca1b963e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1123,6 +1123,36 @@ static unsigned char *scsi_inq_str(unsigned char =
*buf, unsigned char *inq,
 }
 #endif
=20
+/**
+ * scsi_remove_offline_device - remove the device if the criteria met
+ * * @sdev:    scsi_device to check
+ *
+ * Description:
+ * A SCSI device which is part of a TPG in the unavailable state will
+ * have the PQ=3D1. If the device is discovered this way, there is no
+ * way for it to transition to an active state. The device must be
+ * removed and rediscovered during rescan in the event that the TPG
+ * has transitioned to an active state.
+ *
+ * Return:
+ * true: the conditions are met for device removal
+ * false: the conditions are not met
+ **/
+static bool scsi_remove_offline_device(struct scsi_device *sdev)
+{
+       if (sdev =3D=3D NULL || sdev->handler =3D=3D NULL)
+               return false;
+
+       if (sdev->inq_periph_qual =3D=3D SCSI_INQ_PQ_NOT_CON &&
+           (strncmp(sdev->handler->name, "alua", 4) =3D=3D 0)) {
+               SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+                                 "scsi scan: discovered not accessible =
%s\n",
+                                 dev_name(&sdev->sdev_gendev)));
+               return true;
+       }
+       return false;
+}
+
 /**
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @starget:   pointer to target device structure
@@ -1161,6 +1191,10 @@ static int scsi_probe_and_add_lun(struct =
scsi_target *starget,
         * host adapter calls into here with rescan =3D=3D 0.
         */
        sdev =3D scsi_device_lookup_by_target(starget, lun);
+       if (scsi_remove_offline_device(sdev)) {
+               __scsi_remove_device(sdev);
+               sdev =3D NULL;
+       }
        if (sdev) {
                if (rescan !=3D SCSI_SCAN_INITIAL || =
!scsi_device_created(sdev)) {
                        SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, =
sdev,

Thanks,
Brian


