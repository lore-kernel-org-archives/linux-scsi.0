From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH-v2 01/11] lib/iovec: Add memcpy_fromiovec_out library
 function
Date: Mon, 2 Feb 2015 04:44:12 +0000
Message-ID: <20150202044412.GS29656@ZenIV.linux.org.uk>
References: <1422849994-3419-1-git-send-email-nab@daterainc.com>
 <1422849994-3419-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:60842 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbbBBEoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2015 23:44:15 -0500
Content-Disposition: inline
In-Reply-To: <1422849994-3419-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On Mon, Feb 02, 2015 at 04:06:24AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a new memcpy_fromiovec_out() library function which modifies
> the passed *iov following memcpy_fromiovec(), but also returns the next current
> iovec pointer via **iov_out.
> 
> This is useful for vhost ANY_LAYOUT support when guests are allowed to generate
> incoming virtio request headers combined with subsequent SGL payloads into a
> single iovec.

Please, don't.  Just use copy_from_iter(); you are open-coding an uglier
variant of such.
