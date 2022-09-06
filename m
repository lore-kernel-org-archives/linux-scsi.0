Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CEDECAAD5
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Sep 2022 15:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbiIFPL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Sep 2022 11:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbiIFPK5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2022 11:10:57 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315C0326C9
        for <linux-scsi@vger.kernel.org>; Tue,  6 Sep 2022 07:24:48 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o15-20020a17090a3d4f00b002004ed4d77eso6021900pjf.5
        for <linux-scsi@vger.kernel.org>; Tue, 06 Sep 2022 07:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=KJe7cUArJsscTz1vjyjyyJ54+0VOPq+pCJ9MmTqp+ow=;
        b=etc0ZQHNbmVKEbvCwHLL2XNRPMeLwIjp6JDxEwPiFo1rG59guyZHYpxyxY/DAS6Rxj
         ZXmzAGP9IuJ0xxVoHSNngh/21n4tV7kt2NnmcHaYZw9fVwHwGBafXCljN3rKK0zDIrEm
         OUbyEZaJN93R+iWsbOpY24HOu2bYu7N5swfaXxFQKjqw8a/tsy7Rpsjqy2Ofqr1zMajm
         1DnV4Y8/wil+CAa8trBzQNtr72sqxhGruj6jEgIduK9UV6w6/CqqWPdA24TpbUsKFXz8
         P+eJoosZDmYJfygKc4EWwS9+gr4vio4RNzd/vnJKACJ6RXO0khPngiILUT2M4JjOTdQu
         B1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KJe7cUArJsscTz1vjyjyyJ54+0VOPq+pCJ9MmTqp+ow=;
        b=7GyPYx2OZa04DTd1HnXfhiehoBhbbEyyH8pbQ4ZaeR5GlPg1hjzrabQ9Tpb5PPtaUx
         JU1nTA2I7TYI9uqcYd9JL0mhCBexgT414mc4IGbOkmohANwCSdH3FcOEKig09+zdQJQr
         UcqvifrWLcyHgG2LpQCB0ptf0jYujgVuc9QhT/a/t2JdpgMZ563hQHMs2LJDJBrOvK03
         Z8KpMQcQ5MfL3NjxqpSv3ZrZD6lYsh82aYzMt4ylAGWuDiWC0d62mlT1P7XahuWDMDSK
         S9vUtrSXUgZ1l+TBP2hkWDdHlarHJznytxPBOmaqWhfhN3tuKoCMqTqq7mIz8+jP5zAC
         Zcsg==
X-Gm-Message-State: ACgBeo3pmtp36dzch7xQVpzd5UZV2jt2fLj9fsv3YPeLZFig614V3jLI
        bTH+ncN3DHx4bfKyjtq5jpc=
X-Google-Smtp-Source: AA6agR7kbW5+qE+4J4TYdkQYqAoU914RafrJKUnLK7H1uvjTRhIasqwDVCScmAAU8N5Zj4SdDKHXAg==
X-Received: by 2002:a17:902:a40f:b0:172:d0c7:ede1 with SMTP id p15-20020a170902a40f00b00172d0c7ede1mr55181905plq.88.1662474205962;
        Tue, 06 Sep 2022 07:23:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b8-20020a170902d50800b0017440342b5bsm1792646plg.206.2022.09.06.07.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 07:23:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 6 Sep 2022 07:23:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v5 2/4] scsi: core: Make sure that hosts outlive targets
Message-ID: <20220906142322.GA3698227@roeck-us.net>
References: <20220728221851.1822295-1-bvanassche@acm.org>
 <20220728221851.1822295-3-bvanassche@acm.org>
 <20220905173905.GA3405134@roeck-us.net>
 <5462c15b-3ae2-21b7-2f1d-79103b196c34@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5462c15b-3ae2-21b7-2f1d-79103b196c34@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 06, 2022 at 07:16:15AM -0700, Bart Van Assche wrote:
> On 9/5/22 10:40, Guenter Roeck wrote:
> > I understand that it looks like the problem is caused by the shutdown
> > function in the imx driver calling remove_device, but that is not really
> > the problem.
> 
> Hi Guenter,
> 
> A revert for this patch series has been queued and is expected to be sent
> soon to Linus. See also
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/log/?h=6.0/scsi-fixes
> 

Excellent, thanks!

Guenter
