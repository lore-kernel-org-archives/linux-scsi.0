Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB6BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 16:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbiEWQw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 12:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239048AbiEWQw5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 12:52:57 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6512C289A8
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 09:52:55 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w200so14204381pfc.10
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 09:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=m3SFxhJMWVpu+u+6og9DkfrH/8R1Bgd+HEcoG4elZ+k=;
        b=i/wysuHUEFyDrS3m+L2G1e3KUJfcLlc3v6D5RyRN5GwhujmslRhz24FAAxA+iiUNhq
         4OxX4Mt3CTy5cdWN4oj6AuEZWG63O//OpEkAw/fK8+iz4DdRTPVMW0oZx4A/RiVuu5GI
         HCIGJ5Xzqm+aBQMDXzwRR0GnKh37xtFcicQVM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=m3SFxhJMWVpu+u+6og9DkfrH/8R1Bgd+HEcoG4elZ+k=;
        b=YkgS7G8h2aEcMnv64xG2aGX27h/7F7zPi5xsHc/nxUtYLF4BCroI8SwCU6nwqzGstg
         +POATOwwvgmdamsmD9fzAnx25uniB6cWfuhf9mRE91nt2QkZb2ibrDJx9P8DW1FBM3Iz
         SUucwDNTHpujT5NW6aopEnlpiT34jDNvyfR8buaVxOrokBdYJFrc4LB2URMAqs6dRgfg
         uUoSr34ITIIsWLopSF1Q1gBspBUHE2fGfFg41WwcMKSiKXyhknlnr7JEatVRyf4u9Fh0
         129j14vwE3v2qFQtE17VN6u7PGFpI4o3+04JiqS0njbbd3usLiiydm2Mp59UPR9Dx3ST
         /uYg==
X-Gm-Message-State: AOAM532tUR053KiteGMxAeVVYhLh0snW2yr/gL8/V3xPbVGjosH2vcAg
        HFX7P5o0V6hpovE7z/5eByXU4w==
X-Google-Smtp-Source: ABdhPJwvsRXoVZi4kypqTmlZy1IJ8mFtJwuhTw25homWcJLxI+39OZNL0NIvTC2aifbrAguLaMKapw==
X-Received: by 2002:a63:1358:0:b0:3f5:f2ee:fe89 with SMTP id 24-20020a631358000000b003f5f2eefe89mr20815065pgt.57.1653324774722;
        Mon, 23 May 2022 09:52:54 -0700 (PDT)
Received: from smtpclient.apple (vpn.purestorage.com. [192.30.189.1])
        by smtp.gmail.com with ESMTPSA id e10-20020a170902b78a00b0016196bcf743sm5332626pls.275.2022.05.23.09.52.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 May 2022 09:52:53 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <07f3474feb4ea7c2e80664c9977ae0e24b82cc09.camel@suse.com>
Date:   Mon, 23 May 2022 09:52:51 -0700
Cc:     Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Benjamin Marzinski <bmarzins@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4CBD87A8-0A92-4DFD-B50B-124C11BB9C86@purestorage.com>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
 <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
 <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
 <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de>
 <2f6d93fd90c3e78166a1803a989b4dc6064fcada.camel@suse.com>
 <7d0140a6-9ab7-9b88-9601-4204ab8a88ca@oracle.com>
 <234ccf5fc9f36fd837b3959057691a716685da3b.camel@suse.com>
 <CAHZQxyLEOw8jXUzLj8DugbbsVkFP=OMjv-Lkz6LkuayEavYahg@mail.gmail.com>
 <07f3474feb4ea7c2e80664c9977ae0e24b82cc09.camel@suse.com>
To:     Martin Wilck <mwilck@suse.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On May 23, 2022, at 9:03 AM, Martin Wilck <mwilck@suse.com> wrote:
>=20
> On Fri, 2022-05-20 at 19:52 -0700, Brian Bunker wrote:
>> =46rom my perspective, the ALUA transitioning state is a temporary
>> state
>> where the target is saying that it does not have a permanent state
>> yet. Having the initiator try another pg to me doesn't seem like the
>> right thing for it to do.
>=20
> I agree. Unfortunately, there's no logic in dm-multipath saying "I may
> switch paths inside a PG, but I may not do PG failover".
>=20
>> If the target wanted the initiator to use a
>> different pg, it should use an ALUA state which would make that
>> clear,
>> standby, unavailable, etc. The target would only return an error
>> state
>> if it was aware that some other path is in an active state.When
>> transitioning is returned, I don't think the initiator should assume
>> that any other pg would be a better choice. I think it should assume
>> that the target will make its intention clear for that path with a
>> permanent state within a transition timeout.
>=20
> For me the question is still whether trying to send I/O to the path
> that is known not to be able to process it makes sense. As noted
> elsewhere, you patch just delays the BLK_STS_AGAIN by a few
> milliseconds. You want to avoid a PG switch, and I second that, but =
IMO
> that needs a different approach.
>=20
>> =46rom my perspective the right thing to do is to let the ALUA =
handler
>> do what it is trying to do. If the pg state is transitioning and
>> within the transition timeout it should continue to retry that
>> request
>> checking each time the transition timeout.
>=20
> But this means that we should modify the logic not only in
> alua_prep_fn() but also for handling of NOT READY conditions, either =
in
> alua_check_sense() or in scsi_io_completion_action().
> I agree that this would make a lot of sense, perhaps more than trying
> to implement a cleverer logic in dm-multipath as discussed between
> Hannes and myself.
>=20
> This is what we need to figure out first: Do we want to change the
> logic in the multipath layer, making it somehow aware of the special
> nature of "transitioning" state, or should we tune the retry logic in
> the SCSI layer such that dm-multipath will "do the right thing"
> automatically?
>=20
> Regards
> Martin
>=20
I think that a couple of things are needed to get to where my =
expectation of how it should work would be. First this code should come =
out of the not ready sense check. The reason is that it will continually =
override alua_check=E2=80=99s attempt to change the pg state as it =
exceeds the allowed time and the path state is changed to standby to =
handle a misbehaving target which stays in transitioning past the timer.

--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -409,20 +409,12 @@ static char print_alua_state(unsigned char state)
 static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
                                              struct scsi_sense_hdr =
*sense_hdr)
 {
-       struct alua_dh_data *h =3D sdev->handler_data;
-       struct alua_port_group *pg;
-
        switch (sense_hdr->sense_key) {
        case NOT_READY:
                if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D =
0x0a) {
                        /*
                         * LUN Not Accessible - ALUA state transition
                         */
-                       rcu_read_lock();
-                       pg =3D rcu_dereference(h->pg);
-                       if (pg)
-                               pg->state =3D =
SCSI_ACCESS_STATE_TRANSITIONING;
-                       rcu_read_unlock();

Second for this to work how it used to work in Linux and how it works =
for other OS=E2=80=99s where ALUA state transition is not a fail path =
response:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8d18cc7e510e..33828aa44347 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -776,11 +776,11 @@ static void scsi_io_completion_action(struct =
scsi_cmnd *cmd, int result)
                                case 0x1b: /* sanitize in progress */
                                case 0x1d: /* configuration in progress =
*/
                                case 0x24: /* depopulation in progress =
*/
                                       action =3D ACTION_DELAYED_RETRY;
                                        break;
                                case 0x0a: /* ALUA state transition */
-                                       blk_stat =3D BLK_STS_AGAIN;
-                                       fallthrough;
+                                       action =3D ACTION_REPREP;
+                                       break;

Because, as you said the expiation check for whether to continually =
allow new I/O on the pg is in the prep function of the ALUA handler. I =
think that this does introduce a lot error processing for a target that =
will respond quickly. Maybe there is some way to use the equivalent of =
ACTION_DELAYED_RETRY so that the target is not as aggressively retried =
in the transitioning state.

It is possible, maybe likely, in other OS=E2=80=99s that this retry is =
done at the multipath level. The DSM from Microsoft in GitHub would seem =
to show that Windows does it that way. The multipath-tools in Linux =
though don=E2=80=99t seem to use sense data to make decisions so getting =
this logic in would seem like a decent set of changes and getting the =
buy-in to go that route.

Thanks,
Brian

