From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] target: For iblock at default writecache enable.
Date: Tue, 29 Jan 2013 15:04:45 -0800
Message-ID: <5108558D.6000408@redhat.com>
References: <201301250958101278740@gmail.com> <1359486198.23290.1409.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab3A2XEs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2013 18:04:48 -0500
In-Reply-To: <1359486198.23290.1409.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: majianpeng <majianpeng@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On 01/29/2013 11:03 AM, Nicholas A. Bellinger wrote:

> So enabling emulate_write_cache=1 in the case when the underlying device
> has not enabled it is incorrect.
> 
> I'd like to enable this bit when we know the underlying device has WCE=1
> set, but currently there is not a way to determine this (generically)
> from struct block_device.
> 
> So NACK for applying this until there is a method to determine what the
> hardware below is doing.

This should be possible from userspace though. I'm planning on looking
up underlying scsi device(s?) using libblkid, and then query the sense
data using libsgutils when adding a block backstore in targetcli.

It's kind of a hassle, but isn't it a huge performance win if we can
enable this?

Regards -- Andy
