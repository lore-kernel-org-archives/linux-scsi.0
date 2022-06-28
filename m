Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2903BC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 20:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiF1UXV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiF1UVk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 16:21:40 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E802734
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 13:19:34 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id w2-20020a056830110200b00616ce0dfcb2so5270199otq.1
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 13:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gEvFuUJcgKjD1KK0O2ptd6IoziGK1DkrPBnMIs51Dlw=;
        b=viMzckyLSxyumGDXuvwbZfAH+ZpVcpddnKGKjmRdiZ7c2R+4pUF7GTRI4GEZerLJll
         9NZqbUSMRtLM2QyP3uKI4lsn42t40dCeV/aMayXiovylNS8+AtX73VbrJtYdodZ5c275
         R9f+lh5b6yd3dJDgsay575pZ11Bk8zfxYcrGLNtHnZkaO7Ly5lj7p8iQRSQcWPGPGovB
         X9VCCXVvkOq6AjNubZHRVVI0O3QaI+jwiIh6uGBib9951sMhZWBXZJp4UaTpVBl+PSah
         cq1uE8+2yGGXcT+s8rs32s1nL3Bgtr7iXAKVpFm7YFIdPhOXtOQ3DeuPlRUPRB0khkH5
         oqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gEvFuUJcgKjD1KK0O2ptd6IoziGK1DkrPBnMIs51Dlw=;
        b=wMAFp7NjqFveFFE6hJ7yk7RR5OEqx9ewxyZ8m6xi2JjzH+rmllEfv7Pew+M8/ab68D
         lamhtrUHGG+rBv2E+gs+X8WlAq4hmtYUmmMsaBEmsB2TtUHTHIESjgtUJ8CDn9I+o8W8
         6zJohAAa+YeoMYOpcUTOP1RKg2GwAFtUP/f6WWKYjBjTqiIeuxONbYZpM/rFvJKOja32
         HGsfbXvOzTDxWPpTMYwfD7ilJzqm7FolQaNmyiatYw3xfUqYR6DNaqF7UcKhtBzoxKaJ
         Sj2YiIXz1g8jbR/Bxz6iQahJE93RLlrQbzTQYk8jCst+oV5K2p4GNilVOMgX/dGsacTC
         ixCA==
X-Gm-Message-State: AJIora9qWK3UwNJAH8Nq2DgiXsUTfZcQ6EtscWAb0QSopnhsXbWLGfFr
        q5fdqdjLMQry/tcsoKIQGPE4hw==
X-Google-Smtp-Source: AGRyM1t6GoZu1uEi97J1earoxokH7cav9I4fHY14+CKDIjkVDDzutLG1V153Sm7YjcURG36xlQccSA==
X-Received: by 2002:a05:6830:438a:b0:616:f238:1562 with SMTP id s10-20020a056830438a00b00616f2381562mr419026otv.111.1656447574266;
        Tue, 28 Jun 2022 13:19:34 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id a12-20020a056870d60c00b000f30837129esm9536923oaq.55.2022.06.28.13.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 13:19:33 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     linux-kernel@vger.kernel.org, Viresh Kumar <vireshk@kernel.org>,
        devicetree@vger.kernel.org, Nishanth Menon <nm@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-clk@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-scsi@vger.kernel.org,
        Taniya Das <tdas@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Andy Gross <agross@kernel.org>, linux-pm@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: (subset) [PATCH v3 1/7] dt-bindings: clock: qcom,gcc-sdm845: add parent power domain
Date:   Tue, 28 Jun 2022 15:19:04 -0500
Message-Id: <165644753308.10525.1688009123553849699.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220513061347.46480-2-krzysztof.kozlowski@linaro.org>
References: <20220513061347.46480-1-krzysztof.kozlowski@linaro.org> <20220513061347.46480-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 13 May 2022 08:13:41 +0200, Krzysztof Kozlowski wrote:
> Allow Qualcomm GCC to register its parent power domain (e.g. RPMHPD) to
> properly pass performance state from children.
> 
> 

Applied, thanks!

[1/7] dt-bindings: clock: qcom,gcc-sdm845: add parent power domain
      commit: d62cac46b0184b8730c68b01359a33769fee821b

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
