Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DF2C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 13:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FAF964FDF
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 13:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhCEN1I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 08:27:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45387 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230053AbhCEN1E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 08:27:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614950823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iUA1D4MaFvDkvOetYPodYlEn7+aykl6YUCJj7oVKQPc=;
        b=VdA+iFxvzgVzFGmAIroNAxLa7D4uDqI8P/yi+TIPeD/b7bp8XpRfMRHiO4wu/YACPVs/zZ
        7RJMZToF8T6EePmEjJkBbhUT3+D/HL9E1hlhXtTqXvWbJqH3qtUqeY59h9jc4OgKifL/6K
        Zeb5a8j7yPYU5ljQMTOzjnSCtIne+oo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-qpGctsy8Pk2y1FIZdoo2gQ-1; Fri, 05 Mar 2021 08:26:59 -0500
X-MC-Unique: qpGctsy8Pk2y1FIZdoo2gQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A145969758;
        Fri,  5 Mar 2021 13:26:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 554F82B0BC;
        Fri,  5 Mar 2021 13:26:55 +0000 (UTC)
Subject: Re: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev
 cmds outstanding for retried cmds" breaks hpsa P600
To:     Don.Brace@microchip.com, slyich@gmail.com
Cc:     glaubitz@physik.fu-berlin.de, storagedev@microchip.com,
        linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, jszczype@redhat.com,
        Scott.Benesh@microchip.com, Scott.Teel@microchip.com,
        martin.petersen@oracle.com
References: <20210222230519.73f3e239@sf>
 <cc658b61-530e-90bf-3858-36cc60468a24@kernel.dk>
 <8decdd2e-a380-9951-3ebb-2bc3e48aa1c3@physik.fu-berlin.de>
 <20210223083507.43b5a6dd@sf>
 <51cbf584-07ef-1e62-7a3b-81494a04faa6@physik.fu-berlin.de>
 <9441757f-d4bc-a5b5-5fb0-967c9aaca693@physik.fu-berlin.de>
 <20210223192743.0198d4a9@sf> <20210302222630.5056f243@sf>
 <25dfced0-88b2-b5b3-f1b6-8b8a9931bf90@physik.fu-berlin.de>
 <20210303002236.2f4ec01f@sf> <20210303085533.505b1590@sf>
 <SN6PR11MB284885A5751845EEA290BFCFE1989@SN6PR11MB2848.namprd11.prod.outlook.com>
 <20210303220401.501449e5@sf>
 <SN6PR11MB2848371902B9488289A7B4C7E1979@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <5532f9ab-7555-d51b-f4d5-f9b72a61f248@redhat.com>
Date:   Fri, 5 Mar 2021 14:26:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848371902B9488289A7B4C7E1979@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/21 6:00 PM, Don.Brace@microchip.com wrote:
> -----Original Message-----
> From: Sergei Trofimovich [mailto:slyich@gmail.com] 
> Sent: Wednesday, March 3, 2021 4:04 PM
> To: Don Brace - C33706 <Don.Brace@microchip.com>
> Cc: glaubitz@physik.fu-berlin.de; storagedev <storagedev@microchip.com>; linux-scsi@vger.kernel.org; linux-ia64@vger.kernel.org; linux-kernel@vger.kernel.org; jszczype@redhat.com; Scott Benesh - C33703 <Scott.Benesh@microchip.com>; Scott Teel - C33730 <Scott.Teel@microchip.com>; thenzl@redhat.com; martin.petersen@oracle.com
> Subject: Re: [bisected] 5.12-rc1 hpsa regression: "scsi: hpsa: Correct dev cmds outstanding for retried cmds" breaks hpsa P600
> 
> Glad to hear the patch works. 
> The P600 is an unsupported controller that was removed some time ago (by us) and re-added in this patch:
> commit 135ae6edeb51979d0998daf1357f149a7d6ebb08 scsi: hpsa: add support for legacy boards
> Author: Hannes Reinecke <hare@suse.de>
> Date:   Tue Aug 15 08:58:04 2017 +0200
> 
> So, when testing the original patch, I no longer have a P600 to test with. It used to be supported by our obsoleted cciss driver.

Do you know why this is specific to P600, since the struct is used only
internally in the driver and not used to communicate with the controller
or am I wrong?

> 
> Since patch f749d8b7a9896bc6e5ffe104cc64345037e0b152 scsi: hpsa: Correct dev cmds outstanding for retried cmds has
> already been applied to Martin Petersons 5.13/scsi-queue, perhaps it would be better to send up another patch to correct your alignment issue on these legacy boards.
> 
> Wondering what others think about this?

I agree with you I'd prefer a new patch.

Thanks,
Tomas

> 
> Thanks,
> Don
> 

