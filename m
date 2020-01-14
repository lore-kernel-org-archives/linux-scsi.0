Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33108C33CB2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 15:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 060262467E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579015695;
	bh=Qd9PsMTYDvdqZd9t2nadVVh75qz3KZLa8XaHb1mZrwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=d9KBIrANFJD0pOoYEx7MD70hqlbHQagHDcsTOCdJfgUQ+hbld55vtzTcWbnvxdUJR
	 SWFx2EP0gf1VTCe9Rb5+SOxAQhHhRzaXZKFn9wK8alBbpvwaoP/7NGqd2zjb9SIrfE
	 qPGOXT3XfrbIU31OeK1QfvqFd4uiVOLATkAho+FQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgANP2L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 10:28:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgANP2L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 10:28:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2438F2467D;
        Tue, 14 Jan 2020 15:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579015689;
        bh=Qd9PsMTYDvdqZd9t2nadVVh75qz3KZLa8XaHb1mZrwY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sU2/ZaoukzDLr3UNOcE9FRKbegbPg6R2CrffC1Qb4JG8aQkDux1HKVnU/fQxczH6y
         UoigEGxKvuQc5WUbZ3aPAnQ/oWZCnOp9hc14B8sooBBmquDXe5DlFuP7YkiaqMStrW
         5WxL7w9X26vxPlYXbKRWR203EhlLuZkWvi5wubAo=
Date:   Tue, 14 Jan 2020 16:28:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Garry <john.garry@huawei.com>
Cc:     James Bottomley <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "saravanak@google.com" <saravanak@google.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v1] driver core: Use list_del_init to replace list_del at
 device_links_purge()
Message-ID: <20200114152806.GA2043229@kroah.com>
References: <20200108122658.GA2365903@kroah.com>
 <73252c08-ac46-5d0d-23ec-16c209bd9b9a@huawei.com>
 <1578498695.3260.5.camel@linux.ibm.com>
 <20200108155700.GA2459586@kroah.com>
 <1578499287.3260.7.camel@linux.ibm.com>
 <4b185c9f-7fa2-349d-9f72-3c787ac30377@huawei.com>
 <3826a83d-a220-2f7d-59f6-efe8a4b995d7@huawei.com>
 <1578531860.3852.7.camel@linux.ibm.com>
 <20200114150739.GA1975985@kroah.com>
 <6820e1c4-07ab-0748-0bf3-e1c25c524a40@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6820e1c4-07ab-0748-0bf3-e1c25c524a40@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 14, 2020 at 03:20:12PM +0000, John Garry wrote:
> On 14/01/2020 15:07, Greg KH wrote:
> > On Wed, Jan 08, 2020 at 05:04:20PM -0800, James Bottomley wrote:
> > > On Wed, 2020-01-08 at 17:10 +0000, John Garry wrote:
> > > > On 08/01/2020 16:08, John Garry wrote:
> > > > > On 08/01/2020 16:01, James Bottomley wrote:
> > > > > > > > >      cdev->dev = NULL;
> > > > > > > > >              return device_add(&cdev->cdev);
> > > > > > > > >          }
> > > > > > > > >      }
> > > > > > > > >      return -ENODEV;
> > > > > > > > > }
> > > > > > > > 
> > > > > > > > The design of the code is simply to remove the link to the
> > > > > > > > inserted device which has been removed.
> > > > > > > > 
> > > > > > > > I*think*  this means the calls to device_del and device_add
> > > > > > > > are unnecessary and should go.  enclosure_remove_links and
> > > > > > > > the put of the enclosed device should be sufficient.
> > > > > > > 
> > > > > > > That would make more sense than trying to "reuse" the device
> > > > > > > structure here by tearing it down and adding it back.
> > > > > > 
> > > > > > OK, let's try that.  This should be the patch if someone can try
> > > > > > it (I've compile tested it, but the enclosure system is under a
> > > > > > heap of stuff in the garage).
> > > > > 
> > > > > I can test it now.
> > > > > 
> > > > 
> > > > Yeah, that looks to have worked ok. SES disk locate was also fine
> > > > after losing and rediscovering the disk.
> > > 
> > > OK, I'll spin up a patch with fixes/reported and tested tags.
> > 
> > Did this get sent?  I can't seem to find it :(
> > 
> 
> Yeah, but you were not cc'ed :(
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20200114&id=529244bd1afc102ab164429d338d310d5d65e60d

Hey, less work for me, that's fine!  :)

thanks for the poitner.

greg k-h
