Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43466E92717
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Oct 2023 16:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbjJEQEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 12:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237503AbjJEQDR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 12:03:17 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847327FF2D
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 08:56:23 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-41517088479so17987831cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Oct 2023 08:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1696521382; x=1697126182; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uG4Ph64bewzJVU49JFBslaTgnXwJjaVRqO+mHvKsins=;
        b=eRC9OuOnWgE+5IHji7P/SGFXu3/zgLv+Atumhq0U01RmN6egXpJ+BVP6jLMm9Lk6Gl
         jYPQ470ltD0wuJrLWDC2wE1WKNlsdahmUjbHSggzwmCZW4vm5CjK/FBaXZTZPX8WGDzl
         QJJrIp0OXFD3pO5sek6BH5Ge4PKkAeGqRIZm78FU1YRzHwNfymUPySUadOxjsHp4+Pdl
         M3urN58FveKpLomrfDQLS5ryHM3DCcv3QruRoP6Ibb6mXJhHeh1JMj6C9oATkwA+qcjX
         BBf4ry4GvLPPbwI6FI4TcIMkLHjk1j7IyuKKn+WHgS5cuQsr/RlVUbRbB/4GYorh55k2
         mcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696521382; x=1697126182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uG4Ph64bewzJVU49JFBslaTgnXwJjaVRqO+mHvKsins=;
        b=dQ5ApZKyEpJlv0UEahHBwdHlBF7AUZXlVCbHAu0eDvBSdjWbJNcy+hPS1FG5gU0NgE
         HRTa/O2UJuwPWXM/HQFt8c9XzZrHJUC6cJr67kcLdnsplyMDkX/DmY6aQG8R6VqY4Z57
         pynM148TJzszwLYLPAPewlo415HgSKNaT3plKYu6bIMBhnQCPOlMKrtT6U29HaPjczgK
         1T1qEHU+MFnh6qekRH8WaFfYMS0FAufNaWsPGntWeCC9B7spb2vCf1IqqFaSx4BC3dGV
         TBZntRk4MQYTn3c6Eu8LCnWadHNrpdhADDf1grSR7mlMTlmHz9sCvf4AHTg74Z1Mh2Fi
         l+OA==
X-Gm-Message-State: AOJu0YxGYK90bsiAqPhoVrvklRKZ4n+wm+B7pCKgxH48el6QvRZZ/ppG
        PDGahXICnVJjtQrFs3i+uWcW28yyuqh1B6uAepY=
X-Google-Smtp-Source: AGHT+IGWO/x3ytUeLf5AFCkVaB7RnAy+uiwHbX9L5BgFMBqhYq0K8pe3itPgQK5suUVO326lMXZwpg==
X-Received: by 2002:a05:622a:14f:b0:417:fe21:b254 with SMTP id v15-20020a05622a014f00b00417fe21b254mr1562596qtw.18.1696521382422;
        Thu, 05 Oct 2023 08:56:22 -0700 (PDT)
Received: from ziepe.ca ([142.68.26.201])
        by smtp.gmail.com with ESMTPSA id x24-20020ac87ed8000000b004181a3eeff4sm572363qtj.5.2023.10.05.08.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Oct 2023 08:56:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qoQi0-0045ZW-1M;
        Thu, 05 Oct 2023 12:56:16 -0300
Date:   Thu, 5 Oct 2023 12:56:16 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Leon Romanovsky <leon@kernel.org>, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, matsuda-daisuke@fujitsu.com,
        shinichiro.kawasaki@wdc.com, linux-scsi@vger.kernel.org,
        Zhu Yanjun <yanjun.zhu@intel.com>
Subject: Re: [PATCH 1/1] Revert "RDMA/rxe: Add workqueue support for rxe
 tasks"
Message-ID: <20231005155616.GR13795@ziepe.ca>
References: <20230926140656.GM1642130@unreal>
 <d3c05064-a88b-4719-a390-6bf9ae01fba5@acm.org>
 <b7b365e3-dd11-bc66-dace-05478766bf41@gmail.com>
 <2d5e02d7-cf84-4170-b1a3-a65316ac84ee@acm.org>
 <2fcef3c8-808e-8e6a-b23d-9f1b3f98c1f9@linux.dev>
 <552f2342-e800-43bc-b859-d73297ce940f@acm.org>
 <20231004183824.GQ13795@ziepe.ca>
 <c0665377-d2be-e4b6-3d25-727ef303d26e@linux.dev>
 <20231005142148.GA970053@ziepe.ca>
 <6a730dad-9d81-46d9-8adc-764d00745b01@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a730dad-9d81-46d9-8adc-764d00745b01@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 05, 2023 at 07:50:28AM -0700, Bart Van Assche wrote:
> On 10/5/23 07:21, Jason Gunthorpe wrote:
> > Which is why it shows there are locking problems in this code.
> 
> Hi Jason,
> 
> Since the locking problems have not yet been root-caused, do you
> agree that it is safer to revert patch "RDMA/rxe: Add workqueue
> support for rxe tasks" rather than trying to fix it?

I don't think that makes the locking problems go away any more that
using a single threaded work queue?

Jason
