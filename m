Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B8DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Apr 2022 20:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245182AbiDYVBK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 17:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiDYVBI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 17:01:08 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0672C1E3C8
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 13:58:04 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id el3so15132827edb.11
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 13:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=+TQz+vU+zWVuWkGkBgdrc964ZfnYAc3K/dhJi87Hy+Y=;
        b=N1YCZz0fGiWpHh6PFjk+UrJmEKq43bCAs6uBEwRD/Y1NifTQganVqtPVO+gE8s53Wv
         LBD5UbB+992mTYVaqblQ7+pmoVzUV8pT4DnuWs4CaQX1+Ms9gAY8BEb4jLOGxpSyChfU
         ufxWUCAcu94DPbRkxgevbpgoadVOr5UsYJgIhPkkSx1C8hn3St9P7yCLrCv+lDk6UKiZ
         cO6nfFW9oveZ1PuaA7TygJxsXhRyj5lvEdXvzswKOpxgo2dcgvtImkliC3QDurWjFLBc
         wDWjO0fxliVdpyz4+8nwFX+eI3NtzbDS4DmCvOReOhqT6XKvr8//xKra3+5iH81wyIuO
         0xFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=+TQz+vU+zWVuWkGkBgdrc964ZfnYAc3K/dhJi87Hy+Y=;
        b=JrXKq9lgZ4VtyJoVTHwRdAWBWX8NITY9WeN/Vq6qvdfAs/5wxhjlvOuDMOJ37ZBXtt
         7W8TxyLT0hoNOSSJy8xYWVh+KuSCylfq3+evs4RPkzHGjSghqTsa/RUeH2ppu4lkTIdY
         Z5vMViYaFz5AnPWgVw4VVu81wlxSTh+486Fw2Zu4mK53NB8pHmezx/VdB9S8I98bw8wV
         s0Mv6JbE/q0n84e/uf3atLv/oHwj9qAgXuNn8jYBk631vzxXG+CDMS5EEsK6y7hgsFBy
         3GyNA/EYpFRTGMZ0h8SDdY5hJHGAbncMwkiU3k5xlU9bUTkaHlW6Rl0aBY8SQukw4u18
         skWA==
X-Gm-Message-State: AOAM532P5j3iCZieu8Hv8+0zjzDpc7KkEWyIoEC/9p+ExRqYIqtX5GsK
        kB1VJr6fYd2+Zg1Q6ijDse4=
X-Google-Smtp-Source: ABdhPJwHc+4ahmCIhR2FQNm6Bli15pKEP5qxcttUgczgkIUOs317U0H8BaxgBF50qtZw0Q47F/byzA==
X-Received: by 2002:a05:6402:524e:b0:423:e919:8eb4 with SMTP id t14-20020a056402524e00b00423e9198eb4mr21367336edd.153.1650920282493;
        Mon, 25 Apr 2022 13:58:02 -0700 (PDT)
Received: from [192.168.3.2] (p5dd1ed70.dip0.t-ipconnect.de. [93.209.237.112])
        by smtp.googlemail.com with ESMTPSA id t4-20020a1709067c0400b006ef810aab6fsm3974339ejo.213.2022.04.25.13.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:58:02 -0700 (PDT)
Message-ID: <7f29b6ff5631b619b8a9a20cf67d6d5978bfd3ae.camel@gmail.com>
Subject: Re: [PATCH v3 00/28] Split the ufshcd.h header file
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
Date:   Mon, 25 Apr 2022 22:58:01 +0200
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2022-04-19 at 15:57 -0700, Bart Van Assche wrote:
> Hi Martin,
>=20
> This patch series includes the following changes:
> - Split the ufshcd.h header file into two header files - one file
> that
> =C2=A0 defines the interface with UFS drivers and another file with
> definitions
> =C2=A0 only used in the core.
> - Multiple source code cleanup patches.
> - A few patches with minor functional changes.
>=20
> Please consider these changes for kernel v5.19.
>=20
> Thanks,
>=20
> Bart.


Hi Bart,

This series looks good to me and passed the stress test.

Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>



Kind regards,
Bean

