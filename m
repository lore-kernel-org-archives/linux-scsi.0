Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9BDC433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Apr 2022 21:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358297AbiDCVii (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Apr 2022 17:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiDCVih (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2022 17:38:37 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C9739BBA
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 14:36:42 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r10so3188063eda.1
        for <linux-scsi@vger.kernel.org>; Sun, 03 Apr 2022 14:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=0jGtZuq8BQQKsCNAVS+MX3D8r3PGNQak4z5H7gSViOM=;
        b=ZFHHtrlAVNuujaFxg/pqAbIDJTSWNJKdJBpMVA0F9O4pjG4NX0OiBwcT2h5uBYEyLn
         hjh/r0FMBOdxnA7cMbL4EYVp2svwENIx+l+z1rggy3q9L5KD+1s7T+LSEM3tfKVO7VGp
         s70xd1T1QD1XOPKSdVmyV59O3x1rpMV/vzcHslcx/evrRDVBN82h+5hbYW8oob2PtRiR
         KlZlrOuYWs1KCV7PWEq745skxngl6CPicnEWBNZNwRk7c8lqomR0vndeYFo+o6GqQTp/
         b3hEDCCwV4MHQB+ulxAP3nLpBXlUUlcuf+BgITCtKbogUbcPAowCON2YdtlhIWCOcVS7
         WP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=0jGtZuq8BQQKsCNAVS+MX3D8r3PGNQak4z5H7gSViOM=;
        b=c8+1GZIXH9km0BoiVXS23i3/S6X8UuhE5jrya3eKDYvI0SgiPwAMd1bzLDwuAIMFAu
         OJV+4WzWy9+LaEV6DfGTctaXJyi1jyKaa5OLzGUxVLolJaf+cIJ1FVwSHVuZ2bjQ3Jnk
         3ndMreAlIzGEdpePM0S28V+7JV859eF/27iISQZu/05z9X1BgFyAvll3CeyOrv2M0ofj
         BfDEkGRquxcL4gySw6fKoM51l4q/J4W8B+UkTbhrj334OVC6jauhdPh85mb0iHgE+vNL
         aWAnIVUyPtTZjAmNQOw+II4gWw0kEflQtbwkD4H99E8OWenZdQCqahOCgXTAlqED0vhi
         4zIQ==
X-Gm-Message-State: AOAM533wRLsdrMshU4pLyJWvMuOycFIvchEru3rhGht/p6ah2peeX8EX
        YLQD8AeKIgrarlIYh7SmM1s=
X-Google-Smtp-Source: ABdhPJwTF+dskhg5gjkGuLdo6NFo4M+xW1mt+tbCCmD6+LKpz8QDo7GEPJtqetPlHXmwS2y7EcqhGg==
X-Received: by 2002:a05:6402:5193:b0:419:3d19:ce9e with SMTP id q19-20020a056402519300b004193d19ce9emr29646502edd.199.1649021801295;
        Sun, 03 Apr 2022 14:36:41 -0700 (PDT)
Received: from p200300c5870184372b88b7302efecb4a.dip0.t-ipconnect.de (p200300c5870184372b88b7302efecb4a.dip0.t-ipconnect.de. [2003:c5:8701:8437:2b88:b730:2efe:cb4a])
        by smtp.googlemail.com with ESMTPSA id e12-20020a170906c00c00b006e66eff7584sm2164935ejz.102.2022.04.03.14.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 14:36:40 -0700 (PDT)
Message-ID: <9bff98fa4a4a8a61a5c46830ef9515a7dfddcb89.camel@gmail.com>
Subject: Re: [PATCH 00/29] UFS patches for kernel v5.19
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date:   Sun, 03 Apr 2022 23:36:39 +0200
In-Reply-To: <DM6PR04MB6575DBC3CFAD57F5AA19DCF8FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
         <60dc8a92c7eda8f190a8a6123bc927e8403bdbb1.camel@gmail.com>
         <eee8d304-aacd-9116-9e2d-92e2e3682b5b@acm.org>
         <DM6PR04MB6575DBC3CFAD57F5AA19DCF8FCE29@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2022-04-03 at 05:59 +0000, Avri Altman wrote:
> > On 4/1/22 02:32, Bean Huo wrote:
> > > Agree that the current UFS driver is messy, but I don't think
> > > there
> > > was such a big structural change before UFS 4.0 was released,
> > > especially the design of the UFS CQE driver. If you already have
> > > a
> > > plan for CQE, it's best to state it in the patch. If you have
> > > made
> > > such a big change in an environment that is now very stable, do
> > > we
> > > have to make changes after UFS 4.0? ?
> >=20
> > Hi Bean,
> >=20
> > Although this patch series will make it easier to add UFSHCI 4.0
> > support, I think
> > that UFSHCI 4.0 support can also be added without this patch
> > series.
> Also, UFS4.0 and its UFSHCI4.0 companion are expected to be published
> around end of May, right?
> I doubt if we'll have platforms to test those changes within the
> V5.19, or even V5.20 timeframe.
> So MCQ should not conflict with those, mostly structural, cleanups.
>=20
> Thanks,
> Avri=20

Yes, I reviewed the entire series of patches and there are no
significant structural changes. Still want to squeeze ufs driver under
driver/scsi/ufs/. No major conflict with pending submissions. Go ahead.

Kind regards,
Bean
