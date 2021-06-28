Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5721BC2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 06:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E049619F1
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 06:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhF1Ge6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 02:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhF1Ge5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2021 02:34:57 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97025C061574;
        Sun, 27 Jun 2021 23:32:31 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s15so24048107edt.13;
        Sun, 27 Jun 2021 23:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=Txib2lQrDDQhvhBqeRPpUjNCWW8HeQrOQj6T4O5KwlY=;
        b=JhPkhH3Q1zA/DAr3MkYkso+Y8TrPAXPOfWSPbcikGR1MhOMgFr4VxnP3yUZldp4b46
         aZOQKjJ8yd1BqPW9AtOd9K7h2sH4G54JpjOE9RVw85E0WvD8SvriN3aQ6SaflsJf914o
         gN3b/uWwfMFYXsQkLSzKg13zr0TB2qF7ep6M1aS48b/bw+kDRxYj46Mlcatpmn23++TL
         /vQgyRhLh/pMXoYDZ/JVzCT1VmBQaV6oxQqLOhixi7nNQAikk+K50aO4RpVrPvB4pBhm
         NG4+VUET9eiXlucmNedhKc/3+raEFDFU8XK9O7reiYCQC1COE2W+jmLutTLX2oufVh5R
         Lt+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Txib2lQrDDQhvhBqeRPpUjNCWW8HeQrOQj6T4O5KwlY=;
        b=PfbaOJbUC0pZJvy2PQZHuWLHzA46pX+bXJSrZs8gZBXmlUqUwW+BK6V5Kn/CgFupoV
         dUwE4WjmNtlSUwMZ9beC11JG5i4lcd1CxPnDGDIuCJcbAGVLW9iufgK/QdjVvALAAgNU
         hg9u9oOS/5cZIajUx6m9R0lbnJWvp2g07g3KT7UjfzRtyscNKQiOoCcL5BZ5gCl+0cgs
         wTLQOsR8LyTJEaHwOvpEA6Csk7k4lcaVpOQKJCWwj9kN+qYCyUlTmbXTEZNQuLpozT38
         MKV84lbXpQEM7v1oEzDVQ41G8m8jvBFAkrRov3Dm1u3odeeQaLUpgnZx4mkM4QcWiov9
         CcKg==
X-Gm-Message-State: AOAM530a84J67KlAioWqcmHHzNjKKj+AiWDU1S7g63ZHKfOPo29xGjsM
        2oBseDjPpz0sYROeINxz8CA=
X-Google-Smtp-Source: ABdhPJyrYnrhvNmi1u8txWBJT4/at6h8o1jT0bbgA7tVl1vQp1uocjMswBZIZMYOrDFP3OP3pqImMA==
X-Received: by 2002:a05:6402:5248:: with SMTP id t8mr31128621edd.110.1624861950287;
        Sun, 27 Jun 2021 23:32:30 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id bx28sm6430311ejc.39.2021.06.27.23.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 23:32:30 -0700 (PDT)
Message-ID: <5b4717c407a7998380d5edb61ec5b0a1b82a50fc.camel@gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: Refactor ufshcd_is_intr_aggr_allowed()
From:   Bean Huo <huobean@gmail.com>
To:     keosung.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "satyat@google.com" <satyat@google.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jpinto@synopsys.com" <jpinto@synopsys.com>,
        "joe@perches.com" <joe@perches.com>
Date:   Mon, 28 Jun 2021 08:32:28 +0200
In-Reply-To: <1891546521.01624860001810.JavaMail.epsvc@epcpadp3>
References: <CGME20210628055801epcms2p449fdffa1a6c801497d7e65bae2896b79@epcms2p4>
         <1891546521.01624860001810.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-06-28 at 14:58 +0900, Keoseong Park wrote:
> Simplify if else statement to return statement,
> 
> and remove code related to CONFIG_SCSI_UFS_DWC that is not in use.
> 
> 
> 
> v1 -> v2
> 
> Remove code related to CONFIG_SCSI_UFS_DWC that is not in use.
> 
> 
> 
> Cc: Joao Pinto <jpinto@synopsys.com>
> 
> Signed-off-by: Keoseong Park <keosung.park@samsung.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>

