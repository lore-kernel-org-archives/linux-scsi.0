From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Mon, 25 Aug 2014 09:20:42 +0200
Message-ID: <53FAE3CA.6060603@redhat.com>
References: <53F8AAA8.8040407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:58375 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaHYHUs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2014 03:20:48 -0400
Received: by mail-qg0-f49.google.com with SMTP id j107so12498773qga.8
        for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2014 00:20:47 -0700 (PDT)
In-Reply-To: <53F8AAA8.8040407@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

Il 23/08/2014 16:52, Hans de Goede ha scritto:
> Hi All,
> 
> Now that the UAS driver is no longer marked as CONFIG_BROKEN,
> I'm getting quite a few bug reports about issues with UAS drives.
> 
> One if the issues is that there might be a number of bugs in the
> abort handling path, as I don't think that was ever tested properly.
> 
> So I'm wondering is there a way to test the abort path with a real
> drive? E.G. submit some command which is known to take a significant
> amount of time, and then abort it right after submitting ?

You could have some luck with QEMU's UAS emulation.  If you set QEMU's
I/O throttling options low enough (e.g. 100KB/sec), and then use dd with
iflag=direct and a largish block size (a few MBs), the guest should
abort its I/O soon enough.

Paolo
