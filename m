From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: For iblock at default writecache enable.
Date: Tue, 29 Jan 2013 15:14:25 -0800
Message-ID: <1359501265.23290.1720.camel@haakon2.linux-iscsi.org>
References: <201301250958101278740@gmail.com>
	 <1359486198.23290.1409.camel@haakon2.linux-iscsi.org>
	 <5108558D.6000408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59202 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3A2XO1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2013 18:14:27 -0500
In-Reply-To: <5108558D.6000408@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: majianpeng <majianpeng@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On Tue, 2013-01-29 at 15:04 -0800, Andy Grover wrote:
> On 01/29/2013 11:03 AM, Nicholas A. Bellinger wrote:
> 
> > So enabling emulate_write_cache=1 in the case when the underlying device
> > has not enabled it is incorrect.
> > 
> > I'd like to enable this bit when we know the underlying device has WCE=1
> > set, but currently there is not a way to determine this (generically)
> > from struct block_device.
> > 
> > So NACK for applying this until there is a method to determine what the
> > hardware below is doing.
> 
> This should be possible from userspace though. I'm planning on looking
> up underlying scsi device(s?) using libblkid, and then query the sense
> data using libsgutils when adding a block backstore in targetcli.
> 

Querying the mode pages from userspace would work for the SCSI backstore
case, but certainly not for raw block devices.

I'd still like to see this exposed to the block layer somehow, so that
the setting can be automatically determined by TCM once it's known if
the underlying HW has enabled write caching.

> It's kind of a hassle, but isn't it a huge performance win if we can
> enable this?
> 

Most certainly, but the danger is reporting WCE=1 (by default in all
cases) from TCM to the initiator when the underlying drives do not have
caching enabled.  Note that every spinning media device that I've ever
seen disables WCE by default from the factory.

--nab

