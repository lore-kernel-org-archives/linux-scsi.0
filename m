Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD3CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 04:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BAB7611C0
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 04:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhI1Eul (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 00:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhI1Eul (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 00:50:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84E9D61157;
        Tue, 28 Sep 2021 04:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632804542;
        bh=2guL14SYPuBM25kGgtAgYfd4Hm7/RYzcvsfudok0grw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ih77VrdE4NO0PKhAWN/U3YouWCUzgSLaL+ahKbU+pzACC6/pzv8ghAOS4db3PmalW
         ylRfADPTmzb8yfHK1LjQLQvdsCuJ1UYKYhKTCKl4yMJoLjIySI5Xc6EJeZ5Y8mxNeh
         f0ZJmphq82doJbeD+IePATAedVoyUw/5Ym3zpmto=
Date:   Tue, 28 Sep 2021 06:48:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Don Brace <don.brace@microchip.com>,
        Brian King <brking@us.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Hannes Reinecke <hare@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Subject: Re: [PATCH 2/2] scsi: Register SCSI device sysfs attributes earlier
Message-ID: <YVKeuvq7Yl4ofikC@kroah.com>
References: <20210924232635.1637763-1-bvanassche@acm.org>
 <20210924232635.1637763-3-bvanassche@acm.org>
 <YU7l02I/eT3+8410@kroah.com>
 <7e38336a-cb2d-61fc-b1b8-babb99d74cd3@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e38336a-cb2d-61fc-b1b8-babb99d74cd3@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 27, 2021 at 10:37:03AM -0700, Bart Van Assche wrote:
> On 9/25/21 2:03 AM, Greg Kroah-Hartman wrote:
> > On Fri, Sep 24, 2021 at 04:26:35PM -0700, Bart Van Assche wrote:
> > > --- a/include/scsi/scsi_device.h
> > > +++ b/include/scsi/scsi_device.h
> > > @@ -226,6 +226,8 @@ struct scsi_device {
> > >   	struct device		sdev_gendev,
> > >   				sdev_dev;
> > > +	struct attribute_group  gendev_first_attr_group;
> > > +	const struct attribute_group *gendev_attr_groups[6];
> > 
> > Where does 6 come from?
> 
> 1 + 4 + 1: one array entry for the SCSI core sysfs attributes, four for the
> device driver attributes (this is the current limit) and one entry for the NULL
> terminating entry.

Please document this somewhere, otherwise it really looks like a random
number :)

thanks,

greg k-h
