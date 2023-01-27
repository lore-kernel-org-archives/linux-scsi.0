Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DADC54EAA
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 21:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjA0VeN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 16:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjA0VeN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 16:34:13 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121485A351
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2023 13:34:09 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id z3so4175568pfb.2
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2023 13:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u0ZVJ514Y6/oTehW0IoMbdE4wPRH61dDbhbU0VR0ry4=;
        b=b8W5GRRDcli56oxi/HrcFVkYfgxnfHWt5RyIlOOIF/MU7Ot55kREAfW7jVSLsbAO/E
         xgeRW1aDMiKp1+Syua2pxOKrORmeI9BME15Vhke/+T+cMF1RMevIQdZq81l+4x4enRRV
         5D9P1L2WYYMnJelHDo+hxCm6v0tdbeoK3lFExFY44XKgevq2yy4kdctOcJ8s/FsY8PRc
         AKi47sWvl5lXco6ogKXQbxaCABhco/VbE3wiFHbRRofvJEiUi/1+nXa1l9vQzU+Qy78/
         bEzaKetPLjkyWPE6cImEZkhYj8Ov8dIHte5xk8c8IzEL4+5TkobGyn/MDYFp9UbPKmp0
         Bjhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u0ZVJ514Y6/oTehW0IoMbdE4wPRH61dDbhbU0VR0ry4=;
        b=aa388mxwvrQdcujtyMuhLBXSHNgKtH6E2l8CMC/z2gY98gtFbPSkV7/HlqhDQmWqKs
         rcXB7cEKSY7N/zUpvj/28X+9SvmTBvBVsqdUssfAyRXV0Xoll0E+PCnJOEcowa8wbb1l
         MklXyK8jC0aXKbiPr8ie/gAuaDDO5ai3kLc8ytMAMIYPyDqIeBsTnLPgJjy0IRDGC9TA
         zF6kiDjKTTcYH5hArvJrZQr1+Bxwd6ZSUlVsOdZqPrkz2gNLqjoygA4AQbVOABOCb1kq
         hvLYLWLdiyoSKWg/P8eCyGPX9qR8yCeiUXkqx7ZA/5IlELYIIu4c0zkgVvhIHfCSxZah
         ej9Q==
X-Gm-Message-State: AO0yUKXF9aNI/QdHSyu0MS7Cm33AzYfTq+y1pFLPqJL/xOGsg70tELgI
        Ns+W+ZIGcffhnM0nVK+48Ol2wg==
X-Google-Smtp-Source: AK7set9Yib5IEM3dlH8NTy583iwHnq25D8/PD/yQN5OonEs6mWTSciE/J+iL5JeLID/SntmDH7IwoA==
X-Received: by 2002:a62:7b4c:0:b0:592:3eeb:51d9 with SMTP id w73-20020a627b4c000000b005923eeb51d9mr6257855pfc.21.1674855248383;
        Fri, 27 Jan 2023 13:34:08 -0800 (PST)
Received: from smtpclient.apple ([2600:1700:6970:bea0:98e4:2c9:4b09:d80d])
        by smtp.gmail.com with ESMTPSA id e190-20020a621ec7000000b005809d382016sm3052926pfe.74.2023.01.27.13.34.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Jan 2023 13:34:07 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: The PQ=1 saga
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <65e11f62-0109-ee6f-0cd0-56ae30dd1208@acm.org>
Date:   Fri, 27 Jan 2023 13:33:56 -0800
Cc:     linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4ECB6542-489C-4D2B-9D3A-060D5C66601D@purestorage.com>
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
 <4f9794d2-00ed-22da-2b4b-e8afa424bf17@acm.org>
 <d0ac216445c33e9bf98e8c850f4d900acf0787bd.camel@suse.com>
 <9545766a-298d-1358-46f0-64ccfaf30ca0@suse.de>
 <6A8AA317-32B0-48F4-82DC-82B65A221A9F@purestorage.com>
 <65e11f62-0109-ee6f-0cd0-56ae30dd1208@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 27, 2023, at 12:43 PM, Bart Van Assche <bvanassche@acm.org> =
wrote:
>=20
> On 1/27/23 11:57, Brian Bunker wrote:
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
>=20
> When Mike Christie and I looked into the ALUA unavailable state many =
years ago we concluded that using this state is so troublesome that it's =
better not to use this state. How about using active/optimized and =
active/non-optimized instead?
I can=E2=80=99t do that because active/non-optimized is just advisory. =
If a request comes down that path
it must succeed. In our case, we can=E2=80=99t allow that. Our only =
choice is between non-active
ALUA states. We can use standby but that invites SCSI commands we would =
rather
not have to deal with, most notably persistent reservations. ALUA =
unavailable is the
attractive one but it comes with the PQ=3D1 baggage.

Thanks,
Brian
> Thanks,
>=20
> Bart.
>=20

