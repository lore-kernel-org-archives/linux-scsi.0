Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E85C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 17:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1D7064DAE
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 17:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344158AbhA0Rqf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:46:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:55468 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344146AbhA0Rq0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Jan 2021 12:46:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611769539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lZTZzcXU64mycCrC2BEhrDlHqlmEQ9qyVcGc/+zn1zs=;
        b=EukLsHVs/OselKbsNkD3jAsS152dl+PHTCLoUP4oruOGILgHzazOZgwMrZ3C0vZfuGJwnF
        L9FFJVVMVqzND5M22A9tdU+WMdtHxnMDsGrZyYDgkUpbLZ2Va99PHtsSMj4jvFEcN3eYSn
        PFMnXjKNJColeHcP0K46cTPkdaISUvI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7C24FAAC6;
        Wed, 27 Jan 2021 17:45:39 +0000 (UTC)
Message-ID: <b3433bb9120fe197e970415bee6cb73da275cf90.camel@suse.com>
Subject: Re: [PATCH V3 23/25] smartpqi: correct system hangs when resuming
 from hibernation
From:   Martin Wilck <mwilck@suse.com>
To:     Don.Brace@microchip.com, Kevin.Barnett@microchip.com,
        Scott.Teel@microchip.com, Justin.Lindley@microchip.com,
        Scott.Benesh@microchip.com, Gerry.Morong@microchip.com,
        Mahesh.Rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Wed, 27 Jan 2021 18:45:38 +0100
In-Reply-To: <SN6PR11MB28483741FE24DBA749ADF6FCE1BB9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763259402.26927.11602719287229380898.stgit@brunhilda>
         <42c087bddc3cc3f83a2c6e3fdd84940dc204ff5a.camel@suse.com>
         <SN6PR11MB28483741FE24DBA749ADF6FCE1BB9@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-01-27 at 17:39 +0000, Don.Brace@microchip.com wrote:
> -----Original Message-----
> From: Martin Wilck [mailto:mwilck@suse.com] 
> Subject: Re: [PATCH V3 23/25] smartpqi: correct system hangs when
> resuming from hibernation
> 
> > @@ -8688,6 +8688,11 @@ static __maybe_unused int pqi_resume(struct 
> > pci_dev *pci_dev)
> >         pci_set_power_state(pci_dev, PCI_D0);
> >         pci_restore_state(pci_dev);
> > 
> > +       pqi_ctrl_unblock_device_reset(ctrl_info);
> > +       pqi_ctrl_unblock_requests(ctrl_info);
> > +       pqi_scsi_unblock_requests(ctrl_info);
> > +       pqi_ctrl_unblock_scan(ctrl_info);
> > +
> >         return pqi_ctrl_init_resume(ctrl_info);  }
> 
> Like I said in my comments on 14/25:
> 
> pqi_ctrl_unblock_scan() and pqi_ctrl_unblock_device_reset() expand to
> mutex_unlock(). Unlocking an already-unlocked mutex is wrong, and a
> mutex has to be unlocked by the task that owns the lock. How can you
> be sure that these conditions are met here?
> 
> Don: I updated this patch to:
> @@ -8661,9 +8661,17 @@ static __maybe_unused int pqi_resume(struct
> pci_dev *pci_dev)
>                 return 0;
>         }
>  
> +       pqi_ctrl_block_device_reset(ctrl_info);
> +       pqi_ctrl_block_scan(ctrl_info);
> +
>         pci_set_power_state(pci_dev, PCI_D0);
>         pci_restore_state(pci_dev);
>  
> +       pqi_ctrl_unblock_device_reset(ctrl_info);
> +       pqi_ctrl_unblock_requests(ctrl_info);
> +       pqi_scsi_unblock_requests(ctrl_info);
> +       pqi_ctrl_unblock_scan(ctrl_info);
> +
>         return pqi_ctrl_init_resume(ctrl_info);
>  }
> Don: So the mutexes are set and unset in the same task.

Yes, that looks much better to me.

>  I updated the other patch 14 accordingly, but I'll reply in that
> patch also. Is there a specific driver that initiates suspend/resume?
> Like acpi? Or some other pci driver?

I'm no expert on suspend/resume. I think it's platform-dependent, you
shouldn't make any specific assumptions what the platform actually
does.

Regards
Martin



