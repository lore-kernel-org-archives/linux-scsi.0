Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25C9C38145
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 18:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiIHSum (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 14:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiIHSui (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 14:50:38 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2872EB869
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 11:50:37 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b144so14055569pfb.7
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 11:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=NIuAShfOd9MdSAw81tVwkJjrAx6iTypgi/tnmlqzrY4=;
        b=Z90Xu4IgC+FWThgWEiytVCEFvA427s+v0bzCqVuNfwZq2WL1JVSFbzktvCCDvrquMd
         2BgEoWsrOuwRrrd3OllgaIUuMV25dx96n9cO59Jv+XYfeGWJUFPnw1RxI0ccJSd9qjmw
         7Ql/LBVKJPxMIFfADltxdNCI8xwW9U5JhoUFk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=NIuAShfOd9MdSAw81tVwkJjrAx6iTypgi/tnmlqzrY4=;
        b=I7oYOs1I+znqodfGXiE4WBrv1frdAwZi7o3agcg7k53w/qqNi0aIJTI9nd4+3OMGJd
         QqEKReOlNUffuJC7oyLVq09y2J9rR/mZyl0TKI5I0iUY9cFfwy03pErOEHEqij81yFEf
         jsAkOBtxoTJAMXl8i4s3ElY8mzwMRmUR0neTIYDCM4YBC/v+KNLWjdobQMCH0L6t5zVR
         vHCOonQdYU2E3PfOujwVSmULu3ISvh450NbcVdkplQDBnFSas05e+rYAtgF8GI1dKaB5
         9GJrfw3//AfAxitmJ/w3s6iSl+6QYxbCxBTC7gyXx6oi6Jk296m/oHdtIuuMX6//Mi2I
         SxRw==
X-Gm-Message-State: ACgBeo3ymcN8jhjDPVM4l+FU+JEJDS/ujbTPqUi0F0xmxY+LHS7rH9K7
        D8Lx8c27zivjhwy3qanQoPVXBg==
X-Google-Smtp-Source: AA6agR63zbZGkByDDCFMkRNQcB+jpRKvffxsvUFkMo8VsYzlEFjRZqDxOXYbk8lTGslyLJYqQzztLA==
X-Received: by 2002:a65:464a:0:b0:434:883:ea21 with SMTP id k10-20020a65464a000000b004340883ea21mr9355137pgr.152.1662663037369;
        Thu, 08 Sep 2022 11:50:37 -0700 (PDT)
Received: from dev-ushankar.dev.purestorage.com ([2620:125:9007:640:7:70:36:0])
        by smtp.gmail.com with ESMTPSA id w10-20020a65534a000000b0043014f9a4c9sm12962868pgr.93.2022.09.08.11.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 11:50:36 -0700 (PDT)
Date:   Thu, 8 Sep 2022 12:50:34 -0600
From:   Uday Shankar <ushankar@purestorage.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org,
        Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: scsi_scan purge devices no longer in reported LUN
 list
Message-ID: <20220908185034.GA3389976@dev-ushankar.dev.purestorage.com>
References: <CAHZQxyKNqnFro33VrirfkdS8ZNga9vWwJDDu8gQtRdr-yW57iQ@mail.gmail.com>
 <CAGtn9rmV=SCxPEegyPc_9zxd9u4+R02LKc3B2X6uK0osY-zWww@mail.gmail.com>
 <20220729233839.GA578093@dev-ushankar.dev.purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729233839.GA578093@dev-ushankar.dev.purestorage.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bump?
