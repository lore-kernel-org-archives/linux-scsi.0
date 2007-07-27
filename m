From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 23/24] advansys: Improve interrupt handler
Date: Fri, 27 Jul 2007 11:53:46 -0400
Message-ID: <46AA150A.5090804@garzik.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437542538-git-send-email-matthew@wil.cx> <46AA05ED.2060208@garzik.org> <20070727145336.GK21219@parisc-linux.org> <46AA07CC.9090004@garzik.org> <20070727150420.GL21219@parisc-linux.org> <46AA0B70.9060108@garzik.org> <20070727152520.GM21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58901 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762296AbXG0Pxs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 11:53:48 -0400
In-Reply-To: <20070727152520.GM21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> I still say it's an improvement over scanning the list of scsi hosts
> looking for any that have work pending whenever any interrupt comes in.

No, it's not.  It's just silly:

You have replaced an in-driver loop with a slower, higher-overhead, 
highly unusual loop that no one but advansys does.

Your interrupt handler should do something like

	board_info = dev_id;
	for (i = 0; i < board_info->n_ports; i++)
		advansys_port_intr(board_info, &board_info->port[i]);

or if your hardware can tell you which ports have work pending,

	board_info = dev_id;
	port_status = readl(hw reg);
	for (i = 0; i < board_info->n_ports; i++)
		if (port_status & (1 << i))
			advansys_port_intr(board_info,
					&board_info->port[i]);

Having the kernel interrupt subsystem implement a loop for you is 
completely utterly unusual, slow, silly, and likely to get broken when 
people futz with the interrupt system core.  It probably has edge cases 
too, like screwing with the screaming interrupt detection code.

The kernel interrupt subsystem is not meant to be abused in that way.

	Jeff


