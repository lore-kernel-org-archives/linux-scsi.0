Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582CBEB64DA
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Jul 2023 15:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjGHP6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Jul 2023 11:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjGHP6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Jul 2023 11:58:45 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66515125
        for <linux-scsi@vger.kernel.org>; Sat,  8 Jul 2023 08:58:44 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2b6ff1ada5dso45695931fa.2
        for <linux-scsi@vger.kernel.org>; Sat, 08 Jul 2023 08:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688831922; x=1691423922;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dxyBPB0IrjHraas1d4HecaS/ckFBc74Nnz1tqIkqWik=;
        b=FPWgNs8oWePqZMGwbSrY9fznNcZvt2CxQb6h1o48eHIRrVFFNn9wKvJDyD7tjrQnxV
         JaSgvXmvkKknQvgRFtHX5GSAWVo6aiuORIhAn2Irr5j8aL/3LRsgxaj8DV/PjHuPgQsb
         WlAqJVFqoN8lXKih58kpGTyvhTqtQmAPhBQ5kDfhgrO0nhiyh9lUpVc6pAyko2NxWpsO
         fna08xAgzpm9aB9l8P7xtuiv902SEwgM5WhZjIvKX+TVLLnyEZtLvlX1a+Q1rNZst4EG
         N20+U0YQ+vlMAY4+r4zsHwZ4O0gPeAzvLHwAQ3rcROY68cOBDM0Oun4luPV0GSF5C7MW
         sdlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688831922; x=1691423922;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dxyBPB0IrjHraas1d4HecaS/ckFBc74Nnz1tqIkqWik=;
        b=cgVJ6XANL/O85SsDN53+dp/O171oLhSNgzCBxLrBr+OEbg2fhl4/KpcKc4yRLUfEwj
         am09KLyht5B6TM/rc+9vo4N40smtOBPEInJ4PMKH7hR83IQi0ZoILm1UdD9KLutjReU9
         aEULh+E6+pKtfhkFnZyK2CLc5ERrbQ0dlPE1ilIwcv5b6SKd72IEYKBWGr4IKGARPhiQ
         4H7/ymkDn4kOyp4f7t0WfBgiuQWFFg7Rwil8IWkGkJaZfoSkdF5+5hOneqk03ierMfrY
         2buap/Mcaq3Zp5FpXzXGTkWgs9HBs7jDQPRb1N8KxOLPc0wtI0WmeKAbKMXCHCeFfB6m
         SjOw==
X-Gm-Message-State: ABy/qLbOX8oAVvV6YtLwx16bRrZHLTPNl84iIOPNJZg1Mb2MouJ3sPy6
        TyLPsIRNORm8kuwuBaKmOkc=
X-Google-Smtp-Source: APBJJlEsOEBo57yZ87HOgBlqb/QI69srYM0dFNl0v7EPdSHUP1WGbo6v+My9VBWkEDxum3XEFmk1Ag==
X-Received: by 2002:a2e:9cc2:0:b0:2b6:b2bf:ab4d with SMTP id g2-20020a2e9cc2000000b002b6b2bfab4dmr5404247ljj.14.1688831922178;
        Sat, 08 Jul 2023 08:58:42 -0700 (PDT)
Received: from ?IPV6:2003:c5:873b:7c7c:c7cc:5c6f:7d8c:cbe1? (p200300c5873b7c7cc7cc5c6f7d8ccbe1.dip0.t-ipconnect.de. [2003:c5:873b:7c7c:c7cc:5c6f:7d8c:cbe1])
        by smtp.gmail.com with ESMTPSA id ov24-20020a170906fc1800b0099364d9f0e6sm3656574ejb.117.2023.07.08.08.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Jul 2023 08:58:41 -0700 (PDT)
Message-ID: <96497efa-0ae6-2b42-d29a-acaf4d2efff4@gmail.com>
Date:   Sat, 8 Jul 2023 17:58:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] scsi: ufs: Include major and minor number in UFS command
 tracing output
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>
References: <20230706215124.4113546-1-bvanassche@acm.org>
From:   Bean Huo <huobean@gmail.com>
In-Reply-To: <20230706215124.4113546-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Acked-by: Bean Huo <beanhuo@micron.com>
