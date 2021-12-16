Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E263AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Dec 2021 23:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhLPXpO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Dec 2021 18:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhLPXpO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2021 18:45:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD9BC061574
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2021 15:45:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96FC6B82525
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2021 23:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E076C36AE8;
        Thu, 16 Dec 2021 23:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639698311;
        bh=alHXPNlEWdP0KFNJyi/TBYdutp371O/bgnLqBKvrBBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=OkNMuQefTVabql76Shkq16S61E3UJrd9+NOXLEIX8H9EoOX0tWjeJlEwIq5ClABCe
         5zyciSTEqziUYA2H/rd5fgxm2pJ2m7PhvS3aYbMve5hIYBBXTsmsB86FdqXE3wK73X
         Nf+WCT7V7q4nZYfug0WfadTCcSg/HA3IQh+PRe2fFbgaM75mYotnEvEu2Mg6JCNua7
         njz/6LlVrrsMMAn0zKJsKI8kKYfZRL3YPWOeSkMtwOzxBCpNTpMrBamdU5Ejq1Yw7y
         qJ87SLhQCSNYMkMAy20OY6ON5nYhbYHMnpNiBwyT1QKBu+lvqTvagNkEPFovbSXoOY
         O83o8PjXme6zA==
Date:   Thu, 16 Dec 2021 17:45:09 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, steve.hagan@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-pci@vger.kernel.or
Subject: Re: [PATCH v6 21/24] mpi3mr: add support of PM suspend and resume
Message-ID: <20211216234509.GA804768@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216233249.GA804561@bhelgaas>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[-cc Peter Rivera (bouncing)]

On Thu, Dec 16, 2021 at 05:32:51PM -0600, Bjorn Helgaas wrote:
> On Thu, Dec 16, 2021 at 05:30:07PM -0600, Bjorn Helgaas wrote:
> > On Thu, May 20, 2021 at 08:55:42PM +0530, Kashyap Desai wrote:

> > > +static int mpi3mr_suspend(struct pci_dev *pdev, pm_message_t state)
> > > +{

> > > +	mpi3mr_cleanup_ioc(mrioc, 1);
> > 
> > This looks possibly wrong.  mpi3mr_cleanup_ioc() takes a "reason",
> > which looks like it should be MPI3MR_COMPLETE_CLEANUP (0),
> > MPI3MR_REINIT_FAILURE (1), or MPI3MR_SUSPEND (2).
> > 
> > This should at least use the enum, and it looks like it should use
> > MPI3MR_SUSPEND instead of passing the MPI3MR_REINIT_FAILURE value.

Sorry for the noise about this part, I see you fixed this later with
0da66348c26f ("scsi: mpi3mr: Set up IRQs in resume path").
