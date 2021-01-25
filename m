Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB980C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 23:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91D7E22597
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 23:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731989AbhAYX4Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jan 2021 18:56:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:52832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731894AbhAYTou (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Jan 2021 14:44:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611603842; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=77jF0Tp4GCJjyAIAsBqAZLWnGuXi4JsAD6Kgud1GTD4=;
        b=EFnm9bqJyeOpLaWLC2eGKwR/rhL+Q/Gb/TRNPLDLoDRhD94jdTPsCuwCktafxElLAy24y4
        LKaqAn+2ZtMnE5+6iFzW1jfQ/EA13wRDrG/PzzOr7ODOZkgoqu71l2acYWYGYdmtzxgQgW
        TklRJhCqFTMXCBmXXPdEd3B3SHijysQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 012A7ACF5;
        Mon, 25 Jan 2021 19:44:02 +0000 (UTC)
Message-ID: <5b88ceb1164f5cf4bc31690b6a15a040ed0f1605.camel@suse.com>
Subject: Re: [PATCH V3 22/25] smartpqi: update enclosure identifier in sysf
From:   Martin Wilck <mwilck@suse.com>
To:     Don.Brace@microchip.com, Kevin.Barnett@microchip.com,
        Scott.Teel@microchip.com, Justin.Lindley@microchip.com,
        Scott.Benesh@microchip.com, Gerry.Morong@microchip.com,
        Mahesh.Rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Mon, 25 Jan 2021 20:44:00 +0100
In-Reply-To: <SN6PR11MB28485D3332238AD3F0261135E1BD9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763258826.26927.5141004289781904133.stgit@brunhilda>
         <ff8339afa9f17cf65648f2a9a6ba8b8460f4020e.camel@suse.com>
         <SN6PR11MB28485D3332238AD3F0261135E1BD9@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-01-25 at 17:13 +0000, Don.Brace@microchip.com wrote:
> 
> From: Martin Wilck [mailto:mwilck@suse.com] 
> Subject: Re: [PATCH V3 22/25] smartpqi: update enclosure identifier
> in sysf
> 
> > @@ -1841,7 +1841,6 @@ static void pqi_dev_info(struct pqi_ctrl_info
> > *ctrl_info,  static void pqi_scsi_update_device(struct pqi_scsi_dev
> > *existing_device,
> >         struct pqi_scsi_dev *new_device)  {
> > -       existing_device->devtype = new_device->devtype;
> >         existing_device->device_type = new_device->device_type;
> >         existing_device->bus = new_device->bus;
> >         if (new_device->target_lun_valid) {
> > 
> 
> I don't get this. Why was it wrong to update the devtype field?
> 
> Don: From patch Author...
> If we don't remove that statement, following issue will crop up.
> 
> During initial device enumeration, the devtype attribute of the
> device(in current case enclosure device) is filled in
> slave_configure.
> But whenever a rescan occurs, the f/w would return zero for this
> field,  and valid devtype is overwritten by zero, when device
> attributes are updated in pqi_scsi_update_device. Due to this lsscsi
> output shows wrong values.

Thanks. It would be very helpful for reviewers to add comments in
cases like this.

Regards,
Martin

> 
> 


