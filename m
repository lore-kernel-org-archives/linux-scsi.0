From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] use dynamically allocated sense buffer
Date: Mon, 07 Jan 2008 15:37:10 +0900
Message-ID: <20080107153710W.fujita.tomonori@lab.ntt.co.jp>
References: <5dc13e4823ec8c254e5164a51249f05983fa00c2.tomof@acm.org>
	<20080103135907G.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:32838 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbYAGGhs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 01:37:48 -0500
In-Reply-To: <20080103135907G.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tomof@acm.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp

On Thu, 3 Jan 2008 13:56:37 +0900
FUJITA Tomonori <tomof@acm.org> wrote:

> This removes static array sense_buffer in scsi_cmnd and uses
> dynamically allocated sense_buffer (with GFP_DMA).
> 
> scsi_add_host allocates as many buffers as
> scsi_host->can_queue. __scsi_get_command attaches sense_buffer to a
> scsi_cmnd and __scsi_put_command detaches the sense_buffer from it.
> 
> There is a small possibility that a host need more sense buffers than
> can_queue. The failure of the buffer allocation works just like the
> failure of scsi_cmnd allocation. So everything should work as before.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/hosts.c     |   10 ++++++-
>  drivers/scsi/scsi.c      |   67 +++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/scsi_priv.h |    2 +
>  include/scsi/scsi_cmnd.h |    2 +-
>  include/scsi/scsi_host.h |    3 ++
>  5 files changed, 81 insertions(+), 3 deletions(-)

On IRC, James told me that allocating the sense buffer in the critical
path could affet the performance. So I did some tests.

I use scsi_debug with fake_rw=1. So I didn't perform any real I/Os.


- Sequential reads

scsi-misc :             479.56666666666666 MB/s
scsi-misc + the patch : 453.52333333333331 MB/s

- Sequential writes

scsi-misc :             441.64333333333337 MB/s
scsi-misc + the patch : 420.30333333333334 MB/s


I also tried an approach to use pre-allocated buffers instead of
mempool, but I got only around 460 MB/s with sequential reads.

Seems that short-term approaches don't work well though we might not
see the notable effects with real I/Os. I guess that it would be
better to work on a long-term approach now than adding a workaround.
