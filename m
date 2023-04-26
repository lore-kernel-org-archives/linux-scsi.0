Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18BAC7618E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Apr 2023 11:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240327AbjDZLjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Apr 2023 07:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239947AbjDZLjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2023 07:39:15 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED524699
        for <linux-scsi@vger.kernel.org>; Wed, 26 Apr 2023 04:39:13 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-94a342f7c4cso1287817666b.0
        for <linux-scsi@vger.kernel.org>; Wed, 26 Apr 2023 04:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682509152; x=1685101152;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VdkLeisKgHJ/KOY38t/y5biN+wRm3KUzGIf/0Iei0mI=;
        b=LSfg3C2jgyEEeKel2QPU8swDuwS87yqlHMeTBp203V2WuSDrr6RVH1UOBiKcBGB3Eb
         VIxCQP7xYWZhryaVnXmt1nuP5djzVGpXH358YUhxx43AzKAAcedavPAVTB7luSMhk5NK
         8CXv9zhjUAKKfkSYkxC1SJlZGTBotPD+IdXL1JXEyHIdimX7j9n1/WwjfytIEq/vi7Ag
         tP7RbcLDSe9JRubeWd6CMex7BeMZaLxkBVZHgaYEwG/wBPzQzvF3E43RfYHRPoPRGCDO
         Bfz+t+ELEOYm/dKviHuvh/J8ra/7emoV4fe+Q9g3MNxBfzIuPWfJfCzKXVPT05qPOo39
         f+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682509152; x=1685101152;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VdkLeisKgHJ/KOY38t/y5biN+wRm3KUzGIf/0Iei0mI=;
        b=XZ8yXqhvQPbAvN19UhC5WKBZ2hEZilFiEReyopK48Wg2PiqcMkFcG9LreB7376DZAC
         QxJ2Qh6BDo7AsYm5428UL7SbgEr7rSBL78fkKtyw5zO1qb1MUcVRUu6axOCciLCZHwcn
         v1xxnWT9u49tBjhqbA46j5OsFKjj7k28tz4T+KhBRjgi/BrIJQ8UpRPS4q7lkBalNyb3
         DKSFs2zE7yb5Pe6YOmozsaSqnK1UCw6VLgOXdSTnbYr7vT7rafjHgc+P1YwuNkmfyOd4
         8oEe1bCNPor28WQ3Xu4U3inQh1a47d3w3rngBJkSx7HkSTVuYUrRasnwqmQ9r8Pj4l+p
         Nlpw==
X-Gm-Message-State: AAQBX9enUbVu1yiP0ttjzKhwtiN2uBneaejbD4wX24LBBXAE6H74XTBT
        FuZSQK94ScOaOuehzVEduQ8=
X-Google-Smtp-Source: AKy350Y9HNJ5vgN24H1ws85SwFrSHpf7m9ShV+tYTdKRksTDtq1XF7To7nc/HhRwRZrkFqBFyCf3aQ==
X-Received: by 2002:a17:906:fcc:b0:94f:250b:2536 with SMTP id c12-20020a1709060fcc00b0094f250b2536mr14566776ejk.28.1682509152240;
        Wed, 26 Apr 2023 04:39:12 -0700 (PDT)
Received: from [10.176.234.233] ([165.225.203.148])
        by smtp.gmail.com with ESMTPSA id a5-20020a50ff05000000b00506b0b80786sm6626254edu.36.2023.04.26.04.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 04:39:11 -0700 (PDT)
Message-ID: <8afcd88838904f5053be439aaa38f72072f58fed.camel@gmail.com>
Subject: Re: [PATCH 1/4] scsi: ufs: Increase the START STOP UNIT timeout
 from one to ten seconds
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Date:   Wed, 26 Apr 2023 13:39:10 +0200
In-Reply-To: <20230425232954.1229916-2-bvanassche@acm.org>
References: <20230425232954.1229916-1-bvanassche@acm.org>
         <20230425232954.1229916-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-04-25 at 16:29 -0700, Bart Van Assche wrote:
> One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.
> Another UFS vendor asked to increase the UFS timeout from 1 s to 10
> s.
> Hence this patch that increases the UFS timeout to 10 s. This patch
> can
> cause the total timeout to exceed 20 s, the Android shutdown timeout.
> This is fine since the loop around ufshcd_execute_start_stop() exists
> to
> deal with unit attentions and because unit attentions are reported
> quickly.
>=20
> Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")
> Fixes: 8f2c96420c6e ("scsi: ufs: core: Reduce the power mode change
> timeout")
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
