Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B496BC77B70
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 12:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjDKMWI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 08:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjDKMWH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 08:22:07 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C429940C6;
        Tue, 11 Apr 2023 05:22:05 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id o1so10171282lfc.2;
        Tue, 11 Apr 2023 05:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681215724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P0CfEwwxRtpT41g8a6YsRRGMNfYTxceqIiIsFCToW5o=;
        b=Qlm39oo1uwN2R1XrnH6TujBBGRSvw8Usk4/CKvF2HqgylgMCZsYoebFcm2L/94I6dj
         q6VLaY81ZZteQKy+IrrSxgrsB1hAFXyYgL2p4Pi/HBFR1KBl5A2t9U1qt6f8ieTcur3w
         N1A2IJ0SPAvsYsh0dfw2710Ql/q3572B+IVjaHURrdYaDlKebeohHZt21aILQT8N0tJC
         0lzljxfWSli/nkxrmuOKPObWX+66bAKRdNW0jqaq2dZhlzyoMFCAOSN9ZSXmEuNj+Ssk
         UkFiTaALvteVcijXgr9h7aJyog0KON0edIDtz5SO0Hd1q6vY6ChkR6Bo2i+IavoMT7Ni
         tlJg==
X-Gm-Message-State: AAQBX9eA0A1i6H4kKV23JwGO4QwYsWMGqPkV/Dn+4sASpyMtvKeP/eQ2
        2GhM3vPwu5psE2jKoW/HkcLmnJbJdyhPmzH/
X-Google-Smtp-Source: AKy350YcsRFNTafYFBVxlq7IsxWLdwjZmewy5xDiKmI45ffHR99wywc33ew9+03mdnSDkYfhIFcdJQ==
X-Received: by 2002:ac2:5307:0:b0:4eb:3b4c:50a3 with SMTP id c7-20020ac25307000000b004eb3b4c50a3mr2615918lfh.29.1681215724128;
        Tue, 11 Apr 2023 05:22:04 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id r6-20020a056512102600b004e843d6244csm2540278lfr.99.2023.04.11.05.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 05:22:03 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 24541458; Tue, 11 Apr 2023 14:22:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1681215723; bh=/LguqkW2Bx5Nx7Nq830RqXMFmLCkG4fHgOSjgc/o8hk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=phJQywzKolyrZmvjPFQHlKnTkNKjK6N9V5T/BxzvhN0fNxLi7gRiR9NVr8kcLnKak
         dG2vI+aXuo67idi9p9b+F1E+IS/9nuOyvMgFoUxZJz/SUoHGa87Dx29nxcJGnU/7bm
         ECMENityREAkt4ABxj3hZkgMrh5Sb+aGQPCqaPfs=
Received: from x1-carbon (unknown [87.116.37.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id F40CE458;
        Tue, 11 Apr 2023 14:21:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1681215696; bh=/LguqkW2Bx5Nx7Nq830RqXMFmLCkG4fHgOSjgc/o8hk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mW7y5YiX6yqgycGI4V5C3rc93lrUvbbVuOGxTetRdzZ0rNEVnjr1lNXuLCPu1qL21
         Yv8KIw29kxjbr6Ii8q4NSjSdXK/pU82tEZl3g0kjsp/WPG8R6rVLkKn6l57k37n5uA
         Ui1jKrfwJg4z3s9+rDT2fGyBqgVQ60mfFAyvBwms=
Date:   Tue, 11 Apr 2023 14:20:41 +0200
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v6 09/19] scsi: allow enabling and disabling command
 duration limits
Message-ID: <ZDVQmX2bYoRBYR1Y@x1-carbon>
References: <20230406113252.41211-1-nks@flawful.org>
 <20230406113252.41211-10-nks@flawful.org>
 <20230411061648.GD18719@lst.de>
 <e9cf65ce-e1f0-4d99-31e7-75b8e88e2a89@kernel.org>
 <20230411072317.GA22683@lst.de>
 <15ad7cf9-e385-9cea-964a-4a2eac35385c@kernel.org>
 <ZDVLsIi/OhkxNcGb@x1-carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDVLsIi/OhkxNcGb@x1-carbon>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 11, 2023 at 01:59:44PM +0200, Niklas Cassel wrote:
> On Tue, Apr 11, 2023 at 04:38:48PM +0900, Damien Le Moal wrote:
> > On 4/11/23 16:23, Christoph Hellwig wrote:
> > > On Tue, Apr 11, 2023 at 04:09:34PM +0900, Damien Le Moal wrote:
> > >> But yes, I guess we could just unconditionally enable CDL for ATA on device scan
> > >> to be on par with scsi, which has CDL always enabled.
> > > 
> > > I'd prefer that.  With a module option to not enable it just to be
> > > safe.
> > 
> > Then it may be better to move the cdl_enable attribute store definition for ATA
> > devices to libata. That would be less messy that way. Let me see if that can be
> > done cleanly.
> 
> I don't think that the SCSI mode select can just be replaced with simple
> SET FEATURES in libata.
> 
> If we move the SET FEATURES call to a function in libata, and then use a
> function pointer in the scsi_host_template, and let only libata set this
> function pointer (similar to e.g. how the queue_depth sysfs attribute works),
> then the code will no longer work for SATA devices connected to a SAS HBA.
> 
> 
> 
> The current code simply checks if VPD page89 (the ATA Information VPD
> page - which is defined in the SCSI to ATA Translation (SAT) standard)
> exists. This page (and thus the sdev->vpd_pg89 pointer) will only exist
> if either:
> 1) An ATA device is connected to a SATA controller. This page will then
> be implemented by libata.
> 2) An ATA device is connected to a SAS HBA. The SAS HB will then provide
> this page. (The page will not exist for SCSI devices connected to the
> same SAS HBA.)
> 
> For case 1) with the current code, scsi.c will call scsi_mode_select()
> which will be translated by libata before being sent down to the device.
> 
> For case 2) with the current code, scsi.c will send down a SCSI mode
> select to the SAS HBA, and the SAS HBA will be responsible for translating
> the command before sending it to the device.
> 
> So I actually think that the current way to check if vpd page89 exists
> is probably the "cleanest" solution that I can think of.
> 
> If you have a better suggestion that will work for both case 1) and
> case 2), I will be happy to change the code accordingly.


In addition to:
https://github.com/torvalds/linux/blame/v6.3-rc6/drivers/scsi/sd.c#L3066-L3074

checking for the existence of VPD page89 is also currently done by e.g.:
https://github.com/torvalds/linux/blob/v6.3-rc6/drivers/scsi/mpt3sas/mpt3sas_scsih.c#L12607
and
https://github.com/torvalds/linux/blob/v6.3-rc6/drivers/hwmon/drivetemp.c#L340


Kind regards,
Niklas
