Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F1BC32771
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 18:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiIZSSq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 14:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiIZSSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 14:18:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F45816AC;
        Mon, 26 Sep 2022 11:09:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52059B80C94;
        Mon, 26 Sep 2022 18:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6A3C433D6;
        Mon, 26 Sep 2022 18:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664215748;
        bh=f0vC5rcbDYjIyScqcWYY9GpgiQN1RROu0ZZ2a2E8E2U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=cc2VTt5YU8CMoAICIdScy9zbs3OhBWuctGyV31uYoLdX/jhHdprUjUqxyrBZ90I2m
         h8N5ESFrH1aB8IMAdw2dYD0NCdAYmVAWblgzCt/FgA6kr9H6dIGoOFJ3yX0nTLyyk7
         gb35oRC9yB3dTEzhLGg/AhrJGiOmlbX2LU1buRJYTRbUORZAxUyRtFt0UpbZ75PkX2
         qC0+M6pIGnpbu+rX6ewu3bb5iebRbHY/rA+em1+StX155rtK6dt5K5tLJbhb+c0LDc
         fbLcwRJOPUksuwO/XnLcreVRekt5Z59jz5qMlcdMO7KxrNiaxg692INePg4DaFbIMu
         2iLGYmd1p3aOQ==
Date:   Mon, 26 Sep 2022 13:09:06 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Zhuo Chen <chenzhuo.1@bytedance.com>
Cc:     allenbh@gmail.com, dave.jiang@intel.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        linux-pci@vger.kernel.org, jejb@linux.ibm.com, jdmason@kudzu.us,
        james.smart@broadcom.com, fancer.lancer@gmail.com,
        linux-kernel@vger.kernel.org, ntb@lists.linux.dev,
        oohall@gmail.com, bhelgaas@google.com, dick.kennedy@broadcom.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/3] PCI/ERR: Clear fatal status in pcie_do_recovery()
Message-ID: <20220926180906.GA1609498@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1de80c28-33ec-b1bd-a557-91e4166d2da7@bytedance.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 26, 2022 at 10:01:55PM +0800, Zhuo Chen wrote:
> On 9/23/22 5:08 AM, Bjorn Helgaas wrote:
> > On Fri, Sep 02, 2022 at 02:16:33AM +0800, Zhuo Chen wrote:
> > > When state is pci_channel_io_frozen in pcie_do_recovery(),
> > > the severity is fatal and fatal status should be cleared.
> > > So we add pci_aer_clear_fatal_status().
> > 
> > Seems sensible to me.  Did you find this by code inspection or by
> > debugging a problem?  If the latter, it would be nice to mention the
> > symptoms of the problem in the commit log.
> 
> I found this by code inspection so I may not enumerate what kind of problems
> this code will cause.
> > 
> > > Since pcie_aer_is_native() in pci_aer_clear_fatal_status()
> > > and pci_aer_clear_nonfatal_status() contains the function of
> > > 'if (host->native_aer || pcie_ports_native)', so we move them
> > > out of it.
> > 
> > Wrap commit log to fill 75 columns.
> > 
> > > Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
> > > ---
> > >   drivers/pci/pcie/err.c | 8 ++++++--
> > >   1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
> > > index 0c5a143025af..e0a8ade4c3fe 100644
> > > --- a/drivers/pci/pcie/err.c
> > > +++ b/drivers/pci/pcie/err.c
> > > @@ -243,10 +243,14 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
> > >   	 * it is responsible for clearing this status.  In that case, the
> > >   	 * signaling device may not even be visible to the OS.
> > >   	 */
> > > -	if (host->native_aer || pcie_ports_native) {
> > > +	if (host->native_aer || pcie_ports_native)
> > >   		pcie_clear_device_status(dev);
> > 
> > pcie_clear_device_status() doesn't check for pcie_aer_is_native()
> > internally, but after 068c29a248b6 ("PCI/ERR: Clear PCIe Device Status
> > errors only if OS owns AER") and aa344bc8b727 ("PCI/ERR: Clear AER
> > status only when we control AER"), both callers check before calling
> > it.
> > 
> > I think we should move the check inside pcie_clear_device_status().
> > That could be a separate preliminary patch.
> > 
> > There are a couple other places (aer_root_reset() and
> > get_port_device_capability()) that do the same check and could be
> > changed to use pcie_aer_is_native() instead.  That could be another
> > preliminary patch.
> > 
> Good suggestion. But I have only one doubt. In aer_root_reset(), if we use
> "if (pcie_aer_is_native(dev) && aer)", when dev->aer_cap
> is NULL and root->aer_cap is not NULL, pcie_aer_is_native() will return
> false. It's different from just using "(host->native_aer ||
> pcie_ports_native)".
> Or if we can use "if (pcie_aer_is_native(root))", at this time a NULL
> pointer check should be added in pcie_aer_is_native() because root may be
> NULL.

Good point.  In aer_root_reset(), we're updating Root Port registers,
so I think they should look like:

  if (pcie_aer_is_native(root) && aer) {
    ...
  }

Does that seem safe and equivalent to you?

Bjorn
