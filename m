From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 0/2] fix the sense buffer DMA issue
Date: Thu, 3 Jan 2008 13:56:35 +0900
Message-ID: <5dc13e4823ec8c254e5164a51249f05983fa00c2.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:38930 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbYACE4q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jan 2008 23:56:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp

This patchset is to solve the sense buffer DMA issue:

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12632.html

It's not good to fatten up scsi_cmnd so instead this allocates
sense_buffer dynamically with GFP_DMA.

We don't always need sense_buffer per scsi_cmnd but some LLDs assume
that scsi_cmnd:sense_buffer is always available (e.g, some do
dma_mapping for sense_buffer). So allocating sense_buffer only when
necessary is the best option but needs many changes to LLDs.

We need to solve the sense buffer DMA issue now (since critical for
some architectures) so this patchset tries to solve it with minimum
changes though in the long run, we need more changes to sense_buffer
handling.

This removes static array sense_buffer in scsi_cmnd and dynamically
allocates sense_buffer with GFP_DMA.

scsi_add_host allocates as many buffers as
scsi_host->can_queue. __scsi_get_command attaches sense_buffer to a
scsi_cmnd and __scsi_put_command detaches the sense_buffer from it. So
LLDs should work as before though we need one minor change, replacing
sizeof sense_buffer in some LLDs with SCSI_SENSE_BUFFERSIZE.

There is a small possibility that a host need more sense buffers than
can_queue. The failure of the buffer allocation works just like the
failure of scsi_cmnd allocation. So everything should work as before
(the block layer takes care about it).
