From: "Pan, Weimin" <weimin.pan@hp.com>
Subject: How to directly pass a dma physical address and length from SCSI
 upper layer to LLD without mapping the dma memory to kernel pages
Date: Mon, 9 Jun 2008 20:52:46 +0000
Message-ID: <6B24EEDBA38D764293B27C04FE414CC64E40604DE0@G1W0491.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:14986 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYFIUxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 16:53:06 -0400
Received: from G3W0630.americas.hpqcorp.net (g3w0630.americas.hpqcorp.net [16.233.58.74])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by g4t0015.houston.hp.com (Postfix) with ESMTP id 2DF858A91
	for <linux-scsi@vger.kernel.org>; Mon,  9 Jun 2008 20:53:05 +0000 (UTC)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

SCSI upper layer can pass a scatterlist to middle layer and LLD. Normally the page_link, length, and offset is set in the scatterlist. LLD will convert to dma_address from pages by itself. That means the dma physical memory has to map to kernel memory space before it can be passed to LLD for data transfer. If I have a large dma memroy and it doesn't need to be touched by kernel or user mode Apps, it is a performance penalty to force to do that.

Is there a way to directly pass a dma physical address from upper layer to LLD (like use dma_address in a scatterlist)?
I looked at a couple of LLD drivers and none of them handle this kind of situation.

