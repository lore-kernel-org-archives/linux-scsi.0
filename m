From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/7] target: Check sess_tearing_down in
 target_get_sess_cmd()
Date: Mon, 16 Jul 2012 18:56:58 -0700
Message-ID: <1342490218.18004.382.camel@haakon2.linux-iscsi.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
	 <1342461882-5848-6-git-send-email-roland@kernel.org>
	 <1342480139.18004.309.camel@haakon2.linux-iscsi.org>
	 <CAL1RGDVNouDHfvKt-WryhhxswC8a8sd+gP-eg3aVDkgB8wU_Bw@mail.gmail.com>
	 <CAL1RGDWgbdsQr1=YMdFyRt=h5Mr40mtXRExUgD_88YPzOnkMkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55491 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab2GQB5B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2012 21:57:01 -0400
In-Reply-To: <CAL1RGDWgbdsQr1=YMdFyRt=h5Mr40mtXRExUgD_88YPzOnkMkw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Andy Grover <agrover@redhat.com>

On Mon, 2012-07-16 at 18:40 -0700, Roland Dreier wrote:
> > OK, I'll take a look at how you handle this...
> 
> So looking at commit bc187ea6c3b3 in the tree you just pushed out
> ("target: Check sess_tearing_down in target_get_sess_cmd()") it looks
> like you just return from target_submit_cmd() if we fail to add the
> command to sess_cmd_list -- doesn't this mean we just leak those
> commands and possibly leave the HW sitting there with open exchanges?
> 

With dropping patch #5 for now, I assume that would be the case..

> Do you have a plan for how to handle this?  Do we really want to plumb
> through another callback to tell the fabric driver to free the command
> in this case?
> 

I need to think more about this ahead of changing it back again for-3.6
now that other fabrics have the assumption of target_submit_cmd() would
not fail.

There is a clear case with qla2xxx for just changing it back (we might
end up doing that just yet) but I wanted to get the other important bits
into for-next into place first..




