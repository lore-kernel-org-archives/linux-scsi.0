Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22248CDB482
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 10:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345260AbjJSKJo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Oct 2023 06:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345237AbjJSKJi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2023 06:09:38 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BA418E
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2023 03:09:33 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-32003aae100so353149f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2023 03:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697710172; x=1698314972; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tkUOzd+vqXC9Gk9LtENIqmvEDih8D3cQD5X39rjRw90=;
        b=J6xFZ6pLgEkgt2Py5t0CnQRnASsBWoALpqk+aE+UlkGfzIZk+wLyJKC5B/1+8yTgw1
         OdSlqFiLs8ZYndaeN7JA01pYWmlExh2tLZOW9O6fBhHhYGuodVpq/3oRCg/NELq0P9UV
         NpBGAieXNXhGxUmXHC6mbq1XHnqn4QsSMrs7cjf1JyjDoeh9wbKhF5AQv4nIA+YXUC+o
         4Q61fltjA0J9aIl9FWIEB/hFqQH2h4KIhnmPyJebK0jgOIp9lNgQTZSbndRbfgQ+0bJQ
         e8SD+y0qbl0kya/s6nR4kr7oc5btjUzZsyuuunMf3NXaHJ8+wTBPl6xtVAZndRNl07/2
         j8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697710172; x=1698314972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tkUOzd+vqXC9Gk9LtENIqmvEDih8D3cQD5X39rjRw90=;
        b=HrJI0hPWS+NJW+Y/SeDrInwb37LfDPlrLVwI54eVb+LrNnmOrK1tDkUhM/iJe9P3e+
         jyYs0ExlUg7X4/5fe9sqjvckPBhJWs7lFE62aFFI+goX5f8t70Yr2pCksheH5drmi+J5
         7LSFlzspsLwU1dUsi8c21uQIFAU+h8w7i0zXJrWwu3TeTnh4vfppZZrtfXGc0dZo58Hk
         CwOIZ+Q2J56T6dBKAeyFy/To5sXuxWKdChS9aXBYjnQtpY9L0SGUrh3sFlNwMChXksEl
         P/ChtwR+q6DFgR8YcD0Jip1bG7pmxEPJX37Duq6+N6TijBt23iVBBiirbVs5uOK7prNW
         Ci3A==
X-Gm-Message-State: AOJu0Yzpp7ioyBqNYpqpJfoJlZicxBFRv5m1MZlTll1fqMzo/+4clpjt
        REarfog2TCOgXyEja2fp8+RRUQ==
X-Google-Smtp-Source: AGHT+IFl7jktVX1hBG6LQ8h+AJkNLRQtADGCzsqQdX2oIM5MlIP0CAGDx4nFhmRz3exViow5B+YusQ==
X-Received: by 2002:adf:f80a:0:b0:32d:888d:7598 with SMTP id s10-20020adff80a000000b0032d888d7598mr1448946wrp.4.1697710171905;
        Thu, 19 Oct 2023 03:09:31 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id n13-20020adffe0d000000b0031ad2f9269dsm4098708wrr.40.2023.10.19.03.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Oct 2023 03:09:31 -0700 (PDT)
Date:   Thu, 19 Oct 2023 13:09:27 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Su Hui <suhui@nfschina.com>
Cc:     kartilak@cisco.com, sebaddel@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: snici: Remove dead code in
 snic_dr_clean_pending_req
Message-ID: <15081b01-2915-42a4-bcda-0d8243741baa@kadam.mountain>
References: <20231019083026.1525366-1-suhui@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019083026.1525366-1-suhui@nfschina.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 19, 2023 at 04:30:27PM +0800, Su Hui wrote:
> Value stored to 'ret' is never read, remove it to save space.
> 
> Signed-off-by: Su Hui <suhui@nfschina.com>

Could you do this a bit more thouroughly and remove all the
"ret = FAILED;" and "ret = 0;" assignments.  Just "return FAILED;"
and "return 0;" directly.

regards,
dan carpenter

