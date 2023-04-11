Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B253C77B6F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 12:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjDKMAc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 08:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjDKMA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 08:00:29 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7564840E1;
        Tue, 11 Apr 2023 05:00:23 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id h12so5111825lfj.8;
        Tue, 11 Apr 2023 05:00:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681214422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zw76n2bbPioOvsAEoAjoWbfDcdEyCSzZzGKHgJ/nBjM=;
        b=eEDMYjl2NY6m45q8HQZ2MJxi4oq5o+QJ0HKepBB0VoSTD4B/VHrsU0fD6CpNKgiXXd
         jM81rhLSuUOafnaFYGWXZFtidndEZAP9uo02vg9rANe8SeQPChq2HZdVro1X5Q2Fk5hO
         La9QaY/1vJ8ibdDQRavMPPQDpj8Mcy4ylwQJLgKqj498evmWMjzuJK2VpRQ/BkUfl2aM
         4xG4skEhFzV4atxpzByKDcRnqLvbZ40+zihoTKJVQbVxFI5V1RHJohxa17ijd1IiRnfz
         ZPIjlZC1qFQT4CYiC/q+r98coRAY/QnwrDqYCKuSOBsfLDoe/dc1JEj4laODGSEa1yrd
         QO+A==
X-Gm-Message-State: AAQBX9cgokYyNLu4I6/YEjgkBcgP4HkScEHWN8So7PHHUQE4zqr93UyC
        BdQI9znpA3fsdbG7hk0xRmV0g9s3Sghw8VvD
X-Google-Smtp-Source: AKy350Zx1z5vHz2mW67v2WpVfuVR/mZzWSNBYiKqu92kY/l7eZ6UssY4O8F8Jon8QeNtpHQs1BnjqA==
X-Received: by 2002:ac2:5210:0:b0:4eb:3b4c:50ab with SMTP id a16-20020ac25210000000b004eb3b4c50abmr4221199lfl.64.1681214421841;
        Tue, 11 Apr 2023 05:00:21 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id v18-20020ac25612000000b004e9b4a8f738sm2504832lfd.152.2023.04.11.05.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 05:00:21 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 01B34458; Tue, 11 Apr 2023 14:00:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1681214419; bh=ECddMqao3xRJh1D9+EAfsf436pe2DoxfP1EU9RZVNJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DOQQiD5+6d9RiUKoliz4KizGRNl8ik4RMIOB1PxG5gnNKD370uObRLgSQ8Rhd2ZmW
         9yNJQBSn4qFJh1HRyEZwRJLRA1UC63zpTE5or571wFYySZUktqO2FodaHmcpiEOlzu
         1dqSri7PwWqq9gKDIWRh+WQueM7BHhX0OtWJItdc=
Received: from x1-carbon (unknown [87.116.37.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 8ACE532F;
        Tue, 11 Apr 2023 13:59:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1681214391; bh=ECddMqao3xRJh1D9+EAfsf436pe2DoxfP1EU9RZVNJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oPh44aTlvGaO832kv25f1iuf/XdbUfVpG3UlvhdD2+S4Z5PT7FBrLrSBbgT92BEtp
         cED4Z6R6+w6xfXgiK/0c7TSztUe4Vuby3UAUODJ+KDsNCxh11TPG9Pb+G28IUtKZyo
         aMxQi3SBua7Lmrz9gRVyE7wnvP3tQSlUjLtd3EpY=
Date:   Tue, 11 Apr 2023 13:59:44 +0200
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
Message-ID: <ZDVLsIi/OhkxNcGb@x1-carbon>
References: <20230406113252.41211-1-nks@flawful.org>
 <20230406113252.41211-10-nks@flawful.org>
 <20230411061648.GD18719@lst.de>
 <e9cf65ce-e1f0-4d99-31e7-75b8e88e2a89@kernel.org>
 <20230411072317.GA22683@lst.de>
 <15ad7cf9-e385-9cea-964a-4a2eac35385c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15ad7cf9-e385-9cea-964a-4a2eac35385c@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 11, 2023 at 04:38:48PM +0900, Damien Le Moal wrote:
> On 4/11/23 16:23, Christoph Hellwig wrote:
> > On Tue, Apr 11, 2023 at 04:09:34PM +0900, Damien Le Moal wrote:
> >> But yes, I guess we could just unconditionally enable CDL for ATA on device scan
> >> to be on par with scsi, which has CDL always enabled.
> > 
> > I'd prefer that.  With a module option to not enable it just to be
> > safe.
> 
> Then it may be better to move the cdl_enable attribute store definition for ATA
> devices to libata. That would be less messy that way. Let me see if that can be
> done cleanly.

I don't think that the SCSI mode select can just be replaced with simple
SET FEATURES in libata.

If we move the SET FEATURES call to a function in libata, and then use a
function pointer in the scsi_host_template, and let only libata set this
function pointer (similar to e.g. how the queue_depth sysfs attribute works),
then the code will no longer work for SATA devices connected to a SAS HBA.



The current code simply checks if VPD page89 (the ATA Information VPD
page - which is defined in the SCSI to ATA Translation (SAT) standard)
exists. This page (and thus the sdev->vpd_pg89 pointer) will only exist
if either:
1) An ATA device is connected to a SATA controller. This page will then
be implemented by libata.
2) An ATA device is connected to a SAS HBA. The SAS HB will then provide
this page. (The page will not exist for SCSI devices connected to the
same SAS HBA.)

For case 1) with the current code, scsi.c will call scsi_mode_select()
which will be translated by libata before being sent down to the device.

For case 2) with the current code, scsi.c will send down a SCSI mode
select to the SAS HBA, and the SAS HBA will be responsible for translating
the command before sending it to the device.

So I actually think that the current way to check if vpd page89 exists
is probably the "cleanest" solution that I can think of.

If you have a better suggestion that will work for both case 1) and
case 2), I will be happy to change the code accordingly.


Kind regards,
Niklas
