Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9647DCDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Oct 2023 06:50:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376379AbjJTGus (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Oct 2023 02:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376374AbjJTGuq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2023 02:50:46 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2A9D55
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2023 23:50:45 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-32d81864e3fso307951f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2023 23:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697784643; x=1698389443; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tUWFtk2ND59A4SW0HP6A+busYNOlgufyXN1B/G4XDtA=;
        b=Onr/U2J18s514Y+us3FZPav8+M5RSIfcETyyrS/muk7U4bloYBCrtptpqD970wCd9r
         p6/0Q41Z+yxHE49+vhS8irnxyNvtNUiklS7UVWUsDvVFKB7fyoJzS1qovBXqxeLmW1GT
         3+Zvv5DWVcYXlbRVcK+PGxFRNtXTwHiBgZf6PBWS44hSuplcf74sYProHfwbf2h4lNib
         OqowF6Yui9Cmbtf5y3X7RlXyLEueif0MlXUEZs6pMujNDQyQgzz4HISZ8Tfx91Y2Yn83
         rfTvllGlsaTQ3Rz1CwGfmwMMXWfEQN70Y+BPpaDHUX0q7x/x/C8BBdeHz62LbKlOcPgx
         0btA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697784643; x=1698389443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUWFtk2ND59A4SW0HP6A+busYNOlgufyXN1B/G4XDtA=;
        b=QYBp/kAWfFpKiUn5IRd/+kYLo3kvp/ivSCfmncnumKsNPTTa8EfSPE/HN6T5lZeWY0
         N/8WzRo+jcrFQJbA3USzVCTxzxPWNwsl1bk2m3KE/AxdWJgdlQfQwhqfLOTdQ7Ugrn8Y
         JyzaUeHVKK+6H3JFdhTf5p1IPn7+IwDKXCvzv2tvsUx+kNBOfyOK4zCYwpYL1Z5HwOp3
         OE/PEl4ULNHSsWuULdHJq96z58NY8fW93LHG97kR4tLdy7A7LTu7lJLGoxpKswGtm1yj
         kmlwG4/l5BGv0rJN1rERWnpqdqwBv3OJi69FUc07iduyJAKu/+enz8W1zWu4DEoXkK5N
         7IgA==
X-Gm-Message-State: AOJu0YxK8JudFjo+eQ0VjpReVeAg+mwcwKbeonVcFLqiBnqlA4CDthz+
        HBWEbUNsU3Qk7w9lz/EK4bWOT3gN8dovmyi32cY=
X-Google-Smtp-Source: AGHT+IHtu15emaNICwZ5IrrBDxMEyfGF2Enbr0cUK/OCqzAt3rwQ9/5ddPdZo73PCYsCe6CKshER0Q==
X-Received: by 2002:adf:e80e:0:b0:32d:a476:527a with SMTP id o14-20020adfe80e000000b0032da476527amr592325wrm.50.1697784643512;
        Thu, 19 Oct 2023 23:50:43 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e16-20020adfe7d0000000b0032db8f7f378sm997906wrn.71.2023.10.19.23.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 23:50:43 -0700 (PDT)
Date:   Fri, 20 Oct 2023 09:50:39 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Su Hui <suhui@nfschina.com>
Cc:     kartilak@cisco.com, sebaddel@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] scsi: snici: remove useless code in
 snic_dr_clean_pending_req
Message-ID: <8e1d29d7-092d-444e-bf89-23703b0bc278@kadam.mountain>
References: <20231020023326.43898-1-suhui@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020023326.43898-1-suhui@nfschina.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 20, 2023 at 10:33:27AM +0800, Su Hui wrote:
> return error code directly to save space and be more clear.
> 
> Signed-off-by: Su Hui <suhui@nfschina.com>
> ---

Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>

regards,
dan carpenter

