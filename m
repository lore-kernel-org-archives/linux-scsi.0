From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 12207] block reads/writes > 122880 bytes to USB tape
 drive gives EBUSY
Date: Wed, 24 Dec 2008 13:19:23 +0900
Message-ID: <20081224131852F.fujita.tomonori@lab.ntt.co.jp>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
	<20081224025621.8A563108040@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36379 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbYLXETa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2008 23:19:30 -0500
In-Reply-To: <20081224025621.8A563108040@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Tue, 23 Dec 2008 18:56:21 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12207
> 
> 
> 
> 
> 
> ------- Comment #16 from stern@rowland.harvard.edu  2008-12-23 18:56 -------
> USB is working fine, and the patch you proposed should take care of tape
> devices okay.  However the block layer still limits max_sectors to
> BLK_DEF_MAX_SECTORS (see the code for blk_queue_max_sectors), which is defined
> as 1024.  Thus there's no way to request a transfer of more than 512 KB, unless
> st.c does some fancy footwork.

st uses pc requests thus max_hw_sectors matters. st.c can use large
block sizes without any fancy footwork.
