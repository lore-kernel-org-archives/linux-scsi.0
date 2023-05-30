Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B298C77B7A
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 09:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjE3Jwp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 05:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjE3Jwk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 05:52:40 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D61109
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 02:52:16 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-973e7c35eddso410685866b.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 02:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685440335; x=1688032335;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lAHu7hZLxUUfspwSQYT/xnK1ERqRR0P3UoANjoEjE+4=;
        b=rKGUd7MlABbjnx0XDgZiOpkV7zME5WkBijwScjQcUqzvDqeVtoP4JLw9V9bQ5i+hTt
         sTwj510pu4HOJBn2P8gj4JC4V+mZFxU+CgqXIX0vFl54lArfd4hOC3O9TmHaDE8wB7+/
         L3suS3cOMFeVxyIWkjxLV/XqU3RovZddxKuo7Ix6hfrrCwvI2//nXE52uKGBnul80zab
         RMWzNcPIcyNd4c3MEgiGok673WKJqjC2pVb4dRE0tRnutVaGKkYr1ikKYik0U38M3TNh
         aS49ppLfF4fkWfIQ172HTwRo2kqp1zM0zPVIQ4aI2hhA71pkTbcJ8Qsw1ArNUc1yuOpU
         flNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685440335; x=1688032335;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lAHu7hZLxUUfspwSQYT/xnK1ERqRR0P3UoANjoEjE+4=;
        b=LgKeIyygO1oY+dNQDsYs0VlZ9KGBXLve45C7XqnP7x0rkPVr0H5FaAOexVwQdL3i+E
         3XjZgRCa/AAW78y/oP9H3XxK1H4o5qFioZv13lKPuS7lRM4DfU/F5FItQCxISR3fWCYx
         cYXlU8yaOyk1kqQl515lcoUr1G9i4c950apbzM9t5mpiwEUPzVXlQ265apg63fIIehkx
         kb4npLfrgqapGmN+IKwZkGePj1H9DwL6QYiA+3jxtUzrqMcAjhGi8MTus4Yqx9379dQh
         EBVL4SNvDAW6551qb+mAPFQoRt0kza7HbdwPRqDIv7LB0GOXGolmYtH7BdX12P2LSMWQ
         WixA==
X-Gm-Message-State: AC+VfDzJxUInrkkjOy5FeC4O69Dg58n46HU7IWu934M7Z2ScYSpOSiiE
        3Q3mV4U/8hs0N98sUM50pvBft0kpWxMW4Y2P
X-Google-Smtp-Source: ACHHUZ6CP+6OdcleSD6EcAtMUtqDUfV6vuxkDM2XQqsBs3Aeo5hv4FtshgmKykrpG0RaJ7wWBjCbGw==
X-Received: by 2002:a17:907:6d1f:b0:974:1eeb:1ad6 with SMTP id sa31-20020a1709076d1f00b009741eeb1ad6mr1703619ejc.30.1685440334550;
        Tue, 30 May 2023 02:52:14 -0700 (PDT)
Received: from [10.176.234.233] ([165.225.203.148])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090648cc00b00965e9a23f2bsm7086152ejt.134.2023.05.30.02.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 02:52:13 -0700 (PDT)
Message-ID: <d8d67149a5a272726b928d28c7b11cebfdafc38c.camel@gmail.com>
Subject: Re: [PATCH v4 3/5] scsi: ufs: Conditionally enable the
 BLK_MQ_F_BLOCKING flag
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Date:   Tue, 30 May 2023 11:52:12 +0200
In-Reply-To: <20230529202640.11883-4-bvanassche@acm.org>
References: <20230529202640.11883-1-bvanassche@acm.org>
         <20230529202640.11883-4-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-05-29 at 13:26 -0700, Bart Van Assche wrote:
> Prepare for adding code in ufshcd_queuecommand() that may sleep.
>=20
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

